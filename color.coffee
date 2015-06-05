colorspaces = require 'colorspaces'

rgb2lab = colorspaces.converter 'sRGB', 'CIELAB'

class Color
  constructor: ()->
  
  yuv2rgb: ([Y, U, V])->
    
    C = Y - 16
    D = U - 128
    E = V - 128

    R = (298 * C           + 409 * E + 128) >> 8
    G = (298 * C - 100 * D - 208 * E + 128) >> 8
    B = (298 * C + 516 * D           + 128) >> 8
    
    return @normalize [R, G, B]
  
  clip: (i)->
    return 0 if i < 0
    return 255 if i > 255
    i
  
  normalize: (color)->
    [
      (@clip color[0]),
      (@clip color[1]),
      (@clip color[2])
    ]
  
  add: (color1 , color2)->
    [
      color1[0] + color2[0],
      color1[1] + color2[1],
      color1[2] + color2[2]
    ]
  
  subtract: (color1 , color2)->
    [
      color1[0] - color2[0],
      color1[1] - color2[1],
      color1[2] - color2[2]
    ]
  
  multiply: (color1, num)->
    [
      color1[0] * num,
      color1[1] * num,
      color1[2] * num
    ]
  
  rgb2lab: (color)->
    color = @normalize color
    color[0] = color[0] / 256
    color[1] = color[1] / 256
    color[2] = color[2] / 256
    rgb2lab color
  
  distance: (color1, color2)->
    #console.log "rgb #{color1} #{color2}"
    color1 = @rgb2lab color1
    color2 = @rgb2lab color2
    #console.log "lab #{color1} #{color2}"
    (color1[0] - color2[0]) ** 2 + (color1[1] - color2[1]) ** 2 + (color1[2] - color2[2]) ** 2
    
  closest: (color, colors)->
    closestIndex = -1
    closestDistence = Infinity
    
    for anotherColor, index in colors
      newDistance = @distance color, anotherColor
      if newDistance < closestDistence
        closestIndex = index
        closestDistence = newDistance
    
    #console.log 'closest %j %j', color, colors[closestIndex]
    
    return [colors[closestIndex], closestIndex]
  
module.exports = new Color