# ShepardAppearanceConverter

A Swift 2.0 experiment

![Screenshot](/ScreenShot.png?raw=true)

## Project Goals

- ~~Convert codes between Game 1 and Game 2 or 3~~ (completed)
- ~~Style with a custom UISlider and other fancier UI choices~~
- Read codes in via camera text recognition
  - Waiting for Tesseract to work better on Swift 2.0/Xcode 7
- ~~Save Shepard codes to device~~ (completed)
- ~~Save photos with Shepard codes~~
  - ~~Save photos from Camera Roll~~ (completed)
  - ~~Save photos from Camera~~
- ~~Save multiple Shepards~~ (completed)
- ~~Save to a database instead of NSUserDefaults~~ (completed)

## Things learned

- UIStackView is very buggy still, particularly in vertical compression/expansion.
- Size Classes don't seem to be working right, particularly with UIStackView
- Baseline autolayout is easily broken by other autolayout settings and/or compression/expansion settings, in very unintuitive ways.
- Xcode 7 crashes all the time
- CoreData, like NSUserDefaults, doesn't save right on Simulator stop.
- I love protocols
- Signals library only works with class listeners, which sucks as more and more things are made of struct.