import pandas as pd
from sqlalchemy import create_engine


df= pd.read_csv("project12\customer_shopping_behavior.csv")

#print(df.info())
#print(df.isnull().sum())
df['Review Rating'] = df.groupby('Category')['Review Rating'].transform(lambda x: x.fillna(x.median()))
#print(df.isnull().sum())

df.columns = df.columns.str.lower()
df.columns = df.columns.str.replace(' ','_')
#print(df.columns)
# i'll replace purchase ammount to be more clear

df = df.rename(columns={'purchase_amount_(usd)':'purchase_amount'})
#print(df.columns)

thelabel = ['Young Adult', 'Adult', 'Middle-Age', 'Senior']
df['age_group'] = pd.qcut(df['age'], q=4, labels=thelabel)

#print(df[['age','age_group']].head())

# will create a column with int values refering to frequency purchases so it bill be easy to analyse
#print(df['frequency_of_purchases'].unique())
nr_of_frequency = {
    'Fortnightly': 14,
    'Weekly' : 7,
    'Annually' : 365,
    'Quarterly' : 90,
    'Bi-Weekly' : 14,
    'Monthly' : 30,
    'Every 3 Months' : 90
}

df['int_frequency'] = df['frequency_of_purchases'].map(nr_of_frequency)
#print(df['int_frequency'].head())

#print(df.columns)
#print(df[['discount_applied','promo_code_used']].head(30))
#those 2 kinda look the same so i'll check if it's true

#print((df['discount_applied'] == df['promo_code_used']).all())
# they are the same so i'll drop one
df = df.drop('promo_code_used', axis='columns')
#print(df.columns)

#df.to_csv("project12\customer_shopping_behavior_afterpy.csv",index=False)

username = 'postgres'
password = 'root'
host = 'localhost'
port = '5432'
database = 'customer_behavior'

engine = create_engine(f"postgresql+psycopg2://{username}:{password}@{host}:{port}/{database}")
table_name = 'customerr'
df.to_sql(table_name,engine,if_exists='replace',index=False)
print("Data good")

