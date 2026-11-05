# cap_training

SAP CAP (Node.js) training reference project for CPI developers, split into 5 sessions.
Each session is one git commit with a tag (`session-1` ... `session-5`).

> This is the **session-1** state. The full README (deployment, troubleshooting) grows with later sessions.

## Prerequisites

- Node.js 20 or later
- `@sap/cds-dk` (installed as a dev dependency here; optional global install: `npm i -g @sap/cds-dk`)
- Or: SAP BTP trial with a SAP Business Application Studio "Full Stack Cloud Application" dev space

## Run

```bash
npm install
npx cds watch
```

Open http://localhost:4004 - the index page lists all services and entities.

## Session 1 - Data model, sample data, basic service

| File | What it does |
|------|--------------|
| `db/schema.cds` | Entities `Vendors` and `Contacts` in namespace `training`, using `cuid` and `managed` aspects |
| `db/data/training-Vendors.csv` | Sample vendors (file name = `<namespace>-<Entity>.csv`, semicolon separated) |
| `db/data/training-Contacts.csv` | Sample contacts, linked by the `vendor_ID` foreign key column |
| `srv/service.cds` | `VendorService` exposing both entities as OData V4 at `/odata/v4/vendor/` |
| `test/vendor.http` | Sample requests (REST Client extension) |

Try:

- http://localhost:4004/odata/v4/vendor/Vendors
- http://localhost:4004/odata/v4/vendor/Vendors?$expand=contacts
