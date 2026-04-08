@echo off
echo Testing Crime-Weapon Integration
echo.

REM Test 1: Try crime without weapon (should fail)
echo Test 1: Attempting crime without weapon...
curl -X POST http://localhost:3000/crimes/attempt ^
  -H "Content-Type: application/json" ^
  -d "{\"crimeId\":\"mug_person\"}" ^
  -H "Authorization: Bearer TESTTOKEN"
echo.
echo.

REM The rest of tests would require:
REM - Creating a test player
REM - Getting auth token
REM - Buying weapon and ammo
REM - Attempting crime with weapon
REM - Checking weapon degradation

echo.
echo Manual testing required - use existing test player with weapons
pause
