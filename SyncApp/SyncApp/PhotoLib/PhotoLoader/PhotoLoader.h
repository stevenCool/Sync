//
//  PhotoLoader.h
//  Aekitas
//
//  Created by steven on 10-12-30.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PhotoGlobal.h"

@protocol PhotoLoaderObserver;

@interface PhotoLoader : NSObject <PhotoLoadConnectionDelegate>{
@private
	NSDictionary* _currentConnections;
	NSMutableDictionary* currentConnections;
	
	NSLock* connectionsLock;
}

@property(nonatomic,retain) NSDictionary* currentConnections;

//load photo
+ (PhotoLoader*)sharedImageLoader;
- (UIImage*)imageForURL:(NSURL*)aURL shouldLoadWithObserver:(id<PhotoLoaderObserver>)observer;
- (void)loadImageForURL:(NSURL*)aURL observer:(id<PhotoLoaderObserver>)observer;
- (void)cancelLoadForURL:(NSURL*)aURL;

//status
- (BOOL)isLoadingImageURL:(NSURL*)aURL;
- (BOOL)hasLoadedImageURL:(NSURL*)aURL;

- (void)removeObserver:(id<PhotoLoaderObserver>)observer;
- (void)removeObserver:(id<PhotoLoaderObserver>)observer forURL:(NSURL*)aURL;

@end
