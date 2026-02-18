# Neovim Keymap Reference

**Leader key:** `,` (comma)

Mode abbreviations: **n** = normal, **v** = visual, **i** = insert, **o** = operator-pending, **x** = visual+select, **t** = terminal, **s** = select, **c** = command

## Quitting & Saving

| Keys | Mode | Description |
|------|------|-------------|
| `ZZ` | n | Save and quit (wipes terminal buffers) |
| `ZQ` | n | Force quit without saving |
| `XX` | n | Save and quit all |
| `XQ` | n | Force quit all |
| `;;` | n | Save buffer |
| `,w` | n | Save buffer (LSP buffers only) |

## Buffers

| Keys | Mode | Description |
|------|------|-------------|
| `,c` | n | Smart close buffer |
| `,C` | n | Delete buffer and go to next |
| `,b` | n | New buffer |
| `Tab` | n | Next buffer |
| `Shift+Tab` | n | Previous buffer |

## Window Navigation

| Keys | Mode | Description |
|------|------|-------------|
| `Alt+h` | n | Navigate to left window |
| `Alt+j` | n | Navigate to bottom window |
| `Alt+k` | n | Navigate to top window |
| `Alt+l` | n | Navigate to right window |

## Window Resizing

| Keys | Mode | Description |
|------|------|-------------|
| `Ctrl+Alt+h` | n | Decrease width |
| `Ctrl+Alt+j` | n | Decrease height |
| `Ctrl+Alt+k` | n | Increase height |
| `Ctrl+Alt+l` | n | Increase width |

## Search

| Keys | Mode | Description |
|------|------|-------------|
| `,/` | n | Clear search highlights |

## File Paths

| Keys | Mode | Description |
|------|------|-------------|
| `,yr` | n | Copy relative path to clipboard |
| `,ya` | n | Copy absolute path to clipboard |
| `,%r` | n | Show relative path |
| `,%a` | n | Show absolute path |

## Line Numbers

| Keys | Mode | Description |
|------|------|-------------|
| `,1` | n | Cycle line number mode |
| `,2` | n | Set custom line numbers |
| `,3` | n | Set relative line numbers |
| `,4` | n | Set absolute line numbers |

## Text Manipulation

| Keys | Mode | Description |
|------|------|-------------|
| `J` | v | Move selected lines down |
| `K` | v | Move selected lines up |
| `F9` | i | Exit insert, go to beginning of line |
| `F10` | i | Exit insert, go to end of line |

## File Explorer (Oil)

| Keys | Mode | Description |
|------|------|-------------|
| `-` | n | Open file explorer at current file |
| `,f` | n | Open file explorer at working directory |

## Fuzzy Finding (Telescope)

| Keys | Mode | Description |
|------|------|-------------|
| `Ctrl+p` | n, i | Find files |
| `Alt+p` | n, i | Find git files |
| `Ctrl+f` | n, i | Live grep |
| `Alt+f` | n, i | Live grep |
| `,,` | n, i | Find Neovim config files |
| `,?` | n | Open Telescope picker list |
| `,M` | n | View notification history |

## Flash (Motion)

| Keys | Mode | Description |
|------|------|-------------|
| `s` | n, o, x | Flash jump to any location |
| `S` | n, o, x | Flash treesitter select |
| `o` | o | Remote flash |
| `R` | o, x | Treesitter search |
| `Ctrl+s` | c | Toggle flash in search |

## LSP

| Keys | Mode | Description |
|------|------|-------------|
| `K` | n | Hover documentation |
| `gd` | n | Go to definition |
| `gD` | n | Go to declaration |
| `gi` | n | Go to implementation |
| `go` | n | Go to type definition |
| `gr` | n | Find references |
| `gh` | n | LSPSaga finder (references/definitions) |
| `gp` | n | Peek definition |
| `,la` | n, v | Code action |
| `,lf` | n | Format buffer |
| `,lr` | n | Rename symbol |
| `,li` | n | Show cursor diagnostics |
| `,ih` | n | Toggle inlay hints |

## Diagnostics

