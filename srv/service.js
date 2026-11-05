// ---------------------------------------------------------------------------
// Session 2 - Custom logic for VendorService
//
// IMPORTANT: this file must have the SAME name as srv/service.cds.
// CAP finds service.js next to service.cds and uses it as the implementation.
//
// Handler phases (think of CPI: steps before / during / after the main call):
//   before -> validate or enrich the request
//   on     -> do the actual work (replace the default behaviour)
//   after  -> change the result before it goes back to the caller
// ---------------------------------------------------------------------------
const cds = require('@sap/cds');

class VendorService extends cds.ApplicationService {
  init() {
    // Entity definitions of THIS service (VendorService.Vendors etc.)
    const { Vendors } = this.entities;

    // --- before CREATE: validation + default values -----------------------
    this.before('CREATE', Vendors, (req) => {
      // req.data = the JSON body sent by the caller
      if (!req.data.name) {
        // Stops the request and returns HTTP 400 to the caller
        return req.error(400, 'Vendor name is required');
      }
      // Default status for new vendors
      if (!req.data.status) req.data.status = 'Pending';
    });

    // --- on activate: bound action implementation --------------------------
    this.on('activate', Vendors, async (req) => {
      // req.subject = a reference to the vendor the action was called on,
      // e.g. Vendors(a1b2c3d4-0000-0000-0000-000000000001)
      // Do not forget "await" - DB calls are asynchronous!
      await UPDATE(req.subject).with({ status: 'Active' });

      // Return the updated vendor as the action result
      return SELECT.one.from(req.subject);
    });

    // --- on vendorCount: unbound function implementation -------------------
    this.on('vendorCount', async () => {
      const { count } = await SELECT.one`count(*) as count`.from(Vendors);
      return count;
    });

    // --- after READ: modify the result (demo only!) ------------------------
    // Shows how to post-process data. In a real app you would NOT change
    // a stored value like this - you would add a separate (virtual) field.
    this.after('READ', Vendors, (result) => {
      // result is an array for a list read, or one object for a single read.
      // Note: with $select=name the result has no "status", so nothing is appended.
      const vendors = Array.isArray(result) ? result : [result];
      for (const vendor of vendors) {
        if (vendor?.status === 'Pending' && vendor.name) {
          vendor.name += ' (pending)';
        }
      }
    });

    // Always call super.init() at the end so CAP registers its default handlers
    return super.init();
  }
}

module.exports = VendorService;
