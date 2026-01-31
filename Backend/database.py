from motor.motor_asyncio import AsyncIOMotorClient
import os
from dotenv import load_dotenv

load_dotenv()

# MongoDB Connection URL from environment variable
MONGO_URI = os.getenv("MONGO_URI", "mongodb://localhost:27017")

client = AsyncIOMotorClient(MONGO_URI)
database = client.astrotech_db
user_collection = database.get_collection("users")
transaction_collection = database.get_collection("transactions")
consultation_collection = database.get_collection("consultations")
