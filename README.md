# ROS-melodic-python3
Official instructions can be found [here ->>](http://wiki.ros.org/melodic/Installation/Source)

It may be need build OpenCV3 before installation.
from [here->>](https://github.com/apiyap/buildOpenCV3)
<pre>
chmod +x ros-py3.sh
./ros-py3.sh
</pre>
# Install additional packages
For example install ros_control package
<pre>
cd CATKIN_ROS_WORKSPACE/src
wstool init
wstool merge https://raw.github.com/ros-controls/ros_control/melodic-devel/ros_control.rosinstall
#OR if wstool init  Error try
rosinstall_generator robot --rosdistro melodic --deps --tar > melodic-robot.rosinstall
wstool merge melodic-robot.rosinstall -t src

wstool update
cd ..
rosdep install --from-paths . --ignore-src --rosdistro melodic -y
catkin_make
</pre>

# Note

Please remove /opt/ros/melodic/bin: from PATH
and make sure add follwing to ~/.bashrc
<pre>
source ~/ros_catkin_ws/install_isolated/setup.bash
export PATH=$PATH:~/ros_catkin_ws/install_isolated/bin
</pre>
