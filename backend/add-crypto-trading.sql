-- Crypto Trading System
-- Creates market, holdings, transaction, and history tables.

CREATE TABLE IF NOT EXISTS crypto_assets (
  id INT AUTO_INCREMENT PRIMARY KEY,
  symbol VARCHAR(12) NOT NULL UNIQUE,
  name VARCHAR(80) NOT NULL,
  base_price DECIMAL(24,8) NOT NULL,
  current_price DECIMAL(24,8) NOT NULL,
  volatility DECIMAL(10,4) NOT NULL,
  trend_bias DECIMAL(10,4) NOT NULL DEFAULT 0,
  icon_key VARCHAR(50) NOT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_crypto_assets_symbol (symbol),
  INDEX idx_crypto_assets_updated_at (updated_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS crypto_holdings (
  id INT AUTO_INCREMENT PRIMARY KEY,
  player_id INT NOT NULL,
  asset_symbol VARCHAR(12) NOT NULL,
  quantity DECIMAL(24,8) NOT NULL DEFAULT 0,
  avg_buy_price DECIMAL(24,8) NOT NULL DEFAULT 0,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY uniq_crypto_holdings_player_asset (player_id, asset_symbol),
  INDEX idx_crypto_holdings_player (player_id),
  INDEX idx_crypto_holdings_symbol (asset_symbol),
  CONSTRAINT fk_crypto_holdings_player FOREIGN KEY (player_id) REFERENCES players(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS crypto_transactions (
  id INT AUTO_INCREMENT PRIMARY KEY,
  player_id INT NOT NULL,
  asset_symbol VARCHAR(12) NOT NULL,
  side VARCHAR(8) NOT NULL,
  quantity DECIMAL(24,8) NOT NULL,
  price DECIMAL(24,8) NOT NULL,
  total_value DECIMAL(24,8) NOT NULL,
  realized_profit DECIMAL(24,8) NOT NULL DEFAULT 0,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_crypto_transactions_player (player_id),
  INDEX idx_crypto_transactions_symbol (asset_symbol),
  INDEX idx_crypto_transactions_created_at (created_at),
  CONSTRAINT fk_crypto_transactions_player FOREIGN KEY (player_id) REFERENCES players(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS crypto_price_history (
  id INT AUTO_INCREMENT PRIMARY KEY,
  asset_symbol VARCHAR(12) NOT NULL,
  price DECIMAL(24,8) NOT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_crypto_price_history_symbol_time (asset_symbol, created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
