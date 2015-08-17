# ShepardAppearanceConverter

A Swift 2.0 experiment

![Screenshot](/ShepardAppearanceConverter/blob/master/ScreenShot.png?raw=true)

## Project Goals

- ~~Convert codes between Game 1 and Game 2 or 3~~ (completed)
- Style with a custom UISlider and other fancier UI choices
- Read codes in via camera text recognition
- ~~Save Shepard codes to device~~ (completed)
- Save photos with Shepard codes
  - ~~Save photos from Camera Roll~~ (completed)
  - Save photos from Camera
- ~~Save multiple Shepards~~ (completed)
- Save to a database instead of NSUserDefaults

## Current issues

- Need real icons/colors/slider styles

## Things learned

- UIStackView is very buggy still, particularly in vertical compression/expansion.
- Size Classes don't seem to be working right
- UIStackView size class settings not working
- Baseline autolayout is easily broken by other autolayout settings and/or compression/expansion settings, in very unintuitive ways.