###Nodejs Video Frame extractor

split rgb24 stream into frames

------

usage:

    class Extractor
      constructor: new Extractor stream, width, height
        stream : any stream, file stream is also ok
        width  : width  of video
        height : height of video
      
      event:
        frame (Image)
          emit when every frame finished
    
    # since raw rgb24 stream doesn't have header, 
    # it is impossiple to detect the real size of video automatically
      
    class Image
      constructor: rgbBuffer, width, height
      constructor: width, height
      
      methods: 
        getPixel: (x, y)
        setPixel: (x, y, color)
        addPixel: (x, y, color)
      
      propertys:
        buffer: buffer contains pixel data
        width : width of image
        height: height of image
        length: length of internal buffer
    
    # the color is a array contains r, g ,b value
      

------

generate test.rgb `by ffmpeg` for test

`cat [yourvideo] | ffmpeg -i -  -vcodec rawvideo -qp:v 0 -pix_fmt rgb24 -r "2" -vf scale=320:240 -f rawvideo pipe:1 > test.rgb`

run test by `coffee test.coffee`

