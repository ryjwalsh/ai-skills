# SAFR Install, Upgrade, Licensing, Backup and Restore (on-premises)

## Contents

| Section | Topic |
|---|---|
| 1 | Requirements and sizing |
| 2 | Silent / unattended install |
| 3 | Upgrade a single server |
| 4 | Upgrade a cluster |
| 5 | Licensing metrics |
| 6 | License binding and the 24-hour IP rule |
| 7 | Offline licensing, integrated (Windows) |
| 8 | Offline licensing, manual |
| 9 | Backup |
| 10 | Restore |
| 11 | Scheduled daily backup |
| 12 | Rollback |

## 1. Requirements and sizing

SAFR Server is installed as part of the SAFR Platform installer. [S16]

| Platform | Minimum | Recommended |
|---|---|---|
| Windows | Windows Server 2016 or Windows 10 or later; .NET Framework 4.6.2 or later; Intel Core i9-7980XE or AMD Ryzen TR 2700X; NVIDIA Quadro P2000; 16GB RAM; 1TB available storage | Intel Core i9-7980XE or AMD Ryzen TR 3700; Quadro RTX 5000 or Tesla T4; 32GB RAM; 1TB available storage |
| Windows, CUDA 11 Edition | As above but NVIDIA GEFORCE RTX 3060+ and NVIDIA driver 456.38+; 16GB RAM; 1TB storage | NVIDIA GEFORCE RTX 3060+, driver 456.38+; 32GB RAM; 1TB storage |
| macOS | macOS 10.12 or later; Quad Core i7 2.6GHz; 16GB RAM; 1TB available storage; supports one 4K camera | iMac Pro 10-core Intel Xeon, 32GB RAM, up to six 4K cameras; Mac mini 6-core i7 3GHz, 32GB RAM, up to four 4K cameras |
| Linux | Ubuntu 18.04(.2+), Ubuntu 20.04, Redhat 7.x, CentOS 7.x, or Amazon Linux 2018.03; Intel Core i5-8259U or AMD Ryzen 7 2700X; Quadro P2000; 16GB RAM | See [S16] |

Driver constraints [S16]:

- SAFR versions earlier than 3.1 are only compatible with NVidia driver versions **418.96 to 431.86**.
- `NVIDIA driver 418.96+` for GPU-enhanced performance on the Legacy Edition.
- CUDA 11 Edition requires `NVIDIA driver 456.38+` and Ampere or newer (GEFORCE RTX 3*** or later).
- If your card is newer than the Legacy Edition supported list, install the CUDA 11 Edition instead.

**Sizing basis, verbatim:** camera counts are based on an average of five visible faces in a 4K resolution camera view, running at 15 frames per second. Using fewer faces per camera and lower resolution will enable support for more cameras. [S16]

The Desktop Client and SAFR Actions are listed as **N/A on Linux** - not available. [S16]

Conflict to be aware of: [S5] gates the GPU face service default on drivers greater than **418.67**, while [S16] uses **418.96**. Logged as a gap.

## 2. Silent / unattended install

Windows silent install uses `/S`. [S5]

```
SAFRPlatform_win_1_8_302_08_13_19.exe /S
SAFRPlatform_win_1_8_302_08_13_19.exe /S /COMPONENT=YES
SAFRPlatform_win_1_8_302_08_13_19.exe /S /COMPONENT=NO
SAFRPlatform_win_1_8_302_08_13_19.exe /S /VIRGO=YES /Actions=NO
SAFRPlatform_win_1_8_302_08_13_19.exe /Age=YES /Gender=YES /Sentiment=YES
```

Install location override: `/D C:\Program Files\RealNetworks\SAFR`. The docs state it **must be the last command line argument** and **do not use quotes**. [S5]

Linux install disables models with arguments accepting `off`, `false`, `disabled`, `0`, or `no`, case-insensitive. [S5]

```
sudo bash SAFRPlatform_linux-ubuntu_2_0_022_03_03_20.sh -a=OFF
sudo bash SAFRPlatform_linux-ubuntu_2_0_022_03_03_20.sh --age=disabled
sudo bash SAFRPlatform_linux-ubuntu_2_0_022_03_03_20.sh --age=OFF --gender=OFF --sentiment=OFF --occlusion=OFF
sudo bash SAFRPlatform_linux-ubuntu_2_0_022_03_03_20.sh -a=0 -g=0 -s=0 -o=0
```

Linux flags: `-a/--age`, `-g/--gender`, `-m/--mask`, `-n/--maskedface`, `-s/--sentiment`, `-o/--occlusion`, `-i/--identity`, plus `-v/--virgopath` and `-u/--user`. [S5]

Full Windows component and VMS plugin flag tables are in `architecture.md` sections 4 and 5.

## 3. Upgrade a single server

