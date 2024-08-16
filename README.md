# PsiphonLinux v2.01 Beta

A simple way to run the Psiphon VPN on Linux for an uncensored connection to the internet. This repository includes all the scripts and files in order to run Psiphon on linux as well as quality of life scripts which will be described below.

## Ways to install Psiphon Linux
There are two ways to install Psiphon for linux, the recomended way is the automatic global installation, but if you would like to install it manually to a specific folder you are able to do that.
## نصب با کد 
```
sudo bash -c "$(wget -O - https://raw.githubusercontent.com/0fariid0/PsiphonLinux/main/install.sh)"
```
متوقف 
```
sudo systemctl stop psiphon.service
```
شروع مجدد 
```
sudo systemctl restart psiphon.service
```
وضعیت 
```
sudo systemctl status  psiphon.service
```

