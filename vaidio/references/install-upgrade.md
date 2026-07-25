# Vaidio - Install and Upgrade

## Contents
1. Requirements
2. Host preparation (Ubuntu)
3. Storage layout and mounting
4. Online (APT + Docker) install of Vaidio Core 9.3.0
5. Offline USB image install
6. Post-install verification and licensing
7. container_tool reference
8. Upgrade - notes and prerequisites
9. Online upgrade via Admin Portal
10. Offline upgrade via Admin Portal
11. Offline NVIDIA driver upgrade
12. Power Model upgrade
13. Backup, restore and rollback
14. Command Center and Vaidio Enterprise install/upgrade

---

## 1. Requirements [S1]

| Item | Requirement |
|---|---|
| CPU | Requires avx, avx2 and sse4 SIMD instructions |
| GPU | NVIDIA only: Turing / Ampere / Ada Lovelace / Hopper, INT8 precision |
| GPU driver | minimum 535.183.06 |
| OS | Ubuntu 22.04 |
| Browser | Chrome or Edge |

Offline-image minimum hardware equals the VSB-110 spec: CPU i5-10400 / i5-11400 / i5-12500 (>=6C/6T), 16GB (8GBx2), NVIDIA GTX 1660 SU / GTX 1660 Ti / RTX 3050 6GB / RTX A2000-6GB, 240GB SSD system, 1TB HDD AI storage, 1GbE BASE-T x1, reference chassis Dell 3650/3660 with PSU >= 460W. [S5]

## 2. Host preparation (Ubuntu) [S1][S6]

1. Switch the boot target to CLI so the NVIDIA driver install does not fight the desktop:
       sudo systemctl set-default multi-user.target
2. Install basic utilities:
       sudo apt-get update
       sudo apt install curl
       sudo apt install ntpdate
       sudo apt install ssh
       sudo apt install net-tools
3. Configure networking so the host can reach the internet (see references/network-ports.md for the netplan template).

Ubuntu 22.04 install specifics from the vendor guide: download ubuntu-22.04.2-desktop-amd64.iso, boot 'Ubuntu (safe graphics)', choose **minimal installation**, choose 'Something else' for partitioning, then create a 512 MB EFI System Partition, an 8192 MB swap area, and the remainder as ext4 mounted at /. Keep hostname/username consistent across servers. [S6]

Disable Ubuntu kernel auto-upgrades: [S6]

    sudo nano /etc/apt/apt.conf.d/10periodic
    # APT::Periodic::Update-Package-Lists "1";  ->  "0";
    sudo /etc/apt/apt.conf.d/20auto-upgrades
    # APT::Periodic::Update-Package-Lists "1";     ->  "0";
    # APT::Periodic::Unattended-Upgrade "1";       ->  "0";

## 3. Storage layout and mounting [S1]

Mount the data volume **before** running the container. If no additional drive exists this step can be skipped, but everything then lands on the system volume.

| Volume | Purpose | Media guidance | Example device | Mount point |
|---|---|---|---|---|
| Sys volume | OS and Vaidio database | SSD | - | /opt/data/sys |
| Data volume | Vaidio metadata | separate HDD | /dev/sdb -> /dev/sdb1 | /mnt/data |
| Data volume (Recorder) | Internal Video Recorder | separate drive | /dev/sdc -> /dev/sdc1 | /mnt/data-rec |

Procedure (swap sdb for the real device):

    lsblk
    sudo fdisk /dev/sdb        # gpt (only if HDD > 1TB), n (new partition), defaults, w (write)
    sudo mkfs.ext4 /dev/sdb1
    sudo mkdir /mnt/data
    sudo mount -t ext4 /dev/sdb1 /mnt/data
    sudo blkid                 # grab the UUID
    sudo nano /etc/fstab
    # add: UUID=a12460c7-e287-4aa4-89e6-fd44b4357bae /mnt/data ext4 defaults 0 0
    lsblk                      # confirm mounted

To add a recorder drive later, remove the container first (keeping data), mount /mnt/data-rec the same way, then re-init with -r. RAID, LVM and other logical storage are **not** created by the installer and must be pre-configured; hardware RAID is preferred over software RAID. [S1][S5]

