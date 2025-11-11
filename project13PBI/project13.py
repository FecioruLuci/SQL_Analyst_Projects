import pandas as pd

df = pd.read_csv("project13\zepto_v3.csv")
#print(df.head())

#print(df.isnull().sum())
#print(df.info())
df.columns = df.columns.str.lower()
#print(df.head())

df = df.rename(columns={'mrp':'price'})
#print(df.head())

#df.to_csv("project13\zepto_v3python.csv",index=False)

df['price'] = df['price'] / 100
df['discountedsellingprice'] = df['discountedsellingprice'] / 100
#print(df['price'].dtypes)
# converting to rupees
#print(df['price'].dtype)
df.to_csv("project13\zepto_v3pythonv2.csv",index=False)