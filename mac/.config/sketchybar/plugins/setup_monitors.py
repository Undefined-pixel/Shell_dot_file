#!/usr/bin/env python3
"""
Dynamically sets AeroSpace workspace-to-monitor assignments based on connected monitors.

Rules:
  3 monitors (ULTRAWIDE + ULTRAGEAR + built-in) : 1,2,3,4 → ULTRAWIDE (main) | 0,11 → ULTRAGEAR (second)
  2 external monitors (ULTRAWIDE + ULTRAGEAR)   : 1,2,3,4 → ULTRAWIDE | 0,11 → ULTRAGEAR
  1 external + built-in                         : 1,2,3,4 → external | 0,11 → built-in
  1 monitor                                     : all unrestricted

Runs from AeroSpace after-startup-command. Modifies ~/.aerospace.toml and reloads
AeroSpace once if assignments changed (safe: second run detects no change → no loop).
"""

import re
import subprocess
import sys
import os

CONFIG = os.path.expanduser("~/.aerospace.toml")


def get_monitors():
    result = subprocess.run(["aerospace", "list-monitors"], capture_output=True, text=True)
    monitors = []
    for line in result.stdout.strip().splitlines():
        if " | " in line:
            num, name = line.split(" | ", 1)
            monitors.append((int(num.strip()), name.strip()))
    return monitors


def compute_assignments(monitors):
    builtin = [(n, name) for n, name in monitors if "Built-in" in name]
    externals = [(n, name) for n, name in monitors if "Built-in" not in name]

    # Identify monitors by name for reliable assignment regardless of numbering order
    ultrawide = next((n for n, name in externals if "ULTRAWIDE" in name.upper()), None)
    ultragear  = next((n for n, name in externals if "ULTRAGEAR"  in name.upper()), None)
    bi = builtin[0][0] if builtin else None

    if ultrawide and ultragear and bi:
        # 3 monitors: ULTRAWIDE + ULTRAGEAR + built-in laptop
        # 1,2,3,4 → ULTRAWIDE (main) | 0,11 → ULTRAGEAR (second)
        return {1: ultrawide, 2: ultrawide, 3: ultrawide, 4: ultrawide, 0: ultragear, 11: ultragear}

    if ultrawide and ultragear and not bi:
        # 2 external monitors only (no laptop screen)
        # 1,2,3,4 → ULTRAWIDE | 0,11 → ULTRAGEAR
        return {1: ultrawide, 2: ultrawide, 3: ultrawide, 4: ultrawide, 0: ultragear, 11: ultragear}

    if len(externals) == 1 and bi:
        # 1 external + laptop
        e1 = externals[0][0]
        return {1: e1, 2: e1, 3: e1, 4: e1, 0: bi, 11: bi}

    if len(externals) >= 2 and bi:
        # Fallback: 2 unknown externals + built-in (e.g. different monitors connected)
        e1, e2 = externals[0][0], externals[1][0]
        return {1: e1, 2: e1, 3: e1, 4: e1, 0: e2, 11: e2}

    if len(externals) >= 2 and not bi:
        # Fallback: 2 unknown externals without built-in
        e1, e2 = externals[0][0], externals[1][0]
        return {1: e1, 2: e1, 3: e1, 4: e1, 0: e2, 11: e2}

    # Single monitor – no forced assignments
    return {ws: "'main'" for ws in [1, 2, 3, 4, 0, 11]}


def build_section(assignments):
    lines = ["[workspace-to-monitor-force-assignment]"]
    for ws in [1, 2, 3, 4, 0, 11]:
        lines.append(f"{ws} = {assignments[ws]}")
    return "\n".join(lines)


def main():
    monitors = get_monitors()
    if not monitors:
        print("setup_monitors: no monitors detected", file=sys.stderr)
        sys.exit(1)

    assignments = compute_assignments(monitors)
    new_section = build_section(assignments)

    with open(CONFIG, "r") as f:
        content = f.read()

    # Find current section (from header until next section or end of file)
    match = re.search(
        r"\[workspace-to-monitor-force-assignment\].*?(?=\n\[|\Z)",
        content,
        re.DOTALL,
    )
    current_section = match.group(0).strip() if match else ""

    if current_section == new_section:
        print("setup_monitors: assignments already up to date – no reload needed")
        return

    # Replace section in config
    if match:
        updated = re.sub(
            r"\[workspace-to-monitor-force-assignment\].*?(?=\n\[|\Z)",
            new_section + "\n",
            content,
            flags=re.DOTALL,
        )
    else:
        updated = content + "\n" + new_section + "\n"

    with open(CONFIG, "w") as f:
        f.write(updated)

    print(f"setup_monitors: updated assignments:\n{new_section}")
    subprocess.run(["aerospace", "reload-config"])
    import time; time.sleep(1)
    subprocess.run(["sketchybar", "--reload"])


if __name__ == "__main__":
    main()
