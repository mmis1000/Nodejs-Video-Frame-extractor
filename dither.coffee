Color = require './color'

class Dither
  constructor: (@originalTable = defaultTable)->
    @names = []
    @colors = []
    
    for name, value of @originalTable
      @names.push name
      @colors.push Color.normalize value
  
  dither: (image)->
    for x in [0..image.width - 1]
      for y in [0..image.height - 1]
        currentColor = image.getPixel x, y
        
        closest = Color.closest currentColor, @colors
        
        closestColor = closest[0]
        
        image.setPixel x, y, closestColor
        
        transferedDiff = Color.multiply (Color.subtract closestColor, currentColor), -0.25
        
        #console.log "#{x}, #{y} current: %j, closest: %j, transferred:  %j", currentColor, closestColor, transferedDiff
        
        #console.log '%j %j %j', x, y, transferedDiff
        ###
        console.log x    , y + 1, image.getPixel x    , y + 1
        console.log x + 1, y - 1, image.getPixel x + 1, y - 1
        console.log x + 1, y    , image.getPixel x + 1, y    
        console.log x + 1, y + 1, image.getPixel x + 1, y + 1
        ###
        image.addPixel x    , y + 1, transferedDiff
        image.addPixel x + 1, y - 1, transferedDiff
        image.addPixel x + 1, y    , transferedDiff
        image.addPixel x + 1, y + 1, transferedDiff
        ###
        console.log x    , y + 1, image.getPixel x    , y + 1
        console.log x + 1, y - 1, image.getPixel x + 1, y - 1
        console.log x + 1, y    , image.getPixel x + 1, y    
        console.log x + 1, y + 1, image.getPixel x + 1, y + 1
        ###
  ditherToName: ()->

defaultTable = [
  [0  ,   0,   0],
  [127,   0,   0],
  [0  , 127,   0],
  [127, 127,   0],
  [0  , 0  , 127],
  [127, 0  , 127],
  [0  , 127, 127],
  [191, 191, 191],
  
  [127, 127, 127],
  [255,   0,   0],
  [0  , 255,   0],
  [255, 255,   0],
  [0  , 0  , 255],
  [255, 0  , 255],
  [0  , 255, 255],
  [255, 255, 255]
]
  
  
module.exports = Dither