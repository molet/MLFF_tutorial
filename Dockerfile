# Ubuntu 22.04 LTS
FROM ubuntu:22.04

# Updates & essential
RUN apt-get -y update
RUN apt-get -y upgrade
RUN apt-get install -y build-essential

# Install basic programs
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get install -y wget vim git

# Install Miniconda
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
RUN bash Miniconda3-latest-Linux-x86_64.sh -b -p /home/miniconda3
ENV PATH $PATH:/home/miniconda3/bin
RUN conda update -y -n base -c defaults conda
RUN conda install -y python=3.12
RUN conda install -y pip
RUN conda install -y -c conda-forge ncurses

# Install ipython, jupyter and gdown by pip
RUN pip3 install --upgrade pip
RUN pip3 install ipython
RUN pip3 install jupyter

# Install Python packages
RUN pip3 install --quiet tqdm
RUN pip3 install --quiet numpy
RUN pip3 install --quiet matplotlib
RUN pip3 install --quiet ase
RUN pip3 install --quiet nglview
RUN pip3 install torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cpu

# Install Amber
RUN conda install -y -c conda-forge ambertools
RUN echo "source /home/miniconda3/amber.sh > /dev/null" >> ~/.bashrc

# Get the repo
WORKDIR /home
RUN git clone https://github.com/molet/MLFF_tutorial.git
