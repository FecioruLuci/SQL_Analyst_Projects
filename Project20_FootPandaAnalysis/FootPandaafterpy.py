import pandas as pd

df = pd.read_csv(r"W:\vscode\SQL\Project20_Digital_Learning_Analytics\Foodpanda Analysis Dataset.csv")
#print(df.head(5))

#print(df.head(5))

mapping = {
    "Adult" : 35,
    "Senior": 45,
    "Teenager": 25
}

df["age_int"] = df["age"].map(mapping)

#print(df.head(5))

df.to_csv(r"W:\vscode\SQL\Project20_Digital_Learning_Analytics\foodpandaafterpy.csv",index=False)
