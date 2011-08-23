# Little app to generate AS3 image embed code.
# The image will be available from an eponymous static variable, without the file type suffix.

import sys

if (len(sys.argv) > 1):
		filename = sys.argv[1]
		shortname = filename[0:-4]

		print '[Embed(source = "/assets/graphics/' + filename + '")] private static const ' + shortname + 'Class:Class;'
		print 'public static function ' + shortname + '():Bitmap { return new ' + shortname + 'Class() as Bitmap; };'
		# print 'public static const ' + shortname + ':Bitmap = new ' + shortname + 'Class() as Bitmap;'		

else:
		print "Need a filename"
		
