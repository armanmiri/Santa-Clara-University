"""Flask application for the StudyMate course project."""

from __future__ import annotations

import logging
from collections.abc import Callable
from functools import wraps
from pathlib import Path
from typing import Any, TypeVar, cast
from uuid import uuid4

from flask import (
    Flask,
    flash,
    redirect,
    render_template,
    request,
    send_from_directory,
    session,
    url_for,
)
from flask.typing import ResponseReturnValue
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy.exc import SQLAlchemyError
from werkzeug.security import check_password_hash, generate_password_hash
from werkzeug.utils import secure_filename

from config import SECRET_KEY, create_secret_key

logger = logging.getLogger(__name__)
F = TypeVar("F", bound=Callable[..., Any])
UPLOAD_FOLDER = Path(__file__).resolve().parent / "uploads"

app = Flask(__name__)
app.config["SECRET_KEY"] = create_secret_key()
app.config["SQLALCHEMY_DATABASE_URI"] = "sqlite:///studymate.db"
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False
app.config["UPLOAD_FOLDER"] = str(UPLOAD_FOLDER)
UPLOAD_FOLDER.mkdir(parents=True, exist_ok=True)
db = SQLAlchemy(app)

if not SECRET_KEY:
    logger.warning(
        "SECRET_KEY is unset; generated session cookies are invalid after this process restarts."
    )


def _save_upload(uploaded_file: Any, purpose: str) -> Path | None:
    """Save an uploaded document under a collision-resistant filename.

    Args:
        uploaded_file: The upload object received from Flask.
        purpose: Description used in validation logs and errors.

    Returns:
        The saved path, or None when no file was uploaded.

    Raises:
        ValueError: If the supplied filename has no safe characters.
    """
    if not uploaded_file or not uploaded_file.filename:
        return None
    filename = secure_filename(uploaded_file.filename)
    if not filename:
        raise ValueError(f"Invalid {purpose} filename")
    saved_path = UPLOAD_FOLDER / f"{uuid4().hex}_{filename}"
    uploaded_file.save(saved_path)
    return saved_path


# Database models
class User(db.Model):
    """Represent an account that owns study materials.

    Attributes:
        id: Database account identifier.
        username: Unique login name.
        password: Hashed password.
        dark_mode: Display preference.
    """

    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(150), unique=True, nullable=False)
    password = db.Column(db.String(150), nullable=False)
    dark_mode = db.Column(db.Boolean, default=False)


class FlashcardSet(db.Model):
    """Group flashcards and an optional uploaded source file.

    Attributes:
        id: Database set identifier.
        title: User-visible set title.
        user_id: Owner account identifier.
        flashcards: Cards in this set.
        file_path: Optional source document path.
    """

    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String(150), nullable=False)
    user_id = db.Column(db.Integer, db.ForeignKey("user.id"), nullable=False)
    flashcards = db.relationship("Flashcard", backref="flashcard_set", lazy=True)
    file_path = db.Column(db.String(300), nullable=True)

    @property
    def filename(self) -> str | None:
        """Return the source filename without its directory.

        Returns:
            The base filename, or None when no file is attached.
        """
        if self.file_path:
            return Path(self.file_path).name
        return None


class Flashcard(db.Model):
    """Represent one question and answer in a flashcard set.

    Attributes:
        id: Database card identifier.
        question: Prompt shown to the learner.
        answer: Response shown to the learner.
        flashcard_set_id: Containing set identifier.
    """

    id = db.Column(db.Integer, primary_key=True)
    question = db.Column(db.String(300), nullable=False)
    answer = db.Column(db.String(300), nullable=False)
    flashcard_set_id = db.Column(db.Integer, db.ForeignKey("flashcard_set.id"), nullable=False)


class StudyGuide(db.Model):
    """Store a study guide and its optional uploaded source.

    Attributes:
        id: Database guide identifier.
        title: User-visible guide title.
        content: Guide text.
        user_id: Owner account identifier.
        file_path: Optional source document path.
    """

    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String(150), nullable=False)
    content = db.Column(db.Text, nullable=False)
    user_id = db.Column(db.Integer, db.ForeignKey("user.id"), nullable=False)
    file_path = db.Column(db.String(300), nullable=True)

    @property
    def filename(self) -> str | None:
        """Return the source filename without its directory.

        Returns:
            The base filename, or None when no file is attached.
        """
        if self.file_path:
            return Path(self.file_path).name
        return None


class Feedback(db.Model):
    """Represent feedback submitted by an account.

    Attributes:
        id: Database feedback identifier.
        comment: User-provided feedback text.
        rating: Optional rating from one to five.
        user_id: Submitting account identifier.
    """

    id = db.Column(db.Integer, primary_key=True)
    comment = db.Column(db.Text, nullable=False)
    rating = db.Column(db.Integer, nullable=True)
    user_id = db.Column(db.Integer, db.ForeignKey("user.id"), nullable=False)


