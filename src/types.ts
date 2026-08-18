// Shared core concepts (spec §6). Platform adapters and apps depend on these
// types; keep this file limited to the nine concepts until a second app
// proves the need for more.

export type PlatformKind = "shopify" | "etsy" | "bigcommerce" | "wix" | "woocommerce";

export type VerificationState =
  | "verified"
  | "partially_verified"
  | "unable_to_verify"
  | "stale"
  | "error";

export type DiscrepancySeverity = "critical" | "warning" | "informational";

export type DiscrepancyType = "presence" | "quantity" | "price";

export interface Merchant {
  id: string;
  email: string;
  plan_tier: string;
  status: "trial" | "active" | "past_due" | "cancelled";
  created_at: string;
}

export interface Platform {
  id: string;
  kind: PlatformKind;
}

export interface Connection {
  id: string;
  merchant_id: string;
  platform_id: string;
  external_shop_id: string;
  status: "active" | "needs_reauth" | "disconnected";
  access_token: string | null;
  refresh_token: string | null;
  token_expires_at: string | null;
  last_verified_at: string | null;
  created_at: string;
}

export interface Product {
  id: string;
  connection_id: string;
  external_product_id: string;
  title: string;
  updated_at: string;
}

export interface Variant {
  id: string;
  product_id: string;
  external_variant_id: string;
  sku: string | null;
  price: number | null;
  quantity: number | null;
  updated_at: string;
}

export interface Observation {
  id: string;
  variant_id: string;
  verification_state: VerificationState;
  observed_price: number | null;
  observed_quantity: number | null;
  observed_at: string;
}

export interface Discrepancy {
  id: string;
  merchant_id: string;
  type: DiscrepancyType;
  severity: DiscrepancySeverity;
  variant_a_observation_id: string;
  variant_b_observation_id: string | null;
  detected_at: string;
  resolved_at: string | null;
}

export interface Alert {
  id: string;
  discrepancy_id: string;
  merchant_id: string;
  channel: "email" | "dashboard";
  sent_at: string | null;
  acknowledged_at: string | null;
}

export interface Subscription {
  id: string;
  merchant_id: string;
  platform_charge_id: string | null;
  plan_tier: string;
  status: "active" | "past_due" | "cancelled";
  current_period_end: string | null;
}
