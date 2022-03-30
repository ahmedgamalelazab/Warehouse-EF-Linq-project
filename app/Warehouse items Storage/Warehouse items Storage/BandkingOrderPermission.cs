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
  
    public partial class BandkingOrderPermission : Form
    {
        List<BandkingOrderItem> bankingOrderItems = new List<BandkingOrderItem>();

        LINQ_EF_PROJECTEntities db = new LINQ_EF_PROJECTEntities();
        int targetItemId = 0;
        public BandkingOrderPermission()
        {
            InitializeComponent();
            comboBox1.DataSource = db.Warehouses.Select((w) => w.id).ToList();
            comboBox2.DataSource = db.Clients.Select((s) => s.id).ToList();
        }

        private void comboBox1_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {

                int wareHouseID = int.Parse(comboBox1.SelectedItem.ToString());

                var warehouse = db.Warehouses.SingleOrDefault((wr) => wr.id == wareHouseID);

                warehouseNameTXT.Text = warehouse.name;

                dataGridView2.DataSource = db.Items.Where((item) => item.WarehouseID == wareHouseID).ToList();

            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
        }

        private void comboBox2_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {

                int ClientID = int.Parse(comboBox2.SelectedItem.ToString());

                var client = db.Clients.SingleOrDefault((cli) => cli.id == ClientID);

                clientNameTXT.Text = client.name;

            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
        }

        private void targetQuantityBTN_Click(object sender, EventArgs e)
        {
            if (dataGridView2.SelectedRows.Count > 0)
            {
                //record the target item that we wanna add into the table 
                //targetItemId.ToString()
                //read the quantity that we wanna add to banking order 
                try
                {

                    int targetQuantity = int.Parse(targetQuantityTXT.Text);

                    var availableItem = db.SupplyPermissionItems.Single((i) => i.ItemID == targetItemId);

                    BandkingOrderItem bankItem = new BandkingOrderItem()
                    {
                        ItemID = availableItem.ItemID,
                        Name = availableItem.Item.name,
                        AvailableQuantity = availableItem.Quantity.ToString(),
                        ProductionDate = availableItem.ProducationDate,
                        ExpireDate = availableItem.ExpireDate,
                        UnitPrice = availableItem.Item.PricePerUnit.ToString(),
                        RequiredQantity = targetQuantity.ToString()
                    };

                    bankingOrderItems.Add(bankItem);

                    dataGridView1.DataSource = bankingOrderItems.ToList();

                    totalQuantityTXT.Text = bankingOrderItems.Count.ToString();

                    int totalMoney = 0;

                    bankingOrderItems.ForEach((bi) =>
                    {
                        totalMoney += (int.Parse(bi.UnitPrice) * int.Parse(bi.RequiredQantity));
                    });

                    totalAmountOfMoneyTXT.Text = totalMoney.ToString();


                }
                catch(Exception ex)
                {
                    MessageBox.Show(ex.Message);
                }
            }
        }

        private void dataGridView2_CellClick(object sender, DataGridViewCellEventArgs e)
        {
            try
            {

                targetItemId = int.Parse(dataGridView2.Rows[e.RowIndex].Cells[0].Value.ToString());
            }catch(Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
        }

        private void button2_Click(object sender, EventArgs e)
        {
            try
            {

                //loop on the items in the banking table 
                int ClientID = int.Parse(comboBox2.SelectedItem.ToString());

                db.BankingOrders.Add(new BankingOrder()
                {
                    confirmed = 0,
                    destinationID = ClientID,
                    createdAt = DateTime.Now,
                    updatedAt = DateTime.Now,
                    totalMonery = int.Parse(totalAmountOfMoneyTXT.Text),
                });

                db.SaveChanges();

                bankingOrderItems.ForEach((bankItem) =>
                {

                    db.BankingOrderItems.Add(new BankingOrderItem()
                    {
                        BankingOrderID = db.BankingOrders.OrderByDescending((i) => i.id).FirstOrDefault().id,
                        ItemID = bankItem.ItemID,
                        Quantity = int.Parse(bankItem.RequiredQantity),
                        ProductionDate = bankItem.ProductionDate,
                        ExpireDate = bankItem.ExpireDate
                    });

                });
                db.SaveChanges();
                //if all are ok 

                MessageBox.Show("عمليه ناجحة");
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }


        }
    }
}
