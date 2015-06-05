Color = require './color'

class Image
  constructor: (@buffer, @width, @height)->
    if 'number' is typeof @buffer
      @height = @width
      @width = @buffer
      @buffer = new Buffer @width * @height * 3
    
    @length = @width * @height
  getPixel: (x, y)->
  
    x = Math.floor x
    y = Math.floor y
    
    x = 0 if x < 0
    x = @width if x >= @width
    
    y = 0 if y < 0
    y = @height if y >= @height
    
    base = (x + y * @width) * 3
    
    
    return [
      @buffer[base],
      @buffer[base + 1],
      @buffer[base + 2],
    ]
  
  setPixel: (x, y, color)->
    x = Math.floor x
    y = Math.floor y
      
    return false if x < 0
    return false if x >= @width
    
    return false if y < 0
    return false if y >= @height
    
    color = Color.normalize color
    
    base = (x + y * @width) * 3
    
    @buffer[base    ] = color[0]
    @buffer[base + 1] = color[1]
    @buffer[base + 2] = color[2]
    
    true
    
  addPixel: (x, y, color)->
    x = Math.floor x
    y = Math.floor y
  
    return false if x < 0
    return false if x >= @width
    
    return false if y < 0
    return false if y >= @height
    
    base = (x + y * @width) * 3
    
    #console.log base
    
    r = color[0] + @buffer[base    ]
    g = color[1] + @buffer[base + 1]
    b = color[2] + @buffer[base + 2]
    
    color = Color.normalize [r, g, b]
    
    @buffer[base    ] = color[0]
    @buffer[base + 1] = color[1]
    @buffer[base + 2] = color[2]
    
    
    true
 
module.exports = Image