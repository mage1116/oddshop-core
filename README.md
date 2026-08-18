# oddshop-core

Shared core for the Odd Shop app pipeline (build spec v3, §6). Nine concepts
only — Merchant, Platform, Connection, Product, Variant, Observation,
Discrepancy, Alert, Subscription — shared across all platform apps via thin
adapters. Do not add concepts here until a second app proves the need.

- `src/types.ts` — shared TypeScript types
- `migrations/` — D1 schema
- `wrangler.toml` — Worker + D1 bindings (production and `staging` env)

## Deploy

```
npx wrangler deploy
npx wrangler deploy --env staging
```

## Migrate

```
npx wrangler d1 execute oddshop-core-db --remote --file=migrations/0001_init.sql
npx wrangler d1 execute oddshop-core-db-staging --remote --file=migrations/0001_init.sql
```
