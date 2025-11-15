import pandas as pd

df = pd.read_csv("project16-SmartphoneMarket\Global_Mobile_Prices_2025_Extended.csv")
#print(df.head())

df.rename(columns={"5g_support": "fiveg_support"},inplace=True)
#print(df.head())

df.to_csv("project16-SmartphoneMarket\Phones.csv",index=False)

