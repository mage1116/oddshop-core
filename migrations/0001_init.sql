-- Shared core schema (spec §6): Merchant, Platform, Connection, Product,
-- Variant, Observation, Discrepancy, Alert, Subscription.

CREATE TABLE merchant (
  id TEXT PRIMARY KEY,
  email TEXT NOT NULL UNIQUE,
  plan_tier TEXT NOT NULL DEFAULT 'trial',
  status TEXT NOT NULL DEFAULT 'trial' CHECK (status IN ('trial', 'active', 'past_due', 'cancelled')),
  created_at TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE TABLE platform (
  id TEXT PRIMARY KEY,
  kind TEXT NOT NULL UNIQUE CHECK (kind IN ('shopify', 'etsy', 'bigcommerce', 'wix', 'woocommerce'))
);

CREATE TABLE connection (
  id TEXT PRIMARY KEY,
  merchant_id TEXT NOT NULL REFERENCES merchant(id),
  platform_id TEXT NOT NULL REFERENCES platform(id),
  external_shop_id TEXT NOT NULL,
  status TEXT NOT NULL DEFAULT 'active' CHECK (status IN ('active', 'needs_reauth', 'disconnected')),
  last_verified_at TEXT,
  created_at TEXT NOT NULL DEFAULT (datetime('now')),
  UNIQUE (platform_id, external_shop_id)
);
CREATE INDEX idx_connection_merchant ON connection(merchant_id);

CREATE TABLE product (
  id TEXT PRIMARY KEY,
  connection_id TEXT NOT NULL REFERENCES connection(id),
  external_product_id TEXT NOT NULL,
  title TEXT NOT NULL,
  updated_at TEXT NOT NULL DEFAULT (datetime('now')),
  UNIQUE (connection_id, external_product_id)
);
CREATE INDEX idx_product_connection ON product(connection_id);

CREATE TABLE variant (
  id TEXT PRIMARY KEY,
  product_id TEXT NOT NULL REFERENCES product(id),
  external_variant_id TEXT NOT NULL,
  sku TEXT,
  price REAL,
  quantity INTEGER,
  updated_at TEXT NOT NULL DEFAULT (datetime('now')),
  UNIQUE (product_id, external_variant_id)
);
CREATE INDEX idx_variant_product ON variant(product_id);
CREATE INDEX idx_variant_sku ON variant(sku);

CREATE TABLE observation (
  id TEXT PRIMARY KEY,
  variant_id TEXT NOT NULL REFERENCES variant(id),
  verification_state TEXT NOT NULL CHECK (
    verification_state IN ('verified', 'partially_verified', 'unable_to_verify', 'stale', 'error')
  ),
  observed_price REAL,
  observed_quantity INTEGER,
  observed_at TEXT NOT NULL DEFAULT (datetime('now'))
);
CREATE INDEX idx_observation_variant ON observation(variant_id, observed_at);

CREATE TABLE discrepancy (
  id TEXT PRIMARY KEY,
  merchant_id TEXT NOT NULL REFERENCES merchant(id),
  type TEXT NOT NULL CHECK (type IN ('presence', 'quantity', 'price')),
  severity TEXT NOT NULL CHECK (severity IN ('critical', 'warning', 'informational')),
  variant_a_observation_id TEXT NOT NULL REFERENCES observation(id),
  variant_b_observation_id TEXT REFERENCES observation(id),
  detected_at TEXT NOT NULL DEFAULT (datetime('now')),
  resolved_at TEXT
);
CREATE INDEX idx_discrepancy_merchant ON discrepancy(merchant_id, resolved_at);

CREATE TABLE alert (
  id TEXT PRIMARY KEY,
  discrepancy_id TEXT NOT NULL REFERENCES discrepancy(id),
  merchant_id TEXT NOT NULL REFERENCES merchant(id),
  channel TEXT NOT NULL CHECK (channel IN ('email', 'dashboard')),
  sent_at TEXT,
  acknowledged_at TEXT
);
CREATE INDEX idx_alert_merchant ON alert(merchant_id);

CREATE TABLE subscription (
  id TEXT PRIMARY KEY,
  merchant_id TEXT NOT NULL REFERENCES merchant(id),
  platform_charge_id TEXT,
  plan_tier TEXT NOT NULL,
  status TEXT NOT NULL DEFAULT 'active' CHECK (status IN ('active', 'past_due', 'cancelled')),
  current_period_end TEXT
);
CREATE INDEX idx_subscription_merchant ON subscription(merchant_id);
