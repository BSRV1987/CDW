USE [CDW]
GO
/****** Object:  StoredProcedure [dbo].[SP_MERGEFacts]    Script Date: 17/02/2024 18:18:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*This procedure is designed to Merge source data from staging into Dimensions and facts. Please note points below in terms of historization of data in fact table. 

1.Prices historization is maintained in fact table. There are contra correction rows (Record type dimension) created with valid from and valid to dates of prices

*/
Create or ALTER PROCEDURE [dbo].[SP_MERGEFacts]
AS
BEGIN 



Declare @currentperiod BIGINT

select top 1 @currentperiod=[month] from staging.Contracts


Declare @count int

select @count=count(*) from Fact.Contracts

if @count=0
Begin
--First time load
exec sp_insertCorrectionrows
--Error rows where no dimension data available
exec  sp_insertErrorrows
END 
Else 
Begin
--Correction data which is coming through 
exec sp_insertCorrectionrows
--Contra corrections implemented to cater for cumulative usage data being put through the source. When grouped at latest month for a contract we always latest position of the contract
Exec sp_insertcontrarows @currentperiod
--Error rows where no dimension data available
exec sp_insertErrorrows

END

END 

/*
Truncate table Fact.Contracts
exec [dbo].[SP_MERGEFacts]


*/

