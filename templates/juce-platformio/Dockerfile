FROM mcr.microsoft.com/devcontainers/cpp:ubuntu-22.04

# JUCE dependencies (audio, GUI, networking)
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
    # Audio
    libasound2-dev \
    libjack-jackd2-dev \
    ladspa-sdk \
    # GUI / X11
    libx11-dev \
    libxcomposite-dev \
    libxcursor-dev \
    libxext-dev \
    libxinerama-dev \
    libxrandr-dev \
    libxrender-dev \
    # Graphics
    libglu1-mesa-dev \
    mesa-common-dev \
    libgl1-mesa-dev \
    # Fonts / Web / Networking
    libfreetype6-dev \
    libcurl4-openssl-dev \
    libwebkit2gtk-4.0-dev \
    # Build tools
    cmake \
    ninja-build \
    pkg-config \
    # PlatformIO dependencies
    python3-pip \
    python3-venv \
    # Utilities
    usbutils \
    screen \
    minicom \
    && apt-get autoremove -y && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

# Install PlatformIO
RUN pip3 install --no-cache-dir platformio

# Pre-install PlatformIO platforms and toolchains for RP2040 and Teensy
RUN pio platform install "raspberrypi" --with-package "framework-arduino-mbed-rp2040" \
    && pio platform install "teensy" --with-package "framework-arduinoteensy"
