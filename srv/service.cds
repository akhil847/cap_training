// ---------------------------------------------------------------------------
// Session 1 - Service definition
//
// A service exposes entities as an API. CAP serves it as OData V4 at:
//   /odata/v4/vendor/   (service name "VendorService" -> path "vendor")
//
// Session 2 - Actions, functions and a read-only view
//   The custom logic lives in srv/service.js (same file name as this file!).
// ---------------------------------------------------------------------------
using { training } from '../db/schema';

service VendorService {
  // A projection is like a view: it exposes the DB entity through the API.
  // Later we can hide fields, rename them, or filter rows here.
  entity Vendors  as projection on training.Vendors actions {
    // Bound action: called on ONE vendor instance.
    // POST /odata/v4/vendor/Vendors(<ID>)/VendorService.activate   body: {}
    // Actions change data (like a POST); functions only read (like a GET).
    action activate() returns Vendors;
  };

  entity Contacts as projection on training.Contacts;

  // Read-only filtered view: only vendors with status 'Active'.
  // @readonly blocks CREATE / UPDATE / DELETE on this entity set.
  // @cds.redirection.target: false -> we now have TWO projections on
  // training.Vendors. This tells CAP that associations pointing to Vendors
  // (e.g. Contacts.vendor) must keep using "Vendors", not this view.
  // Without it, cds stops with "Add @cds.redirection.target ...".
  // "excluding { contacts }" keeps this view flat (no composition to expand).
  @readonly
  @cds.redirection.target: false
  entity ActiveVendors as projection on training.Vendors excluding { contacts }
    where status = 'Active';

  // Unbound function: not tied to an entity instance.
  // GET /odata/v4/vendor/vendorCount()
  function vendorCount() returns Integer;
}
