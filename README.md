# ROS-melodic-python3
Official instructions can be found [here ->>](http://wiki.ros.org/melodic/Installation/Source)

It may be need build OpenCV3 before installation.
from [here->>](https://github.com/apiyap/buildOpenCV3)
<pre>
chmod +x ros-py3.sh
./ros-py3.sh
</pre>
# Install additional packages
Please see package name from. https://github.com/ros/rosdistro/blob/master/melodic/distribution.yaml

<pre>
chmod +x add-ros-pkg.sh
./add-ros-pkg.sh ros_control
</pre>

# Note

Please remove /opt/ros/melodic/bin: from PATH
and make sure add follwing to ~/.bashrc
<pre>
source ~/ros_catkin_ws/install_isolated/setup.bash
export PATH=$PATH:~/ros_catkin_ws/install_isolated/bin
</pre>
