//
//  PhotoViewProtocol.h
//  Aekitas
//
//  Created by steven on 10-12-30.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#pragma mark PhotoViewSource

@protocol PhotoViewSource <NSObject>

@property(nonatomic,readonly) NSArray *photos;
@property(nonatomic,readonly) NSInteger numberOfPhotos;
- (id)photoAtIndex:(NSInteger)index;

@end


#pragma mark -
#pragma mark PhotoView

@protocol PhotoView <NSObject>

@property(nonatomic,readonly) NSURL *URL;
@property(nonatomic,retain) UIImage *image;
@property(nonatomic,assign,getter=didFail) BOOL failed;

@end
