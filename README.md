# easyfilecrypt
easyfilecrypt is a BASH script, which uses OpenSSL for encryption, and whiptail for GUI, to encrypt and decrypt files.
Run within a terminal session

Features:  
**Text files**: Generating a text file and encrypting it on the fly, inlcuding an already existing text files.  
**Files**: Select and encrypt a file.  
**Folders**: Select a folder, archive and encrypt it.  

Text editors:  
**Nano** (by Default), or **Vim**.

Make sure you have both installed.

**To install, run**:  
  1: `git clone git://github.com/BobyMCBobs/easyfilecrypt.git`  
  2: `sudo install -g root -o root easyfilecrypt/easyfilecrypt /usr/local/bin/easyfilecrypt;`  

**Or in a single command**:  
  `git clone git://github.com/BobyMCBobs/easyfilecrypt.git;sudo install -g root -o root easyfilecrypt/easyfilecrypt /usr/local/bin/easyfilecrypt;echo "EasyFileCrypt has been installed."`  

To do:  
- [ ] Use array to have simular values for window sizes, always  
