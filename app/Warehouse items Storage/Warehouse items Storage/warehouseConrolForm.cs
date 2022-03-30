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
    public partial class warehouseConrolForm : Form
    {
        private LINQ_EF_PROJECTEntities dbRef;

        private warehouseControlPage wareHouseControlPageRef;

        public warehouseConrolForm()
        {
            InitializeComponent();
        }

        public warehouseConrolForm(LINQ_EF_PROJECTEntities dbRef , warehouseControlPage wareHouseControlPage)
        {
            InitializeComponent();
            this.dbRef = dbRef;
            this.wareHouseControlPageRef = wareHouseControlPage;
        }

        private void warehouseConrolForm_Load(object sender, EventArgs e)
        {
            dataGridView1.DataSource = dbRef.WarehouseKeepers
                .Select((emp) => new { emp.id, emp.name, emp.salary, emp.Warehouses.Count })
                .ToList();
        }

        private void dataGridView1_CellClick(object sender, DataGridViewCellEventArgs e)
        {
            if (e.RowIndex >=0 && e.ColumnIndex == 0)
            {
                warehouseKeeperIDTXT.Text = dataGridView1.Rows[e.RowIndex]
               .Cells[e.ColumnIndex]
               .Value.ToString();
            }
        }

        private void formAddWarehouseBTN_Click(object sender, EventArgs e)
        {
            string warehouseAddress = warehouseAddressTXT.Text;
            string warehouseName = warehouseNameTXT.Text;
            string warehouseKeeperID = warehouseKeeperIDTXT.Text;
            if (warehouseName != string.Empty &&
                warehouseAddress != string.Empty &&
                warehouseKeeperID != string.Empty)
            {
                try
                {
                    int parsedWareHouseKeeperID = int.Parse(warehouseKeeperID);
                    Warehouse warehouse = new Warehouse() { name = warehouseName, address = warehouseAddress, WarehouseKeeperID = parsedWareHouseKeeperID };
                    dbRef.Warehouses.Add(warehouse);
                    dbRef.SaveChanges();
                    //if all are ok 
                    this.wareHouseControlPageRef.dataGridView1.DataSource = dbRef.Warehouses.Select((updatedWarehouse) => new {
                        updatedWarehouse.id,
                        updatedWarehouse.name,
                        updatedWarehouse.address,
                        items = updatedWarehouse.Items.Count,
                        updatedWarehouse.WarehouseKeeperID,                        
                        supplyPermissions = updatedWarehouse.SupplyPermissions.Count,
                        exchangePermissions = updatedWarehouse.ExchangePermissions.Count,
                        wareHouseKeeperName = updatedWarehouse.WarehouseKeeper.name
                    }).ToList();
                    MessageBox.Show("عملية ناجحة");
                }
                catch(Exception ex)
                {
                    MessageBox.Show("يجب ان يكون خانة المسئول رقم لاتمام العمليه");
                }
            }
            else
            {
                MessageBox.Show("من فضلك اكمل النموذج لتسجيل مخزن");
            }
        }

        private void dataGridView1_RowsAdded(object sender, DataGridViewRowsAddedEventArgs e)
        {

        }
    }
}
