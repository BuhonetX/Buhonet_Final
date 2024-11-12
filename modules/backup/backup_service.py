import os
import shutil

class BackupService:
    def backup(self, source, destination):
        if not os.path.exists(destination):
            os.makedirs(destination)
        shutil.copytree(source, destination, dirs_exist_ok=True)
        print(f"Backup completado de {source} a {destination}")