# -------------------------------
# Decorators & Context Processor
# -------------------------------
def login_required(f: F) -> F:
    """Protect a route using the current login session.

    Args:
        f: Flask view function to wrap.

    Returns:
        The wrapped view, which redirects unauthenticated requests.
    """

    @wraps(f)
    def decorated_function(*args: Any, **kwargs: Any) -> ResponseReturnValue:
        """Call the protected view only when its account still exists."""
        user_id = session.get("user_id")
        if user_id is None or db.session.get(User, user_id) is None:
            session.pop("user_id", None)
            flash("You need to be logged in to view that page.", "error")
            return redirect(url_for("login"))
        return f(*args, **kwargs)

    return cast(F, decorated_function)


@app.context_processor
def inject_user() -> dict[str, User | None]:
    """Make the current account available to templates.

    Returns:
        A template context containing the current account, if authenticated.
    """
    user_id = session.get("user_id")
    return {"user": db.session.get(User, user_id) if user_id is not None else None}


# -------------------------------
# Routes
# -------------------------------
@app.route("/")
def index() -> ResponseReturnValue:
    """Render the landing page.

    Returns:
        Rendered landing-page HTML.
    """
    return render_template("index.html")


@app.route("/signup", methods=["GET", "POST"])
def signup() -> ResponseReturnValue:
    """Create an account or render the signup form.

    Returns:
        Redirect after signup or rendered signup-page HTML.
    """
    if request.method == "POST":
        username = request.form["username"].strip()
        password = request.form["password"].strip()
        if User.query.filter_by(username=username).first():
            flash("Username already exists! Please choose another.", "error")
            return redirect(url_for("signup"))

        hashed_pw = generate_password_hash(password)
        new_user = User(username=username, password=hashed_pw)
        db.session.add(new_user)
        db.session.commit()
        flash("Signup successful! Please log in.", "success")
        return redirect(url_for("login"))
    return render_template("signup.html")


@app.route("/login", methods=["GET", "POST"])
def login() -> ResponseReturnValue:
    """Authenticate an account or render the login form.

    Returns:
        Redirect after login or rendered login-page HTML.
    """
    if request.method == "POST":
        username = request.form["username"].strip()
        password = request.form["password"].strip()
        user = User.query.filter_by(username=username).first()
        if not user or not check_password_hash(user.password, password):
            flash("Invalid username or password.", "error")
            return redirect(url_for("login"))
        session["user_id"] = user.id
        flash("Login successful!", "success")
        return redirect(url_for("dashboard"))
    return render_template("login.html")


@app.route("/logout")
def logout() -> ResponseReturnValue:
    """Clear the current account session.

    Returns:
        Redirect to the landing page.
    """
    session.pop("user_id", None)
    flash("You have been logged out!", "success")
    return redirect(url_for("index"))


@app.route("/dashboard")
@login_required
def dashboard() -> ResponseReturnValue:
    """Render the authenticated account dashboard.

    Returns:
        Rendered dashboard HTML.
    """
    return render_template("dashboard.html")


# -------------------------------
# CREATE FLASHCARDS
# -------------------------------
@app.route("/create_flashcards", methods=["GET", "POST"])
@login_required
def create_flashcards() -> ResponseReturnValue:
    """Create a flashcard set and save its submitted cards and file.

    Returns:
        Redirect after creation or rendered creation form.
    """
    if request.method == "POST":
        title = request.form.get("title", "").strip()
        if not title:
            flash("Please provide a title for your flashcard set.", "error")
            return redirect(url_for("create_flashcards"))

        flashcard_set = FlashcardSet(title=title, user_id=session["user_id"])

        try:
            saved_path = _save_upload(request.files.get("file"), "flashcard source")
        except ValueError:
            flash("Please choose a valid filename.", "error")
            return redirect(url_for("create_flashcards"))
        if saved_path:
            flashcard_set.file_path = str(saved_path)

        try:
            db.session.add(flashcard_set)
            db.session.flush()
            questions = request.form.getlist("question")
            answers = request.form.getlist("answer")
            for question, answer in zip(questions, answers):
                question, answer = question.strip(), answer.strip()
                if question and answer:
                    db.session.add(
                        Flashcard(
                            question=question,
                            answer=answer,
                            flashcard_set_id=flashcard_set.id,
                        )
                    )
            db.session.commit()
        except SQLAlchemyError:
            db.session.rollback()
            if saved_path:
                saved_path.unlink(missing_ok=True)
            logger.exception("Could not create flashcard set")
            flash("The flashcard set could not be saved. Please try again.", "error")
            return redirect(url_for("create_flashcards"))

        flash("Flashcard set created successfully!", "success")
        return redirect(url_for("dashboard"))
    return render_template("create_flashcards.html")


