@echo off
echo Running heist tests with jail cleanup...
echo.

REM Clear jail before tests
echo Clearing jail records...
call npx tsx clear-jail.ts
echo.

REM Run tests
echo Running heist tests...
node test-heists.js

echo.
echo Test run complete!
