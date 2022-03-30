CREATE SCHEMA dbo;

CREATE TABLE dbo.Client ( 
	id                   int NOT NULL   IDENTITY ,
	name                 varchar(100) NOT NULL    ,
	telephone            varchar(100) NOT NULL    ,
	fax                  varchar(100) NOT NULL    ,
	mobile               varchar(100) NOT NULL    ,
	mail                 varchar(100) NOT NULL    ,
	website              varchar(100)     ,
	CONSTRAINT Pk_Client_id PRIMARY KEY  ( id )
 );

CREATE TABLE dbo.Supplier ( 
	id                   int NOT NULL   IDENTITY ,
	name                 varchar(50) NOT NULL    ,
	telephone            varchar(100) NOT NULL    ,
	fax                  varchar(100) NOT NULL    ,
	mobile               varchar(100) NOT NULL    ,
	mail                 varchar(100) NOT NULL    ,
	website              varchar(100)     ,
	CONSTRAINT Pk_Supplier_id PRIMARY KEY  ( id )
 );

CREATE TABLE dbo.WarehouseKeeper ( 
	id                   int NOT NULL   IDENTITY ,
	name                 varchar(100) NOT NULL    ,
	address              varchar(100) NOT NULL    ,
	phone                varchar(100) NOT NULL    ,
	salary               int NOT NULL    ,
	CONSTRAINT Pk_WarehouseKeeper_id PRIMARY KEY  ( id )
 );

CREATE TABLE dbo.sysdiagrams ( 
	diagram_id           int NOT NULL   IDENTITY ,
	name                 sysname NOT NULL    ,
	principal_id         int NOT NULL    ,
	version              int     ,
	definition           varbinary(max)     ,
	CONSTRAINT PK__sysdiagr__C2B05B611D48F1E6 PRIMARY KEY  ( diagram_id ),
	CONSTRAINT UK_principal_name UNIQUE ( principal_id ASC, name ASC ) 
 );

CREATE TABLE dbo.BankingOrder ( 
	id                   int NOT NULL   IDENTITY ,
	createdAt            date  CONSTRAINT defo_BankingOrder_createdAt DEFAULT getdate()   ,
	updatedAt            date  CONSTRAINT defo_BankingOrder_updatedAt DEFAULT getdate()   ,
	destinationID        int NOT NULL    ,
	confirmed            int     ,
	totalMonery          int NOT NULL    ,
	CONSTRAINT Pk_BankingOrder_id PRIMARY KEY  ( id )
 );

CREATE TABLE dbo.Warehouse ( 
	id                   int NOT NULL   IDENTITY ,
	name                 varchar(100) NOT NULL    ,
	address              varchar(100) NOT NULL    ,
	WarehouseKeeperID    int NOT NULL    ,
	CONSTRAINT Pk_Warehouse_id PRIMARY KEY  ( id )
 );

CREATE TABLE dbo.ExchangePermission ( 
	id                   int NOT NULL   IDENTITY ,
	SourceWarehouseID    int NOT NULL    ,
	DestinationWarehouseID int NOT NULL    ,
	SupplierID           int NOT NULL    ,
	createdAt            date  CONSTRAINT defo_ExchangePermission_createdAt DEFAULT getdate()   ,
	updatedAt            date  CONSTRAINT defo_ExchangePermission_updatedAt DEFAULT getdate()   ,
	confirmed            int     ,
	CONSTRAINT Pk_ExchangePermission_id PRIMARY KEY  ( id )
 );

CREATE TABLE dbo.Item ( 
	id                   int NOT NULL   IDENTITY ,
	name                 varchar(100) NOT NULL    ,
	MeasureUnit          varchar(50) NOT NULL CONSTRAINT defo_Item_MeasureUnit DEFAULT 'TON'   ,
	PricePerUnit         int NOT NULL    ,
	WarehouseID          int     ,
	CONSTRAINT Pk_Item_id PRIMARY KEY  ( id )
 );

CREATE TABLE dbo.SupplyPermission ( 
	id                   int NOT NULL   IDENTITY ,
	WarehouseID          int NOT NULL    ,
	SupplierID           int NOT NULL    ,
	CreatedAt            date  CONSTRAINT defo_SupplyPermission_CreatedAt DEFAULT getdate()   ,
	updatedAt            date  CONSTRAINT defo_SupplyPermission_updatedAt DEFAULT getdate()   ,
	confirmed            int     ,
	CONSTRAINT Pk_SupplyPermission_id PRIMARY KEY  ( id )
 );

