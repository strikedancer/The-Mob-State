export interface Crime {
  id: string;
  name: string;
  description: string;
  minLevel: number;
  baseSuccessChance: number;
  minReward: number;
  maxReward: number;
  xpReward: number;
  minXpReward?: number;
  maxXpReward?: number;
  jailTime: number;
  requiresVehicle?: boolean;
  breakdownChance?: number;
  isFederal?: boolean;
  requiresWeapon?: boolean;
  suitableWeaponTypes?: string[];
  minDamage?: number;
  minIntimidation?: number;
  requiredTools?: string[];
  requiredDrugs?: string[];
  minDrugQuantity?: number;
}
