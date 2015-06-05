fs = require 'fs'
{EventEmitter} = require 'events'
Color = require './color'
Image = require './image'
Dither = require './dither'

mapFrame = (buf)->
  offset = 0
  len = buf.length
  newBuf = new Buffer len
  
  clip = (i)->
    return 0 if i < 0
    return 255 if i > 255
    i
  
  while offset < len
    Y = buf[offset / 3]
    U = buf[offset / 3 + len / 3]
    V = buf[offset / 3 + len / 3 * 2]
    
    C = Y - 16
    D = U - 128
    E = V - 128
    ###
    newBuf[offset] = clip ( 298 * C           + 409 * E + 128) >> 8
    newBuf[offset + 1] = clip ( 298 * C - 100 * D - 208 * E + 128) >> 8
    newBuf[offset + 2] = clip ( 298 * C + 516 * D           + 128) >> 8
    ###
    [newBuf[offset], newBuf[offset + 1], newBuf[offset + 2]]= Color.yuv2rgb [Y, U, V]
    
    offset += 3
    
  newBuf
  
class Converter extends EventEmitter
  constructor: (@stream, @width = 320, @height = 240)->
    @frames = []
    @partial = new Buffer []
    @stream.on 'data', (buffer)=>
      @partial = Buffer.concat [@partial, buffer]
      
      offset = 0
      while @partial.length - offset >= @width * @height * 3
        newFrame = mapFrame @partial.slice 0 + offset, @width * @height * 3 + offset
        newFrame = new Image newFrame, @width, @height
        @frames.push newFrame
        @emit 'frame', newFrame
        
        offset += @width * @height * 3 + offset
        
      if offset isnt 0
        @partial = @partial.slice offset
      
      #console.log "current #{@frames.length} frames"

module.exports = Converter