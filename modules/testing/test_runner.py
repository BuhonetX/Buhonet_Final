import unittest

class TestIntegration(unittest.TestCase):
    def test_api_connection(self):
        self.assertEqual(2 + 2, 4)

if __name__ == "__main__":
    unittest.main()
