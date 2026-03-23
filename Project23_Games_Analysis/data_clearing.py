import pandas as pd

df = pd.read_csv(r"Project23\Video Games Sales (1980-2024) - Raw.csv")

df["total_sales"] = df["total_sales"].fillna(0)
df["jp_sales"] = df["jp_sales"].fillna(0)
df["pal_sales"] = df["pal_sales"].fillna(0)
df["other_sales"] = df["other_sales"].fillna(0)
df["na_sales"] = df["na_sales"].fillna(0)
df["critic_score"] = df["critic_score"].fillna(df.groupby("developer")["critic_score"].transform("mean"))
df["critic_score"] = df["critic_score"].round(1)
df["release_date"] = pd.to_datetime(df["release_date"],dayfirst=True, errors="coerce")
df["release_date"] = df["release_date"].dt.strftime("%Y-%m-%d")
df["last_update"] = pd.to_datetime(df["last_update"],dayfirst=True, errors="coerce")
df["last_update"] = df["last_update"].dt.strftime("%Y-%m-%d")

#print(df.head(7))

df.to_csv(r"W:\vscode\SQL\Project23\dataset_after_py.csv",index=False)
#print(df.dtypes)