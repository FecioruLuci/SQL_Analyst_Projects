import pandas as pd

df = pd.read_csv("project15\Sample - Superstore.csv",encoding="latin-1")

#print(df.head())
#print(df.info())
#print(df.isna().sum())

df.columns =df.columns.str.lower()
#print(df.head())
df = df.rename(columns={"order id": "order_id",
                        "order date": "order_date",
                        "ship date": "ship_date",
                        "ship mode": "ship_mode",
                        "customer id": "customer_id",
                        "customer name": "customer_name",
                        "postal code": "postal_code",
                        "product id": "product_id",
                        "product name": "product_name",
                        "row id": "row_id",
                        "sub-category": "sub_category"})

#print(df.head())

df["product_name"] = df["product_name"].str.replace("'","",regex=False)
df.to_csv("project15\superstoreafterpy.csv", index=False)
