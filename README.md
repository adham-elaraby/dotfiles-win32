# dotfiles-win32
Powershell and WSL setup for better experience.
Sets up a custom ps prompt, adds autocomplete and predictions, and custom keybindings. While lazy loading the profile in the background for quick prompt access.

![screenshot-setup](https://github.com/adham-elaraby/dotfiles-win32/assets/63326537/9fb7e386-e8e7-4625-b80d-e3f27bf8d013)


## Scoop dependencies
`scoop bucket add extras`

- 7zip
- cacert
- cmake
- curl
- dark
- espanso
- ffmpeg
- git
- innounp
- lf
- bat
- less
- ntop
- llvm
- make
- mkvtoolnix
- mpv
- neofetch
- openjdk
- perl
- neovim
- stack
- starship
- sudo
- wget
- youtube-dl
- yt-dlp
- zig
- posh-git
- archwsl (https://wsldl-pg.github.io/ArchW-docs/How-to-Setup/)
- extras/carapace-bin

## Other dependencies
- AltDrag (fork available)
- f.lux
- GoldenDict
- dwm-win32 ([adham-elaraby/dwm-win32](https://github.com/adham-elaraby/dwm-win32)) 
- fd
- which
- posh-git
- PSFzf
- fzf
- Terminal-Icons (powershell)

## PowerShell 7
First prompt upon launch is a stripped down version while profile loads in background, this reduces wait time.
- `Alt+c` calls `fzf` and `Set-Location` to the chosen directory
- `Ctrl+r` calls `fzf` on `history`
- `Ctrl+t` calls fzf and returns the path to files and directories in prompt
- `Tab` to Menue Complete
- `Right` to accept prediction word by word
- `Ctrl+b` and `Ctrl+f` to move one character back and forth
- `Alt+b` and `Alt+f // Right` moves one word back or forward

## Arch WSL
### disable WSLg (prevent Terminal loss of focus)
Create .wslconfig in `%USERPROFILE%`

```
[wsl2]
guiApplications=false
```

### Arch Setup fixes
note that arch does not have `/usr/lib/libedit.so.2` like ubuntu and therefore we must symlink it to the correct lib to ensure intel drivers function correctly.

Steps:

Look for file with .so's
`ls /usr/lib/wsl/drivers/iigd_*` 

then pass the directory to the following command and look for `not found`. eg:
`ldd /usr/lib/wsl/drivers/iigd_dch.inf_amd64_d8bdffa26077ee9a/*.so`

In my case the `libedit` package wasn't even installed yet.
`sudo pacman -S libedit`

Then check to see what libedit version is available in the libs directory and symlink it eg:
`sudo ln -sf libedit.so.0.0.72 /usr/lib/libedit.so.2`

Check again for any unfound libraries. In mycase I still needed `intel-gmmlib` as seen by `libigdmm.so.12 (not found)`
`sudo pacman -S intel-gmmlib`

## Windows Group Policy Edits
### Disable Win Key shortcuts
You can try enable gpedit through the `gpedit-enabler.bat` script in Scripts
1. Type Edit group policy in the Start menu search bar.
2. Right-click on the Best match result and select Run as administrator.
3. Navigate to User Configuration > Administrative Templates > Windows Components > File Explorer.
4. Double-click on the Turn off Windows Key Hotkeys option on the right-hand side.

## tmux container for PowerShell
we will run an alpine wsl container, that will only host a tmux session, and then launch a Powershell Instance on it, this will allow us to use powershell and arch wsl on an independant tmux process.

![Tmux-Scratchpad](https://github.com/adham-elaraby/dotfiles-win32/assets/63326537/77d39a4f-adf6-4483-89c0-914b84731480)


### Setup
- Install Windows Subsystem for Linux, and set to WSL 1 for speed improvements.
- Install the Alpine Linux distribution. I use this as the base for the tmux feature, since it has very low overhead (less than 12MB, including tmux).
- The next few steps are optional. Create a new, cloned WSL instance for PowerShell tmux. You could just use the default Alpine instance, but I like to have a single-purpose WSL instance, similar to Docker containers named posh_tmux.

```
mkdir $env:userprofile\Documents\WSL\instances # Or wherever you want to set this up
mkdir $env:userprofile\Documents\WSL\images
cd $env:userprofile\Documents\WSL
wsl --export Alpine .\images\alpine_base.tar
mkdir .\instances\posh_tmux
wsl --import posh_tmux .\instances\posh_tmux .\images\alpine_base.tar --version 1 
```
- Launch the WSL instance as root with `wsl -d posh_tmux -u root`
- `adduser tmux`
- Set the default user for the instance by creating /etc/wsl.conf with the following contents:
```
[user]
default = tmux
```
- apk add tmux to install tmux

- Exit the session, relaunch with wsl ~ -d posh_tmux (omitting the username, since it will now default to the tmux user)
- Create a ~/.profile with the following:
```
if tmux has-session -t=posh; then
  exec tmux attach-session -t posh
else
  exec tmux new-session -s posh -n PowerShell
fi
```

-Create a ~/.tmux.conf with the following:
```
set -g default-command "cd $(pwsh.exe -c 'Write-Host -NoNewLine \$env:userprofile' | xargs -0 wslpath); exec pwsh.exe --nologo"
set-window-option -g automatic-rename off
bind c new-window -n "PowerShell"

# Give this tmux a "PowerShell blue" color to differentiate it
#set -g status-bg blue


# Mouse support
set -g mouse on

# Start windows and panes at 1, not 0
set -g base-index 1
set -g pane-base-index 1
set-window-option -g pane-base-index 1
set-option -g renumber-windows on

# Set true colors
set-option -sa terminal-overrides ",xterm*:Tc"
set-option -g focus-events on



# Use UTF8
set -qg utf8
set-window-option -qg utf8 on

# Set vi-mode
set-window-option -g mode-keys vi

# ^ Keybindings
bind-key -T copy-mode-vi v send-keys -X begin-selection
bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel

# Bind r to source this file
unbind r
#bind r source ~/.tmux.conf
bind r source-file ~/.tmux.conf \; display "Reloaded!"

# Recommended, to avoid the Ctrl+B finger-gymnastics
# Change default prefix to Screen's
unbind C-b
set-option -g prefix C-Space
bind-key C-Space send-prefix
#bind-key -n C-b send-prefix
bind C-Space last-window

# Maybe later C-S-J C-S-K
bind-key -n C-Tab next-window
bind-key -n C-S-Tab previous-window

#if you want tmux to pass along these (and other) xterm-style key sequences to programs running inside tmux, then you will need to enable the xterm-keys window option.
#set-option -gw xterm-keys on


# Optional
# split panes using - and |
bind | split-window -h
bind - split-window -v
unbind '"'
unbind %

set -g history-limit 10000

set -g default-terminal "screen-256color"

# Plugins
#set -g @plugin 'tmux-plugins/tpm'
#set -g @plugin 'tmux-plugins/tmux-sensible'
#set -g @plugin 'christoomey/vim-tmux-navigator'
#set -g @plugin 'tmux-plugins/tmux-yank'

# Status bar customization
set -g status-interval 10         # update the status bar every 10 seconds
set -g status-justify left
    set -g status-position bottom
set -g status-left-length 200     # increase length (from 10)
set -g status-style 'bg=default'  # transparent background

# STATUS BAR STYLE 1 - PLAIN
set -g status-left "#[fg=#b4befe,bg=default]  #S #[fg=#45475a,bg=default]|"
set -g status-right "#[fg=#eba0ac,bg=default]#{?window_zoomed_flag, ,} #[fg=#45475a,bg=default]|#[fg=#f2dcdc,bg=default] %m/%d/%y "
set -g window-status-current-format '#[fg=#b4befe,bg=default] #I#W'
set -g window-status-format '#[fg=gray,bg=default] #I #W'

# STATUS BAR STYLE 2 - BUBBLES
#set -g status-left '#[fg=#2b2a30,bg=default]#[fg=#b4befe,bg=#2b2a30]  #S #[fg=#2b2a30,bg=default]#[fg=#45475a,bg=default] |'
#set -g status-right '#[fg=#2b2a30,bg=default] #[fg=#eba0ac,bg=#2b2a30]#{?window_zoomed_flag,,}#[fg=#2b2a30,bg=default] #[fg=#45475a,bg=default]| #[fg=#2b2a30,bg=default]#[fg=#f2dcdc,bg=#2b2a30]%m/%d/%y#[fg=#2b2a30,bg=default]'
#set -g window-status-current-format '#[fg=#2b2a30,bg=default] #[fg=#b4befe,bg=#2b2a30]#I#W#[fg=#2b2a30,bg=default]'
#set -g window-status-format '#[fg=gray,bg=default]  #I #W '


set -g window-status-last-style 'fg=white,bg=default'
set -g pane-border-style 'fg=#b4befe'
set -g pane-active-border-style 'fg=#b4befe'
set -g default-terminal "${TERM}"
set -g message-command-style bg=default,fg=#f2dcdc
set -g message-style bg=default,fg=#f2dcdc
set -g mode-style bg=default,fg=#f2dcdc
```
- Set up a PowerShell Core tmux profile in Windows Terminal with the launch command `wsl -d posh_tmux`

- If you need to access the instance without entering tmux/PowerShell (for instance, to sudo apk upgrade or to edit the config), launch instead with `wsl ~ -d tmux_posh -u root`

- You can access tmux commands from within PowerShell by wsl -d tmux_posh -e tmux <tmux_command. For instance, wsl -d tmux_posh -e tmux rename-window host1. - TODO: Create a tmux wrapper PowerShell function for this.

- TODO: PowerShell prompt function to set the window name dynamically to the last executed command


### Fixing Ctrl-Tab not being read by tmux
If your key binds don't work on Windows Terminal/WSL, that is:

`bind -r C-Tab next-window`
`bind -r C-S-Tab previous-window`
You need to go to the terminal key bind settings and add mappings for the tab with modifiers. For Windows Terminal it will be Setting->Open JSON file->go to "actions"->and add the following:
```
{
    "command":
    {
        "action": "sendInput",
        "input": "\u001b[27;5;9~"
    },
    "keys": "ctrl+tab"
},
{
    "command":
    {
        "action": "sendInput",
        "input": "\u001b[27;6;9~"
    },
    "keys": "ctrl+shift+tab"
},
```

## Aliases to consider
### Git functions
```powershell
function ginit ([Parameter(ValueFromRemainingArguments)] $remaining) {
    git init $remaining
}
function gremote ([Parameter(ValueFromRemainingArguments)] $remaining) {
    git remote $remaining
}
function gclone ([Parameter(ValueFromRemainingArguments)] $remaining) {
    git clone $remaining
}
function gadd ([Parameter(ValueFromRemainingArguments)] $remaining) {
    git add $remaining
}
function gmv ([Parameter(ValueFromRemainingArguments)] $remaining) {
    git mv $remaining
}
function grestore ([Parameter(ValueFromRemainingArguments)] $remaining) {
    git restore $remaining
}
function grm ([Parameter(ValueFromRemainingArguments)] $remaining) {
    git rm $remaining
}
function gdiff ([Parameter(ValueFromRemainingArguments)] $remaining) {
    git diff $remaining
}
function ggrep ([Parameter(ValueFromRemainingArguments)] $remaining) {
    git grep $remaining
}
function glog ([Parameter(ValueFromRemainingArguments)] $remaining) {
    git log $remaining
}
function gshow ([Parameter(ValueFromRemainingArguments)] $remaining) {
    git show $remaining
}
function gstatus ([Parameter(ValueFromRemainingArguments)] $remaining) {
    git status $remaining
}
function gbranch ([Parameter(ValueFromRemainingArguments)] $remaining) {
    git branch $remaining
}
function gcheckout ([Parameter(ValueFromRemainingArguments)] $remaining) {
    git checkout $remaining
}
function gcommit ([Parameter(ValueFromRemainingArguments)] $remaining) {
    git commit $remaining
}
function gmerge ([Parameter(ValueFromRemainingArguments)] $remaining) {
    git merge $remaining
}
function grebase ([Parameter(ValueFromRemainingArguments)] $remaining) {
    git rebase $remaining
}
function greset ([Parameter(ValueFromRemainingArguments)] $remaining) {
    git reset $remaining
}
function gswitch ([Parameter(ValueFromRemainingArguments)] $remaining) {
    git switch $remaining
}
function gtag ([Parameter(ValueFromRemainingArguments)] $remaining) {
    git tag $remaining
}
function gfetch ([Parameter(ValueFromRemainingArguments)] $remaining) {
    git fetch $remaining
}
function gpull ([Parameter(ValueFromRemainingArguments)] $remaining) {
    git pull $remaining
}
function gpush ([Parameter(ValueFromRemainingArguments)] $remaining) {
    git push $remaining
}

function gch ($message) {
    git add .
    git commit -m $message
    git push
}
function gnb ($branch_name) {
    gcheckout -b $branch_name
    gcommit -m "new branch - $($branch_name)"
    gpush --set-upstream origin $branch_name
}
function gstart ([Parameter(Mandatory)] $repo) {
    ginit
    gremote add origin $repo
    gadd .
    gpush --set-upstream origin master
}
function mergemaster {
    $cur_branch = gbranch --show-current
    gpull
    gcheckout master
    gpull
    gcheckout $cur_branch
    gmerge master
}

# CD

function .. {
    Set-Location ..
}
function ... {
    Set-Location ../..
}
function .... {
    Set-Location ../../..
}
function ..... {
    Set-Location ../../../..
}
function ...... {
    Set-Location ../../../../..
}

function projects {
    Set-Location ~/Projects
}
```

## TODOs:
- [ ] Research into [mikebattista/PowerShell-WSL-Interop](https://github.com/mikebattista/PowerShell-WSL-Interop) for the possibility of a wsl1 interop with pwsh
- [ ] Create a light WSL 1 TMUX Container for pwsh as detailed [here](https://superuser.com/questions/408874/tmux-screen-alternative-for-powershell)
- [ ] move to zsh? or bashrc and bashrc_noclear
- [ ] update pwsh config to reflect my functions for launching arch instead of ubuntu
- [ ] SystemVerilog
- [ ] lunarvim install & cofig
- [ ] lf config
- [ ] stow dotfiles?
