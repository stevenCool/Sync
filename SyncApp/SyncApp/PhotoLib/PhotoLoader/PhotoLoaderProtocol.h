//
//  PhotoLoaderProtocol.h
//  Aekitas
//
//  Created by steven on 10-12-30.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#pragma mark PhotoLoaderObserver

@protocol PhotoLoaderObserver<NSObject>

- (void)imageLoaderDidLoad:(NSNotification*)notification; 
- (void)imageLoaderDidFailToLoad:(NSNotification*)notification; 

@end

#pragma mark -
#pragma mark PhotoLoadConnection

@class PhotoLoadConnection;

@protocol PhotoLoadConnectionDelegate<NSObject>

- (void)imageLoadConnectionDidFinishLoading:(PhotoLoadConnection *)connection;
- (void)imageLoadConnection:(PhotoLoadConnection *)connection didFailWithError:(NSError *)error;	

@end
