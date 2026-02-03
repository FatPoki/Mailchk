Nice work — this is **absolutely README-worthy** 👌
Below is a **professional, detailed GitHub README** you can paste directly as `README.md`.
It’s written to look good for **SOC / Blue Team / beginner security projects**.

---

# 📧 MailChk — Email Header Analyzer

**MailChk** is a lightweight Bash-based email header analysis tool designed to help SOC analysts, blue teamers, and security learners quickly inspect email headers for signs of spoofing, phishing, or misconfiguration.

It parses common email authentication mechanisms such as **SPF, DKIM, and DMARC**, extracts key header information, and provides a clear verdict on whether an email looks safe or suspicious.

---

## 🚀 Features

* 📬 Extracts key email headers:

  * Sender (`From`)
  * Receiver (`To`)
  * Return-Path
  * Sender IP address
* 🔐 Analyzes email authentication:

  * SPF
  * DKIM
  * DMARC
* 🧠 Detects mixed or forwarded authentication states
* 🎯 Provides a final **ARC-style authentication verdict**
* 🖥️ Terminal-friendly with colored output and banners
* ⚡ Fast analysis using standard Linux utilities

---

## 📂 Supported File Types

MailChk supports the following email formats:

* `.eml`
* `.msg`
* `.emlx`

---

## 🛠️ Requirements

The following tools must be installed on your system:

* `bash`
* `grep`
* `sed`
* `cut`
* `pv`
* `figlet`
* `lolcat`

### Install dependencies (Debian/Ubuntu)

```bash
sudo apt install pv figlet lolcat
```

> Note: Core utilities like `grep`, `sed`, and `cut` are usually preinstalled.

---

## 📦 Installation

Clone the repository and make the script executable:

```bash
git clone https://github.com/yourusername/mailchk.git
cd mailchk
chmod +x mailchk.sh
```

(Optional) Move it to your PATH:

```bash
sudo mv mailchk.sh /usr/local/bin/mailchk
```

---

## ▶️ Usage

```bash
mailchk.sh <email_file>
```

### Example

```bash
./mailchk.sh suspicious.eml
```

---

## ❓ Help Menu

```bash
./mailchk.sh -h
```

Displays usage instructions, description, and examples.

---

## 📊 Output Overview

MailChk provides:

* Parsed email header details
* Individual results for:

  * SPF
  * DKIM
  * DMARC
* Clear indicators for:

  * Forwarded emails
  * Mixed authentication states
* Final verdict:

  * ✅ **Mail looks safe**
  * ⚠️ **Mail looks suspicious**

---

## 🧪 Example Verdict

```text
ARC authentication passed. Mail looks safe.
```

or

```text
ARC authentication failed. Mail looks suspicious.
```

---

## ⚠️ Limitations

* Header-based analysis only (no attachment or body inspection)
* Does not validate cryptographic DKIM signatures
* Best used as a **triage tool**, not a full forensic solution

---

## 🎯 Use Cases

* SOC Tier 1 / Tier 2 email triage
* Phishing investigation practice
* Blue team labs and learning
* Email header analysis automation

---


## 👤 Author

**Anoop Sharma**
Cybersecurity | SOC | Blue Team Enthusiast
