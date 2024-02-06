# dotfiles-win32
My config files for Windows 10




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
- llvm
- make
- mkvtoolnix
- mpv
- neofetch
- openjdk
- perl
- scoop
- stack
- starship
- sudo
- wget
- youtube-dl
- yt-dlp
- zig
- posh-git
- archwsl (https://wsldl-pg.github.io/ArchW-docs/How-to-Setup/)

## Other dependencies
- AltDrag (fork available)
- f.lux
- GoldenDict
- dwm-win32
- fd
- which
- posh-git
- PSFzf
- fzf
- Terminal-Icons (powershell)

## disable WSLg (prevent Terminal loss of focus)
Create .wslconfig in `%USERPROFILE%`

```
[wsl2]
guiApplications=false
```

## Arch WSL
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

Chekc again for any unfound libraries. In mycase I still needed `intel-gmmlib` as seen by `libigdmm.so.12 (not found)`
`sudo pacman -S intel-gmmlib`


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
- [ ] move to zsh? or bashrc and bashrc_noclear
- [ ] update pwsh config to reflect my functions for launching arch instead of ubuntu
- [ ] SystemVerilog
- [ ] lunarvim install & cofig
- [ ] lf config
- [ ] stow dotfiles?
