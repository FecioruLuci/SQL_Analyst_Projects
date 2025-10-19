#Data exploration

import pandas as pd

df = pd.read_csv("SQL\sixthproject\Walmart_SQL_Python\Walmart.csv")
#print(df.shape)
#print(df.describe())
#print(df.info())
#check the type of columns and unit_price is not float so we can use it properly

#print(df.duplicated().sum())
# we found 51 duplicates

#print(df.isnull().sum())
# we also found that we have 31 rows with null

df.dropna(inplace=True)
#print(df.isnull().sum())
#dropped the null rows so i can work easier

df['unit_price'] = df['unit_price'].str.replace("$","").astype(float)

#print(df.info())
#changing the datatype of unit_price into float so we can use the column in the future for calculations

df['total'] = df['unit_price'] * df['quantity']
print(df.head(10))