CREATE TABLE dbo.SupplyPermissionItems ( 
	id                   int NOT NULL   IDENTITY ,
	SupplyPermissionID   int NOT NULL    ,
	ItemID               int NOT NULL    ,
	Quantity             int NOT NULL    ,
	ProducationDate      date NOT NULL CONSTRAINT defo_SupplyPermissionItems_ProducationDate DEFAULT getdate()   ,
	ExpireDate           date NOT NULL CONSTRAINT defo_SupplyPermissionItems_ExpireDate DEFAULT getdate()   ,
	CONSTRAINT Pk_SupplyPermissionItems_id PRIMARY KEY  ( id )
 );

CREATE TABLE dbo.BankingOrderItems ( 
	id                   int NOT NULL   IDENTITY ,
	BankingOrderID       int NOT NULL    ,
	ItemID               int NOT NULL    ,
	Quantity             int NOT NULL    ,
	ProductionDate       date NOT NULL CONSTRAINT defo_BankingOrderItems_ProductionDate DEFAULT getdate()   ,
	ExpireDate           date NOT NULL CONSTRAINT defo_BankingOrderItems_ExpireDate DEFAULT getdate()   ,
	CONSTRAINT Pk_BankingOrderItems_id PRIMARY KEY  ( id )
 );

CREATE TABLE dbo.ExchangePermissionItems ( 
	id                   int NOT NULL   IDENTITY ,
	ExchangePermissionID int NOT NULL    ,
	ItemID               int NOT NULL    ,
	Quantity             int NOT NULL    ,
	productionDate       date NOT NULL CONSTRAINT defo_ExchangePermissionItems_productionDate DEFAULT getdate()   ,
	ExpireDate           date NOT NULL CONSTRAINT defo_ExchangePermissionItems_ExpireDate DEFAULT getdate()   ,
	CONSTRAINT Pk_ExchangePermissionItems_id PRIMARY KEY  ( id )
 );

CREATE FUNCTION dbo.fn_diagramobjects() 
	RETURNS int
	WITH EXECUTE AS N'dbo'
	AS
	BEGIN
		declare @id_upgraddiagrams		int
		declare @id_sysdiagrams			int
		declare @id_helpdiagrams		int
		declare @id_helpdiagramdefinition	int
		declare @id_creatediagram	int
		declare @id_renamediagram	int
		declare @id_alterdiagram 	int 
		declare @id_dropdiagram		int
		declare @InstalledObjects	int
		select @InstalledObjects = 0
		select 	@id_upgraddiagrams = object_id(N'dbo.sp_upgraddiagrams'),
			@id_sysdiagrams = object_id(N'dbo.sysdiagrams'),
			@id_helpdiagrams = object_id(N'dbo.sp_helpdiagrams'),
			@id_helpdiagramdefinition = object_id(N'dbo.sp_helpdiagramdefinition'),
			@id_creatediagram = object_id(N'dbo.sp_creatediagram'),
			@id_renamediagram = object_id(N'dbo.sp_renamediagram'),
			@id_alterdiagram = object_id(N'dbo.sp_alterdiagram'), 
			@id_dropdiagram = object_id(N'dbo.sp_dropdiagram')
		if @id_upgraddiagrams is not null
			select @InstalledObjects = @InstalledObjects + 1
		if @id_sysdiagrams is not null
			select @InstalledObjects = @InstalledObjects + 2
		if @id_helpdiagrams is not null
			select @InstalledObjects = @InstalledObjects + 4
		if @id_helpdiagramdefinition is not null
			select @InstalledObjects = @InstalledObjects + 8
		if @id_creatediagram is not null
			select @InstalledObjects = @InstalledObjects + 16
		if @id_renamediagram is not null
			select @InstalledObjects = @InstalledObjects + 32
		if @id_alterdiagram  is not null
			select @InstalledObjects = @InstalledObjects + 64
		if @id_dropdiagram is not null
			select @InstalledObjects = @InstalledObjects + 128
		
		return @InstalledObjects 
	END

