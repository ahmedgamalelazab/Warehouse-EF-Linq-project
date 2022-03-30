﻿using System;
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
    public partial class AppMainWindow : Form , IMessageFilter
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

        public AppMainWindow()
        {
            InitializeComponent();
            warehouseControlPage1.BringToFront();
            //////////////////////////////////////// START DRAG CODE //////////////////////////////////////////
            Application.AddMessageFilter(this);
            controlsToMove.Add(this);
            controlsToMove.Add(this.panel1);//Add whatever controls here you want to move the form when it is clicked and dragged           
            //////////////////////////////////////// END DRAG CODE //////////////////////////////////////////

        }

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

        private void AppMainWindow_FormClosed(object sender, FormClosedEventArgs e)
        {
            Application.Exit();
        }

        private void shutDownSystem_Click(object sender, EventArgs e)
        {
            if (MessageBox.Show("shut down the system ?", "Confirmation", MessageBoxButtons.YesNoCancel) == DialogResult.Yes)
            {
                Application.Exit();
            }
            else
            {
                //do nothing
            }
            
        }

        private void panel1_DoubleClick(object sender, EventArgs e)
        {
            this.WindowState = FormWindowState.Maximized;
        }

        private void pictureBox1_Click(object sender, EventArgs e)
        {
            
            warehouseControlPage1.BringToFront();
        }

        private void pictureBox4_Click(object sender, EventArgs e)
        {
            itemControlPage1.BringToFront();
        }

        private void pictureBox2_Click(object sender, EventArgs e)
        {
            supplierPage1.BringToFront();
        }

        private void pictureBox3_Click(object sender, EventArgs e)
        {
            clientPage1.BringToFront();
        }

        private void pictureBox5_Click(object sender, EventArgs e)
        {
            permissionsPage1.BringToFront();
        }
    }
}
