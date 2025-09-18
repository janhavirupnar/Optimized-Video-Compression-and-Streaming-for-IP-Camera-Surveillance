#!/bin/bash

cd /home/pi/Desktop/offline/libx264-dev
sudo dpkg -i ./*.deb
cd

cd /home/pi/Desktop/offline/libjpeg-dev
sudo dpkg -i ./*.deb
cd

cd /home/pi/Desktop/offline/libgstreamer1.0-dev
sudo dpkg -i ./*.deb
cd

cd /home/pi/Desktop/offline/libgstreamer-plugins-base1.0-dev
sudo dpkg -i ./*.deb
cd

cd /home/pi/Desktop/offline/libgstreamer-plugins-bad1.0-dev
sudo dpkg -i ./*.deb
cd

cd /home/pi/Desktop/offline/gstreamer1.0-plugins-ugly
sudo dpkg -i ./*.deb
cd

cd /home/pi/Desktop/offline/gstreamer1.0-tools
sudo dpkg -i ./*.deb
cd

cd /home/pi/Desktop/offline/gstreamer1.0-gl
sudo dpkg -i ./*.deb
cd

cd /home/pi/Desktop/offline/gstreamer1.0-gtk3
sudo dpkg -i ./*.deb
cd

cd /home/pi/Desktop/offline/gstreamer1.0-pulseaudio
sudo dpkg -i ./*.deb
cd ..

tar -xf gst-rtsp-server-1.14.4.tar.xz
cd gst-rtsp-server-1.14.4
./configure
make
sudo make install
sudo ldconfig
cd

sudo rm -rf /usr/bin/gst-*
sudo rm -rf /usr/include/gstreamer-1.0

cd /home/pi/Desktop/offline/cmake
sudo dpkg -i ./*.deb
cd

cd /home/pi/Desktop/offline/meson
sudo dpkg -i ./*.deb
cd

cd /home/pi/Desktop/offline/flex
sudo dpkg -i ./*.deb
cd

cd /home/pi/Desktop/offline/bison
sudo dpkg -i ./*.deb
cd

cd /home/pi/Desktop/offline/aptitude/
sudo dpkg -i ./*.deb
cd

cd /home/pi/Desktop/offline/libglib2.0-dev
sudo dpkg -i ./*.deb
cd

cd /home/pi/Desktop/offline/libjpeg-dev
sudo dpkg -i ./*.deb
cd

cd /home/pi/Desktop/offline/libx264-dev
sudo dpkg -i ./*.deb
cd

cd /home/pi/Desktop/offline/libgtk2.0-dev
sudo dpkg -i ./*.deb
cd

cd /home/pi/Desktop/offline/libgtk-3-dev
sudo dpkg -i ./*.deb
cd

cd /home/pi/Desktop/offline/libasound2-dev
sudo dpkg -i ./*.deb
cd ..

sudo tar -xf gstreamer-1.18.4.tar.xz
cd gstreamer-1.18.4
mkdir build && cd build
meson --prefix=/usr \
        --wrap-mode=nofallback \
        -D buildtype=release \
        -D gst_debug=true \
        -D package-origin=https://gstreamer.freedesktop.org/src/gstreamer/ \
        -D package-name="GStreamer 1.18.4 BLFS" ..
ninja -j4
ninja test
sudo ninja install
sudo ldconfig
cd ..
cd ..

sudo tar -xf gst-plugins-base-1.18.4.tar.xz
cd gst-plugins-base-1.18.4
mkdir build && cd build
meson --prefix=/usr \
-D buildtype=release \
-D package-origin=https://gstreamer.freedesktop.org/src/gstreamer/ ..

ninja -j4
sudo ninja install
sudo ldconfig
cd ..
cd ..

sudo tar -xf gst-plugins-good-1.18.4.tar.xz
cd gst-plugins-good-1.18.4
mkdir build && cd build
meson --prefix=/usr       \
       -D buildtype=release \
       -D package-origin=https://gstreamer.freedesktop.org/src/gstreamer/ \
       -D package-name="GStreamer 1.18.4 BLFS" ..

ninja -j4
sudo ninja install
sudo ldconfig
cd ..
cd ..

cd /home/pi/Desktop/offline/librtmp-dev
sudo dpkg -i ./*.deb
cd

cd /home/pi/Desktop/offline/libvo-aacenc-dev
sudo dpkg -i ./*.deb
cd ..

sudo tar -xf gst-plugins-bad-1.18.4.tar.xz
cd gst-plugins-bad-1.18.4
mkdir build && cd build
meson --prefix=/usr       \
       -D buildtype=release \
       -D package-origin=https://gstreamer.freedesktop.org/src/gstreamer/ \
       -D package-name="GStreamer 1.18.4 BLFS" ..

ninja -j4
sudo ninja install
sudo ldconfig
cd ..
cd ..

sudo tar -xf gst-plugins-ugly-1.18.4.tar.xz
cd gst-plugins-ugly-1.18.4
mkdir build && cd build
meson --prefix=/usr       \
      -D buildtype=release \
      -D package-origin=https://gstreamer.freedesktop.org/src/gstreamer/ \
      -D package-name="GStreamer 1.18.4 BLFS" ..

ninja -j4
sudo ninja install
sudo ldconfig
cd ..
cd ..

sudo tar -xf gst-omx-1.18.4.tar.xz
cd gst-omx-1.18.4
mkdir build && cd build
meson --prefix=/usr       \
       -D header_path=/opt/vc/include/IL \
       -D target=rpi \
       -D buildtype=release ..

ninja -j4
sudo ninja install
sudo ldconfig
cd ..
cd ..

cd /home/pi/Desktop/offline/gstreamer1.0-omx
sudo dpkg -i ./*.deb
cd

cd /home/pi/Desktop/offline/libopencv-dev
sudo dpkg -i ./*.deb
cd

cd /home/pi/Desktop/offline/python3-opencv
sudo dpkg -i ./*.deb
cd ..
cd ..

python3 gstreamer.py
