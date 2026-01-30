# Xubuntu Jammy (22.04) / Noble (24.04) Vagrantfile

This folder contains a Vagrantfile to set up Xubuntu Desktop (core/minimal) that includes:
* [Sireum](https://sireum.org/), including its IntelliJ-based IVE and VSCodium-based HAMR SysML v2 front-end
* [ROS2](https://ros.org/) Humble (Jammy) / Jazzy (Noble)
* [Jextract](https://jdk.java.net/jextract/)

## Requirements

* [VirtualBox](https://www.virtualbox.org/)

    
## Provisioning

Define the following environment variables to customize the provision when running `vagrant up`:

* `UBUNTU=noble` to provision Ubuntu Noble; 
  otherwise, Jammy will be provisioned.

* `SIREUM_SHA=<commit>` to setup Sireum on a specific [SHA-commit](https://github.com/sireum/kekinian/commits/master/);
  otherwise, the latest commit will be used.

* `UNAME=<username>` to setup the main username; otherwise, `santos` will be used.

* `UPASSWD=<password>`; otherwise, `sireum` will be used.

* `NO_ROS=true`; otherwise, ROS2 will be installed.

For example, to provision Ubuntu Noble in `.vagrant-noble` with the latest Sireum commit tip, and
with username `foo` and password `bar`:

```shell
VAGRANT_DOTFILE_PATH=.vagrant-noble UBUNTU=noble UNAME=foo UPASSWD=bar vagrant up
```

## Launching

To launch the provisioned VM:

* **macOS/arm64**:

  ```shell
  open `find .vagrant-noble -name "*.vmx"`
  ```
