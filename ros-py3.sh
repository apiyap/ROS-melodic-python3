#!/bin/bash
set -e
ROS_PKG=desktop_full  #desktop_full,desktop,ros-base se https://www.ros.org/reps/rep-0131.html#variants
ROS_DISTRO=melodic
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

