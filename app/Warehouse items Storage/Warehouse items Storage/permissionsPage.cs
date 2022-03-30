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
    public partial class permissionsPage : UserControl
    {
        LINQ_EF_PROJECTEntities db = new LINQ_EF_PROJECTEntities();
        public permissionsPage()
        {
            InitializeComponent();
            //// supply permission projection 
            dataGridView1.DataSource = db
                .SupplyPermissions.Select((sp) => new { sp.id,
                    sp.WarehouseID,
                    confirmed = sp.confirmed == 1 ? "yes" : "No",
                    warehouseName = sp.Warehouse.name,
                    sp.SupplierID,
                    supplierName = sp.Supplier.name })
                .ToList();
            //////
            ///Banking order permission 
            dataGridView2.DataSource = db
                .BankingOrders.Select((bo) => new {
                     bo.id,
                    confirmed = bo.confirmed == 1 ? "yes" : "No",
                    bo.totalMonery,
                     bo.Client.name
                 })
                .ToList();
            ///exchanging permissions 
            dataGridView3.DataSource= db
                .ExchangePermissions.Select((exchangePermission) => new {
                    exchangePermission.id,
                    exchangePermission.SourceWarehouseID,
                    exchangePermission.DestinationWarehouseID,                    
                    exchangePermission.SupplierID,
                    supplierName = exchangePermission.Supplier.name
                })
                .ToList();

        }

        private void tableLayoutPanel2_MouseHover(object sender, EventArgs e)
        {

            this.tableLayoutPanel2.BackColor = Color.Orange;
            this.tableLayoutPanel2.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(217)))), ((int)(((byte)(81)))), ((int)(((byte)(94)))));


        }

        private void tableLayoutPanel2_MouseLeave(object sender, EventArgs e)
        {
            this.tableLayoutPanel2.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(20)))), ((int)(((byte)(17)))), ((int)(((byte)(11)))));
            this.tableLayoutPanel2.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(217)))), ((int)(((byte)(81)))), ((int)(((byte)(94)))));
        }

        private void tableLayoutPanel3_MouseHover(object sender, EventArgs e)
        {
            this.tableLayoutPanel3.BackColor = Color.Orange;
            this.tableLayoutPanel3.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(217)))), ((int)(((byte)(81)))), ((int)(((byte)(94)))));
        }

        private void tableLayoutPanel3_MouseLeave(object sender, EventArgs e)
        {
            this.tableLayoutPanel3.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(20)))), ((int)(((byte)(17)))), ((int)(((byte)(11)))));
            this.tableLayoutPanel3.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(217)))), ((int)(((byte)(81)))), ((int)(((byte)(94)))));
        }

        private void tableLayoutPanel4_MouseHover(object sender, EventArgs e)
        {
            this.tableLayoutPanel4.BackColor = Color.Orange;
            this.tableLayoutPanel4.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(217)))), ((int)(((byte)(81)))), ((int)(((byte)(94)))));
        }

        private void tableLayoutPanel4_MouseLeave(object sender, EventArgs e)
        {
            this.tableLayoutPanel4.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(20)))), ((int)(((byte)(17)))), ((int)(((byte)(11)))));
            this.tableLayoutPanel4.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(217)))), ((int)(((byte)(81)))), ((int)(((byte)(94)))));
        }

        private void tableLayoutPanel2_Click(object sender, EventArgs e)
        {
            SupplyPermissionForm supplyPermissionForm = new SupplyPermissionForm();
            supplyPermissionForm.ShowDialog();
            //// supply permission projection 
            dataGridView1.DataSource = db
                .SupplyPermissions.Select((sp) => new {
                    sp.id,
                    confirmed = sp.confirmed == 1 ? "yes" : "No",
                    sp.WarehouseID,
                    warehouseName = sp.Warehouse.name,
                    sp.SupplierID,
                    supplierName = sp.Supplier.name
                })
                .ToList();

        }

        private void tableLayoutPanel3_Click(object sender, EventArgs e)
        {
            BandkingOrderPermission bankingOrderPermissionForm = new BandkingOrderPermission();
            bankingOrderPermissionForm.ShowDialog();
            dataGridView2.DataSource = db
               .BankingOrders.Select((bo) => new {
                   bo.id,
                   confirmed = bo.confirmed == 1 ? "yes" : "No",                  
                   bo.totalMonery,
                   bo.Client.name
               })
               .ToList();
        }

        private void tableLayoutPanel4_Click(object sender, EventArgs e)
        {
            //exchanging 
            MessageBox.Show("display the exchanging form");
        }

        private void dataGridView1_CellClick(object sender, DataGridViewCellEventArgs e)
        {
            int permissionId = int.Parse(this.dataGridView1.Rows[e.RowIndex].Cells[0].Value.ToString());

            var permission = db.SupplyPermissions.Single((p) => p.id == permissionId);

            if (permission.confirmed == 0)
            {
                if (MessageBox.Show("هل تريد إتمام الإذن للمورد ؟ ") == DialogResult.OK)
                {
                    try
                    {

                        var permissionItems = db.SupplyPermissionItems.Where((si) => si.SupplyPermissionID == permission.id).ToList();

                        permissionItems.ForEach((permissionItem) =>
                        {
                            var item = db.Items.Single((i) => i.id == permissionItem.ItemID);
                            item.WarehouseID = permission.WarehouseID;
                            db.SaveChanges();
                            MessageBox.Show($"بنجاح {item.name} : تم إضافة البضاعة ");
                        });

                        permission.confirmed = 1;

                        db.SaveChanges();

                        dataGridView1.DataSource = db
                            .SupplyPermissions.Select((sp) => new {
                                sp.id,
                                confirmed = sp.confirmed == 1 ? "yes" : "No",
                                sp.WarehouseID,
                                warehouseName = sp.Warehouse.name,
                                sp.SupplierID,
                                supplierName = sp.Supplier.name
                            })
                            .ToList();


                    }
                    catch (Exception ex)
                    {
                        MessageBox.Show(ex.Message);
                    }
                }
                else
                {
                    //do nothing
                }
            }
            else
            {
                MessageBox.Show("هذا الإذن تم الموافقة عليه بالفعل !");
            }
        }

        private void dataGridView2_CellClick(object sender, DataGridViewCellEventArgs e)
        {
            int permissionID = int.Parse(dataGridView2.Rows[e.RowIndex].Cells[0].Value.ToString());

            var bankingOrder = db.BankingOrders.Single((permission) => permission.id == permissionID);

            if (bankingOrder.confirmed == 0)
            {
                if (MessageBox.Show("هل تريد الموفقة على اذن الصرف ؟") == DialogResult.OK)
                {
                    //this permission need to confirm 
                    //inorder to confirm this permission we need to check item quantity recorded in each warehouse
                    //if the quantity required bigger than the available quantity // then refuse the permission //else decrease the quantity in the warehouse

                    db.BankingOrderItems.Where((bi) => bi.BankingOrderID == bankingOrder.id).ToList()
                        .ForEach((bankOrderItemInside) =>
                        {
                            int requiredQuantity = bankOrderItemInside.Quantity;
                            int avaailableQuantity = db.SupplyPermissionItems
                            .Single((i) => i.ItemID == bankOrderItemInside.ItemID).Quantity;
                            if (requiredQuantity > avaailableQuantity)
                            {
                                MessageBox.Show("الكمية المطلوبة غير متوفرة بالمخزن حالياً");
                            }
                            else
                            {
                            //lets update the supply permission that will change the warehouse quantity too for each item 
                            var result = db.SupplyPermissionItems.Single((i) => i.ItemID == bankOrderItemInside.ItemID);

                                result.Quantity = result.Quantity - requiredQuantity;
                                db.SaveChanges();

                            }
                        });
                    bankingOrder.confirmed = 1;
                    db.SaveChanges();

                    //if all are ok 
                    MessageBox.Show("عملية ناجحة");

                    dataGridView2.DataSource = db
                       .BankingOrders.Select((bo) => new {
                           bo.id,
                           confirmed = bo.confirmed == 1 ? "yes" : "No",
                           bo.totalMonery,
                           bo.Client.name
                       })
                       .ToList();
                }
                else
                {
                    //do nothing
                }
            }
            else
            {
                //this permission confirmed already 
                MessageBox.Show("هذا الإذن تم الموافقة عليه بالفعل !");
            }

        }
    }
}
