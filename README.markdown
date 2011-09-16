# Civil Debate Wall Kiosk

The Civil Debate Wall Kiosk is a five-screen installation at the Bob Graham Center at the University of Gainesville Florida. It provides two basic modes. One is active mode, in which a touch interface guides users through the process of contributing their opinion to the system via SMS. The second is a passive mode, or the "wall saver", in which data visualizations summarizing popular opinion are presented across all five screens simultaneously. The screens share a content pool and back-end API with a web-based version of the wall. 

- - - - - - - - - - - - - - - -

## For Clients

  
### Installation

1. Find and download the CivilDebateWall.exe to your desktop from [Server Location TBD].
2. Double click on the downloaded file and follow the on-screen instructions to install 


### Launching

Double click the "Civil Debate Wall" icon on the desktop. This should have been created automatically during the installation process.


### Administration

A list of options is available by right-clicking anywhere in the application window with the wireless mouse. Since right-clicking is not accessible through the touch screen alone, this affords some protection of administrative controls. A summary of the options follows.

* Toggle Full Screen -- Takes the app in and out of full screen mode. By default, the app starts up in full screen mode.
* Toggle Dashboard -- Shows or hides a menu for debugging and testing
* Toggle SMS Button -- Shows or hides the "Simulate SMS" button, which allows participants to skip the lengthy SMS process during testing. This is not recommended for general use, since valid telephone numbers are required for participating in the SMS conversation and for properly identifying participants visiting the wall for the second or third time.
* Toggle FPS -- Shows or hides the frame rate in the top right corner.
* Quit -- Closes the application.

If something goes wrong, the best course of action is generally to right click and "Quit" the app, and then restart it by double clicking on the "Civil Debate Wall" shortcut on the desktop.

A content management system is accessible through [URL TBD].

- - - - - - - - - - - - - - - -

## For Developers

### The Repository

The repo currently has a lot of legacy cruft in it. Active development on the kiosk is currently taking place in "lp-cdw/civildebate_kiosk/new_air_project". Just about every other directory should be dormant for the time being.

### Building

There is currently no automated build process (See the "Native Code" section below for challenges involved).

For testing and development on the Mac, import the project into Flash Builder.

For compilation and deployment on Windows, import the project into Flash Builder, then run "Export Release Build", be sure the "signed native installed" radio button is selected. Use something moew descriptive than "Main" for the "Base Filename" field, I like "CivilDebateWallInstaller". Use the "lpcert" file in the "/certificate" folder when prompted for a signing certificate. This will create an .exe binary installation file. Double click on this and follow the on-screen instructions to install the program on the target machine.


### Dependencies

* AS3 Core Lib (JSON)
* TweenMax (Animation)
* MonsterDebugger (Logging)
* JPEGEncoder (High speed Alchemy-based JPEG encoding)
* Flash (Color interpolation, JPEG encoding)
* Sekati (Brightness measurements)
* Minimal Comps (Debug GUI)
* Object Detection (Face detection)
* FlashSpan (Screen synchronization, TODO)

For convenience these are distributed with the repository under the "libraries" folder. The Flash Builder project watches the libraries folder for changes and automatically references any SWCs it finds.


### Native Code

#### SLR Control

The Air app communicates with a custom SLR Control program to take high-resolution photographs of participants. This program only works on Windows, and requires the Air app to use the "extended desktop" profile, which builds platform-specific installation binaries. Unfortunately there is no way to cross-compile extended desktop applications. Building a binary installer for Windows (the deployment platform) requires compilation on a Windows machine.

#### Screen Synchronization

TODO