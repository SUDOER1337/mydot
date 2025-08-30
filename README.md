# SUDOER1337's Dotfiles

This is my personal dotfiles setup !

The Waybar is based on [gdots](https://github.com/niksingh710/gdots)
and alot of ohter people dotfiles that i regret cant remember

## 󰋩 Gallery

### 🖥️ Hyprland Desktop
![Idle](Screenshots/Idle.png)
![Terminals](Screenshots/Kitty.png)  

---

###  Rofi & Menus
Rofi menus and popups separated to highlight customizations:  

#### Launcher
Rofi main menu styled for my theme.  
![Rofi](Screenshots/Rofi.png)

#### Powermenu
Centered shutdown/reboot/logout prompt.  
![Powermenu](Screenshots/Powermenu.png)

#### Utilities
Calculator and emoji picker for daily tasks.  
![Calc](Screenshots/Calc.png)  
![Emoji](Screenshots/Emoji-Nerdy.png)

---

###  Terminals & Status
Kitty terminal theme and Btop for monitoring system resources.  
![Waybar](Screenshots/Waybar.png)  
![Swaync](Screenshots/Swaync.png)

-  [Hyprland](https://github.com/hyprwm/Hyprland)
-  Waybar
-  Kitty
-  Swappy
-  Swaync (Downgrade to 11)
-  Btop
-  Rofi

Cursor: Bibata-Modern-Classic 24


These are configured for my daily use on **CachyOS + Hyprland**
something here are kinda specfic , like i have autostart for my custom mouse driver so remove if you doenst need it

Feel free to borrow, fork or anything!  
 ⭐ if you find something useful

##    Install

```bash
git clone https://github.com/SUDOER1337/mydot.git ~/.mydot
cd ~/.mydot
chmod +x ./Scripts/install.sh
./Scripts/install.sh 
``````
## 󰆓   Backup

To update:

```bash
cd /mnt/Storages/mydot
git add .
git commit -m "Update: $(date '+%Y-%m-%d %H:%M:%S')"
git push --force
