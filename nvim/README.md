# neovim

## Prerequisites

- ripgrep
- nodejs
- go
- prettier
- rust
- stylua

## Setup

To set this up, symlink this to the neovim config directory:

```
ln -s ~/personal/settings/nvim ~/.config/nvim
```

Run `nvim` and Packer should automatically install all of the necessary plugins. There may be some warnings/errors, but for the most part, this is because things tried to load before they were actually present. Ensure that Packer installs everything, quit, and re-start neovim.
