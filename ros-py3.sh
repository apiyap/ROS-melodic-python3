#!/bin/bash
set -e
ROS_PKG=desktop_full  #desktop_full,desktop,ros-base se https://www.ros.org/reps/rep-0131.html#variants
ROS_DISTRO=melodic
echo "Preparing.."
echo "export ROS_PYTHON_VERSION=3" >> ~/.bashrc
echo "export PYTHONPATH=/usr/local/python/cv2/python-3.6/:/usr/local/python/cv2/python-3.6/" >> ~/.bashrc
source ~/.bashrc
sudo apt-get install -y python-rosdep python-rosinstall-generator python-wstool python-rosinstall build-essential
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
echo "Resolving Dependencies"
sudo apt install -y python3-rosdep
rosdep install --from-paths src --ignore-src --rosdistro $ROS_DISTRO -y
echo "Building the catkin Workspace"
./src/catkin/bin/catkin_make_isolated --install -DCMAKE_BUILD_TYPE=Release
source ~/ros_catkin_ws/install_isolated/setup.bash
echo "Update the workspace"
mv -i $ROS_DISTRO-$ROS_PKG.rosinstall $ROS_DISTRO-$ROS_PKG.rosinstall.old
rosinstall_generator $ROS_PKG --rosdistro $ROS_DISTRO --deps --tar > $ROS_DISTRO-$ROS_PKG.rosinstall
diff -u $ROS_DISTRO-$ROS_PKG.rosinstall $ROS_DISTRO-$ROS_PKG.rosinstall.old
wstool merge -t src $ROS_DISTRO-$ROS_PKG.rosinstall
wstool update -t src
echo "Rebuild your workspace"
./src/catkin/bin/catkin_make_isolated --install

