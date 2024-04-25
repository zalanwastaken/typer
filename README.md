# Typer<br>
## A text editor made with LOVE2D.<br>
**[LOVE2D](https://love2d.org/) is required to run this project**
```
Q: Why ?
A: Because why not !
```
Read html/help.html for help :D<br>
## How to install
### Linux
**NOTE: 2.0.1-PRE-2 Has a installer for Linux(FOR APT NOT FOR PACMAN)**
1. Clone the repo
```BASH
git clone https://github.com/zalanwastaken/typer.git typer
```
2. Install LOVE2D

**APT**
```BASH
sudo add-apt-repository ppa:bartbes/love-stable -y
sudo apt update -y
sudo apt intall love -y
```
**PACMAN**
```BASH
sudo pacman -Syy
sudo pacman -S love
```
3. Run Linux-run.sh
```BASH
cd typer
./Linux-run.sh
```
**All commands**
**APT**
```BASH
git clone https://github.com/zalanwastaken/typer.git typer
sudo add-apt-repository ppa:bartbes/love-stable -y
sudo apt update -y
sudo apt intall love -y
cd typer
./Linux-run.sh
```
**PACMAN**
```BASH
git clone https://github.com/zalanwastaken/typer.git typer
sudo pacman -Syy
sudo pacman -S love
cd typer
./Linux-run.sh
```
**Fix permission error for ./Linux-run.sh with this command**
```BASH
sudo chmod a=rwx ./Linux-run.sh
```
### Windows
1. Clone the repo
```BASH
git clone https://github.com/zalanwastaken/typer.git typer
```
2. Use the LOVE installer to install LOVE2D (Add the path in installer)
**[LOVE](https://love2d.org/)**
3. Run Typer
```BASH
love typer
```
## TODO (Most important to least important)
1. Make a installer for windows
2. Fix some bugs
3. Add Robust error handling
4. Make the first Full-Release 
## NOTES
I currently have no plans to make an installer for MACOS.
I have yet to determine the Full-Release date
