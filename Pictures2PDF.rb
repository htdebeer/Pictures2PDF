#!/usr/bin/env ruby
#
# Pictures2PDF (c) 2007 by HT de Beer (Huub@heerdebeer.org)
#
# Version 0 17-9-2007
#
# pictures2pdf uses ImageMagick to transform pictures into photocopy like
# copies. The transformation used is a very slightly adapted version of a
# bash script using ImageMagick created by by Corey Satten, see
# http://corey.elsewhere.org/camscan/ and
# http://corey.elsewhere.org/camscan/scancvt.
# All praise to Satten :-)Pictures2PDF transforms and combines a number of
# pictures into one PDF file

require '/home/htdebeer/Pictures2PDF/PicDocCreator.rb'
require 'getoptlong'

help_text = "NAME
       pictures2pdf - create a photocopy like pdf of photographed pictures of
       a document

SYNOPSIS
       pictures2pdf [ options ] pictures

DESCRIPTION
       pictures2pdf uses ImageMagick to transform pictures into photocopy like
       copies. The transformation used is a very slightly adapted version of a
       bash script using ImageMagick created by by Corey Satten, see
       http://corey.elsewhere.org/camscan/ and
       http://corey.elsewhere.org/camscan/scancvt.
       All praise to Satten :-)

       The output of pictures2pdf can be changed by giving some options:

       -o, --output filename
              The filename of the output pdf document. The default is
              'output.pdf'.

       -h, --help
              Prints this help.

       pictures
              Pictures are specified either by giving the filenames of the
              pictures separated by spaces. Another option is to specify a
              range of pictures by: 'start_picture.pic to end_picture.pic'.
              With 'pic' the proper extension.

              Where start_picture.pic denotes the start of the range and
              end_picture.pic the end of the range. Path and extension are
              stripped and the set containing all successive strings between
              the start string and the end string is generated and transformed
              into a list of filenames.

              pictures2pdf does not check if these filenames represent
              existing files or pictures. So be sure all files in the range
              does exist before using a range.

EXAMPLES
       pictures2pdf -o menu.pdf menu001.jpg to menu006.jpg:
       Creates the pdf file menu.pdf containing the pictures menu001.jpg,
       menu002.jpg, menu003.jpg, menu004.jpg, menu005.jpg, and menu006.jpg.

       pictures2pdf -o \"doc 2.pdf\" pic0.png pic4.png
       pic12.png to pic15.png:
       Creates the pdf file \"doc 2.pdf\" containing the pictures of pic0.png, pic4.png, pic12.png, pic13.png, and pic15.png.

VERSION
       Version 0.

AUTHOR
       HT de Beer

REPORTING BUGS
       Report bugs to <H.T.de.Beer@gmail.com>.

COPYRIGHT
       Copyright © 2007 HT de Beer.
       This is free software. You may redistribute copies of it under the
       terms of the GNU General Public License
       <http://www.gnu.org/licenses/gpl.html>.  There is NO WARRANTY, to the
       extent permitted by law.

SEE ALSO
       http://corey.elsewhere.org/camscan/"

options = GetoptLong.new(
  [ "--output", "-o", GetoptLong::REQUIRED_ARGUMENT ],
  [ "--help", "-h", "-?", GetoptLong::NO_ARGUMENT] )

# The output document created
document = "output.pdf"

# The quality of the transformed pictures using jpeg compression. 1 is bad and
# 99 is best but also largest
quality = 50

# Rotate the pictures by 90 degrees or not.
rotation = 90

# The pictures forming the document should have all the same extension. The
# default is jpg. If pictures with different extensions (and different
# picture types) should be combined into one document, transform the pictures
# first. For example by using 'convert picture.exe1 picture.exe2'
extension = "jpg"

picture_array = Array.new
error_messages = []


options.each do |option, argument|
  case option
    when "--output", "-o"
      document = argument
    when "?", "--help", "-h"
      puts help_text
      exit(0)
  end
end

in_range = false
ARGV.each do |argument|
  case argument
    when "to"
      if picture_array.empty? then
        error_messages.push( "expecting a picture instead of 'to'." )
      else
        # Encountered a range, next argument will be the end of the range.
        # The range will then be constructed.
        in_range = true
      end
    when /.+\.#{extension}/
      if in_range then
        # Construct the range
        dir = File.dirname( argument )
        start_pic_name = File.basename( picture_array.pop, ".#{extension}" )
        end_pic_name = File.basename( argument, ".#{extension}" )
        (start_pic_name..end_pic_name).each do |name|
          picture_array.push( "#{dir}/#{name}.#{extension}" )
        end

        in_range = false
      else
        # Just one picture
        picture_array.push( argument )
      end
    else
      error_messages.push(  "'#{argument}': not recognized as a picture with extension '#{extension}'.")
  end # case
end # do

if in_range then
  error_messages.push( "'to' encountered last, expecting a picture." )
end

if picture_array.empty? and error_messages.empty? then
  error_messages.push("No pictures specified: no document will be created.")
end

# Execute transformation unless there are errors. If so, print them and exit
if !error_messages.empty? then
  puts "Errors encountered during processing of options or pictures:"
  puts "- " + error_messages.join( "\n- " )
  exit(1)
else
  pdc = PicDocCreator.new
  picture_array.each {|pic| pdc.add_picture( pic ) }
  pdc.create_pdf( document )
end
