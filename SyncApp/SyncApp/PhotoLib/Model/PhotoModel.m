//
//  PhotoModel.m
//  Aekitas
//
//  Created by steven on 10-12-30.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PhotoModel.h"

@implementation PhotoModel
@synthesize URL=_URL, image=_image, failed=_failed;

- (id)initWithImageURL:(NSURL*)aURL image:(UIImage*)aImage {
	if (self = [super init]) {
		_URL = [aURL retain];
		_image = [aImage retain];
	}
	
	return self;
}

- (id)initWithImageURL:(NSURL*)aURL {
	return [self initWithImageURL:aURL image:nil];
}

- (id)initWithImage:(UIImage*)aImage {
	return [self initWithImageURL:nil image:aImage];
}

- (void)dealloc {
	[_URL release], _URL=nil;
	[_image release], _image=nil;
	
	[super dealloc];
}

@end