CREATE PROCEDURE dbo.sp_alterdiagram
	(
		@diagramname 	sysname,
		@owner_id	int	= null,
		@version 	int,
		@definition 	varbinary(max)
	)
	WITH EXECUTE AS 'dbo'
	AS
	BEGIN
		set nocount on
	
		declare @theId 			int
		declare @retval 		int
		declare @IsDbo 			int
		
		declare @UIDFound 		int
		declare @DiagId			int
		declare @ShouldChangeUID	int
	
		if(@diagramname is null)
		begin
			RAISERROR ('Invalid ARG', 16, 1)
			return -1
		end
	
		execute as caller;
		select @theId = DATABASE_PRINCIPAL_ID();	 
		select @IsDbo = IS_MEMBER(N'db_owner'); 
		if(@owner_id is null)
			select @owner_id = @theId;
		revert;
	
		select @ShouldChangeUID = 0
		select @DiagId = diagram_id, @UIDFound = principal_id from dbo.sysdiagrams where principal_id = @owner_id and name = @diagramname 
		
		if(@DiagId IS NULL or (@IsDbo = 0 and @theId <> @UIDFound))
		begin
			RAISERROR ('Diagram does not exist or you do not have permission.', 16, 1);
			return -3
		end
	
		if(@IsDbo <> 0)
		begin
			if(@UIDFound is null or USER_NAME(@UIDFound) is null) -- invalid principal_id
			begin
				select @ShouldChangeUID = 1 ;
			end
		end
		-- update dds data			
		update dbo.sysdiagrams set definition = @definition where diagram_id = @DiagId ;
		-- change owner
		if(@ShouldChangeUID = 1)
			update dbo.sysdiagrams set principal_id = @theId where diagram_id = @DiagId ;
		-- update dds version
		if(@version is not null)
			update dbo.sysdiagrams set version = @version where diagram_id = @DiagId ;
		return 0
	END

CREATE PROCEDURE dbo.sp_creatediagram
	(
		@diagramname 	sysname,
		@owner_id		int	= null, 	
		@version 		int,
		@definition 	varbinary(max)
	)
	WITH EXECUTE AS 'dbo'
	AS
	BEGIN
		set nocount on
	
		declare @theId int
		declare @retval int
		declare @IsDbo	int
		declare @userName sysname
		if(@version is null or @diagramname is null)
		begin
			RAISERROR (N'E_INVALIDARG', 16, 1);
			return -1
		end
	
		execute as caller;
		select @theId = DATABASE_PRINCIPAL_ID(); 
		select @IsDbo = IS_MEMBER(N'db_owner');
		revert; 
		
		if @owner_id is null
		begin
			select @owner_id = @theId;
		end
		else
		begin
			if @theId <> @owner_id
			begin
				if @IsDbo = 0
				begin
					RAISERROR (N'E_INVALIDARG', 16, 1);
					return -1
				end
				select @theId = @owner_id
			end
		end
		-- next 2 line only for test, will be removed after define name unique
		if EXISTS(select diagram_id from dbo.sysdiagrams where principal_id = @theId and name = @diagramname)
		begin
			RAISERROR ('The name is already used.', 16, 1);
			return -2
		end
	
		insert into dbo.sysdiagrams(name, principal_id , version, definition)
				VALUES(@diagramname, @theId, @version, @definition) ;
		
		select @retval = @@IDENTITY 
		return @retval
	END

CREATE PROCEDURE dbo.sp_dropdiagram
	(
		@diagramname 	sysname,
		@owner_id	int	= null
	)
	WITH EXECUTE AS 'dbo'
	AS
	BEGIN
		set nocount on
		declare @theId 			int
		declare @IsDbo 			int
		
		declare @UIDFound 		int
		declare @DiagId			int
	
		if(@diagramname is null)
		begin
			RAISERROR ('Invalid value', 16, 1);
			return -1
		end
	
		EXECUTE AS CALLER;
		select @theId = DATABASE_PRINCIPAL_ID();
		select @IsDbo = IS_MEMBER(N'db_owner'); 
		if(@owner_id is null)
			select @owner_id = @theId;
		REVERT; 
		
		select @DiagId = diagram_id, @UIDFound = principal_id from dbo.sysdiagrams where principal_id = @owner_id and name = @diagramname 
		if(@DiagId IS NULL or (@IsDbo = 0 and @UIDFound <> @theId))
		begin
			RAISERROR ('Diagram does not exist or you do not have permission.', 16, 1)
			return -3
		end
	
		delete from dbo.sysdiagrams where diagram_id = @DiagId;
	
		return 0;
	END

