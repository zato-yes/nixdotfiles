#!/usr/bin/env python3
"""

Walks $XDG_DATA_DIRS, finds *.desktop files, parses them with configparser,
deduplicates by basename (first dir in XDG_DATA_DIRS wins, per spec),
filters out entries that shouldn't be shown, and writes the result as
JSON to a cache file under ~/.cache/quickshell-launcher/.
"""

import configparser
import json
import os
import sys
from pathlib import Path

CACHE_DIR = Path(os.path.expanduser("~/.cache/quickshell-launcher"))
CACHE_FILE = CACHE_DIR / "apps.json"


def get_xdg_data_dirs() -> list[Path]:
    raw = os.environ.get("XDG_DATA_DIRS", "")

    if not raw:
        fallback = [
            os.path.expanduser("~/.nix-profile/share"),
            f"/etc/profiles/per-user/{os.environ.get('USER', '')}/share",
            "/run/current-system/sw/share",
        ]
        raw = ":".join(fallback)

    dirs = []
    for entry in raw.split(":"):
        if not entry:
            continue
        candidate = Path(entry) / "applications"
        if candidate.is_dir():
            dirs.append(candidate)

    return dirs


def find_desktop_files(search_dirs: list[Path]) -> dict[str, Path]:
    seen: dict[str, Path] = {}

    for base_dir in search_dirs:
        for path in sorted(base_dir.rglob("*.desktop")):
            name = path.name
            if name not in seen:
                seen[name] = path

    return seen


# %f, %F  -> single/multiple file paths (we don't have a file to hand it)
# %u, %U  -> single/multiple URLs
# %i      -> icon flag + icon name (rarely needed for a launcher)
# %c      -> translated app name
# %k      -> path to the .desktop file itself
EXEC_FIELD_CODES = ["%f", "%F", "%u", "%U", "%i", "%c", "%k"]


def clean_exec(exec_str: str) -> str:
    """Strip field codes from an Exec= line so it's directly runnable."""
    result = exec_str
    for code in EXEC_FIELD_CODES:
        result = result.replace(code, "")
    return " ".join(result.split())  # collapse extra whitespace


def parse_one(path: Path) -> dict | None:
    """
    Parse a single .desktop file into a normalized dict, or None if it
    should be excluded from the launcher entirely.
    """
    parser = configparser.ConfigParser(
        interpolation=None, 
        strict=False,        
    )

    try:
        parser.read(path, encoding="utf-8")
    except (configparser.Error, UnicodeDecodeError, OSError):
        return None

    if "Desktop Entry" not in parser:
        return None

    entry = parser["Desktop Entry"]
    if entry.get("Type", "Application") != "Application":
        return None
    if entry.getboolean("NoDisplay", fallback=False):
        return None
    if entry.getboolean("Hidden", fallback=False):
        return None
    if entry.getboolean("Terminal", fallback=False):
        return None
    name = entry.get("Name")
    exec_raw = entry.get("Exec")

    if not name or not exec_raw:
        return None

    return {
        "name": name,
        "exec": clean_exec(exec_raw),
        "icon": entry.get("Icon", fallback=None),
        "categories": [c for c in entry.get("Categories", fallback="").split(";") if c],
        "comment": entry.get("Comment", fallback=None),
        "source_file": str(path),
    }


def build_app_list() -> list[dict]:
    search_dirs = get_xdg_data_dirs()
    desktop_files = find_desktop_files(search_dirs)

    apps = []
    for path in desktop_files.values():
        parsed = parse_one(path)
        if parsed is not None:
            apps.append(parsed)

    apps.sort(key=lambda a: a["name"].casefold())
    return apps


def write_cache(apps: list[dict]) -> None:
    CACHE_DIR.mkdir(parents=True, exist_ok=True)

    tmp_file = CACHE_FILE.with_suffix(".json.tmp")
    with open(tmp_file, "w", encoding="utf-8") as f:
        json.dump(apps, f, ensure_ascii=False)
    tmp_file.replace(CACHE_FILE)


def main():
    pretty = "--pretty" in sys.argv
    apps = build_app_list()

    write_cache(apps)

    if pretty:
        json.dump(apps, sys.stdout, indent=2, ensure_ascii=False)
        sys.stdout.write("\n")
        print(f"\n--- {len(apps)} apps found, cache written to {CACHE_FILE} ---", file=sys.stderr)


if __name__ == "__main__":
    main()
