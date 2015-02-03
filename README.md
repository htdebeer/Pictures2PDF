pictures2pdf
============

Convert photographs of pages of a document into one PDF document
----------------------------------------------------------------

I constructed this program during my [historical research on the Dutch
Computer Pionieers](http://heerdebeer.org/History/ComputerPioneers) when I
often found myself in archives where photocopying documents, if accepted at
all, was an expensive hassle. Fortunately, it is almost always allowed to take
pictures with a digital photocamera. As a result I collected a lot of pictures
and I wanted printable documents instead.

So I started searching on the internet for a solution of my problem. The
only thing I found was a [bash script using ImageMagick created by by
Corey Satten](http://corey.elsewhere.org/camscan/scancvt). (See also his
[site about his program](http://corey.elsewhere.org/camscan/)) First I
adapted the script to my needs and later I wrote a ruby program to ease
working with the script. Finally I had the idea to create a C++/Qt
version of the program, but that didn't work out very well due to time
constraints.

Requirements for pictures2pdf are [Ruby](http://www.ruby-lang.org),
[LaTeX](http://www.latex-project.org) and
[ImageMagick](http://www.imagemagick.org). 

Installation is easy: put it somewhere on your filesystem and create a symlink
to the pictures2pdf.sh script in your bin folder. Usage: see below.

        NAME
          pictures2pdf - create a photocopy like pdf of photographed
                         pictures of a document

        SYNOPSIS
          pictures2pdf [ options ] pictures

        DESCRIPTION
          pictures2pdf uses ImageMagick to transform pictures into
          photocopy like copies. The transformation used is a very
          slightly adapted version of a bash script using
          ImageMagick created by by Corey Satten,  see
          http://corey.elsewhere.org/camscan/ and
          http://corey.elsewhere.org/camscan/scancvt.
          All praise to Satten :-)

          The output of pictures2pdf can be changed by giving some
          options:

          -o, --output filename
             The filename of the output pdf document.
             The default is 'output.pdf'.

          -h, --help
             Print this help.

          pictures
            Pictures are specified either by giving the filenames of
            the pictures separated by spaces. Another option is to
            specify a range of pictures by: 'start_picture.pic to
            end_picture.pic'. With 'pic' the proper extension.

            Where start_picture.pic denotes the start of the range and
            end_picture.pic the end of the range. Path and extension
            are stripped and the set containing all successive
            strings  between the start string and the end string is
            generated and transformed into a list of filenames.

            pictures2pdf does not check if these filenames represent
            existing files or pictures. So be sure all files in the
            range does exist before using a range.

        EXAMPLES
          pictures2pdf -o menu.pdf menu001.jpg to menu006.jpg:

            Creates the pdf file menu.pdf containing the pictures
            menu001.jpg, menu002.jpg, menu003.jpg, menu004.jpg,
            menu005.jpg, and menu006.jpg.

          pictures2pdf -o "doc 2.pdf" pic0.png pic4.png pic12.png to
          pic15.png:

            Creates the pdf file "doc 2.pdf" containing the pictures of
            pic0.png, pic4.png, pic12.png, pic13.png, and pic15.png.

        VERSION
          Version 0.

        AUTHOR
          HT de Beer
