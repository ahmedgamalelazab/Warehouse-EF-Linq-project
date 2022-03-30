using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Warehouse_items_Storage
{
    public class BandkingOrderItem
    {
        public int ItemID { get; set; }
        public string Name { get; set; }
        public string UnitPrice { get; set; }
        public string AvailableQuantity { get; set; }
        public string RequiredQantity { get; set; }
        public DateTime ProductionDate { get; set; }
        public DateTime ExpireDate { get; set; }
    }

    //TODO : on any permission create list of this GeneralPurposeItem
    public class GeneralPurposeItem
    {
        public string Name { get; set; }
        public string MeasureUnit { get; set; }
        public int PricePerUinit { get; set; }
        //public int WarehouseID { get; set; }
        public int Quantity { get; set; }
        public DateTime ProductionDate { get; set; }
        public DateTime ExpireDate { get; set; }
    }


    public class SupplyPermissionFormHandler
    {

        public int WarehouseID { get; set; }
        public int SupplierID { get; set; }
        public List<GeneralPurposeItem>Items = new List<GeneralPurposeItem>();

    }
}
