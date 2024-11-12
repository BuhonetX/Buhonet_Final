#!/bin/bash

# Definición de rutas y archivos
BASE_DIR="$HOME/Buhonet_Final"
APP_DIR="$BASE_DIR/app"
SRC_MAIN_DIR="$APP_DIR/src/main"
MANIFEST_PATH="$SRC_MAIN_DIR/AndroidManifest.xml"
MAIN_ACTIVITY_DIR="$SRC_MAIN_DIR/java/com/example/buhonet"
MAIN_ACTIVITY_PATH="$MAIN_ACTIVITY_DIR/MainActivity.kt"
GRADLE_BUILD_FILE="$APP_DIR/build.gradle.kts"
LOCAL_PROPERTIES="$BASE_DIR/local.properties"
LOG_FILE="$BASE_DIR/build_log_$(date +%Y%m%d_%H%M%S).log"

# Función de registro
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# Validación de la estructura del proyecto
validate_structure() {
    log "Validando estructura del proyecto..."
    mkdir -p "$MAIN_ACTIVITY_DIR" "$SRC_MAIN_DIR/res/layout"
    if [ ! -f "$MAIN_ACTIVITY_PATH" ]; then
        log "Creando MainActivity.kt..."
        cat > "$MAIN_ACTIVITY_PATH" <<EOL
package com.example.buhonet

import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity

class MainActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
    }
}
EOL
        log "MainActivity.kt creado correctamente."
    else
        log "MainActivity.kt ya existe."
    fi
}

# Corrección del archivo AndroidManifest.xml
fix_manifest() {
    log "Verificando AndroidManifest.xml..."
    if [ ! -f "$MANIFEST_PATH" ]; then
        log "Creando AndroidManifest.xml..."
        cat > "$MANIFEST_PATH" <<EOL
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.example.buhonet">

    <application
        android:allowBackup="true"
        android:icon="@mipmap/ic_launcher"
        android:label="@string/app_name"
        android:roundIcon="@mipmap/ic_launcher_round"
        android:supportsRtl="true"
        android:theme="@style/Theme.AppCompat">
        <activity android:name=".MainActivity">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>
    </application>
</manifest>
EOL
        log "AndroidManifest.xml creado correctamente."
    else
        if grep -q 'package=' "$MANIFEST_PATH"; then
            log "Eliminando atributo 'package' de AndroidManifest.xml..."
            sed -i '/package=/d' "$MANIFEST_PATH"
            log "Atributo 'package' eliminado."
        else
            log "AndroidManifest.xml ya está correcto."
        fi
    fi
}

# Configuración de gradle.properties
configure_gradle_properties() {
    log "Verificando gradle.properties..."
    GRADLE_PROPERTIES="$BASE_DIR/gradle.properties"
    if [ ! -f "$GRADLE_PROPERTIES" ]; then
        touch "$GRADLE_PROPERTIES"
    fi
    if ! grep -q 'android.useAndroidX=true' "$GRADLE_PROPERTIES"; then
        echo "android.useAndroidX=true" >> "$GRADLE_PROPERTIES"
        log "Propiedad 'android.useAndroidX=true' añadida."
    fi
    if ! grep -q 'android.suppressUnsupportedCompileSdk=34' "$GRADLE_PROPERTIES"; then
        echo "android.suppressUnsupportedCompileSdk=34" >> "$GRADLE_PROPERTIES"
        log "Propiedad 'android.suppressUnsupportedCompileSdk=34' añadida."
    fi
}

# Configuración de local.properties para el SDK
configure_local_properties() {
    log "Verificando local.properties..."
    if [ ! -f "$LOCAL_PROPERTIES" ]; then
        log "Creando local.properties..."
        echo "sdk.dir=$ANDROID_HOME" > "$LOCAL_PROPERTIES"
        log "local.properties creado."
    else
        log "local.properties ya existe."
    fi
}

# Compilación del proyecto con Gradle
build_project() {
    log "Iniciando compilación del proyecto..."
    ./gradlew build 2>&1 | tee -a "$LOG_FILE"
    if [ $? -eq 0 ]; then
        log "🎉 Compilación exitosa."
    else
        log "❌ Error durante la compilación. Revisa el log."
    fi
}

# Análisis de errores previos al construir el proyecto
analyze_logs() {
    log "Analizando logs de errores..."
    if grep -q "SDK location not found" "$LOG_FILE"; then
        log "🔧 Error: SDK no configurado. Verifica ANDROID_HOME."
    fi
    if grep -q "package=" "$LOG_FILE"; then
        log "🔧 Error: 'package' mal configurado en AndroidManifest.xml."
    fi
    if grep -q "Gradle features were used" "$LOG_FILE"; then
        log "🔧 Advertencia: Características obsoletas en Gradle."
    fi
}

# Proceso principal
main() {
    log "🚀 Iniciando proceso de verificación y compilación..."
    validate_structure
    fix_manifest
    configure_gradle_properties
    configure_local_properties
    build_project
    analyze_logs
    log "✅ Proceso completado."
}

main
