# 🦜 Canary USB Sentinel

**Canary USB Sentinel** es un script avanzado en PowerShell diseñado para la monitorización en tiempo real de puertos USB. Su objetivo es detectar archivos sospechosos y scripts maliciosos de ejecución automática en dispositivos de almacenamiento externo.

## 🚀 Funcionalidades
- **Monitorización en Tiempo Real:** Utiliza eventos WMI para detectar la inserción de hardware instantáneamente.
- **Detección de IoCs (Indicadores de Compromiso):** Escanea extensiones críticas (`.vbs`, `.ps1`, `.bat`, `.hta`) y archivos ocultos.
- **Aislamiento Automático:** Expulsa la unidad automáticamente si detecta una amenaza.
- **Auditoría:** Genera un log de eventos en la carpeta de Documentos para análisis forense posterior.

## 🛠️ Instalación
1. Clona el repositorio: `git clone https://github.com/0xBlackCanary/Canary-USB-Scanner`
2. Ejecuta PowerShell como Administrador.
3. Ejecuta el script: `.\Canary-USB-Scanner.ps1`

## ⚠️ Disclaimer
Este software se proporciona con fines educativos y de seguridad preventiva. La autora no se hace responsable del uso indebido de esta herramienta.
