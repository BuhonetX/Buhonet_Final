import cachetools

class CacheManager:
    def __init__(self, max_size=100):
        self.cache = cachetools.LRUCache(maxsize=max_size)

    def set(self, key, value):
        self.cache[key] = value

    def get(self, key):
        return self.cache.get(key, None)
