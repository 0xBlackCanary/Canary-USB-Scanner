🦜 CANARY USB SENTINEL v1.0
Vigilancia táctica y respuesta automatizada

Canary USB Sentinel es un script avanzado de monitorización en PowerShell, diseñado para la detección en tiempo real de Indicadores de Compromiso (IoC) en dispositivos de almacenamiento externo. Inspirado en la filosofía de los Canary Tokens, este centinela actúa de forma proactiva para proteger el host antes de que el malware pueda ejecutarse.

🚀 Funcionalidades Elite
Monitorización en Tiempo Real: Detección instantánea de hardware mediante eventos WMI (__InstanceCreationEvent), minimizando la ventana de exposición.

Escaneo de Amenazas Multi-Capa: Identifica no solo scripts (.vbs, .ps1, .bat), sino también binarios ejecutables peligrosos (.exe, .run, .com) y archivos de persistencia (autorun.inf).

Detección de "Shadow Files": Localiza accesos directos maliciosos (.lnk) y archivos ocultos sospechosos que intentan suplantar carpetas legítimas.

Aislamiento Táctico (Kill-Switch): Expulsa la unidad automáticamente al detectar patrones maliciosos, bloqueando vectores de infección por ejecución accidental.

Auditoría Forense: Genera un log de eventos detallado en el escritorio para el análisis posterior de la amenaza.

🛠️ Especificaciones de Detección
El Sentinel vigila activamente las siguientes extensiones críticas:
.exe | .run | .bat | .cmd | .scr | .vbs | .ps1 | .hta | .wsf | .lnk | .com | .pif

📖 Instalación y Uso
Descarga el archivo Canary_USB_Scanner.ps1.

Abre PowerShell como Administrador (necesario para el aislamiento de hardware).

Lanza el centinela:

PowerShell
.\Canary_USB_Scanner.ps1
⚠️ Aviso Legal
Este software se proporciona con fines educativos y de seguridad preventiva. La autora (0xBlackCanary) no se hace responsable del uso indebido de esta herramienta. Úsala con responsabilidad para fortalecer tu entorno.
