Install cronie. Activate and enable it through systemctl.

Execute
```
crontab -e
```


*/5 * * * * DISPLAY=:0 ~/.config/i3/scripts/randomWallpaper.sh

0 * * * * DISPLAY=:0 ~/.config/i3/scripts/shuffle_lockscreen.sh

