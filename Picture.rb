require 'fileutils'

class Picture

  attr_reader :filename

  def initialize( filename )
    @filename = filename
    @extension = File.extname( filename )
    @name = File.basename( filename, @extension )
    @path = File.dirname( filename )
    @pathname = filename.gsub( @extension, "" )
  end

  # transform picture into a photocopy-like version of it.
  # This method is based on a bash script written by Corey Satten. He uses ImageMagick to transform the picture into a photocopy-like version. For more information about this script see: http://corey.elsewhere.org/camscan/scancvt and (http://corey.elsewhere.org/camscan/)
  # What Satten is doing, I do not know exactly, but it works. So, all thanks to him or her!
  def photo_copy!( quality = 50 )
    aux1 = "aux1-#{@name}#{@extension}"
    aux2 = "aux2-#{@name}#{@extension}"
    aux3 = "aux3-#{@name}#{@extension}"

    system("convert \"#{@filename}\" -colorspace gray -resize 5120x5120 \"#{aux2}\"")
    system("convert \"#{@filename}\" -colorspace gray -resize 1024x1024 -negate -blur 15,15 -resize 5120x5120 #{aux1}")
    system("composite -colorspace gray -compose plus \"#{aux2}\" \"#{aux1}\" \"#{aux3}\"")
    system("convert \"#{aux3}\" -colorspace gray -quality #{quality}  -normalize -level 50,85% \"#{@filename}\"")

    File.delete(aux1)
    File.delete(aux2)
    File.delete(aux3)
  end

  def landscape?
    dimensions = `identify -format "%wx%h" \"#{@filename}\"`.split( "x" )
    width = dimensions[0].to_i
    height = dimensions[1].to_i
    return ( width >= height )
  end

end