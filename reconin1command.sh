#!/bin/bash

# ReconIn1Command - A one-stop solution for advanced reconnaissance
# Author: Your Name
# GitHub: Your GitHub Profile

# Check if a target domain is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <target_domain>"
  exit 1
fi

TARGET=$1
OUTPUT_DIR="recon_$TARGET"

# Create output directory
mkdir -p $OUTPUT_DIR

# Banner
echo "========================================"
echo "        ReconIn1Command v1.0            "
echo "       Advanced Reconnaissance          "
echo "========================================"

# Function: Subdomain Enumeration
subdomain_enum() {
  echo "[*] Enumerating subdomains..."
  subfinder -d $TARGET -silent > $OUTPUT_DIR/subdomains.txt
  assetfinder --subs-only $TARGET >> $OUTPUT_DIR/subdomains.txt
  amass enum -d $TARGET -o $OUTPUT_DIR/amass_subdomains.txt
  cat $OUTPUT_DIR/amass_subdomains.txt >> $OUTPUT_DIR/subdomains.txt
  sort -u $OUTPUT_DIR/subdomains.txt -o $OUTPUT_DIR/subdomains.txt
}

# Function: Subdomain Resolution
resolve_subdomains() {
  echo "[*] Resolving live subdomains..."
  httpx -l $OUTPUT_DIR/subdomains.txt -silent -o $OUTPUT_DIR/resolved_subdomains.txt
}

# Function: Port Scanning
port_scan() {
  echo "[*] Performing port scanning..."
  nmap -iL $OUTPUT_DIR/resolved_subdomains.txt -p- --min-rate=1000 -T4 -oA $OUTPUT_DIR/nmap_scan
}

# Function: Vulnerability Scanning
vuln_scan() {
  echo "[*] Running vulnerability scans..."
  nuclei -l $OUTPUT_DIR/resolved_subdomains.txt -o $OUTPUT_DIR/nuclei_vulns.txt
}

# Function: Web Fingerprinting
web_fingerprinting() {
  echo "[*] Identifying web technologies..."
  whatweb -i $OUTPUT_DIR/resolved_subdomains.txt -v > $OUTPUT_DIR/whatweb_results.txt
}

# Function: Collecting JavaScript Files
collect_js() {
  echo "[*] Collecting JavaScript files..."
  cat $OUTPUT_DIR/resolved_subdomains.txt | waybackurls | grep "\.js$" | tee $OUTPUT_DIR/javascript_files.txt
}

# Function: Endpoints Discovery
discover_endpoints() {
  echo "[*] Finding endpoints..."
  cat $OUTPUT_DIR/javascript_files.txt | gau | tee $OUTPUT_DIR/endpoints.txt
}

# Function: Secrets Scanning in JS Files
scan_js_secrets() {
  echo "[*] Scanning JavaScript files for secrets..."
  cat $OUTPUT_DIR/javascript_files.txt | xargs -I {} python3 SecretFinder.py -i {} -o cli > $OUTPUT_DIR/secrets.txt
}

# Execute all functions
subdomain_enum
resolve_subdomains
port_scan
vuln_scan
web_fingerprinting
collect_js
discover_endpoints
scan_js_secrets

echo "[+] Reconnaissance completed! Results saved in $OUTPUT_DIR/"
