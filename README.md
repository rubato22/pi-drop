# ⚡ Pi-Drop
Automated Tailscale deployment and seamless background Taildrop file-sync for headless Raspberry Pis.
* `install_tailscale.sh`: Installs and secures Tailscale
* `setup_taildrop.sh`: Creates a persistent daemon to instantly catch AirDropped/Taildropped files and save them to a directory/drive of your choice.

===============================================

### 🪟 Windows Setup (Headless Servers / Media PCs)
Because Windows blocks downloaded scripts by default, you need to run a bypass command.

1. Open **PowerShell as Administrator**.
2. Navigate to where you downloaded the folder (e.g., `cd C:\Users\YourName\Downloads\pi-drop`).
3. Copy and paste this exact command to bypass the block and launch the script:

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; .\setup_taildrop_windows.ps1

===============================================

### 🛑 How to Stop or Uninstall the Daemon

If you ever want to pause the background listener or remove it completely, run the following commands:

#### For Linux (Raspberry Pi / Ubuntu):
Open your terminal and run:

# Stop the daemon right now
sudo systemctl stop taildrop-automator

# Prevent it from starting up again on reboot
sudo systemctl disable taildrop-automator

# (Optional) Delete the service file entirely
sudo rm /etc/systemd/system/taildrop-automator.service
sudo systemctl daemon-reload

=============================================

For Windows.
# Stop the background task
Stop-ScheduledTask -TaskName "PiDrop_AutoReceive" -ErrorAction SilentlyContinue

# Delete the task completely
Unregister-ScheduledTask -TaskName "PiDrop_AutoReceive" -Confirm:$false -ErrorAction SilentlyContinue
