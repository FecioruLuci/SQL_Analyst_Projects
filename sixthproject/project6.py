import pandas as pd
import psycopg2
import pymysql
from sqlalchemy import create_engine

df = pd.read_csv(r'C:/Program Files (x86)/vcodestuff/project6\Walmart_SQL_Python/Walmart.csv')

#print(df.head())
#print(df.shape())
#print(df.describe())
#we can see that unit_price has $ sign so it will affect in calculations
#print(df.duplicated().sum())
df.dropna(inplace=True)
df.drop_duplicates(inplace=True)
#print(df.shape)
#print(df.isnull().sum())
df['unit_price'] = df['unit_price'].str.replace('$','').astype(float)
#print(df.head(10))
# removed # sign now we can do calculations
#print(df.info())
#aswell unit_price is float
df['total'] = df['unit_price'] * df['quantity']
#print(df.head(10))
#print(df.shape)
df.to_csv("wallmart_after_python.csv", index=False)

enine_postgresql = create_engine("postgresql+psycopg2://postgres:root@localhost:5432/wallmart")
try:
    enine_postgresql
    print("Connection worked!!")
except:
    print("Connection failed!!")

df.columns = df.columns.str.lower()
#print(df.columns)
df.to_sql("wallmart",con=enine_postgresql, if_exists="append", index=False)
