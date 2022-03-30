using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Warehouse_items_Storage
{
    public class ServiceConsumer
    {
        public string Name { set; get; }
        public string Telephone { set; get; }
        public string Fax { set; get; }
        public string Mobile { set; get; }
        public string Mail { set; get; }
        public string Website { set; get; }


        public ServiceConsumer(string name,string telephone,string fax, string mobile,string mail,string website)
        {
            this.Name = name;
            this.Telephone = telephone;
            this.Fax = fax;
            this.Mobile = mobile;
            this.Mail = mail;                              
            this.Website = website;
        }
    }
}
