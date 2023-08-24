FROM ubuntu:18.04

ENV TZ=UTC
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Set up environment variables for ROS
ENV ROS_DISTRO melodic

# Add ROS repository and key
RUN apt-get update && apt-get install -y gnupg2 lsb-release curl && \
    sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list' && \
    curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add -

# Install Mesa for OpenGL
RUN apt-get update && apt-get install -y \
    libgl1-mesa-glx \
    libgl1-mesa-dri && \
    rm -rf /var/lib/apt/lists/*

# Install ROS Melodic
RUN apt-get update && apt-get install -y ros-melodic-desktop-full && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Initialize rosdep
RUN apt-get update && apt-get install -y python-rosdep && \
    rosdep init && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Update rosdep
RUN rosdep update

# Set up ROS environment
RUN echo "source /opt/ros/melodic/setup.bash" >> ~/.bashrc
