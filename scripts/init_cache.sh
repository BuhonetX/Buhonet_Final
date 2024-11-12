#!/bin/bash
echo "Inicializando caché..."
python3 -c "from modules.cache_optimization.cache_manager import CacheManager; cache = CacheManager(); cache.set('key', 'value'); print('Cache inicializado con valor:', cache.get('key'))"
