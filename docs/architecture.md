# Aura-Spa Infrastructure Architecture

## Overview

Aura-Spa is hosted on an Ubuntu Amazon EC2 instance. Apache serves the website, DuckDNS provides the public hostname, and Let's Encrypt provides the TLS certificate used for HTTPS.

BIND9 and Postfix are installed for local DNS and mail-service practice. They are restricted to local testing and are not configured as public DNS or email services.

## Architecture Components

| Component | Purpose |
|---|---|
| Amazon EC2 | Hosts the Ubuntu server |
| Ubuntu Linux | Operating system |
| DuckDNS | Maps the hostname to the server's public IP |
| Apache | Serves the website |
| Let's Encrypt and Certbot | Provide and manage the HTTPS certificate |
| BIND9 | Provides a local DNS test zone |
| Postfix | Handles local-only email delivery |
| Bash | Automates service and HTTPS health checks |

## Request Flow

1. A visitor opens `aura-spa.duckdns.org`.
2. DuckDNS resolves the hostname to the configured public IP address.
3. HTTP requests on port 80 are redirected to HTTPS.
4. Apache serves the website over port 443 using the installed TLS certificate.
5. BIND9 and Postfix remain available for local administration and testing.

## Security Boundaries

- Public web access uses HTTP and HTTPS as configured in the AWS security group.
- SSH access should be restricted to trusted source IP addresses.
- BIND9 listens on loopback for the local test zone.
- Postfix listens on loopback for local mail delivery.
- Private keys and credentials must never be committed to GitHub.

## Health Checks

The Bash script at `scripts/health-check.sh` checks Apache, BIND9, Postfix, and the public HTTPS endpoint.

## Future Improvements

- Automate server configuration with Ansible.
- Provision infrastructure using Terraform.
- Add monitoring and alerting.
- Implement automated deployment from GitHub.
