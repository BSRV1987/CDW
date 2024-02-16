/*This procedure is designed to Merge source data from staging into Dimensions and facts. Please note points below in terms of historization of data in fact table. 

1.Prices historization is maintained in fact table. There are contra correction rows (Record type dimension) created with valid from and valid to dates of prices

*/
CREATE PROCEDURE SP_MergeFacts
AS
BEGIN 

SELECT 1

END 