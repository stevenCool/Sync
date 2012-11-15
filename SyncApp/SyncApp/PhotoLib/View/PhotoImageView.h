//
//  PhotoImageView.h
//  Aekitas
//
//  Created by steven on 10-12-30.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PhotoGlobal.h"
#import "PhotoLoaderProtocol.h"

@class PhotoScrollView;
@protocol PhotoLoaderObserver;

@interface PhotoImageView : UIView <UIScrollViewDelegate, PhotoLoaderObserver> 
{
@private
	PhotoScrollView *_scrollView;
	id<PhotoView> _photo;
	UIImageView *_imageView;
	UIActivityIndicatorView *_activityView;
	
	BOOL _loading;
//	CGRect _currentRect;
	CGFloat _beginRadians;
//	CGPoint _midPos;
}

@property(nonatomic,readonly) id<PhotoView> photo;
@property(nonatomic,readonly) UIImageView *imageView;
@property(nonatomic,readonly) PhotoScrollView *scrollView;
@property(nonatomic,assign,getter=isLoading) BOOL loading;

- (void)setPhoto:(id<PhotoView>)aPhoto;
- (void)killScrollViewZoom;
- (void)prepareForReusue;

- (void)layoutScrollViewAnimated:(BOOL)animated;
- (void)rotateToOrientation:(UIInterfaceOrientation)orientation;

@end
