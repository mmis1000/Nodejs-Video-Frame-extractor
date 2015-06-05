Converter = require './index'
fs = require 'fs'
Dither = require './dither'

width = 320
height = 240

output = fs.createWriteStream 'test.html'

padding = (item ,len, pad = '0')->
  while item.length < len
    item = pad + item
  item
color = (r, g, b)-> 
  r = r.toString 16 
  g = g.toString 16 
  b = b.toString 16
  "##{padding r, 2}#{padding g, 2}#{padding b, 2}"

output.write """
  <style>
    pre {
      line-height : 3px;
      font-size : 3px;
    }
    span {
      display : inline-block;
      width : 3px;
      height : 3px;
    }
  </style>
"""

  
count = -1

dither = new Dither

conv = new Converter (fs.createReadStream 'test.yuv'), width, height
conv.on 'frame', (frame)->
  count++
  
  outputStr = ''
  
  console.log "frame ##{count}"
  
  outputStr += '<pre>'
  offset = 0
  
  dither.dither frame
  
  for i in [0..frame.height - 1]
    for j in [0..frame.width - 1]
      [r, g, b] = frame.getPixel j, i
      outputStr += "<span style='background:#{color r, g, b}'>  </span>"
    
    #console.log "#{j}, #{i}"
    outputStr += '\r\n'
    
  outputStr += '</pre>'
  output.write outputStr