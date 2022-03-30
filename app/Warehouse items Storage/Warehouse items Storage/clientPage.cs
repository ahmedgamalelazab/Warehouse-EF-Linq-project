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
    public partial class clientPage : UserControl
    {
        LINQ_EF_PROJECTEntities db = new LINQ_EF_PROJECTEntities();
        public clientPage()
        {
            InitializeComponent();
            dataGridView1.DataSource = db.Clients
           .Select((s) => new
           {
               s.id,
               s.name,
               s.telephone,
               s.fax,
               s.mobile,
               s.mail,               
               s.website,
               BankingOrders = s.BankingOrders.Count,               
           }).ToList();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            //adding supplier 
            ClientSupplierAddingForm clientSupplierGenericForm = new ClientSupplierAddingForm(this);
            clientSupplierGenericForm.ShowDialog();
        }

        private void button2_Click(object sender, EventArgs e)
        {
            if (dataGridView1.SelectedRows.Count > 0)
            {
                ServiceConsumer serviceConsumer = new ServiceConsumer(
                  dataGridView1.SelectedRows[0].Cells[1].Value == null ? " " : dataGridView1.SelectedRows[0].Cells[1].Value.ToString(),
                  dataGridView1.SelectedRows[0].Cells[2].Value == null ? " " : dataGridView1.SelectedRows[0].Cells[2].Value.ToString(),
                  dataGridView1.SelectedRows[0].Cells[3].Value == null ? " " : dataGridView1.SelectedRows[0].Cells[3].Value.ToString(),
                  dataGridView1.SelectedRows[0].Cells[4].Value == null ? " " : dataGridView1.SelectedRows[0].Cells[4].Value.ToString(),
                  dataGridView1.SelectedRows[0].Cells[5].Value == null ? " " : dataGridView1.SelectedRows[0].Cells[5].Value.ToString(),
                  dataGridView1.SelectedRows[0].Cells[6].Value == null ? " " : dataGridView1.SelectedRows[0].Cells[6].Value.ToString()
               );
                ClientSupplierAddingForm clientSupplierGenericForm = new ClientSupplierAddingForm(this, serviceConsumer);
                clientSupplierGenericForm.ShowDialog();
            }
            else
            {
                MessageBox.Show("اختر عميل من قائمة البيانات لكى يتم التعديل");
            }
                
        }
    }
}
