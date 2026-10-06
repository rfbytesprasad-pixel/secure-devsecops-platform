# Security Incident Log

Chronological log of security findings, blocks, and fixes. Every entry is a
real event in this repository's history.

Format:
- **Date** — YYYY-MM-DD
- **Type** — secret / vuln / misconfig / policy
- **Status** — blocked / accepted / fixed
- **Evidence** — link to PR, screenshot, or scan output

---

## 2026-10-06 — Secret detected in PR #1

**Type:** secret
**Status:** blocked → fixed → merged
**Detected by:** Semgrep (`generic.secrets.security.detected-github-token`)
**Severity:** HIGH

**What happened:**
A demo GitHub Personal Access Token (`ghp_` + 36 chars) was committed to
`demo-config.md` on branch `feat/demo-secret`. The PR security pipeline
blocked the merge.

**Evidence:**
- PR: [#1](https://github.com/rfbytesprasad-pixel/secure-devsecops-platform/pull/1)
- Screenshot: `evidence/2026-10-06-pr-blocked.png`

**Detection details:**
