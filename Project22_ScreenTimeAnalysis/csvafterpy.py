import pandas as pd

dataset = pd.read_csv(f"Project_22_ScreenTimeAnalysis\Smartphone_Usage_Productivity_Dataset_50000.csv")
dataset.columns = dataset.columns.str.lower()
dataset["daily_phone_hours"] = dataset["daily_phone_hours"].round()
dataset["daily_phone_hours"] = dataset["daily_phone_hours"].astype(int)

dataset["social_media_hours"] = dataset["social_media_hours"].round()
dataset["social_media_hours"] = dataset["social_media_hours"].astype(int)

dataset["sleep_hours"] = dataset["sleep_hours"].round()
dataset["sleep_hours"] = dataset["sleep_hours"].astype(int)

dataset["weekend_screen_time_hours"] = dataset["weekend_screen_time_hours"].round()
dataset["weekend_screen_time_hours"] = dataset["weekend_screen_time_hours"].astype(int)

"""
'user_id', 'age', 'gender', 'occupation', 'device_type',
       'daily_phone_hours', 'social_media_hours', 'work_productivity_score',
       'sleep_hours', 'stress_level', 'app_usage_count',
       'caffeine_intake_cups', 'weekend_screen_time_hours'
"""

print(dataset.head(10))
#dataset.to_csv(f"Project_22_ScreenTimeAnalysis\datasetafterpy.csv",index=False)