'''
--------------------------------------------------------------------------------------------------------------------------------------

Name    : Muhammad Septian Zamzani 
Batch   : HCK-21 

Objective   : Program ini dirancang untuk membangun sistem automasi yang akan dijalankan dalam Airflow. Dengan memanfaatkan fitur-fitur yang disediakan oleh Airflow, program ini akan memastikan bahwa workflow dieksekusi secara berurutan sesuai jadwal.

--------------------------------------------------------------------------------------------------------------------------------------
'''

import pandas as pd
from datetime import datetime
from sqlalchemy import create_engine
from airflow import DAG
from airflow.decorators import task
from airflow.operators.empty import EmptyOperator
from airflow.models import Variable
from elasticsearch import Elasticsearch
from elasticsearch import helpers
import pendulum

default_args= {
    'owner': 'zamzani',
    'start_date': pendulum.datetime(2024, 11, 8,tz='Asia/Jakarta')
}

with DAG(
    'milestone_3',                           
    description='from dataset to postgres',  
    schedule_interval='30 6 * * *',           # Jadwal eksekusi DAG: setiap hari pukul 06:30 pagi
    default_args=default_args,             
    catchup=False                           # catchup=False memastikan DAG tidak mengejar jadwal sebelumnya jika ada eksekusi yang terlewat
    ) as dag:
    start = EmptyOperator(task_id='start')
    end = EmptyOperator(task_id='end')


    @task()
    def insert_to_db():
        '''
        Fungsi insert_to_db ini bertujuan untuk membaca data dari file CSV dan menyimpannya ke dalam tabel di database PostgreSQL menggunakan SQLAlchemy
        '''
        # Mendefinisikan nama database, username, password, dan host untuk koneksi ke PostgreSQL
        database = "data_milestone_3"
        username = "milestone_3"
        password = "milestone_3"
        host = "postgres"

        # Membuat URL koneksi PostgreSQL 
        postgres_url = f"postgresql+psycopg2://{username}:{password}@{host}/{database}"

        # Membuat engine SQLAlchemy untuk menghubungkan Python dengan PostgreSQL
        engine = create_engine(postgres_url)
        with engine.connect() as conn:
            # Membaca data dari file CSV ke dalam DataFrame Pandas
            df = pd.read_csv('/opt/airflow/data/P2M3_zamzani_data_raw.csv')

            # Menyimpan DataFrame ke tabel PostgreSQL ('table_m3')
            df.to_sql('table_m3', conn, index=False, if_exists='replace')
        
    @task()
    def get_data():
        '''
        Fungsi ini dibuat untuk mengambil data dari postgre dan menyimpannya kedalam csv
        '''
        # set data 
        database = "data_milestone_3"
        username = "milestone_3"
        password = "milestone_3"
        host = "postgres"

        postgres_url = f"postgresql+psycopg2://{username}:{password}@{host}/{database}"


        # engine to connect into postgre
        engine = create_engine(postgres_url)
        with engine.connect() as conn:

            query = "SELECT * FROM table_m3"
            # mengambil data dari tabel 'table_m3' dan menyimpannya sebagai file CSV
            df = pd.read_sql(query, conn) 
            df.to_csv('/opt/airflow/data/data_postgre.csv', sep=',', index=False)   

    @task()
    def preprocess_data():
        """
        Fungsi ini berfungsi untuk membaca file CSV, melakukan pra-pemrosesan data, dan menyimpan hasilnya ke file baru.
        Data hasil pra-pemrosesan kemudian disimpan ke file CSV baru di path '/opt/airflow/data/P2M3_zamzani_data_clean.csv.

        """
        # Membaca data dari file CSV
        df = pd.read_csv('/opt/airflow/data/data_postgre.csv')
        
        # Menangani missing values dengan mengisi nilai numerik yang hilang menggunakan rata-rata
        df.fillna(df.mean(numeric_only=True), inplace=True)
        
        # Mengonversi kolom 'Date' dan 'Time' menjadi tipe datetime
        df['Date'] = pd.to_datetime(df['Date'], format='%m/%d/%Y')
        df['Time'] = pd.to_datetime(df['Time'], format='%H:%M')

        # Menghapus data duplikat
        df.drop_duplicates(inplace=True)

        # Mengganti nama kolom 'Tax 5%' menjadi 'tax'
        df = df.rename(columns={'Tax 5%': 'tax'})
        
        # Normalisasi nama kolom menjadi lowercase dan mengganti spasi dengan underscore
        df.columns = df.columns.str.lower().str.replace(' ', '_')

        # Mencetak pesan keberhasilan dan tampilan data hasil pra-pemrosesan
        print("Preprocessed data is Success")
        print(df.head())
        
        # Menyimpan data hasil pra-pemrosesan ke file CSV baru
        df.to_csv('/opt/airflow/data/P2M3_zamzani_data_clean.csv', index=False)

    @task
    def send_data_to_elastich_search():
        """
        Mengirim data yang telah diproses ke Elasticsearch untuk diindeks.Pengiriman data ke Elasticsearch akan menggunakan `helpers.bulk`, yang memungkinkan pengiriman data dalam jumlah besar secara efisien.

        """
        # Membuat koneksi ke Elasticsearch
        es = Elasticsearch([{'host': 'elasticsearch-m3', 'port': 9200, 'scheme': 'http'}])

        # Membaca data yang telah dibersihkan
        df = pd.read_csv('/opt/airflow/data/P2M3_zamzani_data_clean.csv')

        # Mengonversi DataFrame menjadi list of dictionaries
        docs = df.to_dict(orient='records')

        # Menyiapkan aksi bulk untuk setiap baris data
        actions = [
            {
                "_index": "milestone",   # Nama indeks di Elasticsearch
                "_type": "doc",          
                "_source": doc           
            }
            for doc in docs
        ]

        # Mengirim data ke Elasticsearch menggunakan bulk helper
        helpers.bulk(es, actions)

            
    start >> insert_to_db() >> get_data() >> preprocess_data() >> send_data_to_elastich_search() >> end