Download the latest SAFR Platform installer and install it **on top of** your existing SAFR Server. Your SAFR service will be offline while the new SAFR Server is installing. [S7]

## 4. Upgrade a cluster

Order matters. Documented sequence [S7]:

1. Prevent new faces from being added during the upgrade, by either stopping the CoVi service on all secondary SAFR Servers **or** stopping all clients that add new faces (VIRGO video feeds, Desktop clients, Mobile clients).
2. Make a backup of the primary SAFR Server. Backup and restore should only be performed for the primary server; secondary servers synchronize automatically with the primary.
3. Update the **primary** server with the latest SAFR Platform installer. During this the system will be down unless an external load balancer is being used; even with a load balancer there will be **about 2-20 seconds** where newly generated events might be dropped; live video streams will be down.
4. Update the **secondary** servers by running the installer on each of them.
5. Restart the CoVi service on all secondary servers if you stopped them, and resume submitting faces on clients.

RealNetworks states it releases new versions of SAFR almost every month. [S7]

Supported version-to-version upgrade paths, and whether releases can be skipped, are **Not documented**. Logged as a gap.

## 5. Licensing metrics

SAFR systems require a license to operate. [S9]

| Metric | Behaviour at the limit |
|---|---|
| Expiration date | After this date, SAFR software discontinues operation |
| Max Feeds per Hour | Excess video feed connection attempts all fail. Existing feeds must be disconnected for a period of **1 hour** before new feeds are allowed to re-use the license |
| Max Faces | Maximum people registered in the Person Directory; adding people above this limit results in an error |
| Max Days Between Reports | The server discontinues operation if it cannot reach the SAFR License Server within the specified time. On-premises deployments only |

Two details that cause avoidable incidents:

- **Feed double counting.** If a single camera is providing video feeds to 2 different Desktop Client instances, that counts as **2 video feeds** for licensing purposes. [S9]
- **The 1-hour cooldown** means a crashed or restarted client can appear to consume a feed licence for up to an hour. [S9]

License limit metrics for your license are shown on the **Status page of the Web Console**. [S9]

### The only documented outbound endpoint

To communicate with the SAFR License Server, your SAFR Server must be able to make connections to **`cv-instam.real` on port 443**. [S9] The hostname is reproduced exactly as printed and appears truncated or internal; verify the FQDN with the vendor before writing a firewall rule. [INFERRED - verify]

For a private network with no Internet access, the docs direct you to contact your SAFR account manager to acquire a special offline license. [S9]

## 6. License binding and the 24-hour IP rule

- Licenses are attached to the **primary** server. Secondary servers acquire their licenses through the primary. [S9]
- The server attempts to acquire a license from the SAFR license server when it is first run. [S9]
- **Moving the primary server to a machine with a different IP address requires waiting 24 hours between uninstalling and reinstalling.** Reinstalling sooner produces an **unauthorized access error** when the server tries to get a valid license. After 24 hours a reinstalled server automatically reacquires a license. The wait can be avoided by asking your SAFR Account Manager to manually reset your IP address. [S9]
- This applies only to servers that were **uninstalled**. If the IP address or hostname changes while the server remains installed there is no problem; the server informs the License Server of its new address at its next check-in. [S9]

This is the highest-value licensing fact for migration planning - surface it before any primary server move.

## 7. Offline licensing, integrated (Windows only)

Documented flow [S9]: install SAFR Platform on the offline machine; at the Desktop Client login choose **Advanced Options** and set **Server Location** to **This Machine**; use **Manage Offline License** and **Load License Request File** with the **Download from server...** option, entering SAFR Account credentials, to produce a license request file; carry it to an Internet-connected machine running SAFR Desktop; there open **Advanced Options** then **Manage Offline License**, use **Load License Request File** with **Load from file**, then **Load License File** with **Download from Cloud**; carry the resulting license file back to the offline server and use **Load License File** then **Install License File**. Credentials are required again at the final step.

## 8. Offline licensing, manual

Required on Linux and macOS; optional on Windows. [S9]

### Step 1 - generate the request on the SAFR machine

| OS | Command |
|---|---|
| Windows | `python get-license-request.py` from `C:\Program Files\RealNetworks\SAFR\bin\` in an admin Command Prompt or PowerShell |
| Linux | `sudo python /opt/RealNetworks/SAFR/bin/get-license-request.py` |
| macOS | `python /Library/RealNetworks/SAFR/bin/get-license-request.py` |

You are prompted for the SAFR account name and password. The script attempts to read `safrports.conf` to communicate with CoVi; **if `safrports.conf` can't be found the script uses the default port, `8080`.** It generates `safr_license_request.json` in the current working directory, so run it somewhere writable. [S9]

```
usage: get-license-request.py [-h] [-n HOSTNAME] [-p PORT] [-q] [-v]

  -h, --help            show this help message and exit
  -n HOSTNAME, --hostname HOSTNAME
                        Host name to your SAFR installation.
  -p PORT, --port PORT  Port to your SAFR installation.
  -q, --quiet           Suppress output.
  -v, --verbose         Enable DEBUG logging.
