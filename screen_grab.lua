-- -------------------------------------------------------------------------------------
-- Quick and easy screen capture
-- -------------------------------------------------------------------------------------
-- Launch a screen capture that will copy the result to the pastboard
-- Great for quick snips to paste into another app
-- (Wanted to kill grabber (kill9) so it didn't prompt to save file, but alas
-- doing that lost the image from the pastboard, and Hammerspoon couldn't read
-- the image into a variable for some reason.
maxTimer = 20
timerNum = 0
checkForCaptureTimer = nil
GRABBUNDLEID = 'com.apple.Grab'
capturedImage = nil
hs.hotkey.bind({'alt'}, 'G', function()
  -- Stop any previous timer checking for a Grab window
  if checkForCaptureTimer ~= nil then
    checkForCaptureTimer:stop()
  end
  -- Launch Grab app
  hs.application.launchOrFocusByBundleID(GRABBUNDLEID)
  log(hs.inspect(hs.application.applicationsForBundleID(GRABBUNDLEID)))
  grabApp = hs.application.applicationsForBundleID(GRABBUNDLEID)[1]
  if grabApp == nil then
    hs.alert('Grab app not found.')
    return
  end
  -- If Grab already running, bail (nee no windows open in Grab so can detect when a new one opens)
  wins = grabApp:mainWindow()
  if win ~= nil then
      hs.alert('Existing window found. Aborting. Dismiss window and try again.')
      return
  end

  log('Reqesting selection capture')
  grabApp:selectMenuItem({'Capture', 'Selection'})

  -- Wait for user to make the selection (Grab to open a new window)
  timerNum = 0
  checkForCaptureTimer = hs.timer.doEvery(1, function()
    timerNum = timerNum + 1
    grabApp = hs.application.applicationsForBundleID(GRABBUNDLEID)[1]
    if grabApp == nil then
      hs.alert('Grab app not found. Did you quit before making a selection?')
      checkForCaptureTimer:stop()
      return
    end
    wins = grabApp:mainWindow()
      if wins == nil then
        log('No Grab window yet')
        if timerNum > maxTimer then
          hs.alert('You waited to long to make your selection. Please try again.')
          checkForCaptureTimer:stop()
        end
        return
      end
      checkForCaptureTimer:stop()
      grabApp = hs.application.applicationsForBundleID(GRABBUNDLEID)[1]
      grabApp:selectMenuItem({'Edit', 'Copy'})
      hs.alert('Selection copied')
    end)
end)
