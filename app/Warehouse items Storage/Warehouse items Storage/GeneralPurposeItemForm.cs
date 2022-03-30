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

    public partial class GeneralPurposeItemForm : Form
    {

        SupplyPermissionFormHandler formHandler;


        public GeneralPurposeItemForm()
        {
            InitializeComponent();
        }

        //adding data constructor
        public GeneralPurposeItemForm(SupplyPermissionFormHandler formHandler)
        {
            this.formHandler = formHandler;
            InitializeComponent();
        }

        private void addEditItemBTN_Click(object sender, EventArgs e)
        {
            //on adding 
            GeneralPurposeItem item= new GeneralPurposeItem();
            //TODO CHECK FOR EMPTY AND NULL
            item.Name = itemNameTXT.Text;
            item.MeasureUnit = measuringTXT.Text;
            item.Quantity = int.Parse(quantityTXT.Text);
            item.PricePerUinit = int.Parse(priceTXT.Text);
            item.ProductionDate = prodDatePicker.Value;
            item.ExpireDate = expireDatePicker.Value;
            formHandler.Items.Add(item);

            //if all are ok 
            this.Close();
                
        }
    }
}
