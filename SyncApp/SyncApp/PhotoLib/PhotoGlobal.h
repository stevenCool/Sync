//
//  PhotoGlobal.h
//  Aekitas
//
//  Created by steven on 10-12-30.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

// Frameworks
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
//#import "Constants.h"

// Model
#import "PhotoViewProtocol.h"
#import "PhotoModel.h"
#import "PhotoSourceModel.h"

// Controller
#import "PhotoViewController.h"

// Views
#import "PhotoScrollView.h"
#import "PhotoImageView.h"

// PhotoLoader
#import "PhotoLoaderProtocol.h"
#import "PhotoLoader.h"
#import "PhotoLoadConnection.h"
#import "PhotoCache.h"

#ifndef IMAGE_GAP
	#define IMAGE_GAP 30
#endif

#ifndef ZOOM_SCALE
	#define ZOOM_SCALE 2.5
#endif

#ifndef PhotoLoadingPlaceholder
	#define PhotoLoadingPlaceholder [UIImage imageNamed:@"pl_photo_placeholder.png"]
#endif

#ifndef PhotoErrorPlaceholder
	#define PhotoErrorPlaceholder [UIImage imageNamed:@"pl_error_placeholder.png"]
#endif

#ifndef NoPhotosPlaceholder
	#define NoPhotosPlaceholder [UIImage imageNamed:@"pl_nophotos_placeholder.png"]
#endif

#ifndef EmptyPhotosPlaceholder
	#define EmptyPhotosPlaceholder [UIImage imageNamed:@"user_placeholder.jpg"]
#endif
