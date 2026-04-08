#!/usr/bin/env python3
import json
import random
import re
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
VEHICLES_JSON = ROOT / "backend" / "content" / "vehicles.json"

TARGET_CARS = 200
TARGET_BOATS = 30
TARGET_MOTORCYCLES = 60

COUNTRIES = [
	"netherlands",
	"belgium",
	"germany",
	"france",
	"spain",
	"italy",
	"switzerland",
	"austria",
	"united_kingdom",
	"monaco",
]


def slugify(text: str) -> str:
	text = text.lower().strip()
	text = re.sub(r"[^a-z0-9]+", "_", text)
	text = re.sub(r"_+", "_", text).strip("_")
	return text


def rarity_for_value(value: int) -> str:
	if value <= 30000:
		return "common"
	if value <= 90000:
		return "uncommon"
	if value <= 220000:
		return "rare"
	if value <= 650000:
		return "epic"
	return "legendary"


def max_cap_for(rarity: str, category: str) -> int:
	is_boat = category == "boat"
	is_bike = category == "motorcycle"
	if rarity == "common":
		return 24 if is_boat else (50 if is_bike else 60)
	if rarity == "uncommon":
		return 16 if is_boat else (34 if is_bike else 40)
	if rarity == "rare":
		return 10 if is_boat else (20 if is_bike else 22)
	if rarity == "epic":
		return 6 if is_boat else (11 if is_bike else 12)
	return 3 if is_boat else (5 if is_bike else 5)


def rank_for_rarity(rarity: str) -> int:
	return {
		"common": 1,
		"uncommon": 6,
		"rare": 12,
		"epic": 22,
		"legendary": 35,
	}[rarity]


def market_values(base_value: int, home: str) -> dict:
	values = {}
	for c in COUNTRIES:
		mod = 1.0
		if c == home:
			mod = 0.95
		elif c in {"switzerland", "monaco"}:
			mod = 1.16
		elif c in {"france", "italy", "united_kingdom"}:
			mod = 1.06
		elif c in {"netherlands", "belgium", "germany"}:
			mod = 1.0
		else:
			mod = 1.02
		values[c] = int(round(base_value * mod))
	return values


def pick_countries(seed_index: int, min_count: int = 3, max_count: int = 5):
	rnd = random.Random(seed_index)
	k = rnd.randint(min_count, max_count)
	return rnd.sample(COUNTRIES, k)


def create_vehicle_entry(
	category: str,
	vid: str,
	name: str,
	vtype: str,
	base_value: int,
	stats: dict,
	available_countries: list,
	description: str,
):
	rarity = rarity_for_value(base_value)
	home_country = available_countries[0]
	return {
		"id": vid,
		"name": name,
		"type": vtype,
		"image": f"{vid}.png",
		"stats": stats,
		"description": description,
		"availableInCountries": available_countries,
		"baseValue": base_value,
		"marketValue": market_values(base_value, home_country),
		"fuelCapacity": 45 if category == "motorcycle" else (140 if category == "boat" else 60),
		"requiredRank": rank_for_rarity(rarity),
		"rarity": rarity,
		"maxGameAvailability": max_cap_for(rarity, category),
		"imageNew": f"{vid}_new.png",
		"imageDirty": f"{vid}_dirty.png",
		"imageDamaged": f"{vid}_damaged.png",
	}


def unique_id(existing: set, raw_name: str, prefix: str = "") -> str:
	base = slugify(f"{prefix}_{raw_name}" if prefix else raw_name)
	candidate = base
	n = 2
	while candidate in existing:
		candidate = f"{base}_{n}"
		n += 1
	existing.add(candidate)
	return candidate


def ensure_array(data: dict, key: str):
	if key not in data or not isinstance(data[key], list):
		data[key] = []


