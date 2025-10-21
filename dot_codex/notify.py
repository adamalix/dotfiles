#!/usr/bin/env python3

import json
import subprocess
import sys
from pathlib import Path


def format_cwd(raw_path: str | None) -> str:
    """
    Return a compact, user-friendly representation of the cwd.

    Absolute paths inside the home directory become one of:
    - "~" for the home directory itself
    - "~/<leaf>" for a single child
    - "~/.../<leaf>" for deeper descendants

    Other absolute paths collapse to their final component (or "/" for root).
    Relative or empty paths fall back to the last component or "Unknown Location".
    """
    if raw_path is None:
        return "Unknown Location"

    path_text = str(raw_path).strip()
    if not path_text:
        return "Unknown Location"

    path_obj = Path(path_text).expanduser()
    home_path = Path.home()

    if path_obj.is_absolute():
        try:
            relative_to_home = path_obj.relative_to(home_path)
        except ValueError:
            name = path_obj.name
            if not name:
                return "/"
            return name
        else:
            parts = list(relative_to_home.parts)
            if not parts:
                return "~"
            if len(parts) == 1:
                return f"~/{parts[0]}"
            return f"~/.../{parts[-1]}"

    parts = list(path_obj.parts)
    if not parts:
        return "Unknown Location"
    return parts[-1]


def main() -> int:
    if len(sys.argv) != 2:
        print("Usage: notify.py <NOTIFICATION_JSON>")
        return 1

    try:
        notification = json.loads(sys.argv[1])
    except json.JSONDecodeError:
        return 1

    match notification_type := notification.get("type"):
        case "agent-turn-complete":
            message = notification.get("last-assistant-message") or "Turn Complete!"
            path_suffix = format_cwd(notification.get("cwd"))
            title = f"Codex - {path_suffix}"
        # TODO: add case for `approval-requested` when that is implemented by OpenAI
        case _:
            print(f"not sending a push notification for: {notification_type}")
            return 0

    thread_id = notification.get("thread-id", "")

    subprocess.check_output(
        [
            "terminal-notifier",
            "-title",
            title,
            "-message",
            message,
            "-group",
            "codex-" + thread_id,
            "-ignoreDnD",
            "-activate",
            "dev.warp.Warp-Stable",
        ]
    )

    return 0


if __name__ == "__main__":
    sys.exit(main())
