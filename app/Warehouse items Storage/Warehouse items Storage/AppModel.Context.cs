﻿//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace Warehouse_items_Storage
{
    using System;
    using System.Data.Entity;
    using System.Data.Entity.Infrastructure;
    
    public partial class LINQ_EF_PROJECTEntities : DbContext
    {
        public LINQ_EF_PROJECTEntities()
            : base("name=LINQ_EF_PROJECTEntities")
        {
        }
    
        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            throw new UnintentionalCodeFirstException();
        }
    
        public virtual DbSet<BankingOrderItem> BankingOrderItems { get; set; }
        public virtual DbSet<Client> Clients { get; set; }
        public virtual DbSet<ExchangePermissionItem> ExchangePermissionItems { get; set; }
        public virtual DbSet<Supplier> Suppliers { get; set; }
        public virtual DbSet<SupplyPermissionItem> SupplyPermissionItems { get; set; }
        public virtual DbSet<sysdiagram> sysdiagrams { get; set; }
        public virtual DbSet<Warehouse> Warehouses { get; set; }
        public virtual DbSet<WarehouseKeeper> WarehouseKeepers { get; set; }
        public virtual DbSet<Item> Items { get; set; }
        public virtual DbSet<SupplyPermission> SupplyPermissions { get; set; }
        public virtual DbSet<ExchangePermission> ExchangePermissions { get; set; }
        public virtual DbSet<BankingOrder> BankingOrders { get; set; }
    }
}