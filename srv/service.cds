// ---------------------------------------------------------------------------
// Session 1 - Service definition
//
// A service exposes entities as an API. CAP serves it as OData V4 at:
//   /odata/v4/vendor/   (service name "VendorService" -> path "vendor")
// ---------------------------------------------------------------------------
using { training } from '../db/schema';

service VendorService {
  // A projection is like a view: it exposes the DB entity through the API.
  // Later we can hide fields, rename them, or filter rows here.
  entity Vendors  as projection on training.Vendors;
  entity Contacts as projection on training.Contacts;
}
