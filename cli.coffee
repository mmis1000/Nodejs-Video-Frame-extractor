args = process.argv[2..]

fs = require 'fs'
Converter = require './index'
childProcess = require 'child_process'
Dither = require './dither'


printHelp = ()->
  console.log """
    nodejs video frame extractor
    
    [command name] width height file [-rgb] [-o outputFile]
    options:
      rgb: use raw rgb format file
  """

pipeFFmpeg = (stream, width ,height)->
  width = Math.floor width
  height = Math.floor height
  
  ffmpegArguments = ['-i', '-', '-vcodec', 'rawvideo', '-qp:v', '0', '-pix_fmt', 'rgb24', '-r', '2', '-vf', "scale=#{width}:#{height}", '-f', 'rawvideo', '-']
  
  console.error 'ffmpeg options: ' + (ffmpegArguments.join ' ')

  #console.log 'spawning ffmpeg process with arguments %j', ffmpegArguments
  
  child = childProcess.spawn 'ffmpeg', ffmpegArguments
  
  stream.pipe child.stdin
  
  child.stderr.pipe process.stderr
  
  return child.stdout

noFFmpeg = false
inputStream = null
outputStream = process.stdout
ditherer = (i)->i


parseOption = (args, singleOptions)->
  for value, index in args
    if 0 is value.search '-'
      option = args[index..]
      args = args[0 .. index - 1]
      break
  
  options = {}
  
  if not option
    return {
      args : args[0..]
      options : {}
    }
  
  #console.log args, option
  
  index = 0
  while index < option.length
    val = option[index]
    valNext = option[index + 1]
    
    if val in singleOptions
      options[val] = true
      index++
    
    else
      options[val] = valNext
      index += 2
  
  {
    args : args
    options : options
  }
  
options = parseOption args, ['--rgb', '--dither']

console.log options

if options.args.length != 3
  printHelp()
  process.exit()


width = parseInt options.args[0]
height = parseInt options.args[1]
filename = options.args[2]



console.log '<!--', width, height, filename, '-->\r\n'

inputStream = fs.createReadStream filename

if not options.options['--rgb']
  inputStream = pipeFFmpeg inputStream, width, height

if options.options['-o']
  outputStream = fs.createWriteStream options.options['-o']

if options.options['--dither']
  ditherer = new Dither
  ditherer = ditherer.dither.bind ditherer


padding = (item ,len, pad = '0')->
  while item.length < len
    item = pad + item
  item
color = (r, g, b)-> 
  r = r.toString 16 
  g = g.toString 16 
  b = b.toString 16
  "##{padding r, 2}#{padding g, 2}#{padding b, 2}"

outputStream.write """
  <style>
    pre {
      line-height : 6px;
      font-size : 6px;
    }
    span {
      display : inline-block;
      width : 6px;
      height : 6px;
    }
  </style>
"""

  
count = -1

conv = new Converter inputStream, width, height
conv.on 'frame', (frame)->
  count++
  
  outputStr = ''
  
  ditherer frame
  #console.log "frame ##{count}"
  
  outputStr += "
    <a href='#'>frame</a>
    <pre>
  "
  offset = 0
  
  for i in [0..frame.height - 1]
    for j in [0..frame.width - 1]
      [r, g, b] = frame.getPixel j, i
      outputStr += "<span style='background:#{color r, g, b}'>  </span>"
    
    #console.log "#{j}, #{i}"
    outputStr += '\r\n'
    
  outputStr += '</pre>'
  outputStream.write outputStr









