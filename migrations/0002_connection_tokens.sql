-- OAuth token storage for connection, and platform seed rows.

ALTER TABLE connection ADD COLUMN access_token TEXT;
ALTER TABLE connection ADD COLUMN refresh_token TEXT;
ALTER TABLE connection ADD COLUMN token_expires_at TEXT;

INSERT OR IGNORE INTO platform (id, kind) VALUES
  ('shopify', 'shopify'),
  ('etsy', 'etsy');
