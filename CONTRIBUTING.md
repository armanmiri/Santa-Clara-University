# Contributing

Follow PEP 8 with four-space indentation and a 100-character line limit. Add
annotations to public signatures and Google-style docstrings to public classes,
functions, and methods. Group standard-library, third-party, and local imports;
place fixed constants before exceptions and implementation code.

Keep functions focused and split those exceeding 50 lines or deeply nested
control flow when doing so improves clarity. Keep environment settings in one
configuration module, parse external values defensively, and ensure logging or
validation guards cannot break business operations. Do not replace unavailable
data with fabricated zero values.

Format and lint Python changes with Ruff:

```bash
python -m ruff format .
python -m ruff check .
```

Apply thresholds to new and changed code as legacy files are edited.