# -------------------------------
# CREATE STUDY GUIDE
# -------------------------------
@app.route("/create_study_guide", methods=["GET", "POST"])
@login_required
def create_study_guide() -> ResponseReturnValue:
    """Create a study guide from submitted text and optional file.

    Returns:
        Redirect after creation or rendered creation form.
    """
    if request.method == "POST":
        title = request.form.get("title", "").strip()
        content = request.form.get("content", "").strip()
        if not title or not content:
            flash("Please provide both a title and content for your study guide.", "error")
            return redirect(url_for("create_study_guide"))

        study_guide = StudyGuide(title=title, content=content, user_id=session["user_id"])

        try:
            saved_path = _save_upload(request.files.get("file"), "study guide source")
        except ValueError:
            flash("Please choose a valid filename.", "error")
            return redirect(url_for("create_study_guide"))
        if saved_path:
            study_guide.file_path = str(saved_path)

        try:
            db.session.add(study_guide)
            db.session.commit()
        except SQLAlchemyError:
            db.session.rollback()
            if saved_path:
                saved_path.unlink(missing_ok=True)
            logger.exception("Could not create study guide")
            flash("The study guide could not be saved. Please try again.", "error")
            return redirect(url_for("create_study_guide"))
        flash("Study guide created successfully!", "success")
        return redirect(url_for("dashboard"))
    return render_template("create_study_guide.html")


# -------------------------------
# FEEDBACK
# -------------------------------
@app.route("/feedback", methods=["GET", "POST"])
@login_required
def feedback() -> ResponseReturnValue:
    """Save feedback and an optional rating from the current account.

    Returns:
        Redirect after submission or rendered feedback form.
    """
    if request.method == "POST":
        comment = request.form.get("comment", "").strip()
        rating_str = request.form.get("rating", "").strip()
        if not comment:
            flash("Please provide feedback text.", "error")
            return redirect(url_for("feedback"))

        rating = None
        if rating_str:
            try:
                rating = int(rating_str)
            except ValueError:
                flash("Rating must be an integer (e.g., 1-5).", "error")
                return redirect(url_for("feedback"))

        fb = Feedback(comment=comment, rating=rating, user_id=session["user_id"])
        db.session.add(fb)
        db.session.commit()
        flash("Feedback submitted! Thank you.", "success")
        return redirect(url_for("dashboard"))
    return render_template("feedback.html")


# -------------------------------
# DARK MODE
# -------------------------------
@app.route("/toggle_dark_mode", methods=["POST"])
@login_required
def toggle_dark_mode() -> ResponseReturnValue:
    """Toggle the current account dark-mode preference.

    Returns:
        Redirect to the dashboard.
    """
    user = db.session.get(User, session["user_id"])
    if user is None:
        session.pop("user_id", None)
        return redirect(url_for("login"))
    user.dark_mode = not user.dark_mode
    db.session.commit()
    flash("Display settings updated!", "success")
    return redirect(url_for("dashboard"))


# -------------------------------
# DOWNLOAD ROUTES
# -------------------------------
@app.route("/download_guide/<int:guide_id>")
@login_required
def download_guide(guide_id: int) -> ResponseReturnValue:
    """Download a source file attached to an owned study guide.

    Args:
        guide_id: Database identifier of the study guide.

    Returns:
        Download response or redirect with a status message.
    """
    guide = StudyGuide.query.get_or_404(guide_id)
    if guide.user_id != session["user_id"]:
        flash("You do not have permission to download this file.", "error")
        return redirect(url_for("my_study_guides"))
    if not guide.file_path:
        flash("No file attached to this study guide.", "error")
        return redirect(url_for("my_study_guides"))

    filename = Path(guide.file_path).name
    return send_from_directory(app.config["UPLOAD_FOLDER"], filename, as_attachment=True)


@app.route("/download_flashcard/<int:set_id>")
@login_required
def download_flashcard(set_id: int) -> ResponseReturnValue:
    """Download a source file attached to an owned flashcard set.

    Args:
        set_id: Database identifier of the flashcard set.

    Returns:
        Download response or redirect with a status message.
    """
    fset = FlashcardSet.query.get_or_404(set_id)
    if fset.user_id != session["user_id"]:
        flash("You do not have permission to download this file.", "error")
        return redirect(url_for("my_flashcards"))
    if not fset.file_path:
        flash("No file attached to this flashcard set.", "error")
        return redirect(url_for("my_flashcards"))

    filename = Path(fset.file_path).name
    return send_from_directory(app.config["UPLOAD_FOLDER"], filename, as_attachment=True)


# -------------------------------
# "My Flashcards" & "My Study Guides"
# -------------------------------
@app.route("/my_flashcards")
@login_required
def my_flashcards() -> ResponseReturnValue:
    """Render flashcard sets owned by the current account.

    Returns:
        Rendered flashcard list HTML.
    """
    user_id = session["user_id"]
    flashcard_sets = FlashcardSet.query.filter_by(user_id=user_id).all()
    return render_template("my_flashcards.html", flashcard_sets=flashcard_sets)


@app.route("/my_study_guides")
@login_required
def my_study_guides() -> ResponseReturnValue:
    """Render study guides owned by the current account.

    Returns:
        Rendered study-guide list HTML.
    """
    user_id = session["user_id"]
    study_guides = StudyGuide.query.filter_by(user_id=user_id).all()
    return render_template("my_study_guides.html", study_guides=study_guides)


# -------------------------------
# Main Entry
# -------------------------------
if __name__ == "__main__":
    with app.app_context():
        db.create_all()
    app.run(debug=False)