## 4. Online (APT + Docker) install of Vaidio Core 9.3.0 [S1]

    # 3. Prepare repository
    sudo curl -s --compressed "https://ironyun.github.io/Vaidio-APT/KEY.gpg" | sudo apt-key add -
    sudo add-apt-repository ppa:deadsnakes/ppa
    # this command is all one line
    sudo curl -s --compressed -o /etc/apt/sources.list.d/ironyun-release.list "https://ironyun.github.io/Vaidio-APT/ironyun-release.list"
    sudo apt update

    # 4. Install Admin Portal
    sudo apt install admin-portal=9.3.0-1

    # 5. Install docker utility and drivers
    sudo apt install ainvr-docker-utilities=9.3.0-1
    sudo preinstall          # installs drivers; server reboots when done

    # 6. Launch the container
    sudo mkdir /etc/vaidio
    sudo mv profile_x86.bin /etc/vaidio         # profile*.bin supplied by Vaidio
    sudo container_tool -s /opt/data/sys -d /mnt/data -b /etc/vaidio/profile_x86.bin init
    # config generated at /etc/vaidio/vaidio.conf
    sudo container_tool run

With a separate recorder drive, use:

    sudo container_tool -s /opt/data/sys -d /mnt/data -r /mnt/data-rec -b /etc/vaidio/profile_x86.bin init

Admin Portal functions after install: Port configuration, Time, Network, Upgrade, Factory Reset. It is only available once the Vaidio installation is complete. [S1]

There is no documented silent/unattended switch set for the APT path (it is already non-interactive apart from container_tool remove prompts). The **offline USB installer is the unattended path**: it auto-partitions and requires no user input. [S1][S5]

## 5. Offline USB image install [S5]

Workflow: download the installer image -> flash to USB 3.0 -> prepare the target machine -> boot and auto-install -> post-install verification.

1. Download the zipped image (link supplied by Vaidio or an authorised partner) and verify the MD5 checksum against the checksum file for that exact Vaidio version.
2. Flash vaidio-usb-installer_x.x.x.img to a USB 3.0 thumb drive of at least 32GB. USB 2.0 extends install time from about 12 minutes to over 30.
   - Unix: dd if=/path/to/vaidio-usb-installer_x.x.x.img of=/dev/sdx bs=1M
   - Windows (MINGW64): dd if=/c/Users/<user>/Downloads/vaidio-usb-installer_x.x.x.img of=/dev/sdc bs=1M
   - Windows (GUI): clean old partitions with DiskPart, then ImageUSB > Write image to USB drive > select vaidio-usb-installer_9.1.0.img > Write.
3. Target machine: disable Secure Boot in BIOS, confirm UEFI boot support, set boot order USB first then disk, attach a network cable (DHCP internet needed only for the online options).
4. Boot menu options:
   - Autoinstall Ubuntu Server for Vaidio (Offline & Separate Data Disk) - multiple disks, system and AI metadata on different physical disks, no internet.
   - Autoinstall Ubuntu Server for Vaidio (Offline & Single Disk) - one physical disk, no internet.
   - Advanced Option reveals online installation options.
5. Important behaviour: the image includes the OS and **overwrites any existing OS**; the installer auto-partitions two system volumes and one data volume, overwriting pre-existing partitions; on multi-disk systems the smallest disk becomes the system disk and the largest becomes the AI disk (the USB is excluded); choosing Separate Data Disk on a single-disk system halts with an error; RAID/LVM must be pre-configured; hardware outside the standard Ubuntu Server 22.04 support list (for example parallel SCSI RAID cards) may fail.
6. Install takes about 15-20 minutes on USB 3.0, needs no input, reboots several times (keep the USB inserted) and then powers off automatically. Do not interfere.
7. Post-install: remove the USB, power on, log in via console or SSH as **superuser / usersuper888**, then use **sudo su** to become root (only root can run Docker commands) and confirm the Docker information shows ainvr. The install-time IP is DHCP-assigned and appears under enp3s0.
8. Access checks: Admin Portal http://<IP Address>:8000 and Main page http://<IP Address>/login, both **admin / admin888**.
9. Optional desktop: sudo apt install ubuntu-desktop.
10. On failure, collect all logs from /var/log/ on the installed system and contact vaidio.ai/support.

## 6. Post-install verification and licensing [S1][S4]

1. Log in to Core at http://<vaidioip> with admin / admin888 and change the password.
2. System > License > **Export** produces the .info system information file.
3. Open a ticket on the Customer Support Portal: Submit a Ticket > Licensing > New License, attach the .info file, and state company, sales rep, analytics and channel counts, server hardware specs (GPU, CPU, RAM) and whether it is a VM (AWS, GCP and so on).
4. On receipt of the .key file: System > License > **Renew** and upload. Applying can take **30-40 minutes** depending on how many analytics are enabled; the page refreshes itself when finished.
5. Then set timezone (System > Time), storage retention, and optionally SMTP / LDAP / SSO / SSL, server role, and check the AI Model.