CREATE PROCEDURE dbo.sp_helpdiagramdefinition
	(
		@diagramname 	sysname,
		@owner_id	int	= null 		
	)
	WITH EXECUTE AS N'dbo'
	AS
	BEGIN
		set nocount on
		declare @theId 		int
		declare @IsDbo 		int
		declare @DiagId		int
		declare @UIDFound	int
	
		if(@diagramname is null)
		begin
			RAISERROR (N'E_INVALIDARG', 16, 1);
			return -1
		end
	
		execute as caller;
		select @theId = DATABASE_PRINCIPAL_ID();
		select @IsDbo = IS_MEMBER(N'db_owner');
		if(@owner_id is null)
			select @owner_id = @theId;
		revert; 
	
		select @DiagId = diagram_id, @UIDFound = principal_id from dbo.sysdiagrams where principal_id = @owner_id and name = @diagramname;
		if(@DiagId IS NULL or (@IsDbo = 0 and @UIDFound <> @theId ))
		begin
			RAISERROR ('Diagram does not exist or you do not have permission.', 16, 1);
			return -3
		end
		select version, definition FROM dbo.sysdiagrams where diagram_id = @DiagId ; 
		return 0
	END

CREATE PROCEDURE dbo.sp_helpdiagrams
	(
		@diagramname sysname = NULL,
		@owner_id int = NULL
	)
	WITH EXECUTE AS N'dbo'
	AS
	BEGIN
		DECLARE @user sysname
		DECLARE @dboLogin bit
		EXECUTE AS CALLER;
			SET @user = USER_NAME();
			SET @dboLogin = CONVERT(bit,IS_MEMBER('db_owner'));
		REVERT;
		SELECT
			[Database] = DB_NAME(),
			[Name] = name,
			[ID] = diagram_id,
			[Owner] = USER_NAME(principal_id),
			[OwnerID] = principal_id
		FROM
			sysdiagrams
		WHERE
			(@dboLogin = 1 OR USER_NAME(principal_id) = @user) AND
			(@diagramname IS NULL OR name = @diagramname) AND
			(@owner_id IS NULL OR principal_id = @owner_id)
		ORDER BY
			4, 5, 1
	END

CREATE PROCEDURE dbo.sp_renamediagram
	(
		@diagramname 		sysname,
		@owner_id		int	= null,
		@new_diagramname	sysname
	
	)
	WITH EXECUTE AS 'dbo'
	AS
	BEGIN
		set nocount on
		declare @theId 			int
		declare @IsDbo 			int
		
		declare @UIDFound 		int
		declare @DiagId			int
		declare @DiagIdTarg		int
		declare @u_name			sysname
		if((@diagramname is null) or (@new_diagramname is null))
		begin
			RAISERROR ('Invalid value', 16, 1);
			return -1
		end
	
		EXECUTE AS CALLER;
		select @theId = DATABASE_PRINCIPAL_ID();
		select @IsDbo = IS_MEMBER(N'db_owner'); 
		if(@owner_id is null)
			select @owner_id = @theId;
		REVERT;
	
		select @u_name = USER_NAME(@owner_id)
	
		select @DiagId = diagram_id, @UIDFound = principal_id from dbo.sysdiagrams where principal_id = @owner_id and name = @diagramname 
		if(@DiagId IS NULL or (@IsDbo = 0 and @UIDFound <> @theId))
		begin
			RAISERROR ('Diagram does not exist or you do not have permission.', 16, 1)
			return -3
		end
	
		-- if((@u_name is not null) and (@new_diagramname = @diagramname))	-- nothing will change
		--	return 0;
	
		if(@u_name is null)
			select @DiagIdTarg = diagram_id from dbo.sysdiagrams where principal_id = @theId and name = @new_diagramname
		else
			select @DiagIdTarg = diagram_id from dbo.sysdiagrams where principal_id = @owner_id and name = @new_diagramname
	
		if((@DiagIdTarg is not null) and  @DiagId <> @DiagIdTarg)
		begin
			RAISERROR ('The name is already used.', 16, 1);
			return -2
		end		
	
		if(@u_name is null)
			update dbo.sysdiagrams set [name] = @new_diagramname, principal_id = @theId where diagram_id = @DiagId
		else
			update dbo.sysdiagrams set [name] = @new_diagramname where diagram_id = @DiagId
		return 0
	END

