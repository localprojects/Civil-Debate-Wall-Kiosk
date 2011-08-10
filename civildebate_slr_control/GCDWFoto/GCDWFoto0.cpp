// GCDWFoto.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"
#include "EDSDK.h"
#include "stdio.h"
#include "dos.h"
#include <windows.h>
#include "CameraModel.h"
#include "Processor.h"
#include "CameraController.h"
#include "CameraEventListener.h"
#include "OpenSessionCommand.h"
#include "TakePictureCommand.h"

// Camera model
CameraModel* _model;
CameraController*	_controller;

// Command processing
Processor _processor;

EdsError getFirstCamera(EdsCameraRef *camera);

int _tmain(int argc, _TCHAR* argv[])
{
	printf("its not");
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

	//Create Camera model
	if(err == EDS_ERR_OK )
	{
		_model = new CameraModel( camera );
		if(_model == NULL)
		{
			err = EDS_ERR_DEVICE_NOT_FOUND;
		}
	}


	//Create CameraController
	_controller = new CameraController();
	_controller->setCameraModel(_model);

	Command *cmd = new OpenSessionCommand(_model);
	cmd->execute();

	//START SESSION
	/*if(err == EDS_ERR_OK)
	{
		err = EdsOpenSession(camera);
	}*/

	//startLiveview( camera );

	int i = 0;
	while(i < 1)
	{
		Sleep(2000);

		//Command *shootPic = new TakePictureCommand( _model );
		//shootPic->execute();

		++i;
		//if(i == 5)
			EdsSendCommand(camera, kEdsCameraCommand_TakePicture, 0);

		printf("Hello World");
		Sleep(10000);
	}

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
		err = EdsGetChildAtIndex(cameraList , 0 , camera);
	}
	// Release camera list
	if(cameraList != NULL)
	{
		EdsRelease(cameraList);
		cameraList = NULL;
	}

	return err;
}