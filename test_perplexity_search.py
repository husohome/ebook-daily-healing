import unittest
from perplexity_search import search_perplexity

class TestPerplexityAPI(unittest.TestCase):
    def test_search_returns_valid_structure(self):
        # A simple query for testing purposes
        query = "What is artificial intelligence?"
        result = search_perplexity(query)
        # The result should be a dictionary
        self.assertIsInstance(result, dict, "The result should be a dictionary.")
        
        # If there's an error key, we consider it a test failure
        if "error" in result:
            self.fail(f"API request returned an error: {result['error']}")
        else:
            # Check that a 'results' key exists and is a list
            self.assertIn("results", result, "The result dictionary should contain a 'results' key.")
            self.assertIsInstance(result["results"], list, "The 'results' key should map to a list.")
            # Optionally test that the first result has a title (if any results are returned)
            if result["results"]:
                self.assertIn("title", result["results"][0], "Each result should contain a 'title'.")
    
    def test_empty_query(self):
        # Test behavior when an empty query is sent.
        query = ""
        result = search_perplexity(query)
        self.assertIsInstance(result, dict, "The result should be a dictionary.")
        # Depending on API behavior, either an error is returned or a 'results' key is provided.
        if "error" in result:
            self.assertIsInstance(result["error"], str)
        else:
            self.assertIn("results", result)

if __name__ == "__main__":
    unittest.main() 