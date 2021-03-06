//
//  PhotoImageView.m
//  Aekitas
//
//  Created by steven on 10-12-30.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PhotoImageView.h"
#define ZOOM_VIEW_TAG 0x101

@interface RotateGesture : UIRotationGestureRecognizer {}
@end

@implementation RotateGesture
- (BOOL)canBePreventedByGestureRecognizer:(UIGestureRecognizer*)gesture{
	return NO;
}
- (BOOL)canPreventGestureRecognizer:(UIGestureRecognizer *)preventedGestureRecognizer{
	return YES;
}
@end


@interface PhotoImageView (Private)
- (void)layoutScrollViewAnimated:(BOOL)animated;
- (void)handleFailedImage;
- (void)setupImageViewWithImage:(UIImage *)aImage;
- (CABasicAnimation*)fadeAnimation;
@end

@implementation PhotoImageView

@synthesize photo=_photo;
@synthesize imageView=_imageView;
@synthesize scrollView=_scrollView;
@synthesize loading=_loading;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		
		self.backgroundColor = [UIColor blackColor];
		self.userInteractionEnabled = NO;
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		self.opaque = YES;
		
		PhotoScrollView *scrollView = [[PhotoScrollView alloc] initWithFrame:self.bounds];
		scrollView.backgroundColor = [UIColor blackColor];
		scrollView.opaque = YES;
		scrollView.delegate = self;
		[self addSubview:scrollView];
		_scrollView = [scrollView retain];
		[scrollView release];
		
		UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
		imageView.opaque = YES;
		imageView.contentMode = UIViewContentModeScaleAspectFit;
		imageView.tag = ZOOM_VIEW_TAG;
		[_scrollView addSubview:imageView];
		_imageView = [imageView retain];
		[imageView release];
		
		UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
		activityView.frame = CGRectMake((CGRectGetWidth(self.frame) / 2) - 11.0f, CGRectGetHeight(self.frame) - 100.0f , 22.0f, 22.0f);
		activityView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
		[self addSubview:activityView];
		_activityView = [activityView retain];
		[activityView release];
		
		RotateGesture *gesture = [[RotateGesture alloc] initWithTarget:self action:@selector(rotate:)];
		[self addGestureRecognizer:gesture];
		[gesture release];
		
	}
    return self;
}

- (void)layoutSubviews{
	[super layoutSubviews];
	
	if (_scrollView.zoomScale == 1.0f) {
		[self layoutScrollViewAnimated:YES];
	}
	
}

- (void)prepareForReusue
{
	self.tag = -1;
}

- (void)setPhoto:(id <PhotoView>)aPhoto{
	
	if (!aPhoto) return; 
	if ([aPhoto isEqual:self.photo]) return;
	
	if (self.photo != nil) {
		[[PhotoLoader sharedImageLoader] cancelLoadForURL:self.photo.URL];
	}
	
	[_photo release], _photo = nil;
	_photo = [aPhoto retain];
	
	if (self.photo.image) {
		
		self.imageView.image = self.photo.image;
		
	} else {
		
		if ([self.photo.URL isFileURL]) {
			self.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:self.photo.URL]];	
		} else {
			self.imageView.image = [[PhotoLoader sharedImageLoader] imageForURL:self.photo.URL shouldLoadWithObserver:self];
		}
		
	}
	
	if (self.imageView.image) {
		
		[_activityView stopAnimating];
		self.userInteractionEnabled = YES;
		
		_loading=NO;
		[[NSNotificationCenter defaultCenter] postNotificationName:@"PhotoDidFinishLoading" object:[NSDictionary dictionaryWithObjectsAndKeys:self.photo, @"photo", [NSNumber numberWithBool:NO], @"failed", nil]];
		
		
	} else {
		
		_loading = YES;
		[_activityView startAnimating];
		self.userInteractionEnabled= NO;
		self.imageView.image = PhotoLoadingPlaceholder;
	}
	
	[self layoutScrollViewAnimated:NO];
}

- (void)setupImageViewWithImage:(UIImage*)aImage {	
	if (!aImage) return; 
	
	_loading = NO;
	[_activityView stopAnimating];
	self.imageView.image = aImage; 
	[self layoutScrollViewAnimated:NO];
	
	[[self layer] addAnimation:[self fadeAnimation] forKey:@"opacity"];
	self.userInteractionEnabled = YES;
	[[NSNotificationCenter defaultCenter] postNotificationName:@"PhotoDidFinishLoading" object:[NSDictionary dictionaryWithObjectsAndKeys:self.photo, @"photo", [NSNumber numberWithBool:NO], @"failed", nil]];
	
}

- (void)handleFailedImage{
	
	self.imageView.image = PhotoErrorPlaceholder;
	self.photo.failed = YES;
	[self layoutScrollViewAnimated:NO];
	self.userInteractionEnabled = NO;
	[_activityView stopAnimating];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"PhotoDidFinishLoading" object:[NSDictionary dictionaryWithObjectsAndKeys:self.photo, @"photo", [NSNumber numberWithBool:YES], @"failed", nil]];
	
}

#pragma mark -
#pragma mark PhotoLoader Callbacks

- (void)imageLoaderDidLoad:(NSNotification*)notification {	
	
	if ([notification userInfo] == nil) return;
	if(![[[notification userInfo] objectForKey:@"imageURL"] isEqual:self.photo.URL]) return;
	
	[self setupImageViewWithImage:[[notification userInfo] objectForKey:@"image"]];
	
}

- (void)imageLoaderDidFailToLoad:(NSNotification*)notification {
	
	if ([notification userInfo] == nil) return;
	if(![[[notification userInfo] objectForKey:@"imageURL"] isEqual:self.photo.URL]) return;
	
	[self handleFailedImage];
	
}

#pragma mark -
#pragma mark Layout

- (void)rotateToOrientation:(UIInterfaceOrientation)orientation{
	
	if (self.scrollView.zoomScale > 1.0f) {
		
		CGFloat height, width;
		height = MIN(CGRectGetHeight(self.imageView.frame) + self.imageView.frame.origin.x, CGRectGetHeight(self.bounds));
		width = MIN(CGRectGetWidth(self.imageView.frame) + self.imageView.frame.origin.y, CGRectGetWidth(self.bounds));
		self.scrollView.frame = CGRectMake((self.bounds.size.width / 2) - (width / 2), (self.bounds.size.height / 2) - (height / 2), width, height);
		
	} else {
		
		[self layoutScrollViewAnimated:NO];
		
	}
}

- (void)layoutScrollViewAnimated:(BOOL)animated{
	
	if (animated) {
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.0001];
	}
	
	CGFloat hfactor = self.imageView.image.size.width / self.frame.size.width;
	CGFloat vfactor = self.imageView.image.size.height / self.frame.size.height;
	
	CGFloat factor = MAX(hfactor, vfactor);
	
	CGFloat newWidth = self.imageView.image.size.width / factor;
	CGFloat newHeight = self.imageView.image.size.height / factor;
	
	CGFloat leftOffset = (self.frame.size.width - newWidth) / 2;
	CGFloat topOffset = (self.frame.size.height - newHeight) / 2;
	
	self.scrollView.frame = CGRectMake(leftOffset, topOffset, newWidth, newHeight);
	self.scrollView.layer.position = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
	self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width, self.scrollView.bounds.size.height);
	self.scrollView.contentOffset = CGPointMake(0.0f, 0.0f);
	self.imageView.frame = self.scrollView.bounds;
	
	
	if (animated) {
		[UIView commitAnimations];
	}
}


#pragma mark -
#pragma mark Animation

- (CABasicAnimation*)fadeAnimation{
	
	CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
	animation.fromValue = [NSNumber numberWithFloat:0.0f];
	animation.toValue = [NSNumber numberWithFloat:1.0f];
	animation.duration = .3f;
	animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
	
	return animation;
}

#pragma mark -
#pragma mark Parent Controller Fading

- (void)resetBackgroundColors{
	
	self.backgroundColor = [UIColor blackColor];
	self.superview.backgroundColor = self.backgroundColor;
	self.superview.superview.backgroundColor = self.backgroundColor;
	
}

#pragma mark -
#pragma mark UIScrollView Delegate Methods

- (void)killZoomAnimationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context{
	
	if([finished boolValue]){
		
		[self.scrollView setZoomScale:1.0f animated:NO];
		self.imageView.frame = self.scrollView.bounds;
		[self layoutScrollViewAnimated:NO];
		
	}
	
}

- (void)killScrollViewZoom{
	
	if (!self.scrollView.zoomScale > 1.0f) return;
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	[UIView setAnimationDidStopSelector:@selector(killZoomAnimationDidStop:finished:context:)];
	[UIView setAnimationDelegate:self];
	
	CGFloat hfactor = self.imageView.image.size.width / self.frame.size.width;
	CGFloat vfactor = self.imageView.image.size.height / self.frame.size.height;
	
	CGFloat factor = MAX(hfactor, vfactor);
	
	CGFloat newWidth = self.imageView.image.size.width / factor;
	CGFloat newHeight = self.imageView.image.size.height / factor;
	
	CGFloat leftOffset = (self.frame.size.width - newWidth) / 2;
	CGFloat topOffset = (self.frame.size.height - newHeight) / 2;
	
	self.scrollView.frame = CGRectMake(leftOffset, topOffset, newWidth, newHeight);
	self.imageView.frame = self.scrollView.bounds;
	[UIView commitAnimations];
	
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
	return [self.scrollView viewWithTag:ZOOM_VIEW_TAG];
}