def main():
	random.seed(42)
	data = json.loads(VEHICLES_JSON.read_text(encoding="utf-8"))
	ensure_array(data, "cars")
	ensure_array(data, "boats")
	ensure_array(data, "motorcycles")

	existing_ids = {v.get("id") for v in data["cars"] + data["boats"] + data["motorcycles"] if isinstance(v, dict)}

	car_brands_models = [
		("Toyota", ["Yaris", "Corolla", "Camry", "Supra"]),
		("Volkswagen", ["Golf", "Passat", "Arteon", "Polo"]),
		("BMW", ["M2", "M3", "M5", "X5"]),
		("Mercedes", ["A45", "C63", "E63", "GLE63"]),
		("Audi", ["S3", "S5", "RS5", "RS7"]),
		("Porsche", ["911 Carrera", "911 Turbo", "Taycan Turbo", "Panamera"]),
		("Lexus", ["IS500", "RC F", "LS500", "RX500h"]),
		("Nissan", ["370Z", "GT-R", "Qashqai", "Patrol"]),
		("Honda", ["Civic Type R", "Accord", "NSX", "CR-V"]),
		("Ford", ["Mustang GT", "Focus ST", "Ranger", "Explorer"]),
		("Chevrolet", ["Camaro SS", "Corvette C8", "Tahoe", "Silverado"]),
		("Dodge", ["Charger", "Challenger", "Durango", "Ram 1500"]),
		("Alfa Romeo", ["Giulia QV", "Stelvio", "Tonale", "4C"]),
		("Maserati", ["Ghibli", "Levante", "MC20", "Quattroporte"]),
		("Ferrari", ["Roma", "296 GTB", "Purosangue", "SF90"]),
		("Lamborghini", ["Urus", "Huracan Evo", "Revuelto", "Temerario"]),
		("McLaren", ["Artura", "570S", "750S", "GT"]),
		("Bentley", ["Continental GT", "Flying Spur", "Bentayga", "Batur"]),
		("Rolls-Royce", ["Ghost", "Wraith", "Cullinan", "Spectre"]),
		("Bugatti", ["Veyron", "Chiron Sport", "Bolide", "Mistral"]),
	]

	trim_levels = ["Street", "Black Edition", "S-Line", "Sport", "Track", "Midnight", "Executive", "Carbon"]

	car_values_by_brand = {
		"Toyota": (18000, 65000),
		"Volkswagen": (19000, 72000),
		"BMW": (45000, 280000),
		"Mercedes": (42000, 320000),
		"Audi": (39000, 260000),
		"Porsche": (70000, 450000),
		"Lexus": (38000, 170000),
		"Nissan": (24000, 180000),
		"Honda": (20000, 160000),
		"Ford": (22000, 130000),
		"Chevrolet": (26000, 180000),
		"Dodge": (30000, 160000),
		"Alfa Romeo": (35000, 180000),
		"Maserati": (80000, 500000),
		"Ferrari": (220000, 950000),
		"Lamborghini": (260000, 1200000),
		"McLaren": (210000, 980000),
		"Bentley": (170000, 650000),
		"Rolls-Royce": (280000, 1400000),
		"Bugatti": (900000, 5000000),
	}

	car_type_pool = ["standard", "speed", "stealth", "cargo", "armored", "supercar", "hypercar"]

	# Fill cars to target
	i = 0
	while len(data["cars"]) < TARGET_CARS:
		brand, models = car_brands_models[i % len(car_brands_models)]
		model = models[(i // len(car_brands_models)) % len(models)]
		trim = trim_levels[(i * 3) % len(trim_levels)]
		full_name = f"{brand} {model} {trim}".strip()
		vid = unique_id(existing_ids, full_name)
		min_v, max_v = car_values_by_brand[brand]
		rnd = random.Random(1000 + i)
		base_value = rnd.randint(min_v, max_v)

		sp = rnd.randint(48, 99)
		ar = rnd.randint(8, 88)
		cg = rnd.randint(8, 95)
		st = rnd.randint(8, 96)

		vtype = car_type_pool[(i + rnd.randint(0, 4)) % len(car_type_pool)]
		countries = pick_countries(5000 + i, 3, 6)
		desc = f"{brand} {model} in {trim} uitvoering, populair in criminele circuits voor {vtype}-operaties."

		data["cars"].append(
			create_vehicle_entry(
				"car",
				vid,
				full_name,
				vtype,
				base_value,
				{
					"speed": sp,
					"armor": ar,
					"cargo": cg,
					"stealth": st,
				},
				countries,
				desc,
			)
		)
		i += 1

	# Ensure at least 30 boats
	boat_bases = [
		("Harbor Runner", "speed"),
		("Coast Cutter", "stealth"),
		("Bluefin Cargo", "cargo"),
		("Monaco Sport Yacht", "standard"),
		("Nordic Patrol", "armored"),
		("Aegean Cruiser", "standard"),
		("Atlantic Smuggler", "stealth"),
		("Titan Offshore", "speed"),
	]

	b = 0
	while len(data["boats"]) < TARGET_BOATS:
		base_name, btype = boat_bases[b % len(boat_bases)]
		tier = (b // len(boat_bases)) + 1
		full_name = f"{base_name} MK-{tier}"
		vid = unique_id(existing_ids, full_name, prefix="boat")
		rnd = random.Random(8000 + b)
		base_value = rnd.randint(45000, 2200000)
		countries = pick_countries(9000 + b, 2, 5)
		desc = "Snelle of zware boot voor maritieme smokkelroutes en risicovolle transportoperaties."
		data["boats"].append(
			create_vehicle_entry(
				"boat",
				vid,
				full_name,
				btype,
				base_value,
				{
					"speed": rnd.randint(28, 99),
					"armor": rnd.randint(10, 85),
					"cargo": rnd.randint(15, 100),
					"stealth": rnd.randint(10, 90),
				},
				countries,
				desc,
			)
		)
		b += 1

	# Fill motorcycles
	moto_families = [
		("Yamaha", ["MT-09", "R1", "Tracer 9", "XSR900"]),
		("Honda", ["CBR1000RR", "Africa Twin", "CB650R", "Fireblade"]),
		("Kawasaki", ["Ninja ZX-10R", "Z900", "Versys", "H2"]),
		("Suzuki", ["GSX-R1000", "Hayabusa", "V-Strom", "Katana"]),
		("Ducati", ["Panigale V4", "Monster", "Diavel", "Multistrada"]),
		("BMW", ["S1000RR", "R1250GS", "M1000R", "F900XR"]),
		("Triumph", ["Street Triple", "Speed Twin", "Tiger 900", "Rocket 3"]),
		("Aprilia", ["RSV4", "Tuono V4", "RS660", "Tuareg"]),
		("KTM", ["1290 Super Duke", "890 Duke", "Adventure", "RC 8C"]),
		("Harley-Davidson", ["Low Rider S", "Street Glide", "Sportster S", "Road King"]),
	]
	moto_trims = ["Urban", "Street", "Track", "Interceptor", "Ghost", "Carbon", "Raid", "Stealth"]

	m = 0
	while len(data["motorcycles"]) < TARGET_MOTORCYCLES:
		brand, models = moto_families[m % len(moto_families)]
		model = models[(m // len(moto_families)) % len(models)]
		trim = moto_trims[(m * 5) % len(moto_trims)]
		full_name = f"{brand} {model} {trim}".strip()
		vid = unique_id(existing_ids, full_name, prefix="moto")
		rnd = random.Random(12000 + m)
		base_value = rnd.randint(9000, 420000)
		vtype = ["speed", "stealth", "standard", "cargo"][m % 4]
		countries = pick_countries(13000 + m, 3, 6)
		desc = "Wendbare motorfiets voor snelle raids, discrete verplaatsingen en high-risk opdrachten in de stad."
		data["motorcycles"].append(
			create_vehicle_entry(
				"motorcycle",
				vid,
				full_name,
				vtype,
				base_value,
				{
					"speed": rnd.randint(55, 100),
					"armor": rnd.randint(3, 45),
					"cargo": rnd.randint(5, 40),
					"stealth": rnd.randint(20, 98),
				},
				countries,
				desc,
			)
		)
		m += 1

	# Add police event vehicles (future event hooks)
	def add_event_vehicle(collection_key: str, category: str, name: str, base_value: int):
		vid = unique_id(existing_ids, name, prefix="event")
		entry = create_vehicle_entry(
			category,
			vid,
			name,
			"armored" if category != "motorcycle" else "speed",
			base_value,
			{
				"speed": 82 if category == "motorcycle" else 74,
				"armor": 92 if category != "motorcycle" else 58,
				"cargo": 35 if category != "motorcycle" else 18,
				"stealth": 30,
			},
			["netherlands", "belgium", "germany", "france"],
			"Speciaal politievoertuig voor tijdelijke events. Normaal niet beschikbaar buiten eventvensters.",
		)
		entry["rarity"] = "legendary"
		entry["maxGameAvailability"] = 1
		entry["requiredRank"] = 50
		entry["eventOnly"] = True
		data[collection_key].append(entry)

	if not any(v.get("name") == "Politie Interceptor" for v in data["cars"]):
		add_event_vehicle("cars", "car", "Politie Interceptor", 350000)
	if not any(v.get("name") == "Politie Patrouilleboot" for v in data["boats"]):
		add_event_vehicle("boats", "boat", "Politie Patrouilleboot", 550000)
	if not any(v.get("name") == "Politie Motor" for v in data["motorcycles"]):
		add_event_vehicle("motorcycles", "motorcycle", "Politie Motor", 180000)

	data["cars"] = sorted(data["cars"], key=lambda x: x.get("baseValue", 0))
	data["boats"] = sorted(data["boats"], key=lambda x: x.get("baseValue", 0))
	data["motorcycles"] = sorted(data["motorcycles"], key=lambda x: x.get("baseValue", 0))

	VEHICLES_JSON.write_text(json.dumps(data, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")

	print("Catalog expanded:")
	print(f"- cars: {len(data['cars'])}")
	print(f"- boats: {len(data['boats'])}")
	print(f"- motorcycles: {len(data['motorcycles'])}")


if __name__ == "__main__":
	main()
