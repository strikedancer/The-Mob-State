#!/usr/bin/env python3
import os
import sys
from pathlib import Path

# Set API key BEFORE any imports
os.environ["LEONARDO_API_KEY"] = "cc6973fe-9c66-4318-aacf-746433c218ce"

# Now import the script
sys.path.insert(0, str(Path(__file__).parent))
from generate_nightclub_achievement_badges import main

if __name__ == "__main__":
    exit_code = main()
    sys.exit(exit_code)

