export {};

declare global {
  namespace Express {
    interface Request {
      player?: {
        id: number;
        username: string;
        rank: number;
        health: number;
        currentCountry: string;
        role?: string;
      };
      user?: {
        id: number;
        username?: string;
        role?: string;
      };
    }
  }

  function parseInt(string: string | string[], radix?: number): number;
}
