# hyprland-infinite-desktop
A powerful script to transform your Hyprland workspace into an "infinite" canvas. This tool allows you to pan all floating windows simultaneously using your mouse and navigate between them with keyboard shortcuts, creating a dynamic and boundless desktop experience.
<img width="1920" height="1080" alt="20260509_18h26m44s_grim" src="https://github.com/user-attachments/assets/464fa371-7cc4-4fd5-a06c-55d7b51ba59d" />


## 🚀 Features

- Infinite Panning: Move the entire "canvas" of floating windows by holding a modifier combination and moving your mouse.
- Smart Navigation: Cycle focus between floating windows with a smooth panning animation.
- App Protection: Prevents specific apps (like browsers) from losing focus accidentally during navigation.
- Invert Support: Easily toggle the movement direction

## 🛠️ Requirements

You only need Python 3 installed on your system.

*(Note: NixOS users can skip this section, as dependencies are handled automatically by the Flake).*

###  Installation by distribution:
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
### 🐧 On most distributions
1.Add your user to the group
```bash
sudo usermod -aG input $USER
  ```
2.Restart your session
```bash
sudo reboot
  ```
### ❄️ On Nix OS
Add the `input` group to user's `extraGroups` in `configuration.nix` and reboot to apply.

```nix
users.users.<yourusername>.extraGroups = [ "input" ];
```

## 📥 Installation

### 🐧 On most distributions

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
#### ⚙️ Configuration
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

### ❄️ On Nix OS (Flakes)
You do not need to manually clone this repository or run `chmod`. You can install and configure it entirely through your Nix files.

1. **Add the input:**
  Add this repository to the `inputs` section of your main system `flake.nix`:
  ```nix
  inputs = {
    infinite-desktop.url = "github:carlosareyesv204-cpu/hyprland-infinite-desktop";
  };
  ```
2. **Configure Hyprland via Home Manager:**
  Add the absolute `/nix/store` path to your `exec-once` to start the background daemon, along with the required keybindings.
  ```nix
  wayland.windowManager.hyprland.settings = {
    exec-once = [
      "${inputs.infinite-desktop.packages.${pkgs.system}.default}/bin/infinite-desktop"
    ];

    bind = [
      "CTRL SUPER, right, exec, echo right > /tmp/infinite-nav"
      "CTRL SUPER, left, exec, echo left > /tmp/infinite-nav"

      # To use, remember to have enabled floating:
      "SUPER, space, togglefloating"
    ];
  };
  ```
  3. **Rebuild your system:**
  ```bash
  sudo nixos-rebuild switch --flake .#your-hostname`
  ```

## 🖱️ How to use
 **Panning:** Hold ***SUPER + ALT + Left Click*** and move your mouse to slide the entire desktop.
 
 **Navigation:** Press ***CTRL + SUPER + Left/Right Arrow*** to center and focus the next floating window.
