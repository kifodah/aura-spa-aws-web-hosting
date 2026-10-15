# Aura-Spa Troubleshooting Guide

## 1. Apache Is Not Running

**Symptoms:** The website is unavailable or Apache reports an inactive service.

**Checks:**

```bash
sudo systemctl status apache2
sudo apache2ctl configtest
sudo journalctl -u apache2 --no-pager -n 50
```

**Resolution:** Review the error messages, correct any invalid Apache configuration, and restart the service if appropriate.

```bash
sudo systemctl restart apache2
```

## 2. HTTPS Is Not Accessible

**Symptoms:** The browser reports a connection error or TLS certificate warning.

**Checks:**

```bash
sudo systemctl status apache2
sudo apache2ctl configtest
curl -Iv https://aura-spa.duckdns.org
sudo certbot certificates
```

**Possible causes:**

- Inbound TCP port 443 is not allowed by the EC2 security group.
- The hostname resolves to an incorrect public IP.
- Apache has an SSL virtual-host configuration issue.
- The certificate has expired or does not match the hostname.

**Resolution:** Verify DNS, the EC2 security group, Apache configuration, and certificate status before making changes.

## 3. HTTP Does Not Redirect to HTTPS

**Check:**

```bash
curl -I http://aura-spa.duckdns.org
```

**Expected result:** `301 Moved Permanently` with a `Location` header pointing to `https://aura-spa.duckdns.org/`.

If the redirect is missing, inspect the Apache virtual-host configuration and verify that the intended redirect is enabled.

## 4. BIND9 DNS Lookup Fails

**Checks:**

```bash
sudo systemctl status bind9
sudo named-checkconf
sudo named-checkzone lab.test /etc/bind/db.lab.test
dig @127.0.0.1 www.lab.test +short
```

**Resolution:** Review the BIND9 configuration, zone-file syntax, and service logs.

The `lab.test` zone is intended for local testing, not public DNS resolution.

## 5. Postfix Local Mail Delivery Fails

**Checks:**

```bash
sudo postfix status
sudo postconf -n
sudo journalctl -u postfix --no-pager -n 50
sudo ss -ltnp | grep ':25'
```

**Resolution:** Verify the local delivery configuration and inspect the logs. Keep Postfix restricted to loopback unless a separate, properly secured public mail-server design is implemented.

## 6. Certbot Renewal Test Fails

**Check:**

```bash
sudo certbot renew --dry-run
```

**Resolution:** Review the complete error output, confirm that the hostname resolves correctly, and check the web-server configuration and certificate-renewal setup before attempting further changes.

## 7. AWS Connectivity Problems

**Symptoms:** The website cannot be reached from outside the EC2 instance.

**Checks:**

- Confirm the EC2 instance is running.
- Verify that the hostname points to the correct public IP.
- Review the attached security group.
- Check Apache's listening ports.

```bash
sudo ss -ltnp
curl -I http://localhost
curl -I https://aura-spa.duckdns.org
```

Allow only the necessary inbound ports. Restrict SSH access to trusted source IP addresses.

## Troubleshooting Principle

Collect evidence first, identify the likely cause, make one controlled change at a time, and repeat the relevant validation test. Avoid exposing credentials, private keys, or sensitive logs when sharing troubleshooting information.
