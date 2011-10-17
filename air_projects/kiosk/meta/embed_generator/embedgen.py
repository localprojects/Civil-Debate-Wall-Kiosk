# Little app to generate AS3 image embed code.
# The image will be available from an eponymous static variable, without the file type suffix.
# If it's fed a directory, it wil create embed code for every image file in the directory
import os, sys

def printEmbed(filename):
		shortname = filename[0:-4]
		getname = shortname[0].capitalize() + shortname[1:]

		print '[Embed(source = \'/assets/graphics/' + filename + '\')] private static const ' + shortname + 'Class:Class;'
		print 'public static function get' + getname + '():Bitmap { return new ' + shortname + 'Class() as Bitmap; };'
		print 'public static const ' + shortname + ':Bitmap = get' + getname + '();'
		print ''

imageExtensions = ['.jpg', '.png', '.gif']

if (len(sys.argv) > 1):
		input = sys.argv[1]
		
		
		try:
			dirList = os.listdir(input)
			
			for file in dirList:
					if not os.path.isdir(file):
							if os.path.splitext(file)[1] in imageExtensions:
								printEmbed(file)
			
		except:
			print printEmbed(input)
else:
		print "Need a filename"