## 7. container_tool reference [S1]

    sudo container_tool -H     # help

USAGE:

    container_tool [FLAGS] [SUBCOMMAND]
    container_tool -s <system volume> -d <data volume> -r <data volume for recorder> -b <bin file> init
    container_tool run
    container_tool stop
    container_tool start
    container_tool -u <vaidio_admin> -p <vaidio_admin_pwd> upgrade
    container_tool remove
    container_tool status
    container_tool prune
    container_tool check_disk_space
    container_tool -H         print help information
    container_tool -V         print version
    container_tool -v         print version of .conf file

FLAGS: -c clean old images; -s system volume; -d data volume; -r data volume for recorder; -b application bin file; -f config file; -u vaidio username; -p vaidio password; -E exclude some data when removing container; -I skip pull image from Docker Hub; -H help; -V version; -v version of .conf file.

SUBCOMMANDS: init (generate default configuration), run, stop, start, remove, status, upgrade, prune (remove old image/container).

Destructive prompts on remove:

    Do you want to remove vaidio? [y/N]
    Do you want to purge data? [y/N]      # y purges ALL data, N keeps it

**container_tool prune** deletes old images - back up first, and make sure the container_tool version matches the running container before pruning. [S1]

## 8. Upgrade - notes and prerequisites [S2]

- Jumbo (multi-version) upgrades are supported **starting from version 5.0.0**.
- Starting in 6.2.0, Ubuntu 16.04 is no longer supported; contact Support if still on 16.04.
- An **expired warranty blocks upgrades**. Extend via the sales rep or a support request.
- Back up first: Vaidio > System > General > **Export Configuration** produces a .bin file containing the server database (cameras, ROIs, alerts and so on).
- Check model versions: any model without a version number 7.2 or higher in the name will not work after upgrading. Non-Power models need an updated model from Support before upgrading.
- In clustered systems upgrade the **Main server first**, then the Remote servers; the Main reconnects automatically as remotes come back.
- **Admin Portal must be upgraded before the Main System.** [S4]
- Step upgrades: systems older than 6.2.0-1 must first be upgraded to 6.2.0-1, then repeated to reach the latest version.
- Systems older than 9.0 generally require NVIDIA driver 535.183.06 or higher (one page states 535.138.06 - treat 535.183.06 as authoritative since it matches the install guide).
- After the upgrade completes you must **re-enable all your cameras**.
- Do not reboot until the Vaidio user interface is back up.

## 9. Online upgrade via Admin Portal [S2][S4]

1. Log in to http://<vaidioip>:8000.
2. Go to the Upgrade section at the bottom of the page.
3. Step 1 - Upgrade Admin Portal: Check for Update > Upgrade. The Admin Portal restarts when done. If the portal is 9.0.0-1 or older and the upgrade fails, the host may be Ubuntu 18.04 - use the offline Admin Portal path, then continue online.
4. Step 2 - Upgrade Main System: Check for Update > Upgrade. If drivers are too old the portal will upgrade them first, which reboots the server; log back in and click Main System Upgrade again once Vaidio is up.
5. Success is both progress bars at 100% plus 'Upgrade Successful'. The Done Upgrading bar tracks the upgrade, the System Starting bar tracks installation.
6. Re-enable all cameras.

Online upgrade requires internet access to check for and download updates. Offline upgrade files are 13+ GB and are requested from Support. [S4]

## 10. Offline upgrade via Admin Portal [S2]

Files (example versions from the guide): admin-portal_9.2.0-1.deb and offline-ainvr-app_9.2.0-1-enc.tar.gz; for step upgrades, offline-ainvr-app_6.2.0-1.tar.gz.

1. Step 1 - Admin Portal: choose Offline as upgrade type, upload the .deb, click Upgrade, portal restarts.
   - Current Admin Portal 7.2.0-1 or earlier: use admin-portal_9.2.0-1.deb
   - Current Admin Portal 8.0.0-1 or higher: use admin-portal_9.2.0-1-enc.deb
