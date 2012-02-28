
## Installation and Management Guide


### Launching

Double click the "Civil Debate Wall" icon on the desktop.

### Quitting

Using a mouse, right click anywhere on the screen. From the contextual menu, select "Quit".


### Administration

A list of options is available by right-clicking anywhere in the application window with the wireless mouse. Since right-clicking is not accessible through the touch screen alone, this affords some protection of administrative controls. A summary of the options follows.

* Toggle Full Screen -- Takes the app in and out of full screen mode. By default, the app starts up in full screen mode.
* Toggle Dashboard -- Shows or hides a menu for debugging and testing
* Toggle SMS Button -- Shows or hides the "Simulate SMS" button, which allows participants to skip the lengthy SMS process during testing. This is not recommended for general use, since valid telephone numbers are required for participating in the SMS conversation and for properly identifying participants visiting the wall for the second or third time.
* Toggle FPS -- Shows or hides the frame rate in the top right corner.
* Quit -- Closes the application.

If something goes wrong, the best course of action is generally to right click and "Quit" the app, and then restart it by double clicking on the "Civil Debate Wall" shortcut on the desktop.

A content management system is accessible through [URL TBD].

### Kiosk Machine Setup
The Windows 7 machines that run the kiosk should be set up as follows:

- Install the [Adobe Air Runtime](http://get.adobe.com/air/) version 3.0.
- Install the [Adobe Air Settings Manager](http://airdownload.adobe.com/air/applications/SettingsManager/SettingsManager.air)
- Run the settings manager and disable automatic updates.
- Install the [Microsoft Visual C++ 2010 Redistributable Package](http://www.microsoft.com/download/en/details.aspx?id=5555). (Required by the SLR control software. *TODO: Copy all the required DLLs into the native package?*)
- Disabled all power saving functionality.
- Disable screen savers.
- Disable AERO.
- Ensure that the machine is connected to the NAS, and that the NAS is mapped to drive letter "E:". It should be configured to auto-connect at startup.
- Install the CDW Deployment Tools to C:\
- Run CDWupdate.bat to install the latest version of the CDW Kiosk application.
- Install LogMeIn
- TODO a few more steps...

- Disable the "auto right click" option in the eGalaxTouch configuration utility. (Right clicking is for administrators only!)

- you must use a Vista Aero theme to ensure that vertical sync is enabled. Otherwise animations will tear rather badly.

- - - - - - - - - - - - - - - -

## For Developers

### The Repository

The repo's file structure should be self documenting for the most part.


There are a number of supporting projects in the `air_projects` directory:

- `cdw_kiosk` is the main kiosk application. This is what actually runs on the wall in Florida.

- `face_crop_tool` is a stand-alone GUI application for testing different automatic face cropping parameters. It may also be used for batch processing large numbers portraits if we decide to tweak the face cropping parameters in the future.

- `futil` is a library of convenience function I've used and grown over several projects. Includes special text styling functionality evocative of CSS, and certain techniques for working with enforcing exact pixel dimensions on text. A reference to this project is required by `cdw_kiosk`.

- `futil demo` is a GUI application for testing and understanding the text-handling functionality in Futil.

- `object_detection` is a wrapper project to encapsulate the face detection code as a library. This keeps the source tree in the `cdw_kiosk` project clean. A reference to this project is required by `cdw_kiosk`.

- `wall_saver_scratch` allows isolated, single-window testing and development of the wall saver animation sequence. This project now dormant since wall saver functionality has been merged into the main `cdw_kiosk` project. 

`slr_control` contains a Windows-only Visual Studio project for the SLR communication app. The `cdw_kiosk` project has local copies of the relevant binaries, it does not reference this project directly.

`deploy_tools` includes tools and scripts to automate the AIR application update process on the kiosk computers.

### Dependencies

#### Application Software
- Flash Builder Professional 4.6
- Flash Authoring Tool CS5 (For font embedding.)

#### Libraries
- AS3 Core Lib (JSON)
- TweenMax (Animation. I am using my own license.)
- MonsterDebugger (Logging for multi-app testing)
- JPEGEncoder (High speed Alchemy-based JPEG encoding)
- Minimal Comps (Debug GUI)
- Object Detection (Face detection)
- FlashSpan (Screen synchronization)
- Futil (Utilities, text handling, special tweening plugins)

*Note: All libraries are included in the repository.*

### Building and Deployment

Maintaining ant build files and working directly with the Flash / AIR compilers proved logistically problematic given the complexity of compiling AIR with native-interface applications. So, for now, build configuration is maintained using Flash Builder. Once the project structure is finalized, creating a stand-alone ant-based compilation process will make more sense, but at the moment the time required does not justify the gains.

#### Debug Builds
For testing and development on the Mac, make sure your Flash Builder workspace is pointed to `/lp-cdw/air_projects`. Import the `cdw_kiosk`, `object_detection`, and `futil` folders as Flash Builder Projects. Use Flash Builder to compile and run `cdw_kiosk` in debug mode. You will need to make sure there is a database / web server either locally or remotely for the app to communicate with. (See the web portion of the CDW project for more info.)

There is no support for SLR control on the Mac —- for testing purposes, the app will use a web cam for both framing and the final photograph. Testing the actual SLR requires running the project in Flash Builder on a Windows machine.

NOTE: Due to a bug in Flash Builder 4.6, developers on Mac OS 10.7.2 on certain MacBook Pros will run into a crash when attempting to launch the application unless dynamic graphics card switching is disabled. This may be disabled through the Energy Saver system preferences panel, or (more conveniently) with a third party application such as [gfxCardStatus](http://codykrieger.com/gfxCardStatus). Adobe is [working on the issue](http://forums.adobe.com/message/4056447?tstart=0), but as of December 2011 they're talking about the timeline for a fix in terms of "months".

#### Native Code: SLR Control

The `cdw_kiosk` app communicates with a custom SLR Control program to take high-resolution photographs of participants. This program only works on Windows, and requires the Air app to use the "extended desktop" profile, which builds platform-specific installation binaries. Unfortunately there is no way to cross-compile extended desktop applications. Building a binary installer for Windows (the deployment platform) requires compilation on a Windows machine. This creates deployment headaches, which are described below.

#### Release Builds and Deployment

A stand-alone Windows computer or virtual machine takes care of building a Windows-native AIR installer binary for deployment. Using a batch script, the project is automatically refreshed from git, compiled, and then uploaded to S3.

##### Build Machine Set Up:
This is involved. Ideally it only needs to happen once.

1. Procure a Windows 7 machine, ideally a VM,

1. Install [Git for Windows](http://code.google.com/p/msysgit/downloads/list). Choose the "Run Git and included Unix tools from the Windows Command Prompt" option during the installation wizard.

1. Set up an SSH key without a passphrase, with read access to the lp-cdw repo on Assembla. Make sure the remote repo is in known_hosts.

1. Install Flash Builder 4.5 Professional (Has to be the professional version for automated builds.)

1. Configure eclipse to run ant in its own JRE so you can call the build scrip directly from Eclipse. See [this thread](http://stackoverflow.com/questions/4278745/how-do-i-use-ant-build-to-execute-exportreleasebuild-task-in-flash-builder-4/6943308#6943308) for instructions.

1. Clone the git repo into a folder called `CDWBuild` on the desktop.  
 `$git clone git@git.assembla.com:lp-cdw.git`

1. Run Flash Builder, switch its workspace to the `/lp-cdw/air_projects` directory.

1. Import the `cdw_kiosk` project into the workspace. Do the same for `futil` and `object_detection`.

1. Add all of the jar files in `lp-cdw/air_projects/cdw_kiosk/libs-build` to the **global** ant classpath in Flash Builder. (Located under *Window --> Preferences --> Ant --> runtime --> Global Entries*.)

1. Copy and rename the `/lp-cdw/air_projects/cdw_kiosk/build.properties.template` to `build.properties`. Fill in the appropriate credentials.

1. Perform a test build. Close Flash Builder. Then open a command prompt, navigate to `/lp-cdw/air_projects/cdw_kiosk/`, and run build.bat. Double check the S3 bucket to make sure the installation binary wound up where you expected.

*Note: The build script expects Flash Builder to be closed. Make sure nothing is running on the Windows machine before executing the build script.*

##### Creating release builds:
After the build machine is configured, moving from development on the Mac to a release build on windows should be relatively painless.

1. Make sure any changes from your development environment have been pushed to the remote git repository.

1. Navigate to `/lp-cdw/air_projects/cdw_kiosk/` on the build machine, and run `build.bat`.

1. For each CDW kiosk deployment machine, download the `CDW Kiosk.exe` file from S3 and run it to install the latest version of the software. (This step pending automation!)


