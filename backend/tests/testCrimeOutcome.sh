#!/bin/bash

# Crime Outcome System - Quick Test Script
# Tests all 6 crime scenarios via API calls
# Prerequisites:
#   - Backend running on localhost:3000
#   - Valid JWT token (update TOKEN variable)
#   - Player with vehicles and tools

set -e

# Configuration
API_BASE="http://localhost:3000"
PLAYER_ID=1  # Update this to your test player ID
CRIME_ID="robbery"  # Test with robbery crime
TOKEN="YOUR_JWT_TOKEN_HERE"  # Update with actual token

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}╔════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  Crime Outcome System - Test Suite        ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════╝${NC}"
echo ""

# Test 1: Get player's vehicles
echo -e "${YELLOW}📋 Fetching player vehicles...${NC}"
VEHICLES=$(curl -s -H "Authorization: Bearer $TOKEN" \
  "$API_BASE/garage/vehicles")

if echo "$VEHICLES" | grep -q "id"; then
  echo -e "${GREEN}✅ Vehicles found${NC}"
  echo "$VEHICLES" | jq '.[] | {id: .id, vehicleType: .vehicleType, condition: .condition, fuel: .fuel}'
else
  echo -e "${RED}❌ No vehicles found${NC}"
  exit 1
fi

VEHICLE_ID=$(echo "$VEHICLES" | jq -r '.[0].id')
echo -e "${YELLOW}Using vehicle ID: $VEHICLE_ID${NC}"
echo ""

# Test 2: Set vehicle as crime vehicle
echo -e "${YELLOW}🚗 Setting vehicle for crimes...${NC}"
curl -s -X POST -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d "{\"vehicleId\": $VEHICLE_ID}" \
  "$API_BASE/garage/crime-vehicle" | jq '.'

echo ""
echo -e "${YELLOW}🎯 Attempting crime...${NC}"
CRIME_RESULT=$(curl -s -X POST -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d "{\"crimeId\": \"$CRIME_ID\"}" \
  "$API_BASE/crimes/attempt")

echo -e "${BLUE}Crime Attempt Result:${NC}"
echo "$CRIME_RESULT" | jq '{
  outcome: .outcome,
  success: .success,
  reward: .reward,
  message: .outcomeMessage,
  vehicleConditionLoss: .vehicleConditionLoss,
  toolDamage: .toolDamageSustained
}'

OUTCOME=$(echo "$CRIME_RESULT" | jq -r '.outcome // "unknown"')

echo ""
echo -e "${BLUE}═══════════════════════════════════════════${NC}"
echo ""

case $OUTCOME in
  "success")
    echo -e "${GREEN}✅ SUCCESS - Crime completed successfully${NC}"
    ;;
  "caught")
    echo -e "${RED}🚨 CAUGHT - Arrested by police${NC}"
    ;;
  "out_of_fuel")
    echo -e "${YELLOW}⛽ OUT OF FUEL - Fled on foot, lost loot and vehicle${NC}"
    ;;
  "vehicle_breakdown_before")
    echo -e "${YELLOW}🔧 BREAKDOWN - Vehicle broke before reaching crime scene${NC}"
    ;;
  "vehicle_breakdown_during")
    echo -e "${YELLOW}🔧 BREAKDOWN - Vehicle broke during escape${NC}"
    ;;
  "tool_broke")
    echo -e "${YELLOW}🔨 TOOL BROKE - Tool failed, left evidence${NC}"
    ;;
  "fled_no_loot")
    echo -e "${YELLOW}💨 FLED - Escaped without loot${NC}"
    ;;
  *)
    echo -e "${RED}❓ UNKNOWN OUTCOME: $OUTCOME${NC}"
    ;;
esac

echo ""
echo -e "${BLUE}═══════════════════════════════════════════${NC}"
echo -e "${YELLOW}✨ Test completed!${NC}"
echo ""
echo -e "${YELLOW}To verify database changes, run:${NC}"
echo -e "${BLUE}SELECT * FROM crime_attempts WHERE playerId = $PLAYER_ID ORDER BY createdAt DESC LIMIT 1;${NC}"
echo ""
