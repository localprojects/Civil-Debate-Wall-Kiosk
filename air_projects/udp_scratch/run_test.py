from subprocess import call
from subprocess import Popen
from xml.dom import minidom

# call compile?

# Get the existing app id
sourceXML =  minidom.parse("bin-debug/UDPScratch-app.xml");
currentAppID = sourceXML.getElementsByTagName("id")[0].firstChild.data

print "Current App ID: " + currentAppID

for i in range(5):
	# Make the ID unique
	sourceXML.getElementsByTagName("id")[0].firstChild.data = currentAppID + str(i + 1)
	
	# Save the new app XML
	f = open("bin-debug/UDPScratch" + str(i + 1) + "-app.xml", "w")
	sourceXML.writexml(f)
	f.close()	
	
	print "Launching Instance " + str(i + 1)
	#os.system("adl bin-debug/UDPScratch" + str(i + 1) + "-app.xml")	
	Popen(["adl", "bin-debug/UDPScratch" + str(i + 1) + "-app.xml"])
	print "Done"

# clean up 
# todo










