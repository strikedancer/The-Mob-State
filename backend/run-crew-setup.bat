@echo off
echo Setting up Crew tables...
cd /d %~dp0

echo Running crew setup...
call npx ts-node -r dotenv/config setup-crews.ts

echo Regenerating Prisma client...
call npx prisma generate

echo Running type check...
call npm run check

echo.
echo ✅ Setup complete!
echo.
echo Now run: npm run dev
echo Then in another terminal: node test-crews.js
pause
