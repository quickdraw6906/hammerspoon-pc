-- -------------------------------------------------------------------------------------
-- Trap flagsChanged
-- -------------------------------------------------------------------------------------
-- Map keys for cut/copy/paste that are in the same physical location on the keyboard as a PC keyboard (for the right hand)
-- That is, make ctrl+fn, shift+fn do stuff (shift+forwarddelete is handled in the keyDown event tap below)

-- Have to trap flagsChanged event instead of keyDown because holding only modifier keys doesn't trigger a keyDown event on Macs

-- Note: by trapping flag changes, with no actual event to shunt, any key events created here will prop to the OS of VM and RDP
-- windows (VitualBox and Microsoft Remote Desktop). So, these shortcuts won't work in those contexts
etFlags = hs.eventtap.new({hs.eventtap.event.types.flagsChanged}, function (e)
  log('flagsChanged event: flags=' .. hs.inspect(e:getFlags()))
  flags = e:getFlags()
  if flags.fn then
    if hs.eventtap.checkKeyboardModifiers().ctrl then -- Ctrl + Fn is same position physically as Ctrl + Insert on PC keyboard

      keyEvents.ctrlFn()
    end
    if hs.eventtap.checkKeyboardModifiers().shift then -- Shift + Fn is same position physically as Shift + Insert on a PC keyboard
      keyEvents.shiftFn()
    end
  end
  if flags.cmd and flags.ctrl and flags.alt and CLEAR_LOG_ON_HYPER_KEY then
    hs.console.clearConsole()
  end

end)
etFlags:start()
