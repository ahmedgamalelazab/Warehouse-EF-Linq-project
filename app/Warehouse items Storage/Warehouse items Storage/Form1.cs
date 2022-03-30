using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace Warehouse_items_Storage
{
    public partial class Form1 : Form, IMessageFilter
    {
        
        //////////////////////////////////////// DRAG CODE //////////////////////////////////////////        
        public const int WM_NCLBUTTONDOWN = 0xA1;
        public const int HT_CAPTION = 0x2;
        public const int WM_LBUTTONDOWN = 0x0201;

        [DllImportAttribute("user32.dll")]
        public static extern int SendMessage(IntPtr hWnd, int Msg, int wParam, int lParam);
        [DllImportAttribute("user32.dll")]
        public static extern bool ReleaseCapture();

        private HashSet<Control> controlsToMove = new HashSet<Control>();
        //////////////////////////////////////// END DRAG CODE //////////////////////////////////////////

        public Form1()
        {
            InitializeComponent();
            //////////////////////////////////////// EF CODE //////////////////////////////////////////
            LINQ_EF_PROJECTEntities db = new LINQ_EF_PROJECTEntities(); //stablish db instance
            //this.dataGridView1.DataSource = db.WarehouseKeepers.Select((emp) => new { emp.id, emp.name, emp.salary }).ToList();
            //////////////////////////////////////// END EF CODE //////////////////////////////////////////
            
            //////////////////////////////////////// START DRAG CODE //////////////////////////////////////////
            Application.AddMessageFilter(this);
            controlsToMove.Add(this);
            controlsToMove.Add(this.panel1);//Add whatever controls here you want to move the form when it is clicked and dragged
            controlsToMove.Add(this.panel2);
            //////////////////////////////////////// END DRAG CODE //////////////////////////////////////////
        }

        //////////////////////////////////////// START DRAG CODE //////////////////////////////////////////
        public bool PreFilterMessage(ref Message m)
        {
            if (m.Msg == WM_LBUTTONDOWN &&
            controlsToMove.Contains(Control.FromHandle(m.HWnd)))
            {
                ReleaseCapture();
                SendMessage(this.Handle, WM_NCLBUTTONDOWN, HT_CAPTION, 0);
                return true;
            }
            return false;
        }
        //////////////////////////////////////// END DRAG CODE //////////////////////////////////////////
        
        private void formCloseBtn_Click(object sender, EventArgs e)
        {
            Application.Exit();            
        }

        private void loginBTN_Click(object sender, EventArgs e)
        {
            //hard coded admin account for now 
            string adminUser = "admin";
            string adminPassword = "admin";
            string userEmailText = this.userEmailTXT.Text;
            string userPasswordText = this.userPasswordTXT.Text;
            if (userEmailText.ToLower() == adminUser.ToLower() &&
                userPasswordText.ToLower() == adminPassword.ToLower())
            {
                Form appMainWindow = new AppMainWindow();
                this.Hide();
                appMainWindow.ShowDialog();

            }
            else
            {
                MessageBox.Show("Invalid user name or password Pleas try again");
            }
        }
    }
}
