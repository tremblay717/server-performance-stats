# Server Performance Stats
Goal of this project is to write a script to analyse server performance stats.

This script was written as part of the projects available on [roadmap.sh](https://roadmap.sh/projects/server-stats).

# Installing
Start by cloning the repo to a local Debian Based System:

```
git clone https://github.com/tremblay717/server-performance-stats.git
```

# Dependencies
You will need to install the bc package to make the script work. It is necessary to perform mathematical calculations.

Ref: [GNU bc](https://github.com/tremblay717/server-performance-stats.git)

```
sudo apt update
sudo apt install bc
```

# Running the script
**For the next steps, make sure you are in the repo folder on your machine**

## Make the script executable
```
chmod +x ./server-stats.sh 
```

## Launch the script

```
./server-stats.sh 
```


