CREATE OR ALTER   procedure [dbo].[sp_insertcontrarows] @CurrentPeriod BIGINT
As
BEGIN

Declare @maxperiod BIGINT

select @maxperiod=max(AccountingPeriod) from Fact.Contracts
where AccountingPeriod<>@CurrentPeriod

If not exists (select 1 from Fact.Contracts where AccountingPeriod=@CurrentPeriod and [RecordType]='Contra') 
Begin
insert into [Fact].[Contracts](Contract_Id,Product_Id,Region_Id,Status_Id,Cancellationreason_Id,Usage,Usage_Net,[Total_Revenue_LatestPrice],Contract_Created_Date,Start_Date,End_Date,Fillingcancellation_Date,AccountingPeriod,[RecordType],Created_DateTime,Modified_DateTime)
Select Contract_Id,Product_Id,Region_Id,Status_Id,Cancellationreason_Id,Usage*-1,Usage_Net*-1,[Total_Revenue_LatestPrice]*-1,Contract_Created_Date,Start_Date,End_Date,Fillingcancellation_Date,@CurrentPeriod,'Contra',Created_DateTime,Modified_DateTime from Fact.Contracts
where AccountingPeriod=@maxperiod and [RecordType]='Correction'
End




END
