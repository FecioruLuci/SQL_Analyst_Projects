import pandas as pd

df_path = r"C:\Program Files (x86)\vcodestuff\project22_sql_sales\WalmartSalesData.csv.csv"
df_to_path = r"C:\Program Files (x86)\vcodestuff\project22_sql_sales\NewSalesData.csv"
df = pd.read_csv(df_path)
#print(df.head(10))
df = df.rename(columns={"Invoice ID": "invoice_id"})
df = df.rename(columns={"Tax 5%": "tax_5_perc"})
df = df.rename(columns={"gross margin percentage": "gross_margin_percentage"})
df = df.rename(columns={"gross income": "gross_income"})
df = df.rename(columns={"Product line":"product_line"})
df = df.rename(columns={"Unit price":"unit_price"})
df = df.rename(columns={"Customer type":"customer_type"})
df.columns= df.columns.str.lower()


#print(df.info())

df.to_csv(df_to_path,index=False)
