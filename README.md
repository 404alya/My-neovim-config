# My neovim config

My neovim config simply is just a lazyvim and with extra plugins, that's it.

## Installation

```
mv ~/.config/nvim{,.bak}
```
Take backup of existing neovim config

```
rm -rf ~/.config/nvim
```

Or just delete it

--


```
git clone --depth=1 https://github.com/404alya/My-neovim-config ~/.config/nvim && rm -rf ~/.config/nvim/.git
```
Simply clones the repo with shallow clone and removes the .git from it.

## Fast install (any distro)

```
curl -fsSL https://raw.githubusercontent.com/404alya/My-neovim-config/main/install-fast.sh | bash
```
Downloads the latest Neovim AppImage to `~/AppImages`, backs up any existing `~/.config/nvim`, installs this config and adds an `nvim` alias for bash, zsh and fish.
