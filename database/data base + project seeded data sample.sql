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

INSERT INTO dbo.Client( id, name, telephone, fax, mobile, mail, website ) VALUES ( 1, 'ahmed mohamed said', '01019451363', 'cairoForFoods-fax', '01019451363', 'cairoFoods@gmail.com', ' ' ); 
INSERT INTO dbo.Client( id, name, telephone, fax, mobile, mail, website ) VALUES ( 2, 'mohamed zakiii', '010321224422', 'mohamed-zaki-fax', '010191282321', 'zaki@gmail.com', ' ' ); 
INSERT INTO dbo.Client( id, name, telephone, fax, mobile, mail, website ) VALUES ( 3, 'khaled ali', '0112233454', 'kahled-ali-nai-fax', '0102233442', 'khaled982@gmail.com', null ); 
INSERT INTO dbo.Supplier( id, name, telephone, fax, mobile, mail, website ) VALUES ( 4, 'ahmed gamal', '0109922334', 'fax-test', '01092837472', 'agemy844@gmail.com', ' ' ); 
INSERT INTO dbo.Supplier( id, name, telephone, fax, mobile, mail, website ) VALUES ( 5, 'mostafa mohamed', '01022334422', 'fax-mostafa@fax', '01022334567', 'mostafa@gmail.com', null ); 
INSERT INTO dbo.WarehouseKeeper( id, name, address, phone, salary ) VALUES ( 601, 'Abel Warren', '308 East White Second Drive', '575-831-1865', 4096 ); 
INSERT INTO dbo.WarehouseKeeper( id, name, address, phone, salary ) VALUES ( 602, 'Erick Valentine', '77 South Green Clarendon Freeway', '014-474-8711', 4378 ); 
INSERT INTO dbo.WarehouseKeeper( id, name, address, phone, salary ) VALUES ( 603, 'Janice Payne', '33 South White Cowley Drive', '353-114-4212', 4378 ); 
INSERT INTO dbo.WarehouseKeeper( id, name, address, phone, salary ) VALUES ( 604, 'Gretchen Mason', '48 North White New Street', '243-556-3888', 4019 ); 
INSERT INTO dbo.WarehouseKeeper( id, name, address, phone, salary ) VALUES ( 605, 'Lawanda Noble', '124 East Rocky Nobel St.', '817-220-5362', 3118 ); 
INSERT INTO dbo.WarehouseKeeper( id, name, address, phone, salary ) VALUES ( 606, 'Robbie Baird', '371 South Green Fabien Way', '221-391-6541', 3037 ); 
INSERT INTO dbo.WarehouseKeeper( id, name, address, phone, salary ) VALUES ( 607, 'Carla Compton', '381 North Green First Avenue', '303-938-7141', 4049 ); 
INSERT INTO dbo.WarehouseKeeper( id, name, address, phone, salary ) VALUES ( 608, 'Heath Stafford', '80 East Green Second Drive', '746-761-7723', 4207 ); 
INSERT INTO dbo.WarehouseKeeper( id, name, address, phone, salary ) VALUES ( 609, 'Kendra Stevenson', '485 North Green Hague Freeway', '387-172-3341', 3227 ); 
INSERT INTO dbo.WarehouseKeeper( id, name, address, phone, salary ) VALUES ( 610, 'Brandie Chase', '67 South Green Second St.', '556-421-4671', 4387 ); 
INSERT INTO dbo.WarehouseKeeper( id, name, address, phone, salary ) VALUES ( 611, 'Rose Kirk', '584 North Green Milton Way', '170-512-9853', 4146 ); 
INSERT INTO dbo.WarehouseKeeper( id, name, address, phone, salary ) VALUES ( 612, 'Ernest Lam', '683 South Green New Drive', '175-870-4441', 3005 ); 
INSERT INTO dbo.WarehouseKeeper( id, name, address, phone, salary ) VALUES ( 613, 'Randal Jackson', '55 South Rocky Hague Blvd.', '178-929-9149', 4105 ); 
INSERT INTO dbo.WarehouseKeeper( id, name, address, phone, salary ) VALUES ( 614, 'Ismael Holt', '652 South Green Hague Street', '637-744-8238', 4434 ); 
INSERT INTO dbo.WarehouseKeeper( id, name, address, phone, salary ) VALUES ( 615, 'Keri Williams', '96 South Green Clarendon Way', '100-278-9931', 4235 ); 
INSERT INTO dbo.WarehouseKeeper( id, name, address, phone, salary ) VALUES ( 616, 'Cameron Miranda', '52 South Green First Avenue', '492-228-1101', 3283 ); 
INSERT INTO dbo.WarehouseKeeper( id, name, address, phone, salary ) VALUES ( 617, 'Roberta Harrison', '92 South Green Clarendon Drive', '662-403-4802', 3489 ); 
INSERT INTO dbo.WarehouseKeeper( id, name, address, phone, salary ) VALUES ( 618, 'Colby Wilkerson', '64 West Green Milton Boulevard', '733-863-5454', 4127 ); 
INSERT INTO dbo.WarehouseKeeper( id, name, address, phone, salary ) VALUES ( 619, 'Cornelius Johnson', '501 South Green Second Boulevard', '515-135-4572', 3421 ); 
INSERT INTO dbo.WarehouseKeeper( id, name, address, phone, salary ) VALUES ( 620, 'Teddy Hoover', '86 East Green Nobel St.', '210-356-4627', 3345 ); 
INSERT INTO dbo.WarehouseKeeper( id, name, address, phone, salary ) VALUES ( 621, 'Lillian Duran', '571 North Rocky Old Blvd.', '150-871-8337', 4211 ); 
INSERT INTO dbo.WarehouseKeeper( id, name, address, phone, salary ) VALUES ( 622, 'Dianna Oliver', '48 East Green New Drive', '556-225-3401', 4139 ); 
INSERT INTO dbo.WarehouseKeeper( id, name, address, phone, salary ) VALUES ( 623, 'Geoffrey Aguirre', '918 North Green Second Freeway', '545-476-7669', 4172 ); 
INSERT INTO dbo.WarehouseKeeper( id, name, address, phone, salary ) VALUES ( 624, 'Melissa Atkinson', '226 West Green Hague Boulevard', '326-814-3382', 4340 ); 
INSERT INTO dbo.WarehouseKeeper( id, name, address, phone, salary ) VALUES ( 625, 'Moses Downs', '820 North White Clarendon St.', '786-474-5563', 3786 ); 
INSERT INTO dbo.WarehouseKeeper( id, name, address, phone, salary ) VALUES ( 626, 'Franklin Jones', '267 West Rocky Old Boulevard', '729-510-4508', 3077 ); 
INSERT INTO dbo.WarehouseKeeper( id, name, address, phone, salary ) VALUES ( 627, 'Arlene Andersen', '933 South White Milton Blvd.', '843-875-1852', 3520 ); 
INSERT INTO dbo.WarehouseKeeper( id, name, address, phone, salary ) VALUES ( 628, 'Kathleen Novak', '83 South Rocky Old Road', '669-783-4409', 3720 ); 
INSERT INTO dbo.WarehouseKeeper( id, name, address, phone, salary ) VALUES ( 629, 'Sheldon Stuart', '625 East Green Nobel Parkway', '554-526-6327', 4360 ); 
INSERT INTO dbo.WarehouseKeeper( id, name, address, phone, salary ) VALUES ( 630, 'Ivan Humphrey', '73 South White Second Road', '874-568-5783', 3856 ); 
INSERT INTO dbo.WarehouseKeeper( id, name, address, phone, salary ) VALUES ( 631, 'Andre Bush', '958 North Green Oak Avenue', '331-728-8295', 3837 ); 
INSERT INTO dbo.WarehouseKeeper( id, name, address, phone, salary ) VALUES ( 632, 'Joni Roberts', '748 South White Hague Freeway', '543-818-3746', 3858 ); 
INSERT INTO dbo.WarehouseKeeper( id, name, address, phone, salary ) VALUES ( 633, 'Rex Galloway', '27 East Green Nobel Freeway', '820-245-1863', 4346 ); 
INSERT INTO dbo.WarehouseKeeper( id, name, address, phone, salary ) VALUES ( 634, 'Dwight Patton', '41 South Green Old Drive', '965-549-5371', 3322 ); 
INSERT INTO dbo.WarehouseKeeper( id, name, address, phone, salary ) VALUES ( 635, 'Lucas Rivers', '405 South Green Second Way', '728-583-8277', 3485 ); 
INSERT INTO dbo.WarehouseKeeper( id, name, address, phone, salary ) VALUES ( 636, 'Arnold French', '16 West Green Nobel Drive', '807-427-9358', 3222 ); 
INSERT INTO dbo.WarehouseKeeper( id, name, address, phone, salary ) VALUES ( 637, 'Kristen Wilson', '33 East Green Oak Street', '574-154-7847', 4021 ); 
INSERT INTO dbo.WarehouseKeeper( id, name, address, phone, salary ) VALUES ( 638, 'Bobbi Haynes', '55 South Green Old Road', '066-537-4881', 4405 ); 
INSERT INTO dbo.WarehouseKeeper( id, name, address, phone, salary ) VALUES ( 639, 'Carl Nunez', '26 East Green Fabien Freeway', '437-827-9152', 3843 ); 
INSERT INTO dbo.WarehouseKeeper( id, name, address, phone, salary ) VALUES ( 640, 'Frances Keller', '39 North White First Way', '566-941-6061', 3439 ); 
INSERT INTO dbo.WarehouseKeeper( id, name, address, phone, salary ) VALUES ( 641, 'Elena Huber', '764 West Green Milton Parkway', '730-794-3243', 4220 ); 
INSERT INTO dbo.WarehouseKeeper( id, name, address, phone, salary ) VALUES ( 642, 'Luz Olson', '168 West Green Hague Freeway', '347-863-5743', 3503 ); 
INSERT INTO dbo.WarehouseKeeper( id, name, address, phone, salary ) VALUES ( 643, 'Jami Cuevas', '327 South White First Blvd.', '868-246-6481', 4083 ); 
INSERT INTO dbo.WarehouseKeeper( id, name, address, phone, salary ) VALUES ( 644, 'Ruth Simmons', '62 North Rocky Clarendon Road', '653-474-6213', 3925 ); 
INSERT INTO dbo.WarehouseKeeper( id, name, address, phone, salary ) VALUES ( 645, 'Noah Nolan', '84 North Rocky Old Avenue', '882-773-4462', 4075 ); 
INSERT INTO dbo.WarehouseKeeper( id, name, address, phone, salary ) VALUES ( 646, 'Emma Anthony', '258 East Green Hague Drive', '543-928-8165', 3086 ); 
INSERT INTO dbo.WarehouseKeeper( id, name, address, phone, salary ) VALUES ( 647, 'Damien Massey', '376 North White Hague Road', '245-307-2285', 3676 ); 
INSERT INTO dbo.WarehouseKeeper( id, name, address, phone, salary ) VALUES ( 648, 'Caroline Nash', '65 West White Fabien Road', '267-685-4105', 3800 ); 
INSERT INTO dbo.WarehouseKeeper( id, name, address, phone, salary ) VALUES ( 649, 'Elisabeth Cole', '51 North White New Drive', '742-998-1944', 3935 ); 
INSERT INTO dbo.WarehouseKeeper( id, name, address, phone, salary ) VALUES ( 650, 'Morgan Simon', '962 South Green First Way', '837-002-5787', 4033 ); 
INSERT INTO dbo.WarehouseKeeper( id, name, address, phone, salary ) VALUES ( 651, 'Clifford Diaz', '341 North White Second Boulevard', '217-031-0412', 4297 ); 
INSERT INTO dbo.WarehouseKeeper( id, name, address, phone, salary ) VALUES ( 652, 'Guadalupe Pena', '90 North White Milton Blvd.', '148-458-6842', 3756 ); 
INSERT INTO dbo.WarehouseKeeper( id, name, address, phone, salary ) VALUES ( 653, 'Sophia Arnold', '43 South Rocky Nobel Way', '133-593-3146', 3748 ); 
INSERT INTO dbo.WarehouseKeeper( id, name, address, phone, salary ) VALUES ( 654, 'Angela Horn', '618 South Green Clarendon Freeway', '779-532-9540', 4095 ); 
INSERT INTO dbo.WarehouseKeeper( id, name, address, phone, salary ) VALUES ( 655, 'Byron Allen', '761 South White Milton Freeway', '027-306-4129', 4251 ); 
INSERT INTO dbo.WarehouseKeeper( id, name, address, phone, salary ) VALUES ( 656, 'Jesse Glover', '289 North Rocky Fabien Parkway', '752-357-1188', 3652 ); 
INSERT INTO dbo.WarehouseKeeper( id, name, address, phone, salary ) VALUES ( 657, 'Paige Cooper', '512 East Green First Blvd.', '507-045-1530', 3245 ); 
INSERT INTO dbo.WarehouseKeeper( id, name, address, phone, salary ) VALUES ( 658, 'Herman Williamson', '61 East Green Hague Way', '687-500-3279', 3987 ); 
INSERT INTO dbo.WarehouseKeeper( id, name, address, phone, salary ) VALUES ( 659, 'Clarissa Giles', '87 North Green New Blvd.', '713-334-1078', 3572 ); 
INSERT INTO dbo.WarehouseKeeper( id, name, address, phone, salary ) VALUES ( 660, 'Loretta Mueller', '28 South Green Nobel Parkway', '106-514-5712', 3682 ); 
INSERT INTO dbo.WarehouseKeeper( id, name, address, phone, salary ) VALUES ( 661, 'Austin Rivas', '37 North White Nobel Freeway', '477-331-9912', 4243 ); 
INSERT INTO dbo.WarehouseKeeper( id, name, address, phone, salary ) VALUES ( 662, 'Deana Kline', '71 South Green Clarendon Way', '691-440-5932', 3089 ); 
INSERT INTO dbo.WarehouseKeeper( id, name, address, phone, salary ) VALUES ( 663, 'William Stout', '520 North Green Second Blvd.', '520-867-5550', 4256 ); 
INSERT INTO dbo.WarehouseKeeper( id, name, address, phone, salary ) VALUES ( 664, 'Bridgett Woodard', '444 South Rocky Clarendon Drive', '287-469-3050', 3655 ); 
INSERT INTO dbo.WarehouseKeeper( id, name, address, phone, salary ) VALUES ( 665, 'Tamiko Novak', '581 South Green Milton Drive', '532-330-2852', 3771 ); 
INSERT INTO dbo.WarehouseKeeper( id, name, address, phone, salary ) VALUES ( 666, 'Irma Arnold', '42 North Green Cowley Parkway', '814-211-8063', 3456 ); 
INSERT INTO dbo.WarehouseKeeper( id, name, address, phone, salary ) VALUES ( 667, 'Kellie Galvan', '889 South White New Road', '973-756-3870', 3956 ); 
INSERT INTO dbo.WarehouseKeeper( id, name, address, phone, salary ) VALUES ( 668, 'Alex Rowland', '30 North White First Blvd.', '443-634-8238', 4075 ); 
INSERT INTO dbo.WarehouseKeeper( id, name, address, phone, salary ) VALUES ( 669, 'Whitney Jennings', '13 East Rocky Nobel Street', '023-744-5479', 3563 ); 
INSERT INTO dbo.WarehouseKeeper( id, name, address, phone, salary ) VALUES ( 670, 'Marc Pope', '723 South Rocky Milton Freeway', '527-714-0217', 3373 ); 
INSERT INTO dbo.WarehouseKeeper( id, name, address, phone, salary ) VALUES ( 671, 'Dwayne Flynn', '551 North Green New Way', '831-799-7335', 4105 ); 
INSERT INTO dbo.WarehouseKeeper( id, name, address, phone, salary ) VALUES ( 672, 'Theodore Melton', '18 East White Old Drive', '051-882-7377', 4015 ); 
INSERT INTO dbo.WarehouseKeeper( id, name, address, phone, salary ) VALUES ( 673, 'Jayson Shields', '865 North Green New Parkway', '765-564-0017', 4207 ); 
INSERT INTO dbo.WarehouseKeeper( id, name, address, phone, salary ) VALUES ( 674, 'Lauren Spencer', '963 North Green Oak Blvd.', '177-416-8431', 3037 ); 
INSERT INTO dbo.WarehouseKeeper( id, name, address, phone, salary ) VALUES ( 675, 'Tim Taylor', '56 North Rocky New Road', '858-229-0433', 3674 ); 
INSERT INTO dbo.WarehouseKeeper( id, name, address, phone, salary ) VALUES ( 676, 'Omar Sanders', '127 West Green Second Way', '971-270-3275', 3025 ); 
INSERT INTO dbo.WarehouseKeeper( id, name, address, phone, salary ) VALUES ( 677, 'Darla Dalton', '20 North Green First Avenue', '595-317-6295', 3371 ); 
INSERT INTO dbo.WarehouseKeeper( id, name, address, phone, salary ) VALUES ( 678, 'Melisa Li', '32 South Green New Boulevard', '628-624-2188', 3064 ); 
INSERT INTO dbo.WarehouseKeeper( id, name, address, phone, salary ) VALUES ( 679, 'Ron George', '692 West White Clarendon Blvd.', '202-430-7092', 3222 ); 
INSERT INTO dbo.WarehouseKeeper( id, name, address, phone, salary ) VALUES ( 680, 'Heidi Petty', '65 North Green Clarendon Parkway', '042-337-0735', 4175 ); 
INSERT INTO dbo.WarehouseKeeper( id, name, address, phone, salary ) VALUES ( 681, 'Judith Kane', '18 South Green Milton Freeway', '344-767-5135', 3161 ); 
INSERT INTO dbo.WarehouseKeeper( id, name, address, phone, salary ) VALUES ( 682, 'Wallace Savage', '557 East Green Clarendon Avenue', '886-401-7797', 4470 ); 
INSERT INTO dbo.WarehouseKeeper( id, name, address, phone, salary ) VALUES ( 683, 'Luz Gregory', '256 West White Hague Road', '247-217-1052', 4013 ); 
INSERT INTO dbo.WarehouseKeeper( id, name, address, phone, salary ) VALUES ( 684, 'Cari Dillon', '72 South Green New Avenue', '068-556-1697', 3736 ); 
INSERT INTO dbo.WarehouseKeeper( id, name, address, phone, salary ) VALUES ( 685, 'Regina Blackburn', '80 South White Second St.', '172-316-1606', 4150 ); 
INSERT INTO dbo.WarehouseKeeper( id, name, address, phone, salary ) VALUES ( 686, 'Latanya King', '22 West Green Hague Street', '661-524-8282', 3950 ); 
INSERT INTO dbo.WarehouseKeeper( id, name, address, phone, salary ) VALUES ( 687, 'Rudy Mc Knight', '28 East White Fabien Freeway', '776-341-2736', 3731 ); 
INSERT INTO dbo.WarehouseKeeper( id, name, address, phone, salary ) VALUES ( 688, 'Lewis Maxwell', '85 North Green Hague Freeway', '451-526-6241', 4406 ); 
INSERT INTO dbo.WarehouseKeeper( id, name, address, phone, salary ) VALUES ( 689, 'Jasmine Padilla', '482 North Rocky Clarendon Road', '359-825-4791', 4034 ); 
INSERT INTO dbo.WarehouseKeeper( id, name, address, phone, salary ) VALUES ( 690, 'Laura Caldwell', '587 East Green New Boulevard', '724-403-1198', 3371 ); 
INSERT INTO dbo.WarehouseKeeper( id, name, address, phone, salary ) VALUES ( 691, 'Dustin Clements', '32 East Green Clarendon St.', '843-480-5013', 3809 ); 
INSERT INTO dbo.WarehouseKeeper( id, name, address, phone, salary ) VALUES ( 692, 'Julian Heath', '30 South Rocky Hague Freeway', '346-112-6347', 3995 ); 
INSERT INTO dbo.WarehouseKeeper( id, name, address, phone, salary ) VALUES ( 693, 'Kirsten Dickerson', '71 North Green Milton Road', '600-895-3895', 4268 ); 
INSERT INTO dbo.WarehouseKeeper( id, name, address, phone, salary ) VALUES ( 694, 'Rickey Doyle', '34 North Green Hague Way', '508-287-7682', 3147 ); 
INSERT INTO dbo.WarehouseKeeper( id, name, address, phone, salary ) VALUES ( 695, 'Wesley Nichols', '36 South Green First Drive', '612-600-7319', 4010 ); 
INSERT INTO dbo.WarehouseKeeper( id, name, address, phone, salary ) VALUES ( 696, 'Brent Hanson', '510 North Rocky Milton Parkway', '249-160-6959', 3503 ); 
INSERT INTO dbo.WarehouseKeeper( id, name, address, phone, salary ) VALUES ( 697, 'Kurt Wade', '769 South White Milton St.', '742-475-5735', 3258 ); 
INSERT INTO dbo.WarehouseKeeper( id, name, address, phone, salary ) VALUES ( 698, 'Sonya Watkins', '23 North Rocky Cowley Drive', '241-285-5415', 4313 ); 
INSERT INTO dbo.WarehouseKeeper( id, name, address, phone, salary ) VALUES ( 699, 'Cassandra Fischer', '557 East Green First Way', '728-222-3711', 4158 ); 
INSERT INTO dbo.WarehouseKeeper( id, name, address, phone, salary ) VALUES ( 700, 'Bobbie Hill', '311 South Green New Way', '028-701-9470', 4101 ); 
INSERT INTO dbo.sysdiagrams( name, principal_id, diagram_id, version, definition ) VALUES ( 'dbDiagram', 1, 1, 1, '[B@14a94514' ); 
INSERT INTO dbo.BankingOrder( id, createdAt, updatedAt, destinationID, confirmed, totalMonery ) VALUES ( 3, '2022-03-30', '2022-03-30', 3, 1, 409000 ); 
INSERT INTO dbo.BankingOrder( id, createdAt, updatedAt, destinationID, confirmed, totalMonery ) VALUES ( 4, '2022-03-30', '2022-03-30', 1, 1, 29000000 ); 
INSERT INTO dbo.Warehouse( id, name, address, WarehouseKeeperID ) VALUES ( 1, 'test warehouse', 'Tanta', 601 ); 
INSERT INTO dbo.Warehouse( id, name, address, WarehouseKeeperID ) VALUES ( 2, 'test warehouse 2', 'Tanta', 604 ); 
INSERT INTO dbo.Warehouse( id, name, address, WarehouseKeeperID ) VALUES ( 3, 'test warehouse 3', 'Cairo', 605 ); 
INSERT INTO dbo.Warehouse( id, name, address, WarehouseKeeperID ) VALUES ( 4, 'test warhouse 4', 'Cairo', 607 ); 
INSERT INTO dbo.Warehouse( id, name, address, WarehouseKeeperID ) VALUES ( 5, 'test warhouse 5', 'Tanta', 611 ); 
INSERT INTO dbo.Warehouse( id, name, address, WarehouseKeeperID ) VALUES ( 6, 'test warehouse 6', 'Tanta', 617 ); 
INSERT INTO dbo.Warehouse( id, name, address, WarehouseKeeperID ) VALUES ( 7, 'CairoWarehouse', 'Cairo', 637 ); 
INSERT INTO dbo.Item( id, name, MeasureUnit, PricePerUnit, WarehouseID ) VALUES ( 7, 'Playstation 5', 'unit', 15900, 6 ); 
INSERT INTO dbo.Item( id, name, MeasureUnit, PricePerUnit, WarehouseID ) VALUES ( 8, 'Xbox one', 'unit', 10000, 6 ); 
INSERT INTO dbo.Item( id, name, MeasureUnit, PricePerUnit, WarehouseID ) VALUES ( 9, 'Xbox 360', 'unit', 9000, 6 ); 
INSERT INTO dbo.Item( id, name, MeasureUnit, PricePerUnit, WarehouseID ) VALUES ( 10, 'Sugar', 'Ton', 1000000, 7 ); 
INSERT INTO dbo.Item( id, name, MeasureUnit, PricePerUnit, WarehouseID ) VALUES ( 11, 'Salt', 'Ton', 90000, 7 ); 
INSERT INTO dbo.SupplyPermission( id, WarehouseID, SupplierID, CreatedAt, updatedAt, confirmed ) VALUES ( 10, 6, 4, '2022-03-30', '2022-03-30', 1 ); 
INSERT INTO dbo.SupplyPermission( id, WarehouseID, SupplierID, CreatedAt, updatedAt, confirmed ) VALUES ( 11, 7, 5, '2022-03-30', '2022-03-30', 1 ); 
INSERT INTO dbo.SupplyPermissionItems( id, SupplyPermissionID, ItemID, Quantity, ProducationDate, ExpireDate ) VALUES ( 6, 10, 7, 980, '2022-03-30', '2024-03-30' ); 
INSERT INTO dbo.SupplyPermissionItems( id, SupplyPermissionID, ItemID, Quantity, ProducationDate, ExpireDate ) VALUES ( 7, 10, 8, 950, '2022-03-30', '2027-03-30' ); 
INSERT INTO dbo.SupplyPermissionItems( id, SupplyPermissionID, ItemID, Quantity, ProducationDate, ExpireDate ) VALUES ( 8, 10, 9, 250, '2022-03-30', '2023-03-16' ); 
INSERT INTO dbo.SupplyPermissionItems( id, SupplyPermissionID, ItemID, Quantity, ProducationDate, ExpireDate ) VALUES ( 9, 11, 10, 780, '2022-03-30', '2025-06-19' ); 
INSERT INTO dbo.SupplyPermissionItems( id, SupplyPermissionID, ItemID, Quantity, ProducationDate, ExpireDate ) VALUES ( 10, 11, 11, 700, '2022-03-30', '2026-12-23' ); 
INSERT INTO dbo.BankingOrderItems( id, BankingOrderID, ItemID, Quantity, ProductionDate, ExpireDate ) VALUES ( 1, 3, 7, 10, '2022-03-30', '2024-03-30' ); 
INSERT INTO dbo.BankingOrderItems( id, BankingOrderID, ItemID, Quantity, ProductionDate, ExpireDate ) VALUES ( 2, 3, 8, 5, '2022-03-30', '2027-03-30' ); 
INSERT INTO dbo.BankingOrderItems( id, BankingOrderID, ItemID, Quantity, ProductionDate, ExpireDate ) VALUES ( 3, 3, 8, 20, '2022-03-30', '2027-03-30' ); 
INSERT INTO dbo.BankingOrderItems( id, BankingOrderID, ItemID, Quantity, ProductionDate, ExpireDate ) VALUES ( 4, 4, 10, 20, '2022-03-30', '2025-06-19' ); 
INSERT INTO dbo.BankingOrderItems( id, BankingOrderID, ItemID, Quantity, ProductionDate, ExpireDate ) VALUES ( 5, 4, 11, 100, '2022-03-30', '2026-12-23' ); 
