// GCDWFoto.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"
#include "EDSDK.h"
#include "stdio.h"
#include <iostream>
#include <string>
#include "dos.h"
#include <windows.h>

using std::cout;
using std::cin;
using std::endl;
using std::string;

#define DELAY_BEFORE_DOWNLOAD 450

EdsError EDSCALLBACK handleObjectEvent( EdsObjectEvent event,
										EdsBaseRef object,
										EdsVoid * context)
{
	cout << "handleObjectEvent: " << event << endl;

	// do something
	/*
	switch(event)
	{
		case kEdsObjectEvent_DirItemRequestTransfer:
			downloadImage(object);
			break;
		default:
			break;
	}
	*/
	// Object must be released
	if(object)
	{
		EdsRelease(object);
	}


	return 0;
}

EdsError EDSCALLBACK handleSateEvent (EdsPropertyEvent event,
										EdsPropertyID property,
										EdsVoid * context)
{
	// do something

	return 0;
}

/*EdsError EDSCALLBACK handleSateEvent (EdsCameraStateEvent event,
										EdsUInt32 parameter,
										EdsVoid * context)
{
// do something
}*/

EdsError getFirstCamera(EdsCameraRef *camera)
{
	EdsError err = EDS_ERR_OK;
	EdsCameraListRef cameraList = NULL;
	EdsUInt32 count = 0;
	// Get camera list
	err = EdsGetCameraList(&cameraList);
	// Get number of cameras
	if(err == EDS_ERR_OK)
	{
		err	= EdsGetChildCount(cameraList, &count);
		if(count == 0)
		{
			err = EDS_ERR_DEVICE_NOT_FOUND;
		}
	}
		// Get first camera retrieved
	if(err == EDS_ERR_OK)
	{
		err = EdsGetChildAtIndex(cameraList, 0, camera);
	}
	// Release camera list
	if(cameraList != NULL)
	{
		EdsRelease(cameraList);
		cameraList = NULL;
	}

	return err;
}

EdsError startLiveview(EdsCameraRef camera)
{
	EdsError err = EDS_ERR_OK;
	// Get the output device for the live view image
	EdsUInt32 device;
	err = EdsGetPropertyData(camera, kEdsPropID_Evf_OutputDevice, 0, sizeof(device), &device );

	// PC live view starts by setting the PC as the output device for the live view image.
	if(err == EDS_ERR_OK)
	{
		device |= kEdsEvfOutputDevice_TFT;
		//device |= kEdsEvfOutputDevice_PC;
		err = EdsSetPropertyData(camera, kEdsPropID_Evf_OutputDevice, 0 , sizeof(device), &device);
	}
		// A property change event notification is issued from the camera if property settings are made successfully.
		// Start downloading of the live view image once the property change notification arrives.

	return err;
}

EdsError getVolume(EdsCameraRef camera, EdsVolumeRef * volume)
{
	EdsError err = EDS_ERR_OK;
	EdsUInt32 count = 0;
	// Get the number of camera volumes
	err = EdsGetChildCount(camera, &count);
	if(err == EDS_ERR_OK && count == 0)
	{
		err =EDS_ERR_DIR_NOT_FOUND;
	}
	// Get initial volume
	if(err == EDS_ERR_OK)
	{
		err = EdsGetChildAtIndex(camera, 0, volume);
	}

	return err;
}

EdsError getDCIMFolder(EdsVolumeRef volume, EdsDirectoryItemRef * directoryItem)
{
	EdsError err = EDS_ERR_OK;
	EdsDirectoryItemRef dirItem = NULL;
	EdsDirectoryItemInfo dirItemInfo;
	EdsUInt32 count = 0;
	// Get number of items under the volume
	err = EdsGetChildCount(volume, &count);
	if(err == EDS_ERR_OK && count == 0)
	{
		err =EDS_ERR_DIR_NOT_FOUND;
	}
	// Get DCIM folder

	for(EdsUInt32 i = 0; i < count && err == EDS_ERR_OK; i++)
	{
		// Get the ith item under the specifed volume
		if(err == EDS_ERR_OK)
		{
			err = EdsGetChildAtIndex(volume, i , &dirItem);
		}
		// Get retrieved item information
		if(err == EDS_ERR_OK)
		{
			err = EdsGetDirectoryItemInfo(dirItem, &dirItemInfo);
		}
		// Indicates whether or not the retrieved item is a DCIM folder.
		if(err == EDS_ERR_OK)
		{
			if( stricmp(dirItemInfo.szFileName, "DCIM") == 0 &&
			dirItemInfo.isFolder == 1)
			{
				//directoryItem = &dirItem;
				//get first subfolder instead (100CANON), because the pictures are in there
				err = EdsGetChildAtIndex(dirItem, 0, directoryItem);

				EdsUInt32 count = 0;
				// Get number of items under the volume
				err = EdsGetChildCount(dirItem, &count);
				break;
			}
		}
		// Release retrieved item
		if(dirItem)
		{
			EdsRelease(dirItem);
			dirItem = NULL;
		}
	}
	return err;
}

