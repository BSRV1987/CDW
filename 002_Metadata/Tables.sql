GO
/**Object Fact***/ 
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Fact].[Contracts](
	[Id] INT identity(1,1),
	[Product_Id] INT,
	[Region_Id] INT,
	[Status_Id] INT,
	[PriceComponent_Id] INT,
	[Cancellationreason_Id] INT,
	[Usage] BIGINT,
	[Usage_Net] BIGINT,
	[Price] DECIMAL(18,2),
	[Valid_From_Date] DATE,
	[Valid_Until_Date] DATE,
	[Contract_Created_Date] DATE,
	[Start_Date] DATE,
	[End_Date] DATE,
	[Fillingcancellation_Date] DATE,
	[Record_Type_Id] INT,
	[AccountingPeriod] INT,
	[Created_DateTime] DATETIME,
	[Modified_DateTime] DATETIME,
	CONSTRAINT PK_dim_CRID PRIMARY KEY CLUSTERED ([Id])
) ON [PRIMARY]
GO
/****** Object:  Table [dim].[Cancellationreason]    Script Date: 16/02/2024 10:36:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dim].[Cancellationreason](
	[Cancellationreason_Id] [int] IDENTITY(1,1) NOT NULL,
	[Cancellationreason] [varchar](500) NULL,
	[Created_datetime] [datetime] NULL,
 CONSTRAINT [PK_dim_CRID] PRIMARY KEY CLUSTERED 
(
	[Cancellationreason_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dim].[PriceComponent]    Script Date: 16/02/2024 10:36:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dim].[PriceComponent](
	[PriceComponent_Id] [int] IDENTITY(1,1) NOT NULL,
	[Component] [varchar](50) NULL,
	[Unit] [varchar](50) NULL,
	[Created_datetime] [datetime] NULL,
 CONSTRAINT [PK_dim_PriceComponent] PRIMARY KEY CLUSTERED 
(
	[PriceComponent_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dim].[Product]    Script Date: 16/02/2024 10:36:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dim].[Product](
	[Product_Id] [int] IDENTITY(1,1) NOT NULL,
	[productcode] [varchar](50) NULL,
	[productname] [varchar](50) NULL,
	[Product_energy] [varchar](50) NULL,
	[Product_consumptiontype] [varchar](50) NULL,
	[Isdeleted] [varchar](50) NULL,
	[Created_datetime] [datetime] NULL,
 CONSTRAINT [PK_dim_product] PRIMARY KEY CLUSTERED 
(
	[Product_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dim].[Region]    Script Date: 16/02/2024 10:36:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dim].[Region](
	[Region_Id] [int] IDENTITY(1,1) NOT NULL,
	[City] [varchar](100) NULL,
	[country] [varchar](100) NULL,
	[Created_datetime] [datetime] NOT NULL,
 CONSTRAINT [PK_dim_city] PRIMARY KEY CLUSTERED 
(
	[Region_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dim].[Status]    Script Date: 16/02/2024 10:36:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dim].[Status](
	[Status_Id] [int] IDENTITY(1,1) NOT NULL,
	[Status] [varchar](100) NULL,
	[Created_datetime] [datetime] NULL,
 CONSTRAINT [PK_dim_status] PRIMARY KEY CLUSTERED 
(
	[Status_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/*****/
CREATE TABLE [dim].[RecordType](
	[RecordType_Id] [int] IDENTITY(1,1) NOT NULL,
	[Description] [varchar](100) NULL,
	[Created_datetime] [datetime] NULL,
 CONSTRAINT [PK_dim_RT] PRIMARY KEY CLUSTERED 
(
	[RecordType_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO



/****** Object:  Table [staging].[Contracts]    Script Date: 16/02/2024 10:36:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [staging].[Contracts](
	[id] [varchar](50) NULL,
	[type] [varchar](50) NULL,
	[energy] [varchar](50) NULL,
	[usage] [varchar](50) NULL,
	[usagenet] [varchar](50) NULL,
	[createdat] [varchar](50) NULL,
	[startdate] [varchar](50) NULL,
	[enddate] [varchar](50) NULL,
	[fillingdatecancellation] [varchar](50) NULL,
	[cancellationreason] [varchar](500) NULL,
	[city] [varchar](50) NULL,
	[status] [varchar](50) NULL,
	[productid] [varchar](50) NULL,
	[modificationdate] [varchar](50) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [staging].[Prices]    Script Date: 16/02/2024 10:36:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [staging].[Prices](
	[id] [varchar](50) NULL,
	[productid] [varchar](50) NULL,
	[pricecomponentid] [varchar](50) NULL,
	[productcomponent] [varchar](50) NULL,
	[price] [varchar](50) NULL,
	[unit] [varchar](50) NULL,
	[valid_from] [varchar](50) NULL,
	[valid_until] [varchar](50) NULL,
	[modificationdate] [varchar](50) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [staging].[Products]    Script Date: 16/02/2024 10:36:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [staging].[Products](
	[id] [varchar](50) NULL,
	[productcode] [varchar](50) NULL,
	[productname] [varchar](50) NULL,
	[energy] [varchar](50) NULL,
	[consumptiontype] [varchar](50) NULL,
	[deleted] [varchar](50) NULL,
	[modificationdate] [varchar](50) NULL
) ON [PRIMARY]
GO
USE [master]
GO
ALTER DATABASE [CDW] SET  READ_WRITE 
GO
