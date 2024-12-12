# ReconIn1Command

**ReconIn1Command** is a one-stop solution for advanced reconnaissance in a single command. It integrates powerful tools to perform subdomain enumeration, port scanning, vulnerability scanning, and more.

## Features
- Subdomain enumeration using Subfinder, Assetfinder, and Amass
- Resolving live subdomains with HTTPX
- Port scanning with Nmap
- Vulnerability scanning with Nuclei
- Web fingerprinting with WhatWeb
- JavaScript file collection and endpoint discovery
- Secret scanning in JavaScript files

## Prerequisites
Ensure the following tools are installed:
- [Subfinder](https://github.com/projectdiscovery/subfinder)
- [Assetfinder](https://github.com/tomnomnom/assetfinder)
- [Amass](https://github.com/OWASP/Amass)
- [HTTPX](https://github.com/projectdiscovery/httpx)
- [Nmap](https://nmap.org/)
- [Nuclei](https://github.com/projectdiscovery/nuclei)
- [WhatWeb](https://github.com/urbanadventurer/WhatWeb)
- [Waybackurls](https://github.com/tomnomnom/waybackurls)
- [Gau](https://github.com/lc/gau)
- [SecretFinder](https://github.com/m4ll0k/SecretFinder)

## Usage
Run the script with a target domain:
```bash
./reconin1command.sh example.com
