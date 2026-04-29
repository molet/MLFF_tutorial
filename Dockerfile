# Ubuntu 22.04 LTS
FROM ubuntu:22.04

# Updates & essential
RUN apt-get -y update
RUN apt-get -y upgrade
RUN apt-get install -y build-essential

# Install basic programs
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get install -y wget vim git

# Install Miniconda
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
RUN bash Miniconda3-latest-Linux-x86_64.sh -b -p /home/miniconda3
ENV PATH=/home/miniconda3/bin:$PATH
ENV CONDA_PLUGINS_AUTO_ACCEPT_TOS=true
RUN conda update -y -n base -c defaults conda
RUN conda install -y -c conda-forge python pip

# Install jupyter notebook by pip
RUN pip3 install --upgrade pip
RUN pip3 install notebook

# Install Python packages
RUN pip3 install tqdm
RUN pip3 install numpy
RUN pip3 install matplotlib
RUN pip3 install ase
RUN pip3 install "nglview<4"
RUN pip3 install torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cpu

# Install Amber
RUN conda install -y -c conda-forge ambertools

# Get the repo
WORKDIR /home
RUN git clone https://github.com/molet/MLFF_tutorial.git