```

### Step 2 - redeem it on an Internet-connected machine

Copy `safr_license_request.json` and `get-license.py` into the same folder on a machine with Internet access and **Python 3.X** installed. [S9]

| OS | `get-license.py` path |
|---|---|
| Windows | `C:\Program Files\RealNetworks\SAFR\bin\get-license.py` |
| Linux | `/opt/RealNetworks/SAFR/bin/get-license.py` |
| macOS | `/Library/RealNetworks/SAFR/bin/get-license.py` |

Run `python get-license.py`; on Linux `sudo python get-license.py`. It writes `safr_license.json` to the current working directory, so run it somewhere writable. [S9]

```
usage: get-license.py [-h] [-p PATH] [-e ENV] [-q] [-v]

  -h, --help            show this help message and exit
  -p PATH, --path PATH  Path to license request file.
  -e ENV, --env ENV     License server environment to communicate with.
  -q, --quiet           Suppress output.
  -v, --verbose         Enable DEBUG logging.
```

Documented macOS caveat: you might receive an error message about being unable to load SSL root certificates. [S9]

### Step 3 - install onto the primary server

Copy `safr_license.json` into `C:\Program Files\RealNetworks\SAFR\bin\` and run `python insert-license.py` from an admin Command Prompt or PowerShell. [S9]

## 9. Backup

The backup process backs up the entire SAFR Server - the various databases, configuration files, images, and objects - to a single backup file at a location of your choosing. [S8]

| OS | Working path | Command | Output |
|---|---|---|---|
| Windows | `C:\Program Files\RealNetworks\SAFR\bin` | `python backup.py` | `C:\Program Files\RealNetworks\SAFR-backups\SAFR-backup-YYYYMMDD-HHMMSS.tgz` |
| Linux | `/opt/RealNetworks/SAFR/bin` | `sudo python backup.py` | `/opt/RealNetworks/SAFR-backups/SAFR-backup-YYYYMMDD-HHMMSS.tgz` |

Windows backup requires a command line console with administrative privileges. Linux prints a completion message of the form `Backup File: /opt/RealNetworks/SAFR-backups/SAFR-backup-20190814-003342.tgz SAFR Backup Complete.` [S8]

### Shared arguments for `backup.py` and `restore.py` [S8]

| Argument | Meaning |
|---|---|
| `-h`, `--help` | Show the help for the command |
| `-q`, `--quiet` | Quiet mode; suppress all output |
| `-v`, `--verbose` | Enable DEBUG logging |
| `-p PATH`, `--path PATH` | Path to save the backup file. **Backup command only** |
| `-o`, `--objects-only` | Only back up or restore the object storage files. Useful for a secondary server when using a local Object Storage configuration |
| `-l LOC`, `--object-storage-location LOC` | Location of the local Object Storage. Should also be used whenever `-o` is used |
| `-s`, `--skip-objects` | Don't include Object Storage images. Makes backup and restore **much, much faster**; useful if images are already protected, for example on a RAID array |

## 10. Restore

The restore process restores all SAFR Server data to any computer meeting the minimum system requirements, and **the target computer does not need the same IP address** as the original. [S8]

| OS | Command |
|---|---|
| Windows | `python restore.py BACKUPFILENAME` |
| Linux | `sudo python restore.py BACKUPFILENAME` |

Documented Windows example [S8]:

```
python restore.py "C:\Program Files\RealNetworks\SAFR-backups\SAFR-backup-20190814-003342.tgz"
```

You are prompted `Are you sure? (Yy/Nn)` - press `Y`. On success the output is `SAFR Restore Complete.` [S8]

In clusters, back up and restore the **primary only**; secondaries synchronize automatically from the primary. [S7]

## 11. Scheduled daily backup on Windows

Documented Task Scheduler recipe [S8]. Create a Basic Task, Daily trigger, `Recur` = 1, action **Start a Program** pointing at a `.bat` file containing exactly:

```
@echo off
cd C:\Program Files\RealNetworks\SAFR\bin
start python backup.py
```

In task Properties select **Run whether user is logged on or not** and **Run with highest privileges**, then set the account via **Change User or Groups**. Task events appear under History; the backup file lands in the path shown in the `.bat` file. [S8]

Linux has an Auto Daily Backup section in the same document. macOS documents Backup and Restore but **no** Auto Daily Backup section. [S8]

## 12. Rollback

A documented downgrade or rollback procedure does **not** exist. The only recovery path implied by the docs is reinstall plus restore from a backup taken before the upgrade, which is why step 2 of the cluster upgrade exists. [INFERRED - verify] Logged as a gap.
