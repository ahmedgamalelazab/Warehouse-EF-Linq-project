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
    public partial class ClientSupplierAddingForm : Form
    {

        private SupplierPage supplierPage;
        private clientPage clientPage;
        private bool isAddingMode;
        LINQ_EF_PROJECTEntities db = new LINQ_EF_PROJECTEntities();

        public ClientSupplierAddingForm()
        {
            InitializeComponent();
            this.isAddingMode = true;

        }

        public ClientSupplierAddingForm(SupplierPage supplierPage)
        {
            this.supplierPage = supplierPage;
            InitializeComponent();
            this.isAddingMode = true;
        }

        public ClientSupplierAddingForm(SupplierPage supplierPage , ServiceConsumer serviceConsumer , bool isAddingMode = false)
        {
            this.isAddingMode = isAddingMode;
            this.supplierPage = supplierPage;
            InitializeComponent();           
            clientSupplierNameTXT.Text = serviceConsumer.Name;
            clientSupplierTelephoneTXT.Text = serviceConsumer.Telephone;
            clientSupplierFaxTXT.Text = serviceConsumer.Fax;
            clientSupplierMobileTXT.Text = serviceConsumer.Mobile;
            clientSupplierMailTXT.Text = serviceConsumer.Mail;
            clientSupplierWebTXT.Text = serviceConsumer.Website;

        }

        public ClientSupplierAddingForm(clientPage clientPage)
        {
            this.clientPage = clientPage;
            InitializeComponent();
            this.isAddingMode = true;
        }

        public ClientSupplierAddingForm(clientPage clientPage, ServiceConsumer serviceConsumer, bool isAddingMode = false)
        {
            this.isAddingMode = isAddingMode;
            this.clientPage = clientPage;
            InitializeComponent();
            clientSupplierNameTXT.Text = serviceConsumer.Name;
            clientSupplierTelephoneTXT.Text = serviceConsumer.Telephone;
            clientSupplierFaxTXT.Text = serviceConsumer.Fax;
            clientSupplierMobileTXT.Text = serviceConsumer.Mobile;
            clientSupplierMailTXT.Text = serviceConsumer.Mail;
            clientSupplierWebTXT.Text = serviceConsumer.Website;
        }





        private void formDataNullChecker(string name,string telephone,string fax,string mobile,string mail)
        {
            //website is not mandotrary 
            if (name == string.Empty ||
                telephone == string.Empty ||
                fax == string.Empty ||
                mobile == string.Empty ||
                mail == string.Empty )
            {
                throw new Exception("form error");
            }
        }

        private void button1_Click(object sender, EventArgs e)
        {
            if (supplierPage != null)
            {

                //that's mean the target form data is targetting the supplier
                try
                {
                    formDataNullChecker(clientSupplierNameTXT.Text,clientSupplierTelephoneTXT.Text,clientSupplierFaxTXT.Text,clientSupplierMobileTXT.Text,clientSupplierMailTXT.Text);
                    if (clientSupplierWebTXT.Text != string.Empty)
                    {
                        if (this.isAddingMode)
                        {
                            //adding mode
                            Supplier supplier = new Supplier()
                            {
                                name = clientSupplierNameTXT.Text,
                                telephone = clientSupplierTelephoneTXT.Text,
                                fax = clientSupplierFaxTXT.Text,
                                mobile = clientSupplierMobileTXT.Text,
                                mail = clientSupplierMailTXT.Text,
                                website = clientSupplierWebTXT.Text
                            };
                            db.Suppliers.Add(supplier);
                            db.SaveChanges();
                            supplierPage.dataGridView1.DataSource = db.Suppliers
                            .Select((s) => new
                            {
                                s.id,
                                s.name,
                                s.telephone,
                                s.fax,
                                s.mobile,
                                s.mail,
                                s.website,
                                SupplyPermissions = s.SupplyPermissions.Count,                                
                                ExchangePermissions = s.ExchangePermissions.Count,
                            }).ToList();
                            MessageBox.Show("عمليه ناجحة");                           
                        }
                        else
                        {
                            //editing mode
                            Supplier supplier = new Supplier()
                            {
                                name = clientSupplierNameTXT.Text,
                                telephone = clientSupplierTelephoneTXT.Text,
                                fax = clientSupplierFaxTXT.Text,
                                mobile = clientSupplierMobileTXT.Text,
                                mail = clientSupplierMailTXT.Text,
                                website = clientSupplierWebTXT.Text
                            };
                            var result = db.Suppliers.SingleOrDefault((sup) => sup.telephone == supplier.telephone);

                            //updating like mongo exactly
                            result.name = supplier.name;
                            result.telephone = supplier.telephone;
                            result.fax = supplier.fax;
                            result.mobile = supplier.mobile;
                            result.mail = supplier.mail;
                            result.website = supplier.website;

                            db.SaveChanges();
                            supplierPage.dataGridView1.DataSource = db.Suppliers
                            .Select((s) => new
                            {
                                s.id,
                                s.name,
                                s.telephone,
                                s.fax,
                                s.mobile,
                                s.mail,
                                s.website,
                                SupplyPermissions = s.SupplyPermissions.Count,                                
                                ExchangePermissions = s.ExchangePermissions.Count,
                            }).ToList();
                            MessageBox.Show("عمليه ناجحة");
                        }
                    }
                    else
                    {
                        if (this.isAddingMode)
                        {
                            //adding mode
                            Supplier supplier = new Supplier()
                            {
                                name = clientSupplierNameTXT.Text,
                                telephone = clientSupplierTelephoneTXT.Text,
                                fax = clientSupplierFaxTXT.Text,
                                mobile = clientSupplierMobileTXT.Text,
                                mail = clientSupplierMailTXT.Text,                               
                            };
                            db.Suppliers.Add(supplier);
                            db.SaveChanges();
                            supplierPage.dataGridView1.DataSource = db.Suppliers
                            .Select((s) => new
                            {
                                s.id,
                                s.name,
                                s.telephone,
                                s.fax,
                                s.mobile,
                                s.mail,
                                s.website,
                                SupplyPermissions = s.SupplyPermissions.Count,                                
                                ExchangePermissions = s.ExchangePermissions.Count,
                            }).ToList();
                            MessageBox.Show("عمليه ناجحة");
                        }
                        else
                        {
                            //editing mode
                            Supplier supplier = new Supplier()
                            {
                                name = clientSupplierNameTXT.Text,
                                telephone = clientSupplierTelephoneTXT.Text,
                                fax = clientSupplierFaxTXT.Text,
                                mobile = clientSupplierMobileTXT.Text,
                                mail = clientSupplierMailTXT.Text,
                                website = clientSupplierWebTXT.Text
                            };
                            var result = db.Suppliers.SingleOrDefault((sup) => sup.mail == supplier.mail);

                            //updating like mongo exactly
                            result.name = supplier.name;
                            result.telephone = supplier.telephone;
                            result.fax = supplier.fax;
                            result.mobile = supplier.mobile;
                            result.mail = supplier.mail;
                            result.website = clientSupplierWebTXT.Text;

                            db.SaveChanges();
                            supplierPage.dataGridView1.DataSource = db.Suppliers
                            .Select((s) => new
                            {
                                s.id,
                                s.name,
                                s.telephone,
                                s.fax,
                                s.mobile,
                                s.mail,
                                s.website,
                                SupplyPermissions = s.SupplyPermissions.Count,                                
                                ExchangePermissions = s.ExchangePermissions.Count,
                            }).ToList();
                            MessageBox.Show("عمليه ناجحة");
                        }
                    }
                }
                catch (Exception ex)
                {
                    MessageBox.Show("اكمل النموذج بشكل صحيح لإتمام العملية");
                    MessageBox.Show(ex.Message);
                }

            }else if (clientPage != null)
            {
                //that's mean the target form data is targetting the client
                try
                {
                    formDataNullChecker(clientSupplierNameTXT.Text, clientSupplierTelephoneTXT.Text, clientSupplierFaxTXT.Text, clientSupplierMobileTXT.Text, clientSupplierMailTXT.Text);
                    if (clientSupplierWebTXT.Text != string.Empty)
                    {
                        if (this.isAddingMode)
                        {
                            Client client = new Client()
                            {
                                name = clientSupplierNameTXT.Text,
                                telephone = clientSupplierTelephoneTXT.Text,
                                fax = clientSupplierFaxTXT.Text,
                                mobile = clientSupplierMobileTXT.Text,
                                mail = clientSupplierMailTXT.Text,
                                website = clientSupplierWebTXT.Text
                            };
                            db.Clients.Add(client);
                            db.SaveChanges();
                            clientPage.dataGridView1.DataSource = db.Clients
                            .Select((s) => new
                            {
                                s.id,
                                s.name,
                                s.telephone,
                                s.fax,
                                s.mobile,
                                s.mail,
                                s.website,                                
                            }).ToList();
                            MessageBox.Show("عمليه ناجحة");
                        }
                        else
                        {
                            //client edit mode
                            Client client = new Client()
                            {
                                name = clientSupplierNameTXT.Text,
                                telephone = clientSupplierTelephoneTXT.Text,
                                fax = clientSupplierFaxTXT.Text,
                                mobile = clientSupplierMobileTXT.Text,
                                mail = clientSupplierMailTXT.Text,
                                website = clientSupplierWebTXT.Text
                            };
                            var result = db.Clients.SingleOrDefault((c) => c.mail == client.mail);
                            result.name = client.name;
                            result.telephone = client.telephone;
                            result.fax = client.fax;
                            result.mobile = client.mobile;
                            result.mail = client.mail;
                            result.website = client.website;
                            db.SaveChanges();
                            clientPage.dataGridView1.DataSource = db.Clients
                            .Select((s) => new
                            {
                                s.id,
                                s.name,
                                s.telephone,
                                s.fax,
                                s.mobile,
                                s.mail,                                
                                s.website,                                
                            }).ToList();
                            MessageBox.Show("عمليه ناجحة");
                        }
                    }
                    else
                    {
                        if (this.isAddingMode)
                        {
                            Client client = new Client()
                            {
                                name = clientSupplierNameTXT.Text,
                                telephone = clientSupplierTelephoneTXT.Text,
                                fax = clientSupplierFaxTXT.Text,
                                mobile = clientSupplierMobileTXT.Text,
                                mail = clientSupplierMailTXT.Text,
                            };
                            db.Clients.Add(client);
                            db.SaveChanges();
                            clientPage.dataGridView1.DataSource = db.Clients
                            .Select((s) => new
                            {
                                s.id,
                                s.name,
                                s.telephone,
                                s.fax,
                                s.mobile,
                                s.mail,
                                s.website,                                
                            }).ToList();
                            MessageBox.Show("عمليه ناجحة");
                        }
                        else
                        {
                            //client edit mode 
                            Client client = new Client()
                            {
                                name = clientSupplierNameTXT.Text,
                                telephone = clientSupplierTelephoneTXT.Text,
                                fax = clientSupplierFaxTXT.Text,
                                mobile = clientSupplierMobileTXT.Text,
                                mail = clientSupplierMailTXT.Text,
                            };
                            var result = db.Clients.SingleOrDefault((c) => c.mail == client.mail);
                            result.name = client.name;
                            result.telephone = client.telephone;
                            result.fax = client.fax;
                            result.mobile = client.mobile;
                            result.mail = client.mail;
                            result.website = client.website;
                            db.SaveChanges();                          
                            clientPage.dataGridView1.DataSource = db.Clients
                            .Select((s) => new
                            {
                                s.id,
                                s.name,
                                s.telephone,
                                s.fax,
                                s.mobile,
                                s.mail,
                                s.website,                                
                            }).ToList();
                            MessageBox.Show("عمليه ناجحة");
                        }
                    }
                }
                catch(Exception ex)
                {
                    MessageBox.Show("اكمل النموذج بشكل صحيح لإتمام العملية");
                }
            }
        }
    }
}
