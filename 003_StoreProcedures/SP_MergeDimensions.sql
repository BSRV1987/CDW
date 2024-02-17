/*This procedure is designed to Merge source data from staging into Dimensions and facts. Please note points below in terms of historization of data in dimension tables. 

1. Dimensions historization is used as scd type1. 
Which is always replace current value. 
This is for simplicity reason because to acheive what is requested we do not need to maintain dimension history

*/
CREATE OR ALTER PROCEDURE SP_MERGEDIMENSIONs
AS
BEGIN 

--Cancellation Reason
 MERGE [dim].[Cancellationreason] AS tgt
    USING (Select Distinct Cancellationreason,getdate() as dt from staging.contracts) As src
	ON (src.cancellationreason=tgt.Cancellationreason)
 When NOT Matched
	THEN 
		Insert(Cancellationreason,Created_datetime)
		Values(src.Cancellationreason,src.dt);


--Product

 MERGE [dim].[Product] AS tgt
    USING (Select Distinct id,productcode,productname,energy,consumptiontype,deleted,getdate() as dt from staging.products) As src
	ON (src.id=tgt.id_product)
 When NOT Matched
	THEN 
		Insert(id_product,productcode,productname,Product_energy,Product_consumptiontype,Isdeleted,Created_datetime)
		Values(src.id,src.productcode,src.productname,src.energy,src.consumptiontype,src.deleted,src.dt);

--Update changes on product table. scd-1

Update tgt
set tgt.productcode=src.productcode,
tgt.productname=src.productname,
tgt.Product_energy=src.energy,
tgt.Product_consumptiontype=src.consumptiontype,
tgt.Isdeleted=src.deleted,
tgt.[Modified_datetime]=getdate()
from [dim].[Product]  tgt
join staging.products src on tgt.id_product=src.id
where src.productcode<>tgt.productcode OR src.productname<>tgt.productname OR src.energy<>tgt.Product_energy OR src.consumptiontype<>tgt.Product_consumptiontype OR tgt.Isdeleted<>src.deleted



--Region

 MERGE [dim].[Region] AS tgt
    USING (Select Distinct City,'DE' As Country,getdate() as dt from staging.contracts) As src
	ON (src.City=tgt.City)
 When NOT Matched
	THEN 
		Insert(City,Country,Created_datetime)
		Values(src.City,src.Country,src.dt);

--Status

 MERGE [dim].[Status] AS tgt
    USING (Select Distinct [Status],getdate() as dt from staging.contracts) As src
	ON (src.[Status]=tgt.[Status])
 When NOT Matched
	THEN 
		Insert([Status],Created_datetime)
		Values(src.[Status],src.dt);

--price history

--Handle new inserts
 MERGE [dim].[PriceHistory] AS tgt
    USING (Select productid,productcomponent,unit,price,Valid_from,Valid_Until,getdate() as dt from staging.Prices ) As src
	ON (src.productid=tgt.id_product and src.productcomponent=tgt.Product_component and src.price=tgt.price) and  hashbytes('md5',convert(Nvarchar(32),lower(upper(cast(src.unit as Nvarchar(20))))+'|'+
												lower(upper(cast(src.Valid_From as Nvarchar(20))))
		))= tgt.hashdiff


 When NOT Matched
	THEN 
		Insert(id_product,Product_component,price,Unit,Valid_From,Valid_To,hashdiff,Created_datetime)
		Values(src.productid,src.productcomponent,src.price,src.unit,src.Valid_from,src.Valid_Until,
		hashbytes('md5',convert(Nvarchar(32),	lower(upper(cast(src.unit as Nvarchar(20))))+'|'+
												lower(upper(cast(src.Valid_From as Nvarchar(20))))
		))
		
		,src.dt);
--Handle existing updates
Update tgt 
set tgt.unit=src.unit,
	tgt.Valid_From=src.valid_from,
	tgt.Valid_To=src.valid_until,
	tgt.hashdiff=hashbytes('md5',convert(Nvarchar(32),	lower(upper(cast(src.unit as Nvarchar(20))))+'|'+
												lower(upper(cast(src.Valid_From as Nvarchar(20))))
		))
from [dim].[PriceHistory] tgt
JOIN  staging.Prices src on src.productid=tgt.id_product and src.productcomponent=tgt.Product_component and src.price=tgt.price
and  hashbytes('md5',convert(Nvarchar(32),lower(upper(cast(src.unit as Nvarchar(20))))+'|'+
												lower(upper(cast(src.Valid_From as Nvarchar(20))))
		)) = tgt.hashdiff and tgt.Valid_To<>src.valid_until




			   		 	  	  	   
END 



/*

Truncate table [dim].[PriceHistory]

select * from [dim].[PriceHistory]

exec SP_MERGEDIMENSIONs

select * from [dim].[PriceHistory]
*/