#!/usr/bin/env python3
"""Phase 3 smoke test for Smuggling Hub endpoints.

Default mode is non-destructive (catalog/overview/quote checks only).
Use --run-send-test to validate cooldown enforcement with two quick sends.
"""

from __future__ import annotations

import argparse
import json
import os
import sys
from typing import Any, Dict, List, Optional, Tuple

import requests


def _print_step(name: str, ok: bool, details: str = "") -> None:
    status = "PASS" if ok else "FAIL"
    print(f"[{status}] {name}")
    if details:
        print(f"       {details}")


class SmokeContext:
    def __init__(self, base_url: str, token: str):
        self.base_url = base_url.rstrip("/")
        self.headers = {
            "Authorization": f"Bearer {token}",
            "Content-Type": "application/json",
        }

    def get(self, path: str) -> requests.Response:
        return requests.get(f"{self.base_url}{path}", headers=self.headers, timeout=30)

    def post(self, path: str, payload: Dict[str, Any]) -> requests.Response:
        return requests.post(f"{self.base_url}{path}", headers=self.headers, json=payload, timeout=30)


def login_for_token(base_url: str, username: str, password: str) -> Optional[str]:
    resp = requests.post(
        f"{base_url.rstrip('/')}/auth/login",
        json={"username": username, "password": password},
        headers={"Content-Type": "application/json"},
        timeout=30,
    )

    if resp.status_code != 200:
        _print_step("Auth login", False, f"HTTP {resp.status_code}: {resp.text[:300]}")
        return None

    data = resp.json()
    token = data.get("token")
    if not token:
        _print_step("Auth login", False, "No token in login response")
        return None

    _print_step("Auth login", True, "Token acquired")
    return token


def choose_send_candidate(catalog: Dict[str, Any]) -> Optional[Tuple[str, Dict[str, Any]]]:
    categories = catalog.get("categories") or {}

    # Keep vehicle out of automatic send-test to minimize impact.
    priority = ["drug", "ammo", "weapon", "trade"]
    for cat in priority:
        items = categories.get(cat) or []
        for item in items:
            qty = int(item.get("quantity") or 0)
            if qty >= 1:
                return cat, item
    return None


def find_quote_payload(catalog: Dict[str, Any], network_scope: str) -> Optional[Dict[str, Any]]:
    destinations = catalog.get("destinations") or []
    if not destinations:
        return None

    candidate = choose_send_candidate(catalog)
    if not candidate:
        return None

    category, item = candidate
    item_key = str(item.get("itemKey") or "")
    if not item_key:
        return None

    metadata: Dict[str, Any] = {}
    if category == "drug" and item.get("quality"):
        metadata["quality"] = item.get("quality")
    if category == "vehicle" and isinstance(item.get("metadata"), dict):
        metadata.update(item["metadata"])

    destination = str(destinations[0].get("id") or "")
    if not destination:
        return None

    return {
        "category": category,
        "itemKey": item_key,
        "quantity": 1,
        "destinationCountry": destination,
        "channel": "courier",
        "networkScope": network_scope,
        "metadata": metadata,
    }


def assert_json(resp: requests.Response) -> Tuple[bool, Dict[str, Any]]:
    try:
        data = resp.json()
        if isinstance(data, dict):
            return True, data
        return False, {}
    except Exception:
        return False, {}


