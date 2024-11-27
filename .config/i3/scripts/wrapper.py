#!/usr/bin/env python3

import json
import subprocess

if __name__ == "__main__":
    # Check the presentation mode status
    try:
        task = subprocess.getoutput("~/.config/i3/scripts/i3-presentation-mode.sh")
        status_text = task if task else "Presentation mode: Off"
        color = "#ffcc00" if "On" in task else "#ffffff"

        # Output valid JSON
        output = {"full_text": status_text, "color": color}
        print(json.dumps(output))
    except Exception as e:
        # On error, show a fallback block
        output = {"full_text": "Error in presentation mode", "color": "#ff0000"}
        print(json.dumps(output))
