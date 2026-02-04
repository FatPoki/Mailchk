# MailChk – Email Header Analyzer

MailChk is a lightweight Bash-based email header analysis tool designed for SOC analysts, incident responders, and blue teamers. It helps quickly extract and review key email header information and authentication results from suspicious email files, reducing manual effort during investigations.

The tool supports common email file formats and provides optional attachment extraction with hash calculation to assist in malware and phishing analysis workflows.

---

## Features

* Supports `.eml`, `.msg`, and `.emlx` email files
* Extracts key header details:

  * Sender
  * Receiver
  * Return-Path
  * Sender IP address
* Analyzes email authentication results:

  * SPF
  * DKIM
  * DMARC
  * ARC-style pass/fail summary
* Optional attachment handling:

  * Extracts attachments safely using `ripmime`
  * Calculates SHA256 and MD5 hashes
  * Prevents duplicate extractions for the same email
* Clean, terminal-friendly output for fast triage

---

## Directory Structure

```
mailchk/
├── mailchk.sh   # Main email analysis script
├── setup.sh     # Dependency setup script
```

---

## Requirements

The following tools must be installed on the system:

* bash (v4+ recommended)
* ripmime
* grep, sed, cut, tr (coreutils)
* sha256sum, md5sum
* figlet (optional, for banner display)
* lolcat (optional, for colored output)
* pv (optional, for animated text output)

You can install most dependencies on Debian/Ubuntu-based systems using:

```
sudo apt update
sudo apt install ripmime figlet lolcat pv coreutils
```

Alternatively, use the provided setup script.

---

## Setup

1. Clone the repository:

```
git clone https://github.com/<your-username>/mailchk.git
cd mailchk
```

2. Make scripts executable:

```
chmod +x mailchk.sh setup.sh
```

3. (Optional) Run the setup script to install dependencies:

```
./setup.sh
```

---

## Usage

Basic usage:

```
./mailchk.sh suspicious.eml
```

Help menu:

```
./mailchk.sh -h
```
---
## DEMO 

<video
  src="https://github.com/user-attachments/assets/e7def2b6-e58e-4c0c-b6b5-8b64067fb076"
  autoplay
  loop
  muted
  playsinline
  width="800">
</video>

---

## What the Tool Does

1. Validates the input email file
2. Extracts and displays header information
3. Parses SPF, DKIM, and DMARC authentication results
4. Provides a high-level verdict on email authenticity
5. Optionally:

   * Extracts attachments
   * Generates SHA256 and MD5 hashes
   * Saves attachments for personal offline analysis

---

## Attachment Analysis Notes

* Attachments are extracted using `ripmime` (no execution involved)
* Hashes can be used with external reputation services such as:

  * VirusTotal
  * Hybrid Analysis
  * MalwareBazaar
* API integration is intentionally avoided to keep the tool lightweight and offline-friendly

---

## Use Cases

* Phishing email triage
* SOC Level 1 / Level 2 investigations
* Email spoofing analysis
* DFIR email artifact review
* Learning and practicing email header analysis

---

## Limitations

* Authentication results depend on what is present in the email headers
* Does not replace full email gateway or sandbox analysis
* Results should always be correlated with other tools and context

---

## Disclaimer

This tool is intended for defensive security, educational, and investigative purposes only. Results are indicative and should not be relied upon as the sole decision-making factor.

---

## License

MIT License

---

## Author

Developed by Anoop Sharma

Contributions, issues, and feature requests are welcome.
