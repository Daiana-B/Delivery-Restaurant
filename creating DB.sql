USE Italian_restaurant
SET XACT_ABORT ON

BEGIN TRANSACTION QUICKDBD

CREATE TABLE [orders] (
    [row_id] int  NOT NULL ,
    [order_id] varchar(10)  NOT NULL ,
    [created_at] datetime  NOT NULL ,
    [item_id] varchar(10)  NOT NULL ,
    [quantity] int  NOT NULL ,
    [cust_id] int  NOT NULL ,
    [add_id] int  NOT NULL ,
    CONSTRAINT [PK_orders] PRIMARY KEY CLUSTERED (
        [row_id] ASC
    )
)

CREATE TABLE [customers] (
    [cust_id] int  NOT NULL ,
    [cust_firstname] varchar(50)  NOT NULL ,
    [cust_lastname] varchar(50)  NOT NULL ,
    CONSTRAINT [PK_customers] PRIMARY KEY CLUSTERED (
        [cust_id] ASC
    )
)

CREATE TABLE [address] (
    [add_id] int  NOT NULL ,
    [delivery_address1] varchar(200)  NOT NULL ,
    [delivery_address2] varchar(200)  NULL ,
    [delivery_city] varchar(50)  NOT NULL ,
    [delivery_zipcode] varchar(20)  NOT NULL ,
    CONSTRAINT [PK_address] PRIMARY KEY CLUSTERED (
        [add_id] ASC
    )
)

CREATE TABLE [item] (
    [item_id] varchar(10)  NOT NULL ,
    [sku] varchar(20)  NOT NULL UNIQUE,
    [item_name] varchar(50)  NOT NULL ,
    [item_cat] varchar(50)  NOT NULL ,
    [item_size] varchar(10)  NOT NULL ,
    [item_price] decimal(5,2)  NOT NULL ,
    CONSTRAINT [PK_item] PRIMARY KEY CLUSTERED (
        [item_id] ASC
    )
)

CREATE TABLE [ingredient] (
    [ing_id] varchar(10)  NOT NULL ,
    [ing_name] varchar(100)  NOT NULL ,
    [ing_weight] int  NOT NULL ,
    [ing_meas] varchar(20)  NOT NULL ,
    [ing_price] decimal(5,2)  NOT NULL ,
    CONSTRAINT [PK_ingredient] PRIMARY KEY CLUSTERED (
        [ing_id] ASC
    )
)

CREATE TABLE [recipe] (
    [row_id] int  NOT NULL ,
    [recipe_id] varchar(20)  NOT NULL ,
    [ing_id] varchar(10)  NOT NULL ,
    [quantity] int NOT NULL ,
    CONSTRAINT [PK_recipe] PRIMARY KEY CLUSTERED (
        [row_id] ASC
    )
)

CREATE TABLE [inventory] (
    [inv_id] int  NOT NULL ,
    [item_id] varchar(10)  NOT NULL ,
    [quantity] int  NOT NULL ,
    CONSTRAINT [PK_inventory] PRIMARY KEY CLUSTERED (
        [inv_id] ASC
    )
)

ALTER TABLE [orders] WITH CHECK ADD CONSTRAINT [FK_orders_item_id] FOREIGN KEY([item_id])
REFERENCES [item] ([item_id])

ALTER TABLE [orders] CHECK CONSTRAINT [FK_orders_item_id]

ALTER TABLE [orders] WITH CHECK ADD CONSTRAINT [FK_orders_cust_id] FOREIGN KEY([cust_id])
REFERENCES [customers] ([cust_id])

ALTER TABLE [orders] CHECK CONSTRAINT [FK_orders_cust_id]

ALTER TABLE [orders] WITH CHECK ADD CONSTRAINT [FK_orders_add_id] FOREIGN KEY([add_id])
REFERENCES [address] ([add_id])

ALTER TABLE [orders] CHECK CONSTRAINT [FK_orders_add_id]

ALTER TABLE [recipe] WITH CHECK ADD CONSTRAINT [FK_recipe_recipe_id] FOREIGN KEY([recipe_id])
REFERENCES [item] ([sku])

ALTER TABLE [recipe] CHECK CONSTRAINT [FK_recipe_recipe_id]

ALTER TABLE [recipe] WITH CHECK ADD CONSTRAINT [FK_recipe_ing_id] FOREIGN KEY([ing_id])
REFERENCES [ingredient] ([ing_id])

ALTER TABLE [recipe] CHECK CONSTRAINT [FK_recipe_ing_id]

ALTER TABLE [inventory] WITH CHECK ADD CONSTRAINT [FK_inventory_item_id] FOREIGN KEY([item_id])
REFERENCES [ingredient] ([ing_id])

ALTER TABLE [inventory] CHECK CONSTRAINT [FK_inventory_item_id]

COMMIT TRANSACTION QUICKDBD