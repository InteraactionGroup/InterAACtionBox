
# /********************************************************************************************************/
# /* Part1: Internet Connection and deb Libs installation */

# /**
# ** Copy the libs folder to cubic
# **/


# /* IF INTERNET DOESNT WORK
rm -r /etc/resolv.conf
touch /etc/resolv.conf
echo "nameserver 8.8.8.8" > /etc/resolv.conf

cd Libs/

#apt -y install ./dos2unix_7.4.0-2_amd64.deb ./gconf2_3.2.6-6ubuntu1_amd64.deb ./gconf2-common_3.2.6-6ubuntu1_all.deb ./gconf-service_3.2.6-6ubuntu1_amd64.deb ./gconf-service-backend_3.2.6-6ubuntu1_amd64.deb ./libappindicator1_12.10.1+18.04.20180322.1-0ubuntu1_amd64.deb ./libdbusmenu-gtk4_16.04.1+18.04.20171206-0ubuntu1_amd64.deb ./libgconf-2-4_3.2.6-6ubuntu1_amd64.deb ./libindicator7_12.10.2+16.04.20151208-0ubuntu1_amd64.deb ./TobiiProEyeTrackerManager-2.1.2.deb ./multiarch-support_2.27-3ubuntu1_amd64.deb ./google-chrome-stable_current_amd64.deb ./xdotool_3.20160805.1-4_amd64.deb

echo "deb http://fr.archive.ubuntu.com/ubuntu/ focal main restricted universe multiverse
deb http://security.ubuntu.com/ubuntu/ focal-security main restricted
deb http://archive.ubuntu.com/ubuntu/ focal-updates main restricted
" > /etc/apt/sources.list
apt-get update
apt-get -y install build-essential
apt-get -y install curl
apt-get -y install ./*.deb
apt-get -y install google-chrome-stable


# /********************************************************************************************************/
# /* Part2 : Set-Up GazePlay, InteraactionScene and Tobii */

cp -r ~/interaactionBox_Interface-linux /etc/skel/
cd /etc/skel/interaactionBox_Interface-linux/lib/jre/bin/
chmod +x java
cp ~/Ressources/configuration.conf /etc/skel/interaactionBox_Interface-linux/bin/
cd ../../../bin
dos2unix interaactionBoxOS-linux.sh
cd ./scripts/
dos2unix ./*

cd ./ISOScripts
sh ./gazeplayUpdate.sh
sh ./interAACtionGazeUpdate.sh 


mkdir /etc/skel/dist
sh ./interAACtionSceneUpdate.sh
sh ./interAACtionPlayerUpdate.sh
sh ./augcomUpdate.sh

# /********************************************************************************************************/
# /* Part3 : Create Desktop Shortcut */

cd /etc/skel
mkdir Desktop
cd Desktop/

cp -R ~/Ressources/.email /etc/skel/
cp ~/Ressources/interaactionBoxLauncher /etc/skel/
cd /etc/skel/
chmod +x interaactionBoxLauncher

cd /etc/skel/
mkdir .config
cd .config
mkdir autostart

cd /etc/skel/
mkdirs .local/
mkdirs .local/share
mkdirs .local/share/applications
cp ~/Ressources/DesktopFiles/*.desktop  .local/share/applications
chmod a+x /etc/skel/.local/share/applications
cp ~/Ressources/DesktopFiles/InteraactionBoxLauncher.desktop /etc/skel/.config/autostart
chmod a+x /etc/skel/.config/autostart/InteraactionBoxLauncher.desktop

cp -R ~/Ressources/Launcher /etc/skel/
chmod a+x /etc/skel/Launcher/*

# dbus-launch gio set InteraactionBoxLauncher.desktop "metadata::trusted" true

mkdir /etc/skel/Update
cp -R ~/Scripts/* /etc/skel/Update

# /********************************************************************************************************/
# /* Part4 : Choose the default wallpaper */

cd /usr/share/backgrounds/
cp ~/Ressources/wallpaper_interaactionBox.png /usr/share/backgrounds/

# sed -i 's/\<filename\>.*\<\/filename\>/\<filename\>\/usr\/share\/backgrounds\/wallpaper_interaactionBox.png\<\/filename\>/' /usr/share/gnome-background-properties/ubuntu-wallpapers.xml

# sed -i 's/<\/wallpapers>/ \<wallpaper\>\n     \<name\>InteraactionBox wallpaper\<\/name\>\n     \<filename\>\/usr\/share\/backgrounds\/wallpaper_interaactionBox.png\<\/filename\>\n     \<options\>zoom\<\/options\>\n     \<pcolor\>#000000\<\/pcolor\>\n     \<scolor\>#000000\<\/scolor\>\n     \<shade_type\>solid\<\/shade_type\>\n \<\/wallpaper\>\n\<\/wallpapers\>/' /usr/share/gnome-background-properties/focal-wallpapers.xml

# sed -i "s@picture-uri.*\'@picture-uri = \'file:///usr/share/backgrounds/wallpaper_interaactionBox.png\'@g" /usr/share/glib-2.0/schemas/10_ubuntu-settings.gschema.override

cp ~/Ressources/90_ubuntu-custom.gschema.override /usr/share/glib-2.0/schemas/

glib-compile-schemas /usr/share/glib-2.0/schemas/

# /********************************************************************************************************/
# /* Part6 : locale */

cd /usr/share/localechooser/

echo "fr;0;FR;fr_FR.UTF-8;;console-setup
en;1;US;en_US.UTF-8;;console-setup" > languagelist

echo "en
fr" > shortlists

gunzip languagelist.data.gz 
echo "1:en:English:English
0:fr:French:Français" > languagelist.data 
gzip languagelist.data


cd /usr/lib/ubiquity/localechooser
cp /usr/share/localechooser/languagelist ./
cp /usr/share/localechooser/languagelist.data.gz ./
cp /usr/share/localechooser/regionmap ./           
cp /usr/share/localechooser/shortlists ./

# /********************************************************************************************************/
# /* Part7 : account creation */
echo "yes" > /etc/skel/.config/gnome-initial-setup-done
#adduser localadmin --group sudo

# cd /usr/share/polkit-1/actions/
# gedit org.freedesktop.NetworkManager.policy
# System policy prevents modification of network settings for all users
# and change to <allow_active>yes</allow_active>


# /********************************************************************************/
# /* ICONS
cd /usr/share/icons/
mkdir interaaction
cp ~/Ressources/icons/* /usr/share/icons/interaaction
