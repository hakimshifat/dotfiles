Dotfiles Contains
- hyprland
- aria2
- hyprlock
- sway
- niri <-- Currently Using
- SDDMtheme
- Yazi
### Setting Up Git On Linux

```
git config --global user.name "username"

```

```
git config --global user.email "email"

```

```
ssh-keygen -t ed25519 -C "email"

```

```
eval "$(ssh-agent -s)"

```

```
ssh-add ~/.ssh/theprivatekey

```

Test if its working
```
ssh -T git@github.com

```



#### FastOlympicCode
1. Competitive Companion Port : 12345
2. If test cases are downloading to a file but not being run
    sublime, match the filename of the file that its running.


    ## Normal Setup

    1. cpp.sublime-build

```

{
    "shell_cmd": "bash -lc 'ccache g++ \"${file}\" -o \"${file_base_name}\" -std=c++17 -O2 -Wall -Wextra 2> \"${file_path}/errors.txt\" && timeout 4s \"${file_path}/${file_base_name}\" < \"${file_path}/input.txt\" > \"${file_path}/output.txt\" 2>> \"${file_path}/errors.txt\"'",
    "selector": "source.cpp",
    "working_dir": "${file_path}",
    "file_regex": "^(.*?):([0-9]*):([0-9]*): (.*)$",
    "shell": true
}



```

2. Enable Vintage

```
[
    {
        "keys": ["j", "j"],
        "command": "exit_insert_mode",
        "context": [
            { "key": "setting.command_mode", "operand": false },
            { "key": "setting.is_widget", "operand": false }
        ]
    }
]


```

3. precomile header

```
sudo g++ -std=c++17 -O2 -x c++-header /usr/include/c++/15.2.1/x86_64-pc-linux-gnu/bits/stdc++.h -o /usr/include/c++/15.2.1/x86_64-pc-linux-gnu/bits/stdc++.h.gch

```

