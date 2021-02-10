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
scripts_path = dotfiles_path.joinpath("scripts")

#  if dotfiles_path.is_dir():
    #  dotfiles_path.replace(Path.home().joinpath("dotfiles.backup"))

#  repository_url = "https://github.com/tanacchi/dotfiles.git"
#  _ = subprocess.run(["git", "clone", repository_url, str(dotfiles_path)])

Path.home().joinpath(".ssh").mkdir(exist_ok=True)
ssh_config_script_path = Path(scripts_path, "config", "git_ssh_config.sh")


#  _ = subprocess.run(["sh", str(ssh_config_script_path)])

scripts = ["git.sh", "vivaldi.sh", "vim.bash"]
tools_path = scripts_path.joinpath("tools")
for path in scripts:
    path = tools_path.joinpath(path)
    if not path.is_file():
        raise FileNotFoundError(f"{str(path)} is not found.");
    proc = path.suffix[1:]
    #  _ = subprocess.run([proc, str(path)])


#  dotfiles_path.unlink()

print("""
Download pages:
\tSlack:   https://slack.com/intl/ja-jp/downloads/linux
\tZoom:    https://zoom.us/download?os=linux
\tDiscord: https://discord.com/download

Please make ssh key for github and access the link below to set it up.
https://github.com/settings/ssh/new"""
)
