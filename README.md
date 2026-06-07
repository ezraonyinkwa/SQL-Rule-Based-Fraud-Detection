# SQL Rule-Based Fraud Detection

## What This Project Does

Banks and financial institutions process thousands of transactions daily. 
Hidden within that volume are patterns that signal fraud — a device used 
by too many accounts, a transaction spiking past normal thresholds, a 
customer logging in from an unusual location. Without a structured 
detection system, these signals go unnoticed until damage is done.

This project builds a rule-based fraud detection engine using SQL. It 
structures raw daily transaction data into a clean data model, then runs 
9 detection rules against it to surface suspicious activity — with real 
findings annotated directly in the code.

---

## How It Works

### Step 1 — Data Modelling
Raw transaction data is organised into a **Star Schema**: a central fact 
table (`FactTransactionsData`) connected to dimension tables for customers, 
devices, and locations. This structure makes querying fast and the 
relationships between entities traceable.

### Step 2 — Fraud Rule Engine
Nine SQL rules are applied to the structured data, each targeting a 
distinct fraud pattern:

| Rule | What It Detects | Findings |
|------|----------------|----------|
| High-Value Threshold | Transactions above $5,000 | Flagged for review |
| Transaction Velocity | 5+ transactions within 10 minutes | 0 cases — pattern shifted |
| Device Sharing | 1 device used by 3+ accounts | **344 cases found** |
| Unusual Location | Accounts with only 1 transaction location | **24 cases found** |
| Rapid Balance Depletion | Balance dropping >80% quickly | Flagged for review |
| Repeated Failed Logins | Average login attempts >3 | 1 case found (AC00169) |
| Multiple Devices in One Hour | Same account, different devices per hour | Flagged for review |
| IP-to-Merchant Anomaly | 1 IP address used by 3+ merchants | **338 cases found** |
| Off-Hours Transactions | Transactions between midnight and 4am | 0 cases found |

### Step 3 — Monitoring Dashboard
Flagged transactions are surfaced in a **Power BI dashboard** with 
built-in anomaly detection enabled on transaction trends, giving 
stakeholders a live monitoring view without needing to query the 
database directly.

---

## Key Findings

- **344 device-sharing cases** identified — the highest volume fraud 
  signal in the dataset
- **338 IP anomalies** detected across multiple merchants sharing a 
  single IP address
- **Zero velocity fraud** and **zero off-hours transactions** — both 
  rules returned null results, indicating fraudsters have adapted their 
  behaviour, itself a signal worth acting on
- **One repeat login offender** isolated at account level (AC00169)

---

## Tech Stack

- **SQL** — data cleaning, modelling, and rule implementation
- **Star Schema** — relational database design
- **Power BI** — monitoring dashboard with anomaly detection
- **Data Validation** — integrity checks across all relational tables

---

## Who This Is For

This project is relevant to anyone working in **financial services, 
fintech, or banking** who needs a lightweight, interpretable fraud 
detection layer that doesn't require machine learning — just clean 
data, clear rules, and the ability to act on what the numbers show.
