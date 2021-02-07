from pathlib import Path
import os
import platform

os_type = platform.system()
distribution = platform.release()

if os_type != 'Linux':
    print("Sorry, this installer is not supported in your environment.")

script_path= Path(__file__).resolve()
dotfiles_dir = script_path.parents[2]
print(dotfiles_dir)
