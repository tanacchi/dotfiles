from pathlib import Path
import subprocess
import platform


def create_git_user_config(git_user_config_path):
    name  = input("Please set your NAME on GitHub : ")
    email = input("Please set your EMAIL on GitHub : ")
    content = f"""[user]
    name = {name}
    email = {email}\n"""
    with open(git_user_config_path, 'w') as f:
        f.write(content)


def install_config(target, dir=Path.home(), name=None):
    name = target.name if name is None else name
    dst = dir.joinpath(name)
    if dst.exists():
        dst.replace(Path.home().joinpath(name + ".backup"))
        print(f"{name} is replaced.")
    dst.symlink_to(target)


def install_dotfiles():
    os_type = platform.system()
    distribution = platform.release()

    if os_type != 'Linux':
        print("Sorry, this installer is not supported in your environment.")
        exit(1)

    script_path= Path(__file__).resolve()
    dotfiles_path = script_path.parents[2]

    git_user_config_path = dotfiles_path.joinpath(".gitconfig.user")
    if git_user_config_path.is_file():
        print("This dotfiles is already installed.")
        exit(1)

    create_git_user_config(git_user_config_path)

    exclude_list = [
        ".emacs.d.old", ".terminator", ".gitmodules",
        ".gitignore", ".git"
    ]
    exclude_list = [dotfiles_path.joinpath(f) for f in exclude_list]

    for target in dotfiles_path.glob(".*"):
        if any(map(lambda f: f.samefile(target), exclude_list)):
            continue
        install_config(target)

    terminator_config_dir = Path(Path.home(), ".config", "terminator")
    terminator_config_dir.mkdir(parents=True, exist_ok=True)
    install_config(
        dotfiles_path.joinpath(".terminator"),
        terminator_config_dir,
        name="config"
    )

    _ = subprocess.run(["git", "submodule", "init"])
    _ = subprocess.run(["git", "submodule", "update"])


if __name__ == '__main__':
    install_dotfiles()
