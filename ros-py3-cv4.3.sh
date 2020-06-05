#!/bin/bash
set -e
WHEREAMI=$PWD
echo "Setup your sources.list"
sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
echo "Set up your keys"
sudo apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654

ROS_PKG=desktop_full  #desktop_full,desktop,ros-base se https://www.ros.org/reps/rep-0131.html#variants
ROS_DISTRO=melodic
echo "Preparing.."
export ROS_PYTHON_VERSION=3
export PYTHONPATH=/usr/local/python/cv2/python-3.6/:/usr/local/python/cv2/python-3.6/
source ~/.bashrc
sudo apt-get install -y python-rosdep python3-dev python3-pip python-rosinstall-generator python-wstool python-rosinstall build-essential
echo "Generic (pip):"
sudo pip3 install -U rosdep rosinstall_generator wstool rosinstall
sudo pip3 install --upgrade setuptools
echo "Initializing rosdep"
FILE=/etc/ros/rosdep/sources.list.d/20-default.list
if test -f "$FILE"; then
    echo "$FILE exist"
    sudo rm $FILE
fi

sudo rosdep init
rosdep update

echo "Installation"
echo "Create a catkin Workspace"
mkdir -p ~/ros_catkin_ws
cd ~/ros_catkin_ws
echo "ros install generator .."
rosinstall_generator $ROS_PKG --rosdistro $ROS_DISTRO --deps --tar > $ROS_DISTRO-$ROS_PKG.rosinstall

wstool init -j4 src $ROS_DISTRO-$ROS_PKG.rosinstall

echo "Update patch..."
cd ~
patch -N -p1 -d ~/ros_catkin_ws < $WHEREAMI'/patchs/opencv4.3.0.patch'
cd ~/ros_catkin_ws

echo "Resolving Dependencies"
set +e
RET=1
until [ ${RET} -eq 0 ]; do
sudo apt install -y python3-catkin-pkg python3-rosdistro python3-rospkg python3-rosdep-modules python3-rosdep
rosdep install --from-paths src --ignore-src --rosdistro $ROS_DISTRO -y
RET=$?
sleep 10
done
set -e

echo "Building the catkin Workspace"
./src/catkin/bin/catkin_make_isolated 
source ~/ros_catkin_ws/install_isolated/setup.bash
echo "Update the workspace"
mv -i $ROS_DISTRO-$ROS_PKG.rosinstall $ROS_DISTRO-$ROS_PKG.rosinstall.old
rosinstall_generator $ROS_PKG --rosdistro $ROS_DISTRO --deps --tar > $ROS_DISTRO-$ROS_PKG.rosinstall
diff -u $ROS_DISTRO-$ROS_PKG.rosinstall $ROS_DISTRO-$ROS_PKG.rosinstall.old
wstool merge -t src $ROS_DISTRO-$ROS_PKG.rosinstall
wstool update -t src

echo "Rebuild your workspace"
./src/catkin/bin/catkin_make_isolated --install -DCMAKE_BUILD_TYPE=Release
echo "source ~/ros_catkin_ws/install_isolated/setup.bash" >> ~/.bashrc
echo "export PATH=$PATH:~/ros_catkin_ws/install_isolated/bin:~/ros_catkin_ws/install_isolated/lib" >> ~/.bashrc
echo "export ROS_PYTHON_VERSION=3" >> ~/.bashrc
echo "alias catkin_make=catkin_make_isolated" >> ~/.bashrc

source ~/ros_catkin_ws/install_isolated/setup.bash
echo "Build completed"
