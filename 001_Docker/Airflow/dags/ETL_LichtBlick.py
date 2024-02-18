from airflow import DAG
from airflow.operators.python import PythonOperator
from airflow.utils.dates import days_ago
from airflow.providers.common.sql.operators.sql import SQLExecuteQueryOperator
import pandas as pd
import sqlalchemy as sa

def read_csv_to_dataframe(csv_file_path, **kwargs):
    df = pd.read_csv(csv_file_path)
    return df

def write_dataframe_to_sqlserver(table_name,**kwargs):
    df = kwargs['ti'].xcom_pull(task_ids='read_csv_to_dataframe_task')
    conn_id = 'airflow_mssql'
    engine = sa.create_engine('mssql+pyodbc://sa:Passw0rd@localhost/CDW?driver=SQL Server Native Client 11.0?trusted_connection=yes?UID')
    df.to_sql(table_name, engine, if_exists='append', index=False)

default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'start_date': days_ago(1),
    'email': ['airflow@example.com'],
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 1,
}

with DAG(
    'csv_to_sqlserver_dag',
    default_args=default_args,
    description='A DAG to read CSV file and write into SQL Server database',
    schedule_interval=None,
    catchup=False,
) as dag:

    read_products_task = PythonOperator(
        task_id='read_Products',
        python_callable=read_csv_to_dataframe,
        op_kwargs={'csv_file_path': "./dags/csv_files/20201001220037_products.csv"},
    )

    write_products_task = PythonOperator(
        task_id='write_Products',
        python_callable=write_dataframe_to_sqlserver,
        op_kwargs={'table_name': "Staging.Products"},
    )

    read_prices_task = PythonOperator(
        task_id='read_Prices',
        python_callable=read_csv_to_dataframe,
        op_kwargs={'csv_file_path': "./dags/csv_files/20201001220039_prices.csv"},
    )

    write_prices_task = PythonOperator(
        task_id='write_prices',
        python_callable=write_dataframe_to_sqlserver,
        op_kwargs={'table_name': "Staging.Prices"},
    )

    read_contracts_task = PythonOperator(
        task_id='read_contracts',
        python_callable=read_csv_to_dataframe,
        op_kwargs={'csv_file_path': "./dags/csv_files/20201001220039_prices.csv"},
    )

    write_contracts_task = PythonOperator(
        task_id='write_contracts',
        python_callable=write_dataframe_to_sqlserver,
        op_kwargs={'table_name': "Staging.Contracts"},
    )

    call_dimensions = SQLExecuteQueryOperator(
        task_id="Load_Dimensions", conn_id="airflow_mssql", sql="./dags/script/Dim.sql"
    )

    call_Fact = SQLExecuteQueryOperator(
        task_id="Load_Fact", conn_id="airflow_mssql", sql="./dags/script/Dim.sql"
    )


    read_products_task >> write_products_task >> read_prices_task >> write_prices_task >> read_contracts_task >> write_contracts_task >> call_dimensions >> call_Fact
