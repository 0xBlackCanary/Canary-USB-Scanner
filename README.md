# 🦜 CANARY USB SENTINEL v1.3

## 🛡️ Vigilancia Táctica y Defensa Automatizada
**Author:** [0xBlackCanary](https://github.com/0xBlackCanary/0xBlackCanary) 🦜  
**Version:** 1.3 (Stable Release)

---

## 📖 DESCRIPCIÓN GENERAL
**Canary USB Sentinel** es una solución de seguridad proactiva desarrollada en **PowerShell**. Este script actúa como un centinela silencioso en el sistema operativo, monitorizando cada bus USB en busca de dispositivos de almacenamiento que contengan indicadores de compromiso (IoC). 

A diferencia de los antivirus tradicionales, Sentinel aplica una **política de defensa activa**, analizando la estructura de archivos del dispositivo en el milisegundo en que se monta, permitiendo la neutralización de la amenaza mediante la expulsión forzosa del hardware antes de cualquier interacción humana.

---

## 🚀 FUNCIONALIDADES AVANZADAS (v1.3)

### 1. 🔍 Monitorización de Bajo Nivel
Utiliza consultas **WMI (Windows Management Instrumentation)** para suscribirse a eventos del sistema `__InstanceCreationEvent`. Esto garantiza que el script no consume apenas CPU mientras espera, pero reacciona instantáneamente ante la inserción de hardware.

### 2. 🚦 Clasificación de Riesgo Inteligente
Sentinel no solo detecta, sino que evalúa la peligrosidad de los archivos:
* **RIESGO CRÍTICO (Auto-Eject):** Scripting malicioso y archivos de sistema (.bat, .vbs, .ps1, .scr, .cmd, .hta, .wsf, .jse, .lnk) y el clásico vector de infección `autorun.inf`.
* **RIESGO MEDIO (Alerta):** Archivos ejecutables (.exe) que requieren supervisión del operador pero no disparan la expulsión automática por defecto.

### 3. ⚡ Smart Auto-Eject (Aislamiento Forense)
Si se detecta una amenaza de **Riesgo Crítico**, el script invoca el objeto COM `Shell.Application` para realizar una expulsión lógica inmediata. Esto previene ataques de *BadUSB* y ejecución de scripts accidentales.

### 4. 🔔 Respuesta Multimodal
* **Audio:** Secuencia de tonos (beeps) de advertencia de alta frecuencia.
* **Visual:** Notificaciones tipo "Toast" en el área de notificación de Windows.
* **Consola:** Salida detallada en colores (Cian para estado, Rojo para amenazas).

### 5. 📂 Auditoría y Logs
Genera un archivo de registro en `$env:USERPROFILE\Desktop\Canary_USB_Log.txt` con marcas de tiempo precisas, nombres de modelos de USB detectados y rutas completas de los archivos sospechosos.

---

## 🛠️ DESPLIEGUE TÁCTICO

### Requisitos
* Windows 10/11.
* Permisos de Administrador (para la monitorización de eventos WMI).

### Instrucciones de uso
1.  **Clonar/Descargar** el script `Canary_USB_Scanner.ps1`.
2.  Abrir una terminal de **PowerShell como Administrador**.
3.  Ejecutar el comando:
    ```powershell
    .\Canary_USB_Scanner.ps1
    ```

---

## 📋 ESPECIFICACIONES TÉCNICAS
| Característica | Detalle |
| :--- | :--- |
| **Lenguaje** | PowerShell 5.1+ |
| **Motor de Detección** | Eventos WMI / Win32_DiskDrive |
| **Acción de Respuesta** | Shell.Application InvokeVerb (Eject) |
| **Persistencia de Log** | Texto plano (Append mode) |
| **Estado** | Operativo / Producción |

---

## ⚠️ AVISO LEGAL (DISCLAIMER)
Este software ha sido diseñado con fines estrictamente educativos y de seguridad preventiva. La autora (**0xBlackCanary**) no asume responsabilidad alguna por el uso indebido de esta herramienta o por cualquier daño accidental derivado de la expulsión automática de dispositivos. **Úsalo para fortalecer tu seguridad, no para comprometer la de otros.**

---
