# CDW
Sample Repository for data modelling , orchestrated using Airflow and environment spun up in Docker. 

# Tables Created

1. [Fact].[Contracts]
2. [dim].[Cancellationreason]
3. [dim].[PriceHistory]
4. [dim].[Product]
5. [dim].[Region]
6. [dim].[Status]
7. [Fact].[Contracts_Error] -- To Move error rows

# Dimensions and facts can be linked using fk's which are identity columns in dimensions

# Fact table is coming from source as accumulated snapshot data. Hence contra corrections are implemented. where every new month data is loaded as correction+ contra rows from pervious month(negation of correction records if previous month exists.)
# Some of the sample questions that are answered from the data model that is created

# Question : 1 Average revenue per contract
select AccountingPeriod,avg(Total_Revenue_LatestPrice) Average_Revenue,Count(*) Total_Contracts from fact.Contracts
where RecordType='Correction'
group by AccountingPeriod
order by 1 

# Result set
AccountingPeriod	Average_Revenue	Total_Contracts
202010	65975.692591	27708
202011	66315.130381	29378
202012	66614.864049	31149
202101	67137.240734	33374


# Question : 2 How many contracts were “in delivery” on 01.01.2021?


select Count(*) Count_of_Contracts_In_Delivery  from fact.Contracts A
JOIN dim.Status B on A.Status_Id=B.Status_Id
where RecordType='Correction' and AccountingPeriod=202101
and B.Status='indelivery'



# Result set
Count_of_Contracts_In_Delivery
19977

# Question : 3 How many new contract were loaded into the DWH on 01.12.2020


select Count(*) Count_of_Contracts_Loaded_20201201  from fact.Contracts A
where RecordType='Correction' and AccountingPeriod=202012


# Result set

Count_of_Contracts_Loaded_20201201
31149



# ETL Pipeline

Airflow dag is available under docker/Airflow section
