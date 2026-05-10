# hyprland-infinite-desktop
A powerful script to transform your Hyprland workspace into an "infinite" canvas. This tool allows you to pan all floating windows simultaneously using your mouse and navigate between them with keyboard shortcuts, creating a dynamic and boundless desktop experience.
<img width="1920" height="1080" alt="20260509_18h26m44s_grim" src="https://github.com/user-attachments/assets/464fa371-7cc4-4fd5-a06c-55d7b51ba59d" />


## 🚀 Features

-Infinite Panning: Move the entire "canvas" of floating windows by holding a modifier combination and moving your mouse.
-Smart Navigation: Cycle focus between floating windows with a smooth panning animation.
-App Protection: Prevents specific apps (like browsers) from losing focus accidentally during navigation.
-Invert Support: Easily toggle the movement direction

## 🛠️ Requirements

You only need Python 3 installed on your system.
### Installation by Distribution:
* **Arch Linux:**
  ```bash
    sudo pacman -S python
    ```
* **Fedora:**
  ```bash
    sudo dnf install python3
    ```
* **Ubuntu / Debian:**
  ```bash
    sudo apt install python3
    ```
## 🔑 Permissions
1.Add your user to the group
```bash
   sudo usermod -aG input $USER
  ```
2.Restart your session
```bash
   sudo reboot
  ```

## 📥 Installation

1. **Create the directory:**
   All scripts must be stored in a dedicated folder in your home directory:
   ```bash
   mkdir -p ~/scripts
   ```
2. **Download the scripts:**
Place infinite-desktop.sh, infinite_desktop_core.py, and infinite-desktop-toggle.sh inside ~/scripts/.

3. **Grant execution permissions:**
  ```bash
    chmod +x ~/scripts/infinite-desktop.sh ~/scripts/infinite-desktop-toggle.sh
  ```
## ⚙️ Configuration
Add the following lines to your ~/.config/hypr/hyprland.conf:

1. **Auto-start**
   ```bash
     # Launch the infinite desktop daemon (replace 'your_user' with your actual username)
     exec-once = /home/your_user/scripts/infinite-desktop.sh
   ```
2. **Keybindings**
   Add these binds to enable keyboard navigation between your floating windows:
   ```bash
     bind = CTRL SUPER, right, exec, echo right > /tmp/infinite-nav
     bind = CTRL SUPER, left, exec, echo left > /tmp/infinite-nav
   ```

## 🖱️ How to use
 **Panning:** Hold ***SUPER + ALT + Left Click*** and move your mouse to slide the entire desktop.
 
 **Navigation:** Press ***CTRL + SUPER + Left/Right Arrow*** to center and focus the next floating window.
