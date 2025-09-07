#!/bin/bash
# ros_setup.sh

# Colors
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
RED="\033[0;31m"
NC="\033[0m" # No Color

print_section() {
    printf "\n${YELLOW}==> %s...${NC}\n" "$1"
}

# 1. Setup sources.list
print_section "Adding ROS repository to sources.list"
sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'

# 2. Setup keys
print_section "Adding ROS keys"
sudo apt install -y curl gnupg lsb-release || true
curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | sudo apt-key add - || true

# 3. Update package lists
print_section "Updating package lists"
sudo apt update || printf "${RED}[WARN] Failed to update package lists${NC}\n"

# 4. Install ROS desktop-full
print_section "Installing ROS Noetic desktop-full"
sudo apt install -y ros-noetic-desktop-full || printf "${RED}[SKIP] ros-noetic-desktop-full not found${NC}\n"

# 5. Install common tools
print_section "Installing RQT and development tools"
sudo apt install -y ros-noetic-rqt \
                    ros-noetic-rqt-common-plugins \
                    ros-noetic-rqt-gui-py || true

sudo apt install -y python3-rosdep \
                    python3-rosinstall \
                    python3-rosinstall-generator \
                    python3-wstool \
                    build-essential || true

# 6. Initialize rosdep
print_section "Initializing rosdep"
sudo rosdep init 2>/dev/null || printf "${YELLOW}[INFO] rosdep already initialized${NC}\n"
rosdep update || true

# 7. Detect shell
print_section "Detecting shell"
if [[ "$SHELL" == *"bash"* ]]; then
    CONFIG_FILE=~/.bashrc
elif [[ "$SHELL" == *"zsh"* ]]; then
    CONFIG_FILE=~/.zshrc
else
    CONFIG_FILE="(unknown shell config)"
fi
printf "${GREEN}[OK] Detected shell config file: $CONFIG_FILE${NC}\n"

# 8. Completion message
printf "\n${GREEN}✔ ROS Noetic installation completed!${NC}\n"
printf "${YELLOW}Next steps:${NC}\n"
printf "  1. Open your shell config file: %s\n" "$CONFIG_FILE"
printf "  2. Remove the auto-added 'source /opt/ros/noetic/setup.*' line.\n"
printf "  3. Replace it with the following block:\n\n"

cat <<'EOF'
#-------------------------------------------------------------------------
# ROS Configuration 
#-------------------------------------------------------------------------
# Source ROS environment with redirected output
if [[ -n "$ZSH_VERSION" ]]; then
    source /opt/ros/noetic/setup.zsh > /dev/null 2>&1
else
    source /opt/ros/noetic/setup.bash > /dev/null 2>&1
fi
# Add this line once workspace is created with catkin_make
#source ~/robot/robot_ws/devel/setup.$( [ -n "$ZSH_VERSION" ] && echo zsh || echo bash ) > /dev/null 2>&1

#-------------------------------------------------------------------------
# Environment Variables 
#-------------------------------------------------------------------------
# ROS environment variables
export ROS_ROOT=/opt/ros/noetic
export ROS_DISTRO=noetic
export ROS_HOME=~/robot
export ROS_WORKSPACE=~/robot/robot_ws
export ROS_PACKAGE_PATH=~/robot/robot_ws/src:/opt/ros/noetic/share:${ROS_PACKAGE_PATH}
EOF

printf "\n${YELLOW}After editing %s, run: source %s${NC}\n" "$CONFIG_FILE" "$CONFIG_FILE"
