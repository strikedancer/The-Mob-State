import prisma from './src/lib/prisma';
import { getCountryById } from './src/services/travelService';

async function testCountryLookup() {
  console.log('Testing country lookup...\n');
  
  const testCountries = ['turkey', 'china', 'germany', 'netherlands', 'australia'];
  
  for (const countryId of testCountries) {
    const country = getCountryById(countryId);
    if (country) {
      console.log(`✅ ${countryId} -> ${country.name} (${country.id})`);
    } else {
      console.log(`❌ ${countryId} -> NOT FOUND`);
    }
  }
  
  await prisma.$disconnect();
}

testCountryLookup();
