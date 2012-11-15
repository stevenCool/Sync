//
//  PhotoLoadConnection.h
//  Aekitas
//
//  Created by steven on 10-12-30.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PhotoGlobal.h"

@protocol PhotoLoadConnectionDelegate;

@interface PhotoLoadConnection : NSObject {
@private
	NSURL* _imageURL;
	NSURLResponse* _response;
	NSMutableData* _responseData;
	NSURLConnection* _connection;
	NSTimeInterval _timeoutInterval;
	
	id<PhotoLoadConnectionDelegate> _delegate;
}

@property(nonatomic,readonly) NSData* responseData;
@property(nonatomic,readonly,getter=imageURL) NSURL* imageURL;
@property(nonatomic,retain) NSURLResponse* response;
@property(nonatomic,assign) id<PhotoLoadConnectionDelegate> delegate;
@property(nonatomic,assign) NSTimeInterval timeoutInterval; // Default is 30 seconds

- (id)initWithImageURL:(NSURL*)aURL delegate:(id<PhotoLoadConnectionDelegate>)delegate;

- (void)start;
- (void)cancel;


@end

