# divi-rpi64
Resources and instructions to build the Divi core client on raspberry pi OS 64-bit

## Installation steps
This assumes that you have already installed raspberry pi OS 64-bit on your machine. The installation proceeds in 4 steps as follows:

1. Install dependencies
2. Download and build Berkeley DB 4.8.30
3. Download and build openSSL 1.0.2
4. Download and build the Divi core client

## 1. Install dependencies
    sudo apt update    
    sudo apt install build-essential git libtool autotools-dev autoconf pkg-config libssl libssl-dev libboost libboost-all-dev

## 2. Download and build Berkeley DB
Divi core is intended to work with Berkeley DB 4.8.30, which is not available for installation using apt.
    
    # Define DIVI_SOURCES_DIR for convenience, e.g. DIVI_SOURCES_DIR=$HOME
    cd $DIVI_SOURCES_DIR
    
    # Download the source zip and unzip it
    wget http://download.oracle.com/berkeley-db/db-4.8.30.zip
    unzip db-4.8.30.zip 

    # Configure and build 
    cd db-4.8.30/build_unix/
    ../dist/configure --prefix=/usr/local --enable-cxx --build=linux
    make

## 3. Download and build openSSL 1.0.2
Divi core client can be built using the system SSL using the --with-unsupported-ssl flag. In order to avoid potential issues caused by an unsupported version of open SSL, we can build it manually.

    cd $DIVI_SOURCES_DIR
    
    # Clone the 1.0.2 tag from github
    git clone --depth 1 --branch OpenSSL_1_0_2 https://github.com/openssl/openssl.git

    # Configure and build
    cd openssl 
    config shared
    make

## 4. Download and build the divi core client
To build divi core, follow the following instructions. As of now, the latest release is 2.5.1, so we clone the 2.5.1 tag using `--branch v2.5.1`. Please adjust this to use the latest stable release as per the Divi documentation.

    cd $DIVI_SOURCES_DIR   
    git clone --depth 1 --branch v2.5.1 https://github.com/DiviProject/Divi.git 

    cd Divi/divi
    ./autogen.sh

Then, copy the build.sh script from this repository to the Divi/divi folder and run:

    ./build.sh configure
    ./build.sh make

Optionally, run make install
    ./build.sh install

Optionally, you can now move or link the generated executables (in particular divid and divi-cli) to a location of your choice. 

## 5. (Optional) set up a system service for the divi daemon
In order to maximize up-time, it is advisable to set up a service so that the divi daemon will restart automatically in case of system reboot. 
Sample configuration files can be found at:
https://github.com/DiviProject/Divi/tree/v2.5.1/divi/contrib/init
