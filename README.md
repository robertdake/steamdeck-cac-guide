
# Steam Deck CAC Authentication Guide

Guide for enabling **DoD CAC authentication on Steam Deck (SteamOS)** and Linux systems using OpenSC and Firefox.

This guide allows access to DoD resources including:

- OHOME
- DoD411
- OWA
- IPPS-A
- DTS
- EES

---

## Supported Hardware

- Steam Deck (SteamOS Desktop Mode)
- SCR3310 CAC Reader
- Most CCID compatible readers

---

## Install Required Packages

Open **Konsole** and run:

```bash
sudo pacman -S pcsclite ccid opensc firefox
```

---

## Start Smart Card Services

```bash
sudo systemctl enable pcscd
sudo systemctl start pcscd
```

---

## Verify Reader

```bash
pcsc_scan
```

Expected output:

```
Reader detected
Card inserted
```

---

## Verify CAC Token

```bash
pkcs11-tool --module /usr/lib/pkcs11/opensc-pkcs11.so -L
```

Your CAC certificate should appear.

---

## Configure Firefox

Open:

```
about:config
```

Enable:

```
security.osclientcerts.autoload
security.enterprise_roots.enabled
```

Add security device:

Module Name:
```
OpenSC
```

Module Path:

```
/usr/lib/opensc-pkcs11.so
```

---

## Test CAC Authentication

Try visiting:

https://dod411.gds.disa.mil

Your CAC certificate selection prompt should appear.

---

## Troubleshooting

If the reader does not activate:

```bash
sudo systemctl restart pcscd
```

If Firefox does not prompt for certificates:

Verify that the **OpenSC module** is installed.

More troubleshooting tips can be found in:

```
troubleshooting.md
```

---

## Repository Structure

```
steamdeck-cac-guide
│
├── README.md
├── quick-reference.md
├── troubleshooting.md
├── install-script.sh
├── screenshots/
└── docs/
```

---

## Author

Robert Dake
