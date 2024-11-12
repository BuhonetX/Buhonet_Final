#!/bin/bash

# Define paths
BASE_DIR="$HOME/Buhonet_Final"
APP_DIR="$BASE_DIR/app"
SRC_MAIN_DIR="$APP_DIR/src/main"
MANIFEST_PATH="$SRC_MAIN_DIR/AndroidManifest.xml"
LOG_FILE="$BASE_DIR/build_log_$(date +%Y%m%d_%H%M%S).log"
GRADLE_PROPERTIES="$BASE_DIR/gradle.properties"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# Update gradle.properties
log "Actualizando gradle.properties..."
cat > "$GRADLE_PROPERTIES" <<EOL
android.useAndroidX=true
android.enableJetifier=true
android.suppressUnsupportedCompileSdk=34
EOL
log "gradle.properties actualizado."

# Compile project with stacktrace for detailed error logs
log "Iniciando compilación con detalles..."
cd "$BASE_DIR" || exit 1
./gradlew build --stacktrace 2>&1 | tee -a "$LOG_FILE"

log "Proceso completado."
