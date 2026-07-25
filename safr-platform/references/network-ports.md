# SAFR Networking, Ports, and TLS

## 1. Read this first: there is no published port table

**The SAFR documentation set retrieved does not contain a port table.** No page gives
`port | protocol | direction | purpose`. Targeted searching for a ports or firewall
requirements document returned nothing. This is a genuine documentation gap, not an omission in
this skill - see `known-gaps.md`.

Consequence: **never quote a SAFR port number from memory.** Ports are site-specific because
they are declared in a local config file and can be rewritten at install time to resolve
conflicts. Derive them from the running system instead. [S4]

## 2. How to obtain the real port list

`portcheck` lists all the ports that SAFR services are using. [S4]

| OS | Command |
|---|---|
| macOS | `python /Library/RealNetworks/SAFR/bin/portcheck.py` |
| Linux | `sudo python /opt/RealNetworks/SAFR/bin/portcheck.py` |
| Windows | `python "C:\Program Files\RealNetworks\SAFR\bin\portcheck.py"` |

This is read-only and is the correct first step for any firewall question. Capture its output
before raising a change request.

## 3. Where ports are defined

`safrports.conf` is the source of truth. `configure-ports` reads it and takes no arguments. [S4]

| OS | Path |
|---|---|
| macOS | `/Library/RealNetworks/SAFR/safrports.conf` |
| Linux | `/opt/RealNetworks/SAFR/safrports.conf` |
| Windows | `C:\Program Files\RealNetworks\SAFR\safrports.conf` |

Install-time conflict behaviour: conflicting ports are reported, Notepad is launched to edit
`safrports.conf`, and the installer relaunches automatically once non-conflicting ports are
chosen. [S4] The file's syntax and its default contents are **Not documented**.

On Windows, `configure-firewall.py` exists in `SAFR\bin` and is documented as part of the port
reconfiguration process, but it is explicitly marked **internal use only** - do not invoke it
directly. [S4] Its existence implies SAFR manages Windows Firewall rules itself during port
reconfiguration. [INFERRED - verify]

## 4. Traffic patterns you can state from the docs

These are directional facts, not port numbers. [S6]

| Flow | Notes |
|---|---|
| SAFR components and browsers to SAFR Server | HTTPS; certificates cover SAFR Desktop Clients, SAFR Mobile Clients, and third-party applications such as web browsers [S11] |
| Secondary servers to primary server | Cluster join via `safr-worker`; primary is auto-discovered by `proxy-discover.py` internally [S4] |
| Primary server to redundant secondaries | Object Storage Service requests are load-balanced by the primary [S6] |
| Between servers | Database replica set traffic for redundant secondaries [S6] |
| Any server to shared storage | Direct read and write to the NAS in shared object storage mode [S6] |
| External load balancer to all servers | Recognition requests distributed across servers; feed management, reports, and Web Console are never load-balanced and always come from the primary [S6] |
| Server to Internet | Required for online license activation; an offline path exists via `get-license-request` / `insert-license` [S4] |

## 5. TLS and certificates

SSL certificates allow secure https connections between SAFR Servers and other applications
such as SAFR Desktop Clients, SAFR Mobile Clients, and web browsers. [S11]

**Security-critical default:** SAFR Platform installations automatically include self-signed
SSL certificates, and because all newly installed SAFR Platforms use the same default
self-signed SSL certificates, these certificates only provide moderate security, at best. The
vendor recommends replacing them with either custom generated self-signed certificates or
standard certificates from a trusted certificate authority. [S11]

Raise this proactively on any on-prem deployment review: a shared, publicly known default key
pair means TLS provides encryption but effectively no server authentication.

### 5.1 Certificate tool

Verbatim usage string [S11]:

```
usage: configure-ssl.py [-h] [-d] [-g] [-p] [-c] [-v] [-q] [-f]
```

| Argument | Effect |
|---|---|
| `-h`, `--help` | Show this help message and exit |
| `-d`, `--default-cert` | Reset to the factory default SSL certificate and key |
| `-g`, `--generate-cert` | Generate a new SSL Self-Signed certificate and key |
| `-p`, `--public-key` | Display the current SSL certificate's public key |
| `-c`, `--config` | Only change certificates, do not stop or start services |
| `-v`, `--verbose` | Enable DEBUG level logging |
| `-q`, `--quiet` | Display only ERROR logs |
| `-f`, `--force` | Override warnings |

Generate a custom self-signed certificate: open a command prompt, navigate to your SAFR
Server's folder, and run `python configure-ssl.py -g`. [S11]

**Two defects in this doc page, both logged as gaps:**

- It prints the default install location as `C:Files`, a broken rendering of
  `C:\Program Files\RealNetworks\SAFR`. [INFERRED - verify]
  - The sentence giving the output location of the generated certificate and private key is
    truncated mid-sentence: "are located at as". The actual output path is therefore
      **Not documented**.

      ### 5.2 Prerequisites for a CA-issued certificate

      Before installing a standard, non-self-signed certificate you must first configure a DNS
      hostname for the server within your network domain. [S11]

      - A DNS **A record** is required, documented example: `safr.example.com A 12.34.56.78` [S11]
      - Use a **static IP**. The docs warn that with DHCP, if the address changes the DNS hostname
        entry stops working until you update it. [S11]
        - Static IP details to obtain from the network administrator: static IP address, subnet mask,
          default gateway. [S11]

          ### 5.3 Binding the hostname

          After DNS exists, `reconfigure` sets the hostname the SAFR Server uses, and takes a second
          argument declaring whether an SSL certificate chain is used. See `operations.md` section 6. [S4]

          Mismatch between the certificate common name and the name clients use is the usual cause of
          trust warnings after this step. [INFERRED - verify]

          ## 6. Proxy support

          HTTP/HTTPS forward-proxy configuration for SAFR Server is **Not documented** on any page
          retrieved. Note that `proxy-discover.py` is unrelated - it is an internal script used during
          auto-discovery of the primary SAFR Server, not a web proxy setting. [S4] Logged as a gap.

          ## 7. Genetec integration traffic

          Port and protocol requirements for the Genetec integrations are covered in
          `genetec-integration.md`. The same caution applies: where the Genetec guides do not state a
          port, do not supply one.
          
