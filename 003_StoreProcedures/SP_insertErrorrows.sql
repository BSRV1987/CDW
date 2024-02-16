Create or alter procedure sp_insertErrorrows
As
BEGIN



--Correction records
With cte_pricing_Per_Contract
as
(
Select contractid,[baseprice],[workingprice] FROM
(
select ct.id as Contractid,Cast(p.price As Decimal(18,2)) As Price,p.productcomponent from Staging.Contracts ct
JOIN staging.prices p on ct.productid=p.productid
where p.valid_until='9999-12-31'
) AS TTP
PIVOT(
sum(Price)
FOR productcomponent in ([baseprice],[workingprice])
) As Pvt
)
,Cte_dataprep as
(
Select p.id,ct.id as contractid,ct.city,ct.status,ct.cancellationreason,ct.usage,ct.usagenet,ppc.[baseprice],ppc.[workingprice],ct.createdat,ct.startdate,ct.enddate,ct.fillingdatecancellation,ct.[month] AccountingPeriod from Staging.Contracts ct
LEFT JOIN cte_pricing_Per_Contract ppc on ct.id=ppc.Contractid
LEFT JOIN CDW.staging.products p on ct.productid=p.id
where p.id is null
)
insert into [Fact].[Contracts_Error](Contract_Id,Product_Id,Region_Id,Status_Id,Cancellationreason_Id,Usage,Usage_Net,[Total_Revenue_LatestPrice],Contract_Created_Date,Start_Date,End_Date,Fillingcancellation_Date,AccountingPeriod,[RecordType],Created_DateTime,Modified_DateTime)
Select cte.contractid,ISNULL(pd.Product_Id,-1),isnull(r.Region_Id,-1),isnull(st.Status_id,-1),isnull(cr.Cancellationreason_Id,-1),cte.usage,cte.usagenet,(cte.[baseprice]+(cast(cte.usagenet as INT)*cte.[workingprice])),cte.createdat,cte.startdate,cte.enddate,cte.fillingdatecancellation,cte.AccountingPeriod,'Correction',getdate(),getdate() from Cte_dataprep cte
LEFT JOIN dim.region r on cte.city=r.city
LEFT JOIN dim.status st on cte.status=st.status
LEFT JOIN dim.Cancellationreason cr on cr.Cancellationreason=cte.Cancellationreason
LEFT JOIN dim.Product pd on pd.id_product=cte.id
LEFT JOIN [Fact].[Contracts_Error] fc on fc.Contract_Id=cte.contractid and fc.AccountingPeriod=cte.AccountingPeriod and fc.RecordType='Correction'-- granularity of the table.
where fc.id is null

END