EdsError downloadImage(EdsDirectoryItemRef directoryItem)
{
	EdsError err = EDS_ERR_OK;
	EdsStreamRef stream = NULL;
	// Get directory item information
	EdsDirectoryItemInfo dirItemInfo;
	err = EdsGetDirectoryItemInfo(directoryItem, & dirItemInfo);
	// Create file stream for transfer destination
	if(err == EDS_ERR_OK)
	{
		err = EdsCreateFileStream( dirItemInfo.szFileName,
		kEdsFileCreateDisposition_CreateAlways,
		kEdsAccess_ReadWrite, &stream);
	}
	// Download image
	if(err == EDS_ERR_OK)
	{
		err = EdsDownload( directoryItem, dirItemInfo.size, stream);
	}
	// Issue notification that download is complete
	if(err == EDS_ERR_OK)
	{
		err = EdsDownloadComplete(directoryItem);
		cout << "Download complete" << endl;
	}
	// Release stream
	if( stream != NULL)
	{
		EdsRelease(stream);
		stream = NULL;
	}
	return err;
}

int _tmain(int argc, _TCHAR* argv[])
{
	EdsError err = EDS_ERR_OK;
	EdsCameraRef camera = NULL;
	bool isSDKLoaded = false;
	// Initialize SDK
	err = EdsInitializeSDK();
	if(err == EDS_ERR_OK)
	{
		isSDKLoaded = true;
	}
	// Get first camera
	if(err == EDS_ERR_OK)
	{
	err = getFirstCamera (&camera);
	}
	// Set event handler
	if(err == EDS_ERR_OK)
	{
		err = EdsSetObjectEventHandler(camera, kEdsObjectEvent_All,
		handleObjectEvent, NULL);
	}

	if(err == EDS_ERR_OK)
	{
		err = EdsOpenSession(camera);
	}

	//startLiveview( camera );
	 
	string input;
	while (cin >> input)
	{
		if( input == "p" )
		{
			EdsSendCommand(camera, kEdsCameraCommand_TakePicture, 0);
			Sleep(DELAY_BEFORE_DOWNLOAD);

			err = EdsCloseSession(camera);
			Sleep(100);
			err = EdsOpenSession(camera);

			EdsVolumeRef camVolume;
			EdsDirectoryItemRef dcimFolder;

			getVolume( camera, &camVolume );
			getDCIMFolder( camVolume, &dcimFolder );
			EdsUInt32 count = 0;
			// Get number of items under the volume
			err = EdsGetChildCount(dcimFolder, &count);
			cout << "dcimFolder-Count: " << count << std::endl;

			EdsDirectoryItemRef lastFotoRef;
			EdsGetChildAtIndex(dcimFolder, count - 1, &lastFotoRef);

			EdsDirectoryItemInfo lastFotoInfo;
			err = EdsGetDirectoryItemInfo(lastFotoRef, &lastFotoInfo);

			cout << lastFotoInfo.szFileName << " will be downloaded. Size is " << lastFotoInfo.size << endl;

			downloadImage( lastFotoRef );
		}
		else if( input == "f" )
		{
			EdsVolumeRef camVolume;
			getVolume( camera, &camVolume );
			cout << "formatting volume" << endl;
			EdsFormatVolume( camVolume );
		}
		else if( input == "q" )
		{
			cout << "quitting" << endl;
			break;
		}
		else
		{
			cout << "unknown command, use p to take a picture, f to format the volume, or q to quit." << endl;
		}
			

		
	}

	//EdsSendStatusCommand(camera, kEdsCameraStatusCommand_UIUnLock, 0);

	// Close session with camera
	if(err == EDS_ERR_OK)
	{
		err = EdsCloseSession(camera);
	}
	// Release camera
	if(camera != NULL)
	{
		EdsRelease(camera);
	}
	// Terminate SDK
	if(isSDKLoaded)
	{
		EdsTerminateSDK();
	}
	//
	return 0;
}