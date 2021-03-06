//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace Warehouse_items_Storage
{
    using System;
    using System.Collections.Generic;
    
    public partial class ExchangePermission
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public ExchangePermission()
        {
            this.ExchangePermissionItems = new HashSet<ExchangePermissionItem>();
        }
    
        public int id { get; set; }
        public int SourceWarehouseID { get; set; }
        public int DestinationWarehouseID { get; set; }
        public int SupplierID { get; set; }
        public Nullable<System.DateTime> createdAt { get; set; }
        public Nullable<System.DateTime> updatedAt { get; set; }
        public Nullable<int> confirmed { get; set; }
    
        public virtual Warehouse Warehouse { get; set; }
        public virtual Warehouse Warehouse1 { get; set; }
        public virtual Supplier Supplier { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<ExchangePermissionItem> ExchangePermissionItems { get; set; }
    }
}
