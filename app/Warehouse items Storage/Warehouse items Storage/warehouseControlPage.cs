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
    public partial class warehouseControlPage : UserControl
    {
        LINQ_EF_PROJECTEntities dbLoad = new LINQ_EF_PROJECTEntities();

        public warehouseControlPage()
        {
            InitializeComponent();
          
          
        }

        private void warehouseControlPage_Load(object sender, EventArgs e)
        {
            dataGridView1.DataSource = dbLoad.Warehouses.Select((warehouse)=> new { warehouse.id,
                warehouse.name,
                warehouse.address,
                items = warehouse.Items.Count,
                warehouse.WarehouseKeeperID,                
                supplyPermissions = warehouse.SupplyPermissions.Count,
                exchangePermissions = warehouse.ExchangePermissions.Count,
                wareHouseKeeperName=warehouse.WarehouseKeeper.name }            
            ).ToList();

            dataGridView2.DataSource = dbLoad.WarehouseKeepers.ToList();
        }

        private void warehouseAddBTN_Click(object sender, EventArgs e)
        {
            warehouseConrolForm warehouseForm = new warehouseConrolForm(dbLoad , this);
            warehouseForm.ShowDialog();
        }

        //TODO implement after clinic on each item dispaly item form detail
    }
}
