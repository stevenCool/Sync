//
//  PhotoViewController.h
//  Aekitas
//
//  Created by steven on 10-12-30.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PhotoGlobal.h"
//#import "PhotoEntryProtocol.h"

@interface PhotoViewController : UIViewController <UIScrollViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
@private
	id<PhotoViewSource> _photoSource;
	NSMutableArray *_photoViews;
	UIScrollView   *_scrollView;	
	NSInteger      _pageIndex;
	
	BOOL _isOffer;
	BOOL _noPhotos;
	BOOL _isSelectingPhoto;
	
	BOOL _barsHidden;
	
	BOOL _storedOldStyles;
	UIStatusBarStyle _oldStatusBarSyle;
	UIBarStyle _oldNavBarStyle;
	BOOL _oldNavBarTranslucent;
	UIColor* _oldNavBarTintColor;
	BOOL _oldNavBarHidden;
	UIBarStyle _oldToolBarStyle;
	BOOL _oldToolBarTranslucent;
	UIColor* _oldToolBarTintColor;	
	BOOL _oldToolBarHidden;
    UIImage *_oldBackGroundImage;
	
	UIBarButtonItem *_leftButton;
	UIBarButtonItem *_rightButton;
	UIBarButtonItem *_actionButton;
    UIBarButtonItem *_deleteButton;
    UIBarButtonItem *_addButton;
//    id<PhotoEntryProtocol> _photoSourceDelegate;
    UIActivityIndicatorView *_activityView;
}

@property(nonatomic,retain) id<PhotoViewSource> photoSource;
@property(nonatomic,retain) NSMutableArray *photoViews;
@property(nonatomic,retain) UIScrollView *scrollView;
//@property(nonatomic,assign) id<PhotoEntryProtocol> photoSourceDelegate;

- (id)initWithPhotoSource:(id<PhotoViewSource>)aSource isOffer:(BOOL)type storeStyle:(BOOL)isStore;
- (id)initWithPhotoSource:(id<PhotoViewSource>)aPhotoSource;
- (NSInteger)currentPhotoIndex;
//- (void)handleResult:(BOOL)success withIndex:(NSInteger)index withArray:(NSArray*)array;

#pragma mark -
#pragma mark Photo View Methods
- (void)moveToPhotoAtIndex:(NSInteger)index animated:(BOOL)animated;

@end