- (CGRect)frameToFitCurrentView{
	
	CGFloat heightFactor = self.imageView.image.size.height / self.frame.size.height;
	CGFloat widthFactor = self.imageView.image.size.width / self.frame.size.width;
	
	CGFloat scaleFactor = MAX(heightFactor, widthFactor);
	
	CGFloat newHeight = self.imageView.image.size.height / scaleFactor;
	CGFloat newWidth = self.imageView.image.size.width / scaleFactor;
	
	
	CGRect rect = CGRectMake((self.frame.size.width - newWidth)/2, (self.frame.size.height-newHeight)/2, newWidth, newHeight);
	
	return rect;
	
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale{
	
	if (scrollView.zoomScale > 1.0f) {		
		
		
//		CGFloat height, width, originX, originY;
        CGFloat height, width;
//		height = MIN(CGRectGetHeight(self.imageView.frame) + self.imageView.frame.origin.x, CGRectGetHeight(self.bounds));
//		width = MIN(CGRectGetWidth(self.imageView.frame) + self.imageView.frame.origin.y, CGRectGetWidth(self.bounds));
		
		
		if (CGRectGetMaxX(self.imageView.frame) > self.bounds.size.width) {
			width = CGRectGetWidth(self.bounds);
//			originX = 0.0f;
		} else {
			width = CGRectGetMaxX(self.imageView.frame);
			
//			if (self.imageView.frame.origin.x < 0.0f) {
//				originX = 0.0f;
//			} else {
//				originX = self.imageView.frame.origin.x;
//			}	
		}
		
		if (CGRectGetMaxY(self.imageView.frame) > self.bounds.size.height) {
			height = CGRectGetHeight(self.bounds);
//			originY = 0.0f;
		} else {
			height = CGRectGetMaxY(self.imageView.frame);
			
//			if (self.imageView.frame.origin.y < 0.0f) {
//				originY = 0.0f;
//			} else {
//				originY = self.imageView.frame.origin.y;
//			}
		}
		
		CGRect frame = self.scrollView.frame;
		self.scrollView.frame = CGRectMake((self.bounds.size.width / 2) - (width / 2), (self.bounds.size.height / 2) - (height / 2), width, height);
		self.scrollView.layer.position = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
		if (!CGRectEqualToRect(frame, self.scrollView.frame)) {		
			
			CGFloat offsetY, offsetX;
			
			if (frame.origin.y < self.scrollView.frame.origin.y) {
				offsetY = self.scrollView.contentOffset.y - (self.scrollView.frame.origin.y - frame.origin.y);
			} else {				
				offsetY = self.scrollView.contentOffset.y - (frame.origin.y - self.scrollView.frame.origin.y);
			}
			
			if (frame.origin.x < self.scrollView.frame.origin.x) {
				offsetX = self.scrollView.contentOffset.x - (self.scrollView.frame.origin.x - frame.origin.x);
			} else {				
				offsetX = self.scrollView.contentOffset.x - (frame.origin.x - self.scrollView.frame.origin.x);
			}
			
			if (offsetY < 0) offsetY = 0;
			if (offsetX < 0) offsetX = 0;
			
			self.scrollView.contentOffset = CGPointMake(offsetX, offsetY);
		}
		
	} else {
		[self layoutScrollViewAnimated:YES];
	}
}	


#pragma mark -
#pragma mark RotateGesture

- (void)rotate:(UIRotationGestureRecognizer*)gesture{
	
	if (gesture.state == UIGestureRecognizerStateBegan) {
		
		[self.layer removeAllAnimations];
		_beginRadians = gesture.rotation;
		self.layer.transform = CATransform3DMakeRotation(_beginRadians, 0.0f, 0.0f, 1.0f);
		
	} else if (gesture.state == UIGestureRecognizerStateChanged) {
		
		self.layer.transform = CATransform3DMakeRotation((_beginRadians + gesture.rotation), 0.0f, 0.0f, 1.0f);
		
	} else {
		
		CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
		animation.toValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
		animation.duration = 0.3f;
		animation.removedOnCompletion = NO;
		animation.fillMode = kCAFillModeForwards;
		animation.delegate = self;
		[animation setValue:[NSNumber numberWithInt:202] forKey:@"AnimationType"];
		[self.layer addAnimation:animation forKey:@"RotateAnimation"];
		
	} 
	
	
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
	
	if (flag) {
		
		if ([[anim valueForKey:@"AnimationType"] integerValue] == 101) {
			
			[self resetBackgroundColors];
			
		} else if ([[anim valueForKey:@"AnimationType"] integerValue] == 202) {
			
			self.layer.transform = CATransform3DIdentity;
			
		}
	}
	
}


#pragma mark -
#pragma mark Dealloc

- (void)dealloc {
	
	if (_photo) {
		[[PhotoLoader sharedImageLoader] cancelLoadForURL:self.photo.URL];
	}
	
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	[_activityView release], _activityView=nil;
	[_imageView release]; _imageView=nil;
	[_scrollView release]; _scrollView=nil;
	[_photo release]; _photo=nil;
    [super dealloc];
	
}

@end

