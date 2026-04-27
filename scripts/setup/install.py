#!/usr/bin/env python3
from __future__ import annotations

import argparse
import os
import platform
import shutil
import subprocess
from datetime import datetime
from pathlib import Path


DOTFILE_EXCLUDES = {
    ".DS_Store",
    ".git",
    ".gitignore",
    ".gitmodules",
}


def timestamp() -> str:
    return datetime.now().strftime("%Y%m%d%H%M%S")


def dotfiles_root() -> Path:
    return Path(__file__).resolve().parents[2]


def run(command: list[str], *, check: bool = True) -> subprocess.CompletedProcess:
    print("+", " ".join(command))
    return subprocess.run(command, check=check)


def command_exists(command: str) -> bool:
    return shutil.which(command) is not None


def mise_healthy() -> bool:
    if not command_exists("mise"):
        return False
    result = subprocess.run(
        ["mise", "--version"],
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
        check=False,
    )
    return result.returncode == 0


def backup_path(path: Path) -> Path:
    return path.with_name(f"{path.name}.backup.{timestamp()}")


def replace_with_symlink(source: Path, destination: Path, *, dry_run: bool) -> None:
    if destination.is_symlink() and destination.resolve() == source.resolve():
        print(f"ok: {destination} -> {source}")
        return

    if destination.exists() or destination.is_symlink():
        backup = backup_path(destination)
        print(f"backup: {destination} -> {backup}")
        if not dry_run:
            destination.rename(backup)

    print(f"link: {destination} -> {source}")
    if not dry_run:
        destination.symlink_to(source, target_is_directory=source.is_dir())


def ensure_git_user_config(root: Path, *, dry_run: bool) -> None:
    path = root / ".gitconfig.user"
    if path.exists():
        return

    print("create: .gitconfig.user")
    if dry_run:
        return

    name = input("Git user.name: ").strip()
    email = input("Git user.email: ").strip()
    path.write_text(f"[user]\n    name = {name}\n    email = {email}\n", encoding="utf-8")


def iter_dotfiles(root: Path) -> list[Path]:
    return sorted(
        path
        for path in root.iterdir()
        if path.name.startswith(".") and path.name not in DOTFILE_EXCLUDES
    )


def install_dotfiles(*, dry_run: bool) -> None:
    root = dotfiles_root()
    home = Path.home()

    ensure_git_user_config(root, dry_run=dry_run)

    for source in iter_dotfiles(root):
        replace_with_symlink(source, home / source.name, dry_run=dry_run)


def ensure_mise(*, dry_run: bool) -> None:
    if mise_healthy():
        return

    system = platform.system()
    if system == "Darwin" and command_exists("brew"):
        command = [
            "sh",
            "-c",
            "brew list mise >/dev/null 2>&1 && brew upgrade mise || brew install mise",
        ]
    else:
        command = ["sh", "-c", "curl https://mise.run | sh"]

    if dry_run:
        print("+", " ".join(command))
        return

    run(command)


def install_tools(*, dry_run: bool) -> None:
    if not mise_healthy():
        if dry_run:
            print("+ mise install --dry-run")
            return
        raise RuntimeError("mise is not available. Re-run with --install-mise or install mise first.")

    command = ["mise", "install", "--dry-run"] if dry_run else ["mise", "install"]
    run(command)


def main() -> None:
    parser = argparse.ArgumentParser(description="Install tanacchi dotfiles.")
    parser.add_argument("--dry-run", action="store_true", help="show planned changes")
    parser.add_argument("--install-mise", action="store_true", help="install mise when missing")
    parser.add_argument("--install-tools", action="store_true", help="run mise install after linking")
    args = parser.parse_args()

    install_dotfiles(dry_run=args.dry_run)

    if args.install_mise:
        ensure_mise(dry_run=args.dry_run)

    if args.install_tools:
        install_tools(dry_run=args.dry_run)

    shell = os.environ.get("SHELL", "")
    if shell.endswith("bash"):
        print("Restart the shell or run: source ~/.bashrc")
    else:
        print("Open a new shell after installation.")


if __name__ == "__main__":
    main()
