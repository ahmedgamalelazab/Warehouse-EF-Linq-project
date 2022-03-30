using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace Warehouse_items_Storage
{
    public partial class itemControlPage : UserControl
    {

        LINQ_EF_PROJECTEntities db = new LINQ_EF_PROJECTEntities();

        public itemControlPage()
        {
            InitializeComponent();

            dataGridView1.DataSource = db.
                Warehouses.Select((warehouse) => new {
                    warehouse.id,
                    warehouse.name,
                    warehouse.address,
                    items = warehouse.Items.Count,
                    warehouse.WarehouseKeeperID,                    
                    supplyPermissions = warehouse.SupplyPermissions.Count,
                    exchangePermissions = warehouse.ExchangePermissions.Count,
                    wareHouseKeeperName = warehouse.WarehouseKeeper.name
                }).ToList();
        }

        private void dataGridView1_CellClick(object sender, DataGridViewCellEventArgs e)
        {
            //when u clinic on any cell 
            //MessageBox.Show(dataGridView1.Rows[e.RowIndex].Cells[0].Value.ToString());
            try
            {
                int warehouseID = int.Parse(dataGridView1.Rows[e.RowIndex].Cells[0].Value.ToString());

                dataGridView2.DataSource = db.Items.Where((item) =>
                     item.WarehouseID == warehouseID)
                    .Select((i) => new
                    {
                        i.id,
                        i.name,
                        i.MeasureUnit,
                        i.PricePerUnit,
                        quantity = i.SupplyPermissionItems.FirstOrDefault((si)=>si.ItemID == i.id).Quantity,
                        warehouseName = i.Warehouse.name,
                        i.WarehouseID,
                        SupplypermissionID = i.SupplyPermissionItems
                        .FirstOrDefault((si)=>si.ItemID == i.id).SupplyPermissionID,                        
                        supplierName = i.SupplyPermissionItems.FirstOrDefault((si) => si.ItemID == i.id).SupplyPermission.Supplier.name,
                    }).ToList();

            }catch(Exception ex)
            {
                MessageBox.Show(ex.Message);
            }

        }
    }
}