def run_non_destructive_checks(ctx: SmokeContext) -> Tuple[bool, Dict[str, Any], Dict[str, Any]]:
    ok_all = True

    # Personal catalog
    c1 = ctx.get("/smuggling/catalog?networkScope=personal")
    ok_json, d1 = assert_json(c1)
    ok = c1.status_code == 200 and ok_json and bool(d1.get("success"))
    _print_step("Catalog personal", ok, f"HTTP {c1.status_code}")
    ok_all = ok_all and ok

    # Crew catalog
    c2 = ctx.get("/smuggling/catalog?networkScope=crew")
    ok_json2, d2 = assert_json(c2)
    ok2 = c2.status_code == 200 and ok_json2 and bool(d2.get("success"))
    _print_step("Catalog crew", ok2, f"HTTP {c2.status_code}")
    ok_all = ok_all and ok2

    # Overview
    ov = ctx.get("/smuggling/overview")
    ok_json_ov, dov = assert_json(ov)
    ok3 = ov.status_code == 200 and ok_json_ov and bool(dov.get("success"))
    _print_step("Overview", ok3, f"HTTP {ov.status_code}")
    ok_all = ok_all and ok3

    # Quote personal
    quote_payload = find_quote_payload(d1, "personal")
    if quote_payload is None:
        _print_step("Quote personal", False, "No suitable item/destination found in personal catalog")
        ok_all = False
    else:
        q1 = ctx.post("/smuggling/quote", quote_payload)
        ok_json_q1, dq1 = assert_json(q1)
        ok4 = q1.status_code in (200, 400) and ok_json_q1
        _print_step("Quote personal", ok4, f"HTTP {q1.status_code}, success={dq1.get('success')}")
        ok_all = ok_all and ok4

    # Quote crew (if crew is usable and has an item)
    if d2.get("canUseCrewNetwork"):
        quote_payload_crew = find_quote_payload(d2, "crew")
        if quote_payload_crew is None:
            _print_step("Quote crew", True, "Skipped: no crew item available")
        else:
            q2 = ctx.post("/smuggling/quote", quote_payload_crew)
            ok_json_q2, dq2 = assert_json(q2)
            ok5 = q2.status_code in (200, 400) and ok_json_q2
            _print_step("Quote crew", ok5, f"HTTP {q2.status_code}, success={dq2.get('success')}")
            ok_all = ok_all and ok5
    else:
        _print_step("Quote crew", True, "Skipped: account has no crew")

    return ok_all, d1, d2


def run_cooldown_send_test(ctx: SmokeContext, personal_catalog: Dict[str, Any]) -> bool:
    payload = find_quote_payload(personal_catalog, "personal")
    if payload is None:
        _print_step("Cooldown send test", False, "No suitable personal item for send test")
        return False

    # Use package channel for shortest cooldown while still validating enforcement.
    payload["channel"] = "package"

    s1 = ctx.post("/smuggling/send", payload)
    ok_json_s1, d1 = assert_json(s1)
    ok1 = s1.status_code in (200, 201) and ok_json_s1 and bool(d1.get("success"))
    _print_step("Send #1", ok1, f"HTTP {s1.status_code}")
    if not ok1:
        return False

    s2 = ctx.post("/smuggling/send", payload)
    ok_json_s2, d2 = assert_json(s2)
    # Expected: second send blocked by cooldown (400 + message includes 'Wacht').
    blocked = s2.status_code == 400 and ok_json_s2 and "Wacht" in str(d2.get("message") or "")
    _print_step("Send #2 cooldown", blocked, f"HTTP {s2.status_code}, message={d2.get('message')}")
    return blocked


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Smuggling phase-3 smoke test")
    parser.add_argument("--base-url", default=os.getenv("SMOKE_BASE_URL", "http://localhost:3000"))
    parser.add_argument("--token", default=os.getenv("SMOKE_TOKEN"))
    parser.add_argument("--username", default=os.getenv("SMOKE_USERNAME"))
    parser.add_argument("--password", default=os.getenv("SMOKE_PASSWORD"))
    parser.add_argument("--run-send-test", action="store_true", help="Runs a real send twice to validate cooldown (consumes inventory).")
    return parser.parse_args()


def main() -> int:
    args = parse_args()

    token = args.token
    if not token:
        if not args.username or not args.password:
            print("Provide --token OR --username/--password (or SMOKE_TOKEN / SMOKE_USERNAME / SMOKE_PASSWORD).")
            return 2
        token = login_for_token(args.base_url, args.username, args.password)
        if not token:
            return 2

    ctx = SmokeContext(args.base_url, token)
    print("\nRunning non-destructive checks...")
    ok, personal_catalog, _crew_catalog = run_non_destructive_checks(ctx)

    if args.run_send_test:
        print("\nRunning cooldown send test (destructive)...")
        ok = run_cooldown_send_test(ctx, personal_catalog) and ok
    else:
        print("\nSkipping cooldown send test (use --run-send-test to enable).")

    print("\nSummary:")
    print(json.dumps({"success": ok, "runSendTest": args.run_send_test}, indent=2))
    return 0 if ok else 1


if __name__ == "__main__":
    sys.exit(main())
