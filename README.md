# Cronos

A small World of Warcraft 1.12 addon (made for OctoWoW) that brings the minimap calendar button back when **ShaguTweaks → "MiniMap Tweaks"** is enabled.

MiniMap Tweaks hides `GameTimeFrame` (the sun/moon button at the top-right of the minimap) and adds an `OnShow` script that keeps re-hiding it. This addon restores the button's original `OnShow` script and shows it again. The other MiniMap Tweaks changes stay in place: mousewheel zoom, hidden zoom buttons and the cleaner minimap header.

## Installation

1. Download the repository (**Code → Download ZIP**).
2. Extract it into `World of Warcraft\Interface\AddOns\`.
3. Rename the folder from `Calendar-main` to **`Cronos`**. The folder name has to match `Cronos.toc`.
4. Restart the game.

## Usage

- **Shift + drag** the button to move it. The position is saved per character, which is handy with "MiniMap Square".
- `/cronos reset`: put the button back in its default spot
- `/cronos show`: force the button to show again

## Compatibility

- Client: 1.12.1 (Interface 11200)
- Works alongside ShaguTweaks and ShaguTweaks-extras
