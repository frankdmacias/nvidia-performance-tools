FROM nvidia/cuda-ppc64le:10.2-devel-ubuntu18.04

# Set one or more individual labels
LABEL maintainer="Carl Pearson"

# prevent prompts during apt-get
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y -q --no-install-recommends --no-install-suggests \
  cmake \
  libglib2.0 \
  && rm -rf /var/lib/apt/lists/*

COPY test.cu .
COPY nsight-compute-PPC64LE-2019.5.0.14-27346997.run nsight_compute.run
COPY NVIDIA_Nsight_Systems_Power_CLI_Only_2020.2.1.71.deb nsight_systems.deb

# install Nsight Compute
# install script seems to want TERM set
RUN chmod +x nsight_compute.run
RUN TERM=xterm ./nsight_compute.run --quiet -- -noprompt -targetpath=/usr/local/NVIDIA-Nsight-Compute
ENV PATH=$PATH:/usr/local/NVIDIA-Nsight-Compute

# install Nsight Systems
RUN dpkg -i nsight_systems.deb
