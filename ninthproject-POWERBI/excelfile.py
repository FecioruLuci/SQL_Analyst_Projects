import pandas as pd

df = pd.read_csv("drive-download-20251025T200047Z-1-001\pizza_sales.csv")
pd.set_option('display.max_rows', None)
#print(df['order_date'].head())
df['order_date'] = pd.to_datetime(df['order_date'], format='%d-%m-%Y').dt.strftime('%Y/%m/%d')
print(df.head())

df.to_csv("drive-download-20251025T200047Z-1-001\pizza_sales3.csv", index=False)