| Keys | Mode | Description |
|------|------|-------------|
| `Ctrl+j` | n | Next diagnostic (or next Trouble entry if open) |
| `Ctrl+k` | n | Previous diagnostic (or prev Trouble entry if open) |
| `,!` | n | Workspace diagnostics |
| `,%!` | n | Buffer diagnostics |
| `,?` | n | Line diagnostics (LSP buffer) |

## LSP Call Hierarchy

| Keys | Mode | Description |
|------|------|-------------|
| `,ki` | n | Incoming calls |
| `,ko` | n | Outgoing calls |

## Completion (nvim-cmp)

| Keys | Mode | Description |
|------|------|-------------|
| `Ctrl+Space` | i | Trigger completion |
| `Ctrl+y` | i | Confirm completion |
| `Ctrl+e` | i | Abort completion |
| `Ctrl+u` | i | Scroll docs up |
| `Ctrl+d` | i | Scroll docs down |

## Trouble

| Keys | Mode | Description |
|------|------|-------------|
| `,xx` | n | Toggle project diagnostics |
| `,xX` | n | Toggle buffer diagnostics |
| `,xs` | n | Toggle symbols outline |
| `,xl` | n | Toggle LSP definitions/references |
| `,xL` | n | Toggle location list |
| `,xQ` | n | Toggle quickfix list |

## Quickfix

| Keys | Mode | Description |
|------|------|-------------|
| `,q` | n | Toggle quickfix list |
| `Enter` | n (in qf) | Open entry and close quickfix |

## Code Outline (Aerial)

| Keys | Mode | Description |
|------|------|-------------|
| `,o` | n | Toggle code outline (Telescope/Aerial) |

## Git (GitSigns)

### Hunk Navigation

| Keys | Mode | Description |
|------|------|-------------|
| `Ctrl+l` | n | Next git hunk |
| `Ctrl+h` | n | Previous git hunk |

### Hunk Actions

| Keys | Mode | Description |
|------|------|-------------|
| `,hs` | n, v | Stage hunk |
| `,hr` | n, v | Reset hunk |
| `,hS` | n | Stage entire buffer |
| `,hu` | n | Undo stage hunk |
| `,hR` | n | Reset entire buffer |
| `,hp` | n | Preview hunk |
| `,hb` | n | Blame line (full) |
| `,hd` | n | Diff this |
| `,hD` | n | Diff this (against ~) |
| `,tb` | n | Toggle current line blame |
| `,td` | n | Toggle deleted lines |
| `ih` | o, x | Select hunk (text object) |

## Git (LazyGit)

| Keys | Mode | Description |
|------|------|-------------|
| `,lg` | n | Open LazyGit |

## Git Worktree

| Keys | Mode | Description |
|------|------|-------------|
| `,wc` | n | Create git worktree |
| `,wo` | n | Switch git worktree |

## Terminal (Multiterm)

| Keys | Mode | Description |
|------|------|-------------|
| `Alt+o` | n, i, v, t | Toggle terminal |
| `F1` | n, i, v, t | Terminal 1 |
| `F2` | n, i, v, t | Terminal 2 |
| `F3` | n, i, v, t | Terminal 3 |
| `F4` | n, i, v, t | Terminal 4 |
| `Esc Esc` | t | Exit terminal mode |
| `Meta+Esc` | t | Exit terminal insert mode |

## Testing (Neotest)

| Keys | Mode | Description |
|------|------|-------------|
| `Meta+t` | n, i | Run current test |
| `Ctrl+t` | n, i | Run all tests in file |
| `,tr` | n | Run current test |
| `,tt` | n | Run all tests in file |
| `,tl` | n | Run last test |
| `,dt` | n | Debug current test |
| `,to` | n | Open test output |
| `,tO` | n | Toggle output panel |
| `,th` | n | Toggle test summary |

## Debugging (DAP)

