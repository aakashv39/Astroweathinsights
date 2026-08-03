import sys
import unittest
from pathlib import Path

sys.path.append(str(Path(__file__).resolve().parents[1]))


class MemoryCollectionFallbackTests(unittest.IsolatedAsyncioTestCase):
    async def test_memory_collection_insert_and_read(self):
        from database import MemoryCollection

        collection = MemoryCollection("users")
        result = await collection.insert_one({"email": "demo@example.com", "name": "Demo"})
        stored = await collection.find_one({"email": "demo@example.com"})

        self.assertIsNotNone(stored)
        self.assertEqual(stored["email"], "demo@example.com")
        self.assertEqual(result.inserted_id, stored["_id"])


if __name__ == "__main__":
    unittest.main()
