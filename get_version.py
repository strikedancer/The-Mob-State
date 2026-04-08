import requests
import os

token = os.getenv("REPLICATE_API_TOKEN")

r = requests.get(
    "https://api.replicate.com/v1/models/black-forest-labs/flux-1.1-pro",
    headers={"Authorization": f"Bearer {token}"}
)

if r.status_code == 200:
    data = r.json()
    version_id = data.get("latest_version", {}).get("id")
    print(version_id)
else:
    print(f"Error: {r.status_code}")
