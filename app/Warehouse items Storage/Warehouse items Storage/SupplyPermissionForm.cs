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
    public partial class SupplyPermissionForm : Form
    {

        SupplyPermissionFormHandler supplyFormHandler = new SupplyPermissionFormHandler();

        LINQ_EF_PROJECTEntities db = new LINQ_EF_PROJECTEntities();
        public SupplyPermissionForm()
        {
            InitializeComponent();
            comboBox1.DataSource = db.Warehouses.Select((w) => w.id).ToList();
            comboBox2.DataSource = db.Suppliers.Select((s) => s.id).ToList();
            dataGridView1.DataSource = supplyFormHandler.Items.ToList();
        }

        private void comboBox1_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {

                int wareHouseID = int.Parse(comboBox1.SelectedItem.ToString());

                var warehouse = db.Warehouses.SingleOrDefault((wr) => wr.id == wareHouseID);

                warehouseNameTXT.Text = warehouse.name;

            }catch(Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
        }

        private void comboBox2_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {

                int supplierID = int.Parse(comboBox2.SelectedItem.ToString());

                var supplier = db.Suppliers.SingleOrDefault((sp) => sp.id == supplierID);

                supplierNameTXT.Text = supplier.name;

            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
        }

        private void button1_Click(object sender, EventArgs e)
        {
            //send this object to the form             
            GeneralPurposeItemForm generalPurposeItemForm = new GeneralPurposeItemForm(supplyFormHandler);
            generalPurposeItemForm.ShowDialog(); //blokcing thread // we can use it
            //updating the table            
            this.dataGridView1.DataSource = supplyFormHandler.Items.ToList(); 

        }

        private void button4_Click(object sender, EventArgs e)
        {
            //on save i need to do the following 
            //create supply permission  and fill supply permission
            SupplyPermission newSupplyPermission = new SupplyPermission()
            {
                WarehouseID = int.Parse(comboBox1.SelectedItem.ToString()),
                SupplierID = int.Parse(comboBox2.SelectedItem.ToString()),
                CreatedAt = DateTime.Now,
                updatedAt = DateTime.Now,
                confirmed = 0

            };
            db.SupplyPermissions.Add(newSupplyPermission);
            //db.SaveChanges();
            //loop on the items in the table and add item and add supplyPermissionItems 
            //SupplyPermissionItem supplyPermissionItem = new SupplyPermissionItem();            

            supplyFormHandler.Items.ForEach((item) =>
            {
                var newItem = new Item()
                {
                    name = item.Name,
                    MeasureUnit = item.MeasureUnit,
                    PricePerUnit = item.PricePerUinit

                };
                db.Items.Add(newItem);
                db.SaveChanges();
                db.SupplyPermissionItems.Add(new SupplyPermissionItem()
                {
                    ItemID = db.Items.OrderByDescending((i)=>i.id).FirstOrDefault().id,
                    SupplyPermissionID = db.SupplyPermissions.OrderByDescending((i) => i.id).FirstOrDefault().id,
                    Quantity = item.Quantity,
                    ProducationDate = item.ProductionDate,
                    ExpireDate = item.ExpireDate
                });
                db.SaveChanges();
            });

            //if all are ok 
            MessageBox.Show("عمليه ناجحة");
            this.Close();

        }
    }
}
