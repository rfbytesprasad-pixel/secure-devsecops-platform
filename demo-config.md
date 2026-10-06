# Demo Application Config

Credentials are injected at runtime via environment variables.
Never commit secrets to source code.

## Required environment variables

- `GITHUB_TOKEN` — provided by CI/CD secret store
- `AWS_ACCESS_KEY_ID` — provided by CI/CD secret store
- `AWS_SECRET_ACCESS_KEY` — provided by CI/CD secret store
