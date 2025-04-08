# DFIRbian

DFIRbian is a Debian 12 based virtual machine for malware forensics.

## Requirements
- [Virtualbox](https://www.virtualbox.org/)
- [Vagrant](https://www.vagrantup.com/)

## Setup
1. **Clone this repository:** 
`$ git clone https://github.com/mr-zorbot/dfirbian.git`
2. **Go to `vagrant/` directory:** 
`$ cd dfirbian/vagrant/`
3. **Deploy the Virtual Machine:** 
`$ vagrant up`
4. **Create a snapshot of the base system:**
`$ vagrant snapshot save base`

## Usage
1. **Connect to the virtual machine (Don't use `$ vagrant ssh`!):** 
   
   `$ ssh -i .vagrant/machines/default/virtualbox/private_key vagrant@192.168.56.10`
2. **Isolate the network:** By default, Vagrant will always use a NAT type network adapter to configure/manage the guest machine. This means that all outbound traffic from the VM is routed through the host, i.e. the machine on which you intend to manipulate malicious files has, by default, access to other devices present on your internal network. 

    To avoid incidents, such as the propagation of a worm on your LAN, it is essential to disable the NAT interface on the virtual machine:
 
    `$ sudo ip link set eth0 down`
3. **Access the data:** Copy the data to be analyzed - i.e. suspicious files, disk images, memory dumps, PCAP files, etc. - to the `dfirbian/guest` folder on the host. This way, the files will be accessible by the virtual machine via the `/mnt/host` path.
4. **Restore the VM:** After performing the investigation, restore the virtual machine to its original state.

    `$ vagrant snapshot restore base --no-start`

## Available Tools
1. [**Radare2:**](https://github.com/radareorg/radare2) An open-source framework for reverse engineering and analyzing binaries, offering a comprehensive set of tools for tasks such as disassembly, debugging, decompilation, and forensic analysis of executable files, as well as providing support for a variety of architectures and file formats.
2. [**Winedbg:**](https://gitlab.winehq.org/wine/wine/-/wikis/Commands/winedbg) A debugger used for troubleshooting and analyzing Windows applications running on Wine, providing features like breakpoints, stack tracing, and memory inspection to assist in identifying and fixing issues in Windows programs on Unix-like systems.
3. [**The Sleuth Kit:**](https://github.com/sleuthkit/sleuthkit) An open-source collection of digital forensics tools designed to help investigators analyze disk images, recover deleted files, examine file systems, and perform in-depth forensic analysis on data from hard drives, memory, and other storage devices.
4. [**PhotoRec:**](https://github.com/cgsecurity/testdisk) File recovery software that focuses on recovering lost files, including photos, videos, and documents, from damaged or corrupted storage media. 
5. [**TermShark:**](https://github.com/gcla/termshark) A terminal-based network traffic analyzer that provides a text-based interface for capturing and inspecting network packets, leveraging Wireshark's features while running in a command-line environment.
6. [**Volatility3:**](https://github.com/volatilityfoundation/volatility3) An open-source memory forensics framework used to analyze and extract information from volatile memory (RAM) dumps, providing tools for investigating system processes, network connections, and other data to aid in digital forensics and incident response.
7. [**CyberChef:**](https://github.com/gchq/CyberChef) CyberChef is an open-source web application that provides a wide range of tools for encoding, decoding, encrypting, decrypting, and performing data analysis tasks, making it a versatile platform for digital forensics, cybersecurity, and data manipulation. You can access it by running the `$ cyberchef` command on the VM and then connecting to port 8000 via the host's web browser.



