import pandas as pd

df = pd.read_csv(r"C:\Program Files (x86)\vcodestuff\Project18-Toyota_Used_Cars\toyota.csv")

#print(df.head())

df["model"] = df["model"].str.replace(" ", "")
#print(df.head())

df.to_csv(r"C:\Program Files (x86)\vcodestuff\Project18-Toyota_Used_Cars\toyotaafterpy.csv", index=False)