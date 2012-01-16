##FlashSpan

###About
FlashSpan is an open-source library for spanning Flash content across multiple screens.

FlashSpan relies on the fact that the code running on each computer should generate the exact same visuals over a certain number of frames. It works by keeping track of how many frames each client has rendered, and then closing any gaps in rendering speed.

Some inspiration was draw from Daniel Shiffman’s epic Most Pixels Ever library for Processing, though the projects don’t share source code.

###History
FlashSpan was initially developed in 2008 for [Newsworthy Chicago](http://newsworthychicago.com/about/index.php), an interactive installation at the Hyde Park Art Center.

FlashSpan emerged as a means of distributing the project’s live text content across an 80 foot wide video wall powered by 10 projectors and 5 computers.

It was later revised in 2011 with the support of [Local Projects](http://localprojects.net) for a 5-screen installation of [The Great Civil Debate Wall](http://www.civildebatewall.com/).


###Dependencies
*For compilation:*  
[Adobe Flex SDK (4.5.1+)](http://www.adobe.com/go/flex_sdk/)  
[Python (2.6+)](http://www.python.org/getit/)  
[Apache Ant (?.?+)](http://ant.apache.org/bindownload.cgi)  
[Ant XMLtask](http://www.oopsconsultancy.com/software/xmltask/) (Included)  
[Ant Contrib](http://sourceforge.net/projects/ant-contrib/) (Included)  

*For use:*  
[AS3 Commons Logging](http://www.as3commons.org/as3-commons-logging/index.html)  
[Minimal Comps](http://www.minimalcomps.com/) (Only required for the example.)

Due to the complexity involved in testing multiple instances of an AIR app on one machine, the project relies on custom Ant build files for compilation and testing.

###License
FlashSpan is licensed under the GNU Lesser General Public License. You may link to it from closed-source software, but any improvements made to the library itself must also be released under the LGPL.


###Contact
[Eric Mika](http://ericmika.com)