/** Score units for active `trade` category game events (Contraband Rush). */

export function scoreTradeSellContribution(
  realizedProfit: number,
  totalEarnings: number
): number {
  if (totalEarnings <= 0 && realizedProfit <= 0) {
    return 0;
  }
  const profitPts = Math.floor(Math.max(0, realizedProfit) / 200);
  const volumePts = Math.floor(Math.max(0, totalEarnings) / 1000);
  if (realizedProfit > 0) {
    return Math.max(1, profitPts + volumePts);
  }
  return Math.max(1, volumePts);
}

export function scoreTradeSmuggleClaim(quantity: number): number {
  return Math.max(1, Math.floor(Math.max(0, quantity)));
}
