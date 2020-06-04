#!/bin/bash
set -e
diff -ruN --exclude="*.pyc" ros_org_ws/src ros_catkin_ws/src/ > opencv4.3.0.patch

