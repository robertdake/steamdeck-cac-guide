
# Troubleshooting CAC Authentication

| Issue | Cause | Solution |
|------|------|------|
| Reader not detected | pcscd not running | sudo systemctl start pcscd |
| No certificate prompt | OpenSC module missing | Add module in Firefox |
| SSL_ERROR_RX_CERTIFICATE_REQUIRED_ALERT | CAC not presented | Restart Firefox and reinsert CAC |
| Token not listed | OpenSC middleware issue | reinstall opensc |
| Reader light not blinking | pcscd service stopped | restart service |

## Useful Diagnostics

Check reader:

```bash
pcsc_scan
```

List certificates:

```bash
pkcs11-tool --module /usr/lib/pkcs11/opensc-pkcs11.so -L
```
