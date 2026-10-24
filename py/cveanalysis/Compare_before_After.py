
import json
from pathlib import Path

BASE = Path("/Users/csamal/Desktop/chaintech/mistal-chain/hello-melange-apko/py/cveanalysis/")

FILES = {
    "Original single-stage": BASE / "single.json",
    "Original multi-stage": BASE / "multi.json",
    "Patched single-stage": BASE / "single-patched-critical-v2.json",
    "Patched multi-stage": BASE / "multi-patched-critical-v2.json",
}


def load_cves(path):
    with path.open(encoding="utf-8") as f:
        report = json.load(f)

    cves = set()

    for result in report.get("Results") or []:
        for vuln in result.get("Vulnerabilities") or []:
            if vuln.get("Severity", "").upper() == "CRITICAL":
                cves.add(vuln.get("VulnerabilityID", "UNKNOWN"))

    return cves


results = {}
for name, path in FILES.items():
    if not path.exists():
        raise SystemExit(f"Missing report: {path}")
    results[name] = load_cves(path)

lines = [
    "BEFORE-AND-AFTER CRITICAL CVE COMPARISON",
    "=" * 55,
    ""
]

for name, cves in results.items():
    lines.append(f"{name}: {len(cves)} unique Critical CVEs")
    for cve in sorted(cves):
        lines.append(f"  {cve}")
    lines.append("")

for original, patched in [
    ("Original single-stage", "Patched single-stage"),
    ("Original multi-stage", "Patched multi-stage"),
]:
    before = results[original]
    after = results[patched]

    lines.extend([
        f"Comparison: {original} -> {patched}",
        f"Before: {len(before)} unique Critical CVEs",
        f"After: {len(after)} unique Critical CVEs",
        f"Resolved from scan results: {len(before - after)}",
        f"Still reported: {len(before & after)}",
        f"Newly reported: {len(after - before)}",
        "Still reported CVEs: " + (
            ", ".join(sorted(before & after)) or "None"
        ),
        ""
    ])

output = BASE / "before-after-critical-comparison.txt"
output.write_text("\n".join(lines) + "\n", encoding="utf-8")
print(f"Report created: {output}")
