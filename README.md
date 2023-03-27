# MLFF Tutorial

This repository includes the [MLFF.ipynb](./MLFF.ipynb) Jupyter notebook for the Machine Learning-based Force Fields lectures.

There are 3 possibilities to run the notebook:

1. [Locally on your machine](#Running-the-notebook-locally-on-your-machine)
2. [On Colab](Running-the-notebook-on-Colab)
3. [From Docker](Running-the-notebook-from-Docker)

## 1. Running the notebook locally on your machine

We are using [Python3](https://www.python.org/) and [Jupyter notebook](https://jupyter.org/install).
The latter, as many other packages that we are using, can be installed by [pip](https://pip.pypa.io/en/stable/), the package installer for Python.

After installing Jupyter notebook, download the [MLFF.ipynb](./MLFF.ipynb), [open it](https://jupyter-notebook-beginner-guide.readthedocs.io/en/latest/execute.html) and follow the instructions in the `Installation of softwares` section to install the required packages.

## 2. Running the notebook on Colab

[Colab](https://colab.research.google.com/) provides a virtual machine, where Jupyter notebooks can be run.

It also has a bunch of Python packages pre-installed so it is a convenient way to run the notebook.

Use [this link](https://colab.research.google.com/drive/1bYlVBEH32tVemb_ZC-gNE2ucMHx6sTF1) to access the Colab version of the notebook.

There is a limitation of using this approach as it is currently not supported in Colab to visualize MD trajectories.

## 3. Running the notebook from Docker

If you are having difficulties with installing the required packages locally, you can also use [Docker](https://docs.docker.com/get-started/overview/) that provides a lightweight and fast virtual machine on which you can also run the notebook (for more information visit the [Docker documentation](https://docs.docker.com/)).

### 3.1. Install Docker

1. [Download and install Docker](https://docs.docker.com/get-docker/) for your corresponding platform. For [Mac](https://docs.docker.com/desktop/mac/install/) and [Windows](https://docs.docker.com/desktop/windows/install/) it is the Docker Desktop, while for [Linux](https://docs.docker.com/engine/install/) it is the Docker Engine.

2. Start Docker by running the Docker Desktop or on Linux by typing `sudo service docker start` in a terminal.

3. Verify Docker by typing `sudo docker run hello-world` in a terminal.

Congratulations, you have Docker on your machine!

### 3.2. Build the Docker Image

Download the [Dockerfile](./Dockerfile) provided within this repository. You can either copy the raw content and save it with the same filename on your machine, or use [Git](https://git-scm.com/downloads) and clone the repository:

```
git clone https://github.com/molet/MLFF_tutorial.git
```

You can update the contents of the repository on you machine by typing `git pull` after entering `MLFF_tutorial`.

Once you have the Dockerfile on your machine, enter to its directory and build the image by typing:

```
docker build -t mlff_image:latest .
```

For M1 Mac series we need to set the target platform to linux/amd64:

```
docker build --platform=linux/amd64 -t mlff_image:latest .
```

These will build the virtual machine `mlff_image` with the tag `latest`. It is a Linux Ubuntu 22.04 operating system with all required program packages.

### 3.3. Run a Container over the Docker Image

You can run the image inside of a container by using [`docker run`](https://docs.docker.com/engine/reference/commandline/run/) (for M1 Mac add the flag for platform as used in bulding the image, i.e. `--platform=linux/amd64`):

```
docker run --name=mlff_container --ulimit stack=-1 --publish=9999:9999 --entrypoint /bin/bash --workdir="/home/MLFF_tutorial" --rm -it mlff_image:latest
```

In the above command, with the `--name` flag we name the container (as `mlff_container`), `--ulimit stack=-1` will set the stack space unlimited (this is equivalent to run `ulimit -s unlimited` on Linux and required to run XdynBP nicely), `--publish=9999:9999` publishes the port 9999 of the container to the port 9999 of the host (this will be used to access the notebook outside of the container), with `--entrypoint /bin/bash` we use the bash shell, `--workdir="/home/MLFF_tutorial"` specifies the directory we enter, `--rm` removes the container if exists and `-it` makes sure we can use the container interactively.

### 3.4. Running Jupyter Notebook from a Docker Container

Once you are running a container as described above, you can start a notebook in the working directory (`/home/MLFF_tutorial`):

```
jupyter notebook --no-browser --ip=0.0.0.0 --port=9999 --allow-root
```

After the server started, it should print out something like this:

```
    To access the notebook, open this file in a browser:
        file:///root/.local/share/jupyter/runtime/nbserver-92-open.html
    Or copy and paste one of these URLs:
        http://01109c22e8b6:9999/?token=a14df6b6eef9000f985dda1997336767fb0ef184bdd1a31c
     or http://127.0.0.1:9999/?token=a14df6b6eef9000f985dda1997336767fb0ef184bdd1a31c
```

If you copy and paste any of these URLs in your browser (your actual URLs will be different from the above example), you should have access to the notebooks in the container.

### 3.5. Useful Docker Commands

Use [`docker images`](https://docs.docker.com/engine/reference/commandline/images/) and [`docker ps`](https://docs.docker.com/engine/reference/commandline/ps/) to list images and containers on your machine.

Once a container is running, you can run a new command by [`docker exec`](https://docs.docker.com/engine/reference/commandline/exec/). For instance, if you already started the container by the above `docker run` command then you can enter it interactively from another terminal by typing:

```
docker exec -it mlff_container /bin/bash
```

It is important to note that once you finish running a command (e.g. stop and exit the container) then all data and changes you made in the container will be lost. In order to save your changes, you can create a new image from the container by the [`docker commit`](https://docs.docker.com/engine/reference/commandline/commit/) command:

```
docker commit mlff_container mlff_images:new
```

We cannot directly access the files and folders in a container from our local filesystem. However, if required, files and folders can be copied between the container and local filesystem by the [`docker cp`](https://docs.docker.com/engine/reference/commandline/cp/) command. For example, if you run the `mlff_container` then the PDB file generated in the beginning of the tutorial can copied to your local folder by typing:

```
docker cp mlff_container:/home/MLFF_tutorial/dialanine.pdb .
