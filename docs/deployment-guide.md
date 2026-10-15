# Aura-Spa Deployment Guide

## 1. Project Overview

This guide documents the deployment of the Aura-Spa website on an Ubuntu Amazon EC2 instance, including Apache, DuckDNS, HTTPS, BIND9, and Postfix.

## 2. Prerequisites

- An AWS account with permission to create and manage EC2 resources.
- An Ubuntu EC2 instance.
- SSH access to the instance.
- A DuckDNS hostname pointing to the instance's public IP address.
- A local Git and GitHub environment for project documentation.

## 3. Connect to the EC2 Instance

Connect using the SSH private key associated with the instance:

```bash
ssh -i /path/to/key.pem ubuntu@YOUR_PUBLIC_IP
```

Replace the placeholders with your actual key path and server IP. Keep the private key outside the Git repository.

## 4. Update Ubuntu

```bash
sudo apt update
sudo apt upgrade
```

Review package changes before confirming an upgrade on a production server.

## 5. Install and Verify Apache

```bash
sudo apt install apache2
sudo systemctl enable --now apache2
sudo systemctl status apache2
sudo apache2ctl configtest
```

Verify the website locally:

```bash
curl -I http://localhost
```

## 6. Configure the Hostname

Configure the DuckDNS hostname `aura-spa.duckdns.org` to resolve to the EC2 instance's public IP address.

Verify DNS resolution:

```bash
dig aura-spa.duckdns.org
```

The returned address should match the configured public IP.

## 7. Configure HTTPS with Certbot

Certbot was installed and used with the Apache plugin to obtain and install a Let's Encrypt certificate.

The certificate paths are:

- Certificate chain: `/etc/letsencrypt/live/aura-spa.duckdns.org/fullchain.pem`
- Private key: `/etc/letsencrypt/live/aura-spa.duckdns.org/privkey.pem`

Validate the Apache configuration:

```bash
sudo apache2ctl configtest
sudo systemctl reload apache2
```

Test HTTPS:

```bash
curl -I https://aura-spa.duckdns.org
```

Test the HTTP-to-HTTPS redirect:

```bash
curl -I http://aura-spa.duckdns.org
```

The expected HTTP response is `301 Moved Permanently` with an HTTPS `Location` header.

## 8. Configure Local DNS Testing

BIND9 was configured with a local test zone named `lab.test`.

Example validation commands:

```bash
dig @127.0.0.1 www.lab.test +short
dig @127.0.0.1 lab.test MX +short
sudo systemctl is-active bind9
```

The DNS service is restricted to loopback for local testing.

## 9. Configure Local Mail Testing

Postfix was configured for local-only mail delivery.

Check the service:

```bash
sudo postfix status
sudo ss -ltnp | grep ':25'
```

The SMTP listener should remain on loopback for this configuration. This setup is not a public email service.

## 10. Validate the Deployment

Run:

```bash
sudo apache2ctl configtest
sudo systemctl is-active apache2
sudo systemctl is-active bind9
sudo postfix status
curl -I https://aura-spa.duckdns.org
curl -I http://aura-spa.duckdns.org
sudo certbot renew --dry-run
```

The deployment was verified with Apache active, HTTPS returning `200 OK`, HTTP redirecting with `301 Moved Permanently`, and a successful Certbot renewal dry run.

## 11. Security Notes

- Restrict SSH access to trusted IP addresses.
- Allow only the inbound ports required by the deployment.
- Do not expose DNS or SMTP publicly for this local-only configuration.
- Never commit AWS credentials, passwords, access tokens, or private keys.
- Review AWS costs and stop or remove resources when they are no longer needed.

## 12. Future Improvements

- Automate configuration with Ansible.
- Provision infrastructure with Terraform.
- Add centralized monitoring and alerting.
- Integrate automated deployments through GitHub Actions.
