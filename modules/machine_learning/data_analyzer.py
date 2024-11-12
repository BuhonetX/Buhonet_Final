import pandas as pd

class DataAnalyzer:
    def analyze(self, data):
        df = pd.DataFrame(data)
        return df.describe()
