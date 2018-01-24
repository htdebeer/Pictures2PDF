# PicDocCreator
#
# Create a pdf-document from a set of pictures
#
# (c) 2007 by HT de Beer
#             Huub@heerdebeer.org
#
require 'fileutils'
require '/home/htdebeer/Pictures2PDF/Picture.rb'

class PicDocCreator

  # Create a PicturesDocument, setting attributes to default value:
  # - quality = 50
  # - rotation = 0, that is: no rotation.
  # - output = "output.pdf" in the current working directory
  # - pictures is a new created array.
  def initialize( )
   @output = "output.pdf"
   @pictures = Array.new
  end

  # Clear the set of pictures
  def clear()
    @pictures.clear
  end

  # Add a picture to the set of pictures to be included in the document
  def add_picture( pic )
    @pictures.push( pic )
  end

  # Create a pdf containing all pictures and writes this pdf to output
  def create_pdf( output )
    name = File.basename( "#{output}", ".*" )

    # create a LaTeX document the pictures are put into
    File.open("#{name}.tex", "w") do |doc|
      doc.puts startLaTeXDocument
      @pictures.each do |pic|

        pic_copy = "TEMP-#{File.basename( pic )}"
        FileUtils.cp( pic, pic_copy )
        picture = Picture.new( pic_copy )
        picture.photo_copy!( 50 )

        if picture.landscape? then
          doc.puts "\\newpage
                    \\begin{center}
                      \\includegraphics[angle=270,width=\\textwidth]{#{pic_copy}}
                    \\end{center}"
        else
          doc.puts "\\newpage
                    \\begin{center}
                      \\includegraphics[width=\\textwidth]{#{pic_copy}}
                    \\end{center}"
        end

      end # pictures.each
      doc.puts "\\end{document}"
    end # File.open

    system( "pdflatex \"#{name}.tex\" > \"log.txt\"" )
    system( "pdflatex \"#{name}.tex\" > \"log.txt\"" )

    # Clean up
    @pictures.each { |pic| FileUtils.remove_file( "TEMP-#{File.basename( pic )}", true ) }
    FileUtils.remove_file( "#{name}.tex", true )
    FileUtils.remove_file( "#{name}.aux", true )
    FileUtils.remove_file( "#{name}.log", true )
    FileUtils.remove_file( "log.txt", true )
  end

  def startLaTeXDocument
    return "
\\documentclass[a4paper,final]{article}

\\usepackage{graphicx}

% Change the page size to create an area as large as possible for the pictures
% to be inserted. Furthermore, page numbers are surpressed
\\pagestyle{empty}

\\setlength{\\oddsidemargin}{-20mm}
\\setlength{\\evensidemargin}{-20mm}
\\setlength{\\topmargin}{-10mm}
\\setlength{\\headheight}{0cm}
\\setlength{\\headsep}{0cm}
\\setlength{\\topskip}{0cm}
\\setlength{\\footskip}{0cm}
\\setlength{\\textheight}{285mm}
\\setlength{\\textwidth}{200mm}

\\begin{document}"
  end

  # Create a copy of pic on disk and return the filename of that copy.
  # The quality of the copy is photocopy-like.
  # This method is based on a bash script written by Corey Satten. He uses ImageMagick to transform the picture into a photocopy-like version. For more information about this script see: http://corey.elsewhere.org/camscan/scancvt and (http://corey.elsewhere.org/camscan/)
  # What Satten is doing, I do not know exactly, but it works. So, all thanks to him!

end
