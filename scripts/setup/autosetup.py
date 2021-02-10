from pathlib import Path, PurePath
import platform
from pprint import pprint
import subprocess


os_type = platform.system()
distribution = platform.release()


if os_type != 'Linux':
    print("Sorry, this installer is not supported in your environment.")
    exit(1)


dotfiles_path = Path.home().joinpath("dotfiles")

if dotfiles_path.is_dir():
    dotfiles_path.replace(Path.home().joinpath("dotfiles.backup"))

repository_url = "https://github.com/tanacchi/dotfiles.git"
_ = subprocess.run(["git", "clone", repository_url, str(dotfiles_path)])
