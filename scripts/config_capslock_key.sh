available_version=1710
current_version=$(cat /etc/os-release | \grep VERSION_ID | tr  -dc '0-9')

if [ $((current_version - available_version)) -lt 0 ]; then
  echo "Please set caps-lock config manually."
else

gsettings set org.gnome.desktop.input-sources xkb-options "['ctrl:nocaps']"
