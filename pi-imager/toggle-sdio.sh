ENABLED=$(grep "#dtoverlay=sdio" /boot/config.txt)
if [ ! -z $ENABLED ]; then
  sudo sed -i -E 's/(dtoverlay=sdio.*)/#\1/' /boot/config.txt
else
  sudo sed -i -E 's/#(dtoverlay=sdio.*)/\1/' /boot/config.txt
fi