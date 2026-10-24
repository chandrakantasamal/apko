
import json
from pathlib import Path
from collections import Counter

# REPORT_DIR = Path.home() / "cve-analysis"
REPORT_DIR = Path("/Users/csamal/Desktop/chaintech/mistal-chain/hello-melange-apko/py/cveanalysis/")

IMAGES = {
    "SINGLE-STAGE": REPORT_DIR / "single.json",
    "MULTI-STAGE": REPORT_DIR / "multi.json",
}


def load_critical_cves(path):
    with path.open(encoding="utf-8") as f:
        report = json.load(f)

    findings = []

    for result in report.get("Results") or []:
        for vuln in result.get("Vulnerabilities") or []:
            if vuln.get("Severity", "").upper() != "CRITICAL":
                continue

            findings.append({
                "cve": vuln.get("VulnerabilityID", "UNKNOWN"),
                "package": vuln.get("PkgName", ""),
                "installed": vuln.get("InstalledVersion", ""),
                "fixed": vuln.get("FixedVersion", "") or "No fix listed",
                "target": result.get("Target", ""),
                "title": vuln.get("Title", ""),
                "url": vuln.get("PrimaryURL", ""),
            })

    return findings


def unique_cves(findings):
    return {item["cve"] for item in findings}


def format_findings(name, findings):
    lines = [
        f"=== {name} IMAGE: CRITICAL CVEs ===",
        f"Total package-level findings: {len(findings)}",
        f"Unique CVE identifiers: {len(unique_cves(findings))}",
        ""
    ]

    if not findings:
        lines.append("No Critical CVEs were reported by this scan.")
        lines.append("")

    for item in sorted(
        findings, key=lambda x: (x["cve"], x["package"])
    ):
        lines.extend([
            f"CVE: {item['cve']}",
            f"  Package: {item['package']}",
            f"  Installed version: {item['installed']}",
            f"  Fixed version: {item['fixed']}",
            f"  Target: {item['target']}",
            f"  Title: {item['title']}",
            f"  Reference: {item['url']}",
            ""
        ])

    return lines


def finding_keys(findings):
    return {
        (item["cve"], item["package"], item["installed"])
        for item in findings
    }


single_path = IMAGES["SINGLE-STAGE"]
multi_path = IMAGES["MULTI-STAGE"]

for path in (single_path, multi_path):
    if not path.exists():
        raise SystemExit(f"Missing scan report: {path}")

single = load_critical_cves(single_path)
multi = load_critical_cves(multi_path)

single_cves = unique_cves(single)
multi_cves = unique_cves(multi)

single_keys = finding_keys(single)
multi_keys = finding_keys(multi)

lines = [
    "CRITICAL CVE COMPARISON REPORT",
    "=" * 60,
    "Images:",
    "Single: localhost:5001/hello-melange-apko:v1-single",
    "Multi:  localhost:5001/hello-melange-apko:v1-multi",
    "",
    "SUMMARY",
    "-" * 60,
    f"Single-stage package-level findings: {len(single)}",
    f"Multi-stage package-level findings:  {len(multi)}",
    f"Single-stage unique CVEs: {len(single_cves)}",
    f"Multi-stage unique CVEs:  {len(multi_cves)}",
    f"Shared CVE identifiers: {len(single_cves & multi_cves)}",
    f"CVEs only in single-stage: {len(single_cves - multi_cves)}",
    f"CVEs only in multi-stage:  {len(multi_cves - single_cves)}",
    "",
    "DETAILED FINDINGS",
    "=" * 60,
]

lines += format_findings("SINGLE-STAGE", single)
lines += format_findings("MULTI-STAGE", multi)

lines += [
    "CVE IDENTIFIER COMPARISON",
    "=" * 60,
    "Shared CVEs:",
    *[f"  {cve}" for cve in sorted(single_cves & multi_cves)],
    "",
    "Only in single-stage:",
    *[f"  {cve}" for cve in sorted(single_cves - multi_cves)],
    "",
    "Only in multi-stage:",
    *[f"  {cve}" for cve in sorted(multi_cves - single_cves)],
    "",
    "PACKAGE-LEVEL DIFFERENCES",
    "=" * 60,
    "Findings only in single-stage:",
    *[
        f"  {cve} | {pkg} | {version}"
        for cve, pkg, version in sorted(single_keys - multi_keys)
    ],
    "",
    "Findings only in multi-stage:",
    *[
        f"  {cve} | {pkg} | {version}"
        for cve, pkg, version in sorted(multi_keys - single_keys)
    ],
    "",
    "Note: Results reflect the scanner database and image contents",
    "at scan time. No findings does not prove an image is secure.",
]

output = REPORT_DIR / "critical-cve-comparison.txt"
output.write_text("\n".join(lines) + "\n", encoding="utf-8")

print(f"Comparison report created: {output}")
print(f"Single-stage findings: {len(single)}")
print(f"Multi-stage findings:  {len(multi)}")
