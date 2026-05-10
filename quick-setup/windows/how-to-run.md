3 steps to run this on Windows:
Step 1 — Save the script above as SETUP.ps1 in your project root folder.
Step 2 — Open PowerShell in that folder and run:
.\SETUP.ps1

The first line is a one-time setting that allows PowerShell to run local scripts. The second line runs the setup.

Step 3 — Activate the git hooks:
git config core.hooksPath .githooks
