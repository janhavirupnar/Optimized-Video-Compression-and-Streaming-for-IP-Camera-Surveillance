#!/bin/bash
cd /home/pi/Desktop/offline/
sudo apt update
sudo apt upgrade -y
sudo apt install aptitude -y
sudo apt-get install libx264-dev libjpeg-dev
sudo aptitude install libgstreamer1.0-dev \
     libgstreamer-plugins-base1.0-dev \
     libgstreamer-plugins-bad1.0-dev \
     gstreamer1.0-plugins-ugly \
     gstreamer1.0-tools

sudo apt-get install gstreamer1.0-gl gstreamer1.0-gtk3
sudo apt-get install gstreamer1.0-pulseaudio
tar -xf gst-rtsp-server-1.14.4.tar.xz
cd gst-rtsp-server-1.14.4
./configure
make
sudo make install
sudo ldconfig
cd
sudo rm -rf /usr/bin/gst-*
sudo rm -rf /usr/include/gstreamer-1.0
sudo apt-get install cmake meson flex bison
sudo apt-get install libglib2.0-dev libjpeg-dev libx264-dev
sudo aptitude install libgtk2.0-dev libgtk-3-dev
sudo aptitude install libasound2-dev
cd /home/pi/Desktop/offline/
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

sudo apt install librtmp-dev
sudo apt-get install libvo-aacenc-dev
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
cd
sudo aptitude install -y gstreamer1.0-omx
sudo apt-get install libopencv-dev
sudo apt-get install python3-opencv
python3 gstreamer.py