import pandas as pd

df = pd.read_csv(r"W:\vscode\SQL\proejct17_Codvid\CVD_cleaned.csv")

#print(df.head())
df.columns = df.columns.str.lower()
#print(df.columns)

df.rename(columns={"height_(cm)" : "heightcm"},inplace=True)
df.rename(columns={"weight_(kg)" : "weightkg"},inplace=True)
#print(df.columns)
#df.to_csv(r"W:\vscode\SQL\proejct17_Codvid\covidnew.csv",index=False)
#print(df["diabetes"].unique())
df["diabetes"] = df["diabetes"].replace({"No, pre-diabetes or borderline diabetes" : "pre-diabetes"})
df["diabetes"] = df["diabetes"].replace({"Yes, but female told only during pregnancy" : "yes-pregnancy"})

#print(df["diabetes"].unique())

#print(df["heightcm"].info())

#print(df.info())
df["heightcm"] = df["heightcm"].astype(int)
#print(df["heightcm"].info())

df["alcohol_consumption"] = df["alcohol_consumption"].astype(int)
df["fruit_consumption"] = df["fruit_consumption"].astype(int)
df["green_vegetables_consumption"] =df["green_vegetables_consumption"].astype(int)
df["friedpotato_consumption"] = df["friedpotato_consumption"].astype(int)
#print(df.info())
df.to_csv(r"W:\vscode\SQL\proejct17_Codvid\covidnew.csv",index=False)