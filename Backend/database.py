import os
from typing import Any, Dict, Optional
from uuid import uuid4

from dotenv import load_dotenv

try:
    from motor.motor_asyncio import AsyncIOMotorClient
    import certifi
except Exception:  # pragma: no cover
    AsyncIOMotorClient = None
    certifi = None

load_dotenv()

MONGO_URI = os.getenv("MONGO_URI", "mongodb://localhost:27017")


class MemoryCollection:
    def __init__(self, name: str):
        self.name = name
        self._docs: Dict[str, Dict[str, Any]] = {}

    class InsertResult:
        def __init__(self, inserted_id: str):
            self.inserted_id = inserted_id

    async def insert_one(self, document: Dict[str, Any]):
        doc = dict(document)
        doc["_id"] = str(uuid4())
        self._docs[doc["_id"]] = doc
        return self.InsertResult(doc["_id"])

    async def find_one(self, query: Dict[str, Any]):
        for doc in self._docs.values():
            if all(doc.get(k) == v for k, v in query.items()):
                return doc
        return None

    async def update_one(self, query: Dict[str, Any], update: Dict[str, Any]):
        doc = await self.find_one(query)
        if doc is None:
            return None
        if "$set" in update:
            for key, value in update["$set"].items():
                doc[key] = value
        return None


class DatabaseProxy:
    def __init__(self):
        self._memory = False
        self._client = None
        self._database = None
        self.user_collection = None
        self.transaction_collection = None
        self.consultation_collection = None

    def _connect(self):
        if self.user_collection is not None:
            return
        if AsyncIOMotorClient is None:
            self._memory = True
            self.user_collection = MemoryCollection("users")
            self.transaction_collection = MemoryCollection("transactions")
            self.consultation_collection = MemoryCollection("consultations")
            return

        try:
            self._client = AsyncIOMotorClient(MONGO_URI, tlsCAFile=certifi.where() if certifi else None)
            self._database = self._client.astrotech_db
            self.user_collection = self._database.get_collection("users")
            self.transaction_collection = self._database.get_collection("transactions")
            self.consultation_collection = self._database.get_collection("consultations")
            self._memory = False
        except Exception as exc:
            print(f"MongoDB unavailable, using in-memory fallback: {exc}")
            self._memory = True
            self.user_collection = MemoryCollection("users")
            self.transaction_collection = MemoryCollection("transactions")
            self.consultation_collection = MemoryCollection("consultations")


database_proxy = DatabaseProxy()
database_proxy._connect()
database = database_proxy
