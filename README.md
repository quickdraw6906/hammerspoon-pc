# hammerspoon-pc
My hammerspoon Lua scripts bring PC key bindings to the mac (and other useful goodies)

This is a labor of love for a left hand mouser who needs a ten key and therefore REALLY REALLY wants cut/copy/paste functions on the right hand. Oh, and I really need to be productive on a mac but live in PC land much of the time for Visual Studio work (hey at least that work is in a VM on a mac now). I also do a ton of work through remote servers with Microsoft Remote Desktop.

## Installation
Install [Hammerspoon](http://www.hammerspoon.org/)
Create a directory: ~/.hammerspoon and put all files there. If you already have Hammerspoon, rename init.lua to hammerspoon-pc.lua before copying into ~/.hammerspoon, then edit your init.lua and add the following:

require('hammerspoon-pc')

## Customizing
You can have each app get a different set of keypresses. Edit actions.lua. But first you need to know the internal application name. In bindings.lua you will see that Alt+a has been mapped to a Hammerspoon function that displays the app name. Enter that name exactly into the mapping, replacing spaces with underscores.

For example, moving the cursor to the begining or the ending of the line is tricking on a Mac. It's like the REALLY didn't want you to do that. To have this work in all contexts (browsers are special snowflakes), there is this mapping in actions.lua:

```lua
beginLine = {
  default = {{'cmd'}, 'left'},
  Terminal = {{'alt'}, 'left'},
  iTerm2 = {},
  Microsoft_Remote_Desktop = {},
  VirtualBox_VM = {},
  -- SKip in browsers. cmd+arrows used to navigate pages
  Chrome = {},
  Safari = {},
  Firefox = {},
  Opera = {}
},
```

This says for the home key send Command+Left normally, but in browsers, Virtualbox and MS RDP pass through the home key and in Terminal (another special snowflake) send Alt+Left.



## Principles
Whoah to left hand people. Besides poor mouse choices on the market, Mac folks have the curse of right hand only for cut/copy/paste on keyboard. On the PC, Ctrl+Insert, Shift+Insert and Shift+Delete are key kit.

PC folks making their way to the mac have to contend with a huge divide in keyboard conventions and cursor movement.

Selecting whole words with the keyboard is more natural when the modifier for such action is as close to the arrow keys as possible. On a Mac, you have to twist your wrist to reach for the option key. Millimeters matter when using the thumb on option and the index finger on left and right arrow keys.

IT professionals who need to administer PC's remotely and use alternate OS's need to run virtualization software and remote control software. That's a big problem from a Mac. The keyboard event model, and just plain weird shortcut choices just don't translate well. Try moving ten lines of anything one line at a time from a Windoz VM or RDP session to a file in Atom. Talk about brain/key gymnastics (yes there are other ways to do this, I'm just talking about small quick things).

Add all that up- Left hand mouse keyboard wizards coming from decades of PC use (with diminishing brain plasticity) using Mac OS 10.12+ (Sierra)...are pretty much screwed. These scripts are an attempt to ease the transition**

\* Hello Karabiner Elements as a reaction to issues with keyboard Sierra hell for us GTD folks.

** Also a hope is to forestall arthritis by having to do the contortions the Mac keyboard layout cause, like tucking the thumb under the palm on the left hand to get Command+X, etc.

## Pasteboard, Right Hand?
There is only one "real" keyboard layout for max efficiency (see below). Yes, you can get good on the Mac layout. The PC will just always be better. Mac has a layout that comes close, but where on a PC there is an insert key, the mac has a function key. So to get x/c/p on the right hand consistent with the standard PC x/c/p shortcuts of ctrl+insert, shift+delete (forward delete to those in mac land), and shift+insert, we have to use a program like Hammerspoon to (literally) take back control!

## Woah To Sierra Users
Sierra changed the game with the key event model. None of this would be needed if this version of the OS didn't throw Karabiner off kilter. I'd just send folks to that app (https://pqrs.org/osx/karabiner/). Alas, it doesn't work under Sierra. Work is in progress on that, but who knows when it will be ready (downside of open source software).

## Other Options
damieng has posted a great set of default keymaps for the basic movements. Note however, that not all apps honor default key bindings in Mac OS (XCode, Firefox, etc.)
https://damieng.com/blog/2015/04/24/make-home-end-keys-behave-like-windows-on-mac-os-x

## Open Issues
* No x/c/p functions work in MinTTY (bash emulator for git) on Windoz (VM)
* Ctrl+Fn & Shift+Fn don't work in Microsoft Remote Desktop (mods not sending)

## Why all these maps?
To replicate keyboard use with this PC layout, and a left hand mouser:

|Main Area|Magic Happens|Ten Key Area
| :-------------: | :-----------: | :---------------: |
[~][F1]..........................[F12][Eject]|[PrtScr] [ScrLck] [P/Brk]|~~[F16][F17][F18][F19]~~
 Main keys |**[Ins]**[Home][Pg Up]|[NL][Eq][Div][Mul]
 Main keys |**[Del]**[End] [Pg Dn]|[7] [8] [9] [-]
 Main keys ||[4] [5] [6] [+]
 [Shift]  Main keys  **[Shift]** |[Up]|[1] [2] [3] [Ent]
 [Ctrl] [Win] [Alt] [Space] [Alt] [Win] **[Ctrl]**  |  **[Left]** [Down] **[Right]**  |[Zero][Dot][Ent]