2. Step 2 (only if the Admin Portal was 9.0.0-1 or older) - upgrade Python 3.11 manually. Check the release with **lsb_release -a**, upload the matching tarball, then:
       tar zxvf python3.11_jammy.tar.gz      # 22.04 (focal = 20.04, bionic = 18.04)
       cd python3.11_jammy
       sudo bash install.sh
       cd ..
       rm -rf python3.11_jammy.tar.gz python3.11_jammy
3. Step 3 - Main System: upload offline-ainvr-app_9.2.0-1-enc.tar.gz under Main System, click Upgrade, wait for both bars to reach 100%.
4. Re-enable all cameras.

## 11. Offline NVIDIA driver upgrade [S2]

    sudo container_tool stop
    sudo apt-get remove --purge --allow-change-held-packages -y '^nvidia-*' '^libnvidia-*'
    sudo apt autoremove --allow-change-held-packages -y
    reboot
    nvidia-smi                                  # confirm drivers are gone
    chmod +x NVIDIA-Linux-x86_64-535.183.06.run
    sh NVIDIA-Linux-x86_64-535.183.06.run       # Continue Install / No 32-bit / No nvidia-xconfig
    dpkg -i libnvidia-container1*
    dpkg -i libnvidia-container-tools*
    dpkg -i nvidia-container-toolkit-base*
    dpkg -i nvidia-container-toolkit_*
    dpkg -i nvidia-container-runtime*
    reboot
    nvidia-smi                                  # confirm 535.183.06
    rm *nvidia* NVIDIA*

## 12. Power Model upgrade [S2]

Latest documented Power Model is **PowerModel-Core-8.2g2-Pro-3.4**; any model prior to 7.2 must be updated to 8.2. Apply at Vaidio > System > AI Model > **Replace** next to the model being upgraded. Replace keeps all profiles and settings; Upload loses them. A replacement model must include all Object Types of the model it replaces, and applying a new model deactivates all cameras. [S2][S4]

## 13. Backup, restore and rollback

| Task | Path | Notes | Source |
|---|---|---|---|
| Core config backup | System > General > Export Configuration | .bin containing Application, Network and System configuration (cameras, ROIs, alerts) | S2 S4 S9 |
| Core config restore | System > General > Restore > Upload File > Confirm | Restores system settings from the exported .bin | S4 |
| Vaidio Data backup | System > Backup & Restore > Backup Now | Full instance backup; downloads as .tar, e.g. backup_20250918_181835.tar; needs free local disk | S10 |
| Vaidio Data restore | System > Restore from Backup (Upload -> Validate -> Restore Now) | Returns the system to the captured state; can restore to another instance | S10 |
| Command Center node backup | System > Setting > Node Configuration toggle + backup time | Daily backup of connected Core node configurations, CC 8.1.0+ | S12 |
| Node config restore | Node Management > node menu > Clone Latest Configuration | Manually restores a Core node configuration onto another connected Core node | S12 |
| Edge config | Settings > Export Configuration / Restore | Restore only onto the same device type, same hardware and same firmware version | S15 |
| Factory reset | Admin Portal (port 8000) > Factory Reset | Resets the server to defaults - destructive | S3 S4 |

**Rollback of a Vaidio version is not documented.** There is no documented downgrade path; the only documented recovery levers are configuration restore, container removal and reinstall, and Factory Reset. Treat 'how do I roll back 9.3 to 9.2' as a Support question. [S1][S2]

## 14. Command Center and Vaidio Enterprise install/upgrade

Command Center minimum hardware: Ubuntu 22.04, CPU i7-9700 / i7-11700 / i7-12700, 32GB (16GBx2), 480GB SATA SSD system storage, 2TB SATA HDD AI storage. GPU is not required. Upgrade follows the same Admin Portal order (Admin Portal first, then Main System), online or offline. [S12]

CC can upgrade Core nodes remotely: Node Management > node menu > System Upgrade, or select up to about 3 nodes for a batch upgrade. Eligible nodes must be Core, on 9.1+, Connected, with valid warranty and a Local or Command Center license. Upgrades cannot be paused or stopped once started; brief CC disconnection during upgrade is expected. As of 9.1.0 CC upgrades apply only to Core nodes. [S12]

Vaidio Enterprise: infrastructure and Kubernetes setup are done by the service provider or customer - provision hardware per the appliance calculator, install Ceph, install and initialise Kubernetes with pod networking, install Vaidio Manager on the master node, then create Cores and assign the license key. Core creation defaults: Version 9.2.0-1, Maximum Disk Size 20 GB, Storage Retention Period 30 days; initialisation can take up to 10 minutes. [S11]
