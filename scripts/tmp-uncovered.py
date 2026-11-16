"""Temporary, fork only. Prints added Core lines that no test executed."""
import re, subprocess, sys
base, llvm_cov, binary, prof = sys.argv[1:5]
diff = subprocess.run(["git", "diff", "-U0", base, "HEAD", "--", "Sources/PokeTokenBar/Core"], capture_output=True, text=True).stdout
added, cur = {}, None
for line in diff.splitlines():
    if line.startswith("+++ b/"): cur = line[6:]; added[cur] = set()
    m = re.match(r"@@ -\d+(?:,\d+)? \+(\d+)(?:,(\d+))? @@", line)
    if m and cur:
        start, n = int(m.group(1)), int(m.group(2) or 1)
        added[cur].update(range(start, start + n))
for path, lines in added.items():
    out = subprocess.run([llvm_cov, "show", binary, f"-instr-profile={prof}", path, "--show-regions"], capture_output=True, text=True).stdout
    missed, regions = [], []
    rows = out.splitlines()
    for i, row in enumerate(rows):
        m = re.match(r"\s*(\d+)\|\s*([0-9.kKM]+)?\|(.*)", row)
        if not m: continue
        no, count, code = int(m.group(1)), m.group(2), m.group(3)
        if no not in lines or count is None: continue
        if count == "0": missed.append((no, code.strip()))
        elif i + 1 < len(rows) and "^0" in rows[i + 1]: regions.append((no, code.strip()))
    print(f"COVERAGE {path}: {len(lines)} added lines, {len(missed)} never run, {len(regions)} with an unrun region")
    for no, code in missed: print(f"  LINE-0 {no}: {code[:110]}")
    for no, code in regions: print(f"  REGION-0 {no}: {code[:110]}")
