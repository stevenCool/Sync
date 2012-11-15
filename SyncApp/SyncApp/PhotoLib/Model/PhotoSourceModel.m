//
//  PhotoSourceModel.m
//  Aekitas
//
//  Created by steven on 10-12-30.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PhotoSourceModel.h"

@implementation PhotoSourceModel
@synthesize photos=_photos, numberOfPhotos=_numberOfPhotos;

- (id)initWithPhotos:(NSArray*)photos {
	if (self = [super init]) {
		_photos = [photos retain];
		_numberOfPhotos = [_photos count];
		
	}
	
	return self;
}

- (int)numberOfPhotos{
	_numberOfPhotos = [_photos count];
	return _numberOfPhotos;
}

- (id<PhotoView>)photoAtIndex:(NSInteger)index {
	return [_photos objectAtIndex:index];
}

- (void)dealloc{
	[_photos release], _photos=nil;
	[super dealloc];
}

@end