| Keys | Mode | Description |
|------|------|-------------|
| `F5` | n | Continue / start debugging |
| `Shift+F5` | n | Terminate debugger |
| `F8` | n | Step out |
| `F9` | n | Step into |
| `F10` | n | Step over |
| `,db` | n | Toggle breakpoint |
| `,dB` | n | Conditional breakpoint |
| `,dl` | n | Log point |
| `,dr` | n | Open REPL |
| `,dR` | n | Run last debug config |
| `,du` | n | Toggle DAP UI |

## Claude Code

| Keys | Mode | Description |
|------|------|-------------|
| `,ai` | n | Toggle Claude terminal |
| `,as` | v | Send selection to Claude |

## REST Client (Kulala)

| Keys | Mode | Description |
|------|------|-------------|
| `,rr` | n | Run request |
| `,rv` | n | Toggle response view |
| `,rn` | n | Jump to next request |
| `,rp` | n | Jump to previous request |
| `,rc` | n | Copy request to clipboard |
| `,re` | n | Set environment |

## Database (Dadbod UI)

| Keys | Mode | Description |
|------|------|-------------|
| `,Db` | n | Toggle database UI |
| `,Df` | n | Find database buffer |
| `,Dr` | n | Rename database buffer |
| `,Dq` | n | Show last query info |

## Snippets (LuaSnip)

| Keys | Mode | Description |
|------|------|-------------|
| `Right` | i, s | Jump to next snippet placeholder |
| `Left` | i, s | Jump to previous snippet placeholder |

## Split/Join (TreeSJ)

| Keys | Mode | Description |
|------|------|-------------|
| `Space m` | n | Toggle split/join |
| `Space j` | n | Join nodes |
| `Space s` | n | Split nodes |

## Treesitter Incremental Selection

| Keys | Mode | Description |
|------|------|-------------|
| `Ctrl+Space` | n | Start incremental selection |
| `Ctrl+Space` | (in selection) | Expand selection |
| `Backspace` | (in selection) | Shrink selection |

## Treesitter Text Objects

### Selection

| Keys | Mode | Description |
|------|------|-------------|
| `af` / `if` | o, x | Outer / inner function |
| `ac` / `ic` | o, x | Outer / inner function call |
| `ap` / `ip` | o, x | Outer / inner parameter |
| `ai` / `ii` | o, x | Outer / inner conditional |
| `al` / `il` | o, x | Outer / inner loop |
| `as` / `is` | o, x | Outer / inner class/struct |
| `a=` / `i=` | o, x | Outer / inner assignment |
| `l=` / `r=` | o, x | Left-hand / right-hand side of assignment |

### Navigation

Move to **next** start / end:

| Keys | Mode | Description |
|------|------|-------------|
| `]f` / `]F` | n, x, o | Next function start / end |
| `]c` / `]C` | n, x, o | Next call start / end |
| `]s` / `]S` | n, x, o | Next class/struct start / end |
| `]i` / `]I` | n, x, o | Next conditional start / end |
| `]l` / `]L` | n, x, o | Next loop start / end |
| `]p` / `]P` | n, x, o | Next parameter start / end |
| `]=` | n, x, o | Next assignment |

Move to **previous** start / end:

| Keys | Mode | Description |
|------|------|-------------|
| `[f` / `[F` | n, x, o | Previous function start / end |
| `[c` / `[C` | n, x, o | Previous call start / end |
| `[s` / `[S` | n, x, o | Previous class/struct start / end |
| `[i` / `[I` | n, x, o | Previous conditional start / end |
| `[l` / `[L` | n, x, o | Previous loop start / end |
| `[p` / `[P` | n, x, o | Previous parameter start / end |
| `[=` | n, x, o | Previous assignment |

### Repeat Motion

| Keys | Mode | Description |
|------|------|-------------|
| `;` | n, x, o | Repeat last motion forward |
| `,` | n, x, o | Repeat last motion backward |

## Session

| Keys | Mode | Description |
|------|------|-------------|
| `,S` | n | Save workspace session |

## Neovide Only

| Keys | Mode | Description |
|------|------|-------------|
| `Cmd+=` | n, i | Increase font size |
| `Cmd+-` | n, i | Decrease font size |
| `Cmd+0` | n, i | Reset font size |
