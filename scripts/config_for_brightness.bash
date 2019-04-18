#!/bin/bash

grub_config_file="/etc/default/grub"
if grep -E '^GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"$' ${grub_config_file} > /dev/null; then
  sudo sed -ie 's/"quiet splash"$/"quiet splash acpi_backlight=video"/1' ${grub_config_file}
  sudo update-grub
fi

device_config=\
'Section "Device"
  Identifier "Intel Graphics"
  Driver     "intel"
  Option     "AccelMethod" "sna"
  Option     "Backlight"   "acpi_video0"
  BusID      "PCI:0:2:0"
EndSection'
device_config_file="/usr/share/X11/xorg.conf.d/80-backlight.conf"
sudo touch "${device_config_file}"
echo "${device_config}" | sudo tee "${device_config_file}"
echo "Done. You shold reboot to apply changes."
