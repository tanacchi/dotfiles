import logging
import platform
import shutil
import subprocess
from pathlib import Path, PurePath
from pprint import pprint


def is_github_ssh_config_exists():
    ssh_config_path = Path(Path.home(), ".ssh", "config")
    if ssh_config_path.is_file():
        with open(ssh_config_path, 'r') as f:
            if 'github' in f.read():
                return True
    return False


logging.basicConfig(level=logging.DEBUG)

# Check environment
os_type = platform.system()
distribution = platform.release()

if os_type != 'Linux':
    logging.warning(
        "Sorry, this installer is not supported in your environment.")
    exit(1)

# Path settings
dotfiles_path = Path.home().joinpath("dotfiles")
scripts_path = dotfiles_path.joinpath("scripts")

# Make backup of dotfiles
if dotfiles_path.is_dir():
    dotfiles_path.replace(Path.home().joinpath("dotfiles.backup"))
    logging.info("~/dotfiles has been existed, so replaced.")

# Check ssh config for GitHub
if (is_ssh_configured := is_github_ssh_config_exists()):
    repository_url = "git@github.com:tanacchi/dotfiles.git"
else:
    repository_url = "https://github.com/tanacchi/dotfiles.git"

logging.info(f"$ git clone {repository_url} {str(dotfiles_path)}")

# Clone this repository
_ = subprocess.run(["git", "clone", repository_url, str(dotfiles_path)])
logging.debug(f"git clone ${repository_url} finished.")

if not is_ssh_configured:
    Path.home().joinpath(".ssh").mkdir(exist_ok=True)
    ssh_config_script_path = Path(scripts_path, "config", "git_ssh_config.sh")
    status = subprocess.run(["sh", str(ssh_config_script_path)])
    logging.info("~/.ssh/config is updated for github.")

scripts = ["git.sh", "vivaldi.sh", "vim.bash"]
tools_path = scripts_path.joinpath("tools")
for path in scripts:
    path = tools_path.joinpath(path)
    if not path.is_file():
        raise FileNotFoundError(f"{str(path)} is not found.")
    proc = path.suffix[1:]
    logging.info(f"'Running $ {proc} {path}'")
    _ = subprocess.run([proc, str(path)], stdout=subprocess.STDOUT)

print("""
Download pages:
\tSlack:   https://slack.com/intl/ja-jp/downloads/linux
\tZoom:    https://zoom.us/download?os=linux
\tDiscord: https://discord.com/download""")

if is_ssh_configured:
    exit(0)

print(f"""
Please make ssh key for github and access the link below to set it up.
https://github.com/settings/ssh/new

And re-run this script by
curl -L https://tanacchi.github.io/dotfiles | sh
""")
shutil.rmtree(dotfiles_path)
