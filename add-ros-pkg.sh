#!/bin/bash
set -e

ROS_PKG=$1 #Please see. https://github.com/ros/rosdistro/blob/master/melodic/distribution.yaml


echo "Download $ROS_PKG source code"
#Add ros package
rosinstall_generator $ROS_PKG --rosdistro melodic --deps --tar > melodic-$ROS_PKG.rosinstall
wstool merge melodic-$ROS_PKG.rosinstall -t src
echo "Build workspace"
wstool update -j 4 -t src
./src/catkin/bin/catkin_make_isolated --install -DCMAKE_BUILD_TYPE=Release
echo "Install workspace"
./src/catkin/bin/catkin_make_isolated --install
echo "Add $ROS_PKG to workspace completed"
