#!/bin/bash
# ros_setup.sh

# Exit on any error
set -e

echo "Updating package lists..."
sudo apt update

echo "Installing core MoveIt packages..."
sudo apt install -y ros-noetic-moveit-full
sudo apt install -y ros-noetic-moveit --install-suggests
sudo apt install -y ros-noetic-moveit-python --install-suggests

echo "Installing Gazebo and TF2 packages..."
sudo apt install -y ros-noetic-gazebo-ros-pkgs --install-suggests
sudo apt install -y 'ros-noetic-tf2*'

echo "Installing Trac-IK and related kinematics plugins..."
sudo apt install -y 'ros-noetic-trac-ik*'
sudo apt install -y ros-noetic-trac-ik
sudo apt install -y ros-noetic-trac-ik-python
sudo apt install -y ros-noetic-trac-ik-kinematics-plugin

echo "Installing sensor and visualization tools..."
sudo apt install -y ros-noetic-depthimage-to-laserscan
sudo apt install -y ros-noetic-effort-controllers
sudo apt install -y ros-noetic-urdf-parser-plugin

echo "Installing desktop-full and RQT tools..."
sudo apt install -y ros-noetic-desktop-full
sudo apt install -y ros-noetic-desktop-full --install-suggests
sudo apt install -y ros-noetic-rqt \
                    ros-noetic-rqt-common-plugins \
                    ros-noetic-rqt-gui-py

echo "Installation completed successfully!"