CREATE TABLE IF NOT EXISTS advanced_trucking_profiles (
  identifier VARCHAR(80) PRIMARY KEY,
  name VARCHAR(80) NOT NULL,
  xp INT NOT NULL DEFAULT 0,
  level INT NOT NULL DEFAULT 1,
  reputation INT NOT NULL DEFAULT 50,
  completed_deliveries INT NOT NULL DEFAULT 0,
  failed_deliveries INT NOT NULL DEFAULT 0,
  perfect_deliveries INT NOT NULL DEFAULT 0,
  total_earnings BIGINT NOT NULL DEFAULT 0,
  weekly_earnings BIGINT NOT NULL DEFAULT 0,
  total_distance FLOAT NOT NULL DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
CREATE TABLE IF NOT EXISTS advanced_trucking_history (
  id INT AUTO_INCREMENT PRIMARY KEY,
  identifier VARCHAR(80) NOT NULL,
  contract_id VARCHAR(80) NOT NULL,
  cargo_type VARCHAR(80),
  pickup_label VARCHAR(120),
  delivery_label VARCHAR(120),
  distance FLOAT DEFAULT 0,
  payment INT DEFAULT 0,
  xp INT DEFAULT 0,
  reputation_change INT DEFAULT 0,
  vehicle_damage FLOAT DEFAULT 0,
  trailer_damage FLOAT DEFAULT 0,
  cargo_damage FLOAT DEFAULT 0,
  completed TINYINT(1) DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE IF NOT EXISTS advanced_trucking_licenses (
  id INT AUTO_INCREMENT PRIMARY KEY,
  identifier VARCHAR(80) NOT NULL,
  license VARCHAR(80) NOT NULL,
  granted_by VARCHAR(80),
  granted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY uniq_license (identifier, license)
);
CREATE TABLE IF NOT EXISTS advanced_trucking_missions (
  id INT AUTO_INCREMENT PRIMARY KEY,
  identifier VARCHAR(80) NOT NULL,
  mission_id VARCHAR(80) NOT NULL,
  mission_type VARCHAR(30) NOT NULL,
  progress INT DEFAULT 0,
  completed TINYINT(1) DEFAULT 0,
  claimed TINYINT(1) DEFAULT 0,
  reset_period VARCHAR(20) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
