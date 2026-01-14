import pandas as pd

df = pd.read_csv(r"C:\Program Files (x86)\vcodestuff\Project19-UberAnalysis\ncr_ride_bookings.csv")

#print(df.head(5))

df.columns = df.columns.str.lower()

#print(df.head(5))
#print(df.columns)

df = df.rename(columns={"booking id":"booking_id",
                        "booking status": "booking_status",
                        "customer id": "customer_id",
                        "avg vtat": "avg_vtat",
                        "avg ctat": "avg_ctat",
                        "cancelled rides by customer": "cancelled_rides_by_customer",
                        "reason for cancelling by customer": "reason_for_cancelling_by_customer",
                        "cancelled rides by driver": "cancelled_rides_by_driver",
                        "driver cancellation reason": "driver_cancellation_reason",
                        "incomplete rides": "incomplete_rides",
                        "incomplete rides reason": "incomplete_rides_reason",
                        "booking value": "booking_value",
                        "ride distance": "ride_distance",
                        "driver ratings": "driver_ratings",
                        "customer rating": "customer_rating",
                        "payment method": "payment_method",
                        "vehicle type": "vehicle_type",
                        "pickup location": "pickup_location",
                        "drop location": "drop_location",
                        "date": "date_created",
                        "time": "time_created"
                        })

#df["incomplete_rides"] = pd.to_numeric(df["incomplete_rides"])
df["incomplete_rides"] = df["incomplete_rides"].fillna(0)
df["incomplete_rides"] = df["incomplete_rides"].astype(int)

df["avg_vtat"] = df["avg_vtat"].fillna(0)
df["avg_ctat"] = df["avg_ctat"].fillna(0)

df["booking_value"] = df["booking_value"].fillna(0)
df["booking_value"] = df["booking_value"].astype(int)

df["ride_distance"] = df["ride_distance"].fillna(0)

df["driver_ratings"] = df["driver_ratings"].fillna(0)

df["customer_rating"] = df["customer_rating"].fillna(0)

df["cancelled_rides_by_driver"] = df["cancelled_rides_by_driver"].fillna(0)
df["cancelled_rides_by_driver"] = df["cancelled_rides_by_driver"].astype(int)

df["cancelled_rides_by_customer"] = df["cancelled_rides_by_customer"].fillna(0)
df["cancelled_rides_by_customer"] = df["cancelled_rides_by_customer"].astype(int)
#print(df.head())
#print(df["incomplete_rides"].head(20))
#print(df["avg_vtat"].head(20))
#df["avg_vtat"] = df["avg_vtat"].str.replace("null", " ")
#print(df["avg_vtat"].head(20))
#print(df.info())

df.to_csv(r"C:\Program Files (x86)\vcodestuff\Project19-UberAnalysis\uber_rides_afterpy.csv", index=False)