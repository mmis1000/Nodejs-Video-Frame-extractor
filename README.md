###Nodejs Video Frame extractor

split yuv stream into frames

------

generate test.yuv `by ffmpeg` for test

`cat [yourvideo] | ffmpeg -i -  -vcodec rawvideo -qp:v 0 -pix_fmt yuv444p -r "2" -vf scale=320:240 -f rawvideo pipe:1 > test.yuv`

run test by `coffee test.coffee`

