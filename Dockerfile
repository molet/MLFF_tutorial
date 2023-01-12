# Ubuntu 22.04 LTS
FROM ubuntu:22.04

# Updates & essential
RUN apt-get -y update
RUN apt-get -y upgrade
RUN apt-get install -y build-essential

# Install basic programs
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get install -y wget vim git
RUN apt-get install -y python3-venv python3-pip python3-dev python3-numpy python3-matplotlib

# Install ipython, jupyter and gdown by pip
RUN pip3 install --upgrade pip
RUN pip3 install ipython
RUN pip3 install jupyter
RUN pip3 install --upgrade --no-cache-dir gdown

# Download the tutorial
WORKDIR /home
RUN mkdir -p /home/ML-FF_tutorial
WORKDIR /home/ML-FF_tutorial
# RUN gdown
RUN mkdir -p /home/ML-FF_tutorial/Programs
WORKDIR /home/ML-FF_tutorial/Programs

# Install Miniconda
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
RUN bash Miniconda3-latest-Linux-x86_64.sh -b -p /home/ML-FF_tutorial/Programs/miniconda3
ENV PATH $PATH:/home/ML-FF_tutorial/Programs/miniconda3/bin
RUN conda update -y -n base -c defaults conda
RUN conda install -y -c conda-forge ncurses

# Install Amber
RUN conda install -y -c conda-forge ambertools
RUN echo "source /home/ML-FF_tutorial/Programs/miniconda3/amber.sh > /dev/null" >> ~/.bashrc

# Install Quippy
RUN pip3 install quippy-ase

# Install ASE
RUN git clone https://gitlab.com/molet/ase.git
ENV PATH $PATH:/home/ML-FF_tutorial/Programs/ase/bin
ENV PYTHONPATH $PYTHONPATH:/home/ML-FF_tutorial/Programs/ase
