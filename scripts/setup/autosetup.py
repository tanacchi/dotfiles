#!/usr/bin/env python3
"""Clone this repository and run the dotfiles installer.

This script is intentionally small because the real install behavior lives in
scripts/setup/install.py inside the cloned repository.
"""

from __future__ import annotations

import shutil
import subprocess
from pathlib import Path


REPOSITORY_URL = "https://github.com/tanacchi/dotfiles.git"


def run(command: list[str]) -> None:
    print("+", " ".join(command))
    subprocess.run(command, check=True)


def main() -> None:
    destination = Path.home() / "dotfiles"

    if destination.exists():
        if (destination / ".git").exists():
            run(["git", "-C", str(destination), "pull", "--ff-only"])
        else:
            backup = destination.with_name("dotfiles.backup")
            if backup.exists():
                shutil.rmtree(backup)
            destination.rename(backup)
            run(["git", "clone", REPOSITORY_URL, str(destination)])
    else:
        run(["git", "clone", REPOSITORY_URL, str(destination)])

    run(["python3", str(destination / "scripts/setup/install.py"), "--install-mise", "--install-tools"])


if __name__ == "__main__":
    main()
