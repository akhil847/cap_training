// ---------------------------------------------------------------------------
// Session 1 - Data model
//
// This file defines the database tables (entities) for our training app.
// CAP turns every entity into a table: training.Vendors -> table training_Vendors
// ---------------------------------------------------------------------------
namespace training;

// Reusable aspects from SAP:
//  - cuid    : adds a key field "ID" of type UUID (generated automatically)
//  - managed : adds createdAt, createdBy, modifiedAt, modifiedBy (filled automatically)
using { cuid, managed } from '@sap/cds/common';

// A supplier/vendor we do business with
entity Vendors : cuid, managed {
  name     : String(100);
  country  : String(3);    // ISO country code, e.g. DE, US, IN
  status   : String(20);   // Active / Pending / Inactive
  website  : String(200);

  // Composition = the vendor "owns" its contacts.
  // Deleting a vendor deletes its contacts too (deep delete).
  // The ON condition links Contacts.vendor back to this vendor.
  contacts : Composition of many Contacts on contacts.vendor = $self;
}

// A contact person at a vendor
entity Contacts : cuid {
  // Association = a foreign key. CAP creates a column "vendor_ID" in the table.
  vendor : Association to Vendors;
  name   : String(100);
  email  : String(100);
}
