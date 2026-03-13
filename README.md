# ⚡ Pi-Drop
Automated Tailscale deployment and seamless background Taildrop file-sync for headless Raspberry Pis.
* `install_tailscale.sh`: Installs and secures the node.
* `setup_taildrop.sh`: Creates a persistent daemon to instantly catch AirDropped/Taildropped files and save them to a directory/drive of your choice.

===============================================

### 🪟 Windows Setup (Headless Servers / Media PCs)
Because Windows blocks downloaded scripts by default, you need to run a bypass command.

1. Open **PowerShell as Administrator**.
2. Navigate to where you downloaded the folder (e.g., `cd C:\Users\YourName\Downloads\pi-drop`).
3. Copy and paste this exact command to bypass the block and launch the script:

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; .\setup_taildrop_windows.ps1
