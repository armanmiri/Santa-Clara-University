"""Read application settings for the StudyMate web app."""

from __future__ import annotations

import os
import secrets

SECRET_KEY: str | None = os.environ.get("SECRET_KEY")


def create_secret_key() -> str:
    """Return the configured session key or a temporary development key.

    Returns:
        A persistent configured key when set, otherwise a random process key.
    """
    return SECRET_KEY or secrets.token_urlsafe(32)
