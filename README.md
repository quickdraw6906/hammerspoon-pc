# hammerspoon-pc
My hammerspoon Lua scripts to bring PC key bindings to the mac (and other useful goodies)

This is a labor of love for a left hand mouser who needs a ten key and therefore REALLY REALLY wants cut/copy/paste functions on the right hand. Oh, and I really need to be productive on a mac but live in PC land much of the time for Visual Studio work (hey at least that work is in a VM on a mac now).

## Principles
IMO: Apple created, still creates*, and forces other app developers to create huge piles of technical debt (tied with Windoz? More?) by not providing having common keyboard services that apps get by default. I'm not all hip on all the low level issues, but something isn't right about how keyboard events are handled.

Woah to left hand people. Besids poor mouse choices on the market, Mac folks have the curse of right only cut/copy/paste on keyboard.

PC folks making their way to the mac have to contend with a huge divide in keyboard conventions.

Selecting whole words with the keyboard is more natural when the modifier for such action is as close to the arrow keys as possible. On a Mac, you have to twist your wrist to reach for the option key. Millimeters matter when using the thumb on option and the index finger on left arrow.

IT professionals who need to administer PC's remotely and use alternate OS's need to run virtualization software and remote control software. That's a big problem from a Mac. The keyboard event model and just plain wierd shortcut choices just doesn't translate well. Try moving ten lines of anything one line at a time from an Windoz VM to a file in Atom. Talk about brain/key gymnastics. Ditto with the Mac native app Microsoft Remote Desktop.

Add all that up and Left hand mouse keyboard wizards coming from decades of PC use (with dimishing brain plasticity) using Mac OS 10.12 (Sierra)...are pretty much screwed. These scripts are an attempt to ease the transition**

\* Hello Karabiner Elements as a reaction to issues with keyboard Sierra hell for us GTD folks.

** Also a hope is to forestall arthritis by having to do the contortions the Mac keyboard layout cause.

## Pasteboard, Right Hand?
There is only one "real" keyboard layout for max efficiency. Mac has such a layout but where on a PC there is an insert key, the mac has a function key. So to get x/c/p on the right hand consistenct with the standard shortcuts (can I say that in Mac land? STANDARD!) c/x/p keys of ctrl+insert, shift+del (forward delete to those in mac land), and shift+insert

## Open Issues
Select word (next/previous) is buggy. There event issues on repeat strokes. You end up switching desktops. I tried to go as low level as possible, but some events fall through to the OS.

shift+fn is not working for paste in VirtualBox

A screen grab function could not be done totally gracefully because from th Grab app Hammerspoon couldn't load the image in the pasteboard into a variable. Something to research...

I keep having the situation where Hammerspoon loses all eventtaps. I have to reload the config periodically. Would love some insights into that. I might have to schedule a reload on a timer every 30 seconds or so (yuck).

## Work in Progress
I'm still learning a ton about keyboard events. Any wisdom is appreciated.


## Why all these maps?

For keyboards with this layout, and a left hand mouser:

|Main Area|Magic Happens|Ten Key Area
| :-------------: | :-----------: | :---------------: |
[~][F1]..........................[F12][Eject]|[PrtScr] [ScrLck] [P/Brk]|[F16][F17][F18][F19]
Main keys|[Ins][Home][Pg Up]|[Clr][Eq][Div][Mul]
Main keys|[Del][End] [Pg Dn]|[7] [8] [9] [-]
Main keys||[4] [5] [6] [+]
Main keys|[Up]|[1] [2] [3] [Ent]
[Ctrl] [Win] [Alt] [Space] [Alt] [Win] [Ctrl]  |  [Left] [Down] [Right]|[Zero][Dot][Ent]

Herm...so much for tables in Github. Renders fine here [kramdown renderer](https://kramdown.herokuapp.com/)