CREATE PROCEDURE dbo.sp_upgraddiagrams
	AS
	BEGIN
		IF OBJECT_ID(N'dbo.sysdiagrams') IS NOT NULL
			return 0;
	
		CREATE TABLE dbo.sysdiagrams
		(
			name sysname NOT NULL,
			principal_id int NOT NULL,	-- we may change it to varbinary(85)
			diagram_id int PRIMARY KEY IDENTITY,
			version int,
	
			definition varbinary(max)
			CONSTRAINT UK_principal_name UNIQUE
			(
				principal_id,
				name
			)
		);

		/* Add this if we need to have some form of extended properties for diagrams */
		/*
		IF OBJECT_ID(N'dbo.sysdiagram_properties') IS NULL
		BEGIN
			CREATE TABLE dbo.sysdiagram_properties
			(
				diagram_id int,
				name sysname,
				value varbinary(max) NOT NULL
			)
		END
		*/
		IF OBJECT_ID(N'dbo.dtproperties') IS NOT NULL
		begin
			insert into dbo.sysdiagrams
			(
				[name],
				[principal_id],
				[version],
				[definition]
			)
			select	 
				convert(sysname, dgnm.[uvalue]),
				DATABASE_PRINCIPAL_ID(N'dbo'),			-- will change to the sid of sa
				0,							-- zero for old format, dgdef.[version],
				dgdef.[lvalue]
			from dbo.[dtproperties] dgnm
				inner join dbo.[dtproperties] dggd on dggd.[property] = 'DtgSchemaGUID' and dggd.[objectid] = dgnm.[objectid]	
				inner join dbo.[dtproperties] dgdef on dgdef.[property] = 'DtgSchemaDATA' and dgdef.[objectid] = dgnm.[objectid]
				
			where dgnm.[property] = 'DtgSchemaNAME' and dggd.[uvalue] like N'_EA3E6268-D998-11CE-9454-00AA00A3F36E_' 
			return 2;
		end
		return 1;
	END

ALTER TABLE dbo.BankingOrder ADD CONSTRAINT fk_bankingorder_client FOREIGN KEY ( destinationID ) REFERENCES dbo.Client( id ) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE dbo.BankingOrderItems ADD CONSTRAINT fk_bankingorderitems FOREIGN KEY ( BankingOrderID ) REFERENCES dbo.BankingOrder( id ) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE dbo.BankingOrderItems ADD CONSTRAINT fk_bankingorderitems_item FOREIGN KEY ( ItemID ) REFERENCES dbo.Item( id ) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE dbo.ExchangePermission ADD CONSTRAINT fk_exchangepermission FOREIGN KEY ( SourceWarehouseID ) REFERENCES dbo.Warehouse( id ) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE dbo.ExchangePermission ADD CONSTRAINT fk_exchangepermission_Dest FOREIGN KEY ( DestinationWarehouseID ) REFERENCES dbo.Warehouse( id ) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE dbo.ExchangePermission ADD CONSTRAINT fk_exchangepermission_supplier FOREIGN KEY ( SupplierID ) REFERENCES dbo.Supplier( id ) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE dbo.ExchangePermissionItems ADD CONSTRAINT fk_exchangepermissionitems FOREIGN KEY ( ExchangePermissionID ) REFERENCES dbo.ExchangePermission( id ) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE dbo.ExchangePermissionItems ADD CONSTRAINT fk_exchangepermissionitems_forign FOREIGN KEY ( ItemID ) REFERENCES dbo.Item( id ) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE dbo.Item ADD CONSTRAINT fk_item_warehouse FOREIGN KEY ( WarehouseID ) REFERENCES dbo.Warehouse( id ) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE dbo.SupplyPermission ADD CONSTRAINT fk_supplypermission_warehouse FOREIGN KEY ( WarehouseID ) REFERENCES dbo.Warehouse( id ) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE dbo.SupplyPermission ADD CONSTRAINT fk_supplypermission_supplier FOREIGN KEY ( SupplierID ) REFERENCES dbo.Supplier( id ) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE dbo.SupplyPermissionItems ADD CONSTRAINT fk_supplypermissionitems_item FOREIGN KEY ( ItemID ) REFERENCES dbo.Item( id ) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE dbo.SupplyPermissionItems ADD CONSTRAINT fk_supplypermissionitems FOREIGN KEY ( SupplyPermissionID ) REFERENCES dbo.SupplyPermission( id ) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE dbo.Warehouse ADD CONSTRAINT fk_warehouse_warehousekeeper FOREIGN KEY ( WarehouseKeeperID ) REFERENCES dbo.WarehouseKeeper( id ) ON DELETE CASCADE ON UPDATE CASCADE;

