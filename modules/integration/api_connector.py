import requests

class APIConnector:
    def fetch_data(self, url, params=None):
        response = requests.get(url, params=params)
        return response.json()

    def post_data(self, url, data=None):
        response = requests.post(url, json=data)
        return response.status_code, response.json()
