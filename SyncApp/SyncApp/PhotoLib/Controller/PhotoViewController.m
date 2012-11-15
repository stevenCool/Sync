//
//  PhotoViewController.m
//  Aekitas
//
//  Created by steven on 10-12-30.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PhotoViewController.h"

@interface PhotoViewController (Private)
- (void)initPhotoViewSet;
- (void)setScrollViewAttribute;
- (void)photoNumberZero;
- (void)setupToolbar;
- (void)setupScrollViewContentSize;

- (void)setViewState;
- (void)enqueuePhotoViewAtIndex:(NSInteger)theIndex;
- (PhotoImageView*)dequeuePhotoView;
- (void)loadScrollViewWithPage:(NSInteger)page;

- (void)layoutScrollViewSubviews;

- (NSInteger)centerPhotoIndex;
- (void)setBarsHidden:(BOOL)hidden animated:(BOOL)animated;

- (void)takeAnotherPhoto;
- (void)selectPhoto;
- (void)deletePhoto;
- (void)savePhoto;
- (void)copyPhoto;
@end

@implementation PhotoViewController
@synthesize scrollView=_scrollView;
@synthesize photoSource=_photoSource; 
@synthesize photoViews=_photoViews;
//@synthesize photoSourceDelegate = _photoSourceDelegate;

- (id)initWithPhotoSource:(id<PhotoViewSource>)aSource isOffer:(BOOL)type storeStyle:(BOOL)isStore{
	if (self = [super init]) {
		[self initPhotoViewSet];
		_photoSource = [aSource retain];
		_isOffer = type; 
		_storedOldStyles = isStore;
		_isSelectingPhoto = FALSE;
	}
	
	return self;
}

- (id)initWithPhotoSource:(id<PhotoViewSource>)aSource{
	if (self = [super init]) {
		[self initPhotoViewSet];	
		_photoSource = [aSource retain];
		_isOffer = FALSE; 
		_storedOldStyles = FALSE;
		_isSelectingPhoto = FALSE;
	}
	
	return self;
}

- (void)initPhotoViewSet{
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toggleBarsNotification:) name:@"PhotoViewToggleBars" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(photoViewDidFinishLoading:) name:@"PhotoDidFinishLoading" object:nil];
	
	self.hidesBottomBarWhenPushed = YES;
	self.wantsFullScreenLayout = YES;	
	
	_pageIndex= 0;
	_noPhotos = FALSE;
}

- (NSInteger)currentPhotoIndex{
	
	return _pageIndex;
	
}

#pragma mark -
#pragma mark View Controller Methods

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.view.backgroundColor = [UIColor blackColor];
	self.wantsFullScreenLayout = YES;
	
	if (!_scrollView) {
		
		_scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
		[self setScrollViewAttribute];
		[self.view addSubview:_scrollView];
		
	}
	
	//  load photoviews lazily
	NSMutableArray *views = [[NSMutableArray alloc] init];
	for (unsigned i = 0; i < [self.photoSource numberOfPhotos]; i++) {
		[views addObject:[NSNull null]];
	}
	self.photoViews = views;
	[views release];
	
    UIBarButtonItem* backBarItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:backBarItem];
    [backBarItem release];
}

- (void)setScrollViewAttribute
{
	_scrollView.delegate=self;
	_scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
	_scrollView.multipleTouchEnabled=YES;
	_scrollView.scrollEnabled=YES;
	_scrollView.directionalLockEnabled=YES;
	_scrollView.canCancelContentTouches=YES;
	_scrollView.delaysContentTouches=YES;
	_scrollView.clipsToBounds=YES;
	_scrollView.alwaysBounceHorizontal=YES;
	_scrollView.bounces=YES;
	_scrollView.pagingEnabled=YES;
	_scrollView.showsVerticalScrollIndicator=NO;
	_scrollView.showsHorizontalScrollIndicator=NO;
	_scrollView.backgroundColor = self.view.backgroundColor;
}

- (void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
//    EMMALog(@"%@",self.navigationController);
    
    CGRect frame = [[UIScreen mainScreen] applicationFrame];
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    activityView.frame = CGRectMake((CGRectGetWidth(frame) / 2) - 11.0f, CGRectGetHeight(frame) - 200.0f , 22.0f, 22.0f);
    activityView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
    [self.view addSubview:activityView];
    _activityView = [activityView retain];
    [activityView release];
	
	if(_storedOldStyles && !_isSelectingPhoto) {
		_oldStatusBarSyle = [UIApplication sharedApplication].statusBarStyle;
		
		_oldNavBarTintColor = [self.navigationController.navigationBar.tintColor retain];
		_oldNavBarStyle = self.navigationController.navigationBar.barStyle;
		_oldNavBarTranslucent = self.navigationController.navigationBar.translucent;
		
		_oldToolBarTintColor = [self.navigationController.toolbar.tintColor retain];
		_oldToolBarStyle = self.navigationController.toolbar.barStyle;
		_oldToolBarTranslucent = self.navigationController.toolbar.translucent;
		
		_oldToolBarHidden = [self.navigationController isToolbarHidden];
        _oldNavBarHidden = [self.navigationController isNavigationBarHidden];
        
        NSString *osVersion = [[UIDevice currentDevice] systemVersion];
        if ([osVersion floatValue] >= 5.0) {
            if ([self.navigationController.navigationBar backgroundImageForBarMetrics:0]) {
                _oldBackGroundImage = [[self.navigationController.navigationBar backgroundImageForBarMetrics:0] retain];
                [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:0];
            }
        }
	}	
	
	if (![self.photoSource numberOfPhotos]) {
		[self photoNumberZero];
	}
	
//	if ([self.navigationController isToolbarHidden] && ([self.photoSource numberOfPhotos] > 1)) {
	if ([self.navigationController isToolbarHidden]) {
		[self.navigationController setToolbarHidden:NO animated:YES];
	}
    if ([self.navigationController isNavigationBarHidden]) {
		[self.navigationController setNavigationBarHidden:NO animated:YES];
	}
	self.navigationController.navigationBar.tintColor = nil;
	self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
	self.navigationController.navigationBar.translucent = YES;
	
	self.navigationController.toolbar.tintColor = nil;
	self.navigationController.toolbar.barStyle = UIBarStyleBlack;
	self.navigationController.toolbar.translucent = YES;
	
	[self setupToolbar];
	[self setupScrollViewContentSize];
	[self moveToPhotoAtIndex:_pageIndex animated:NO];
	
}

- (void)viewWillDisappear:(BOOL)animated{
	[super viewWillDisappear:animated];
	
	if(_storedOldStyles) {		
		[[UIApplication sharedApplication] setStatusBarStyle:_oldStatusBarSyle animated:YES];
		
		if(!_oldToolBarHidden) {
			if ([self.navigationController isToolbarHidden]) {
				[self.navigationController setToolbarHidden:NO animated:YES];
			}
			self.navigationController.toolbar.barStyle = _oldNavBarStyle;
			self.navigationController.toolbar.tintColor = _oldNavBarTintColor;
			self.navigationController.toolbar.translucent = _oldNavBarTranslucent;
		} else {
			[self.navigationController setToolbarHidden:_oldToolBarHidden animated:YES];
		}
        if(!_oldNavBarHidden) {
			if ([self.navigationController isNavigationBarHidden]) {
				[self.navigationController setNavigationBarHidden:NO animated:YES];
			}
			self.navigationController.navigationBar.barStyle = _oldNavBarStyle;
            self.navigationController.navigationBar.tintColor = _oldNavBarTintColor;
            self.navigationController.navigationBar.translucent = _oldNavBarTranslucent;
		} else {
			[self.navigationController setNavigationBarHidden:_oldToolBarHidden animated:YES];
		}
        
        NSString *osVersion = [[UIDevice currentDevice] systemVersion];
        if ([osVersion floatValue] >= 5.0) {
            if (_oldBackGroundImage) {
                [self.navigationController.navigationBar setBackgroundImage:_oldBackGroundImage forBarMetrics:0];
            }
        }
	}
	else {
		[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
		[self.navigationController setNavigationBarHidden:NO animated:NO];
		self.navigationController.navigationBar.translucent = NO;
		self.navigationController.toolbar.translucent = NO;
		[self.navigationController setToolbarHidden:NO animated:YES];
	}

	
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
   	return (UIInterfaceOrientationIsLandscape(interfaceOrientation) || interfaceOrientation == UIInterfaceOrientationPortrait);	
}

#pragma mark -
#pragma mark Photo View Methods

- (NSInteger)centerPhotoIndex{
	
	CGFloat pageWidth = self.scrollView.frame.size.width;
	return floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
	
}

- (void)moveForward:(id)sender{
	[self moveToPhotoAtIndex:[self centerPhotoIndex]+1 animated:NO];	
}

- (void)moveBack:(id)sender{
	[self moveToPhotoAtIndex:[self centerPhotoIndex]-1 animated:NO];
}

- (void)photoNumberZero{
	_noPhotos = YES;	
	[_photoSource release], _photoSource=nil;
	PhotoModel *noPhotos = [[PhotoModel alloc] initWithImage:NoPhotosPlaceholder];
    PhotoSourceModel *source = [[PhotoSourceModel alloc] initWithPhotos:[NSArray arrayWithObjects:noPhotos, nil]];
    _photoSource = [source retain];
//	[self.photoViews removeAllObjects];
//	[self.photoViews addObject:[NSNull null]];

    [noPhotos release];
    [source release];
}

- (void)setupToolbar {
	
//	if([self.photoSource numberOfPhotos] == 1) {
//		[self.navigationController setToolbarHidden:YES animated:NO];
//		return;
//	}
	
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent animated:YES];
	
    if (_isOffer) {
        UIBarButtonItem *deleteItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Delete", @"") style:UIBarButtonItemStyleBordered target:self action:@selector(deletePhoto)];
        _deleteButton = deleteItem;
        UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        if ([self.photoSource numberOfPhotos] > 1) {
            
            UIBarButtonItem *fixedCenter = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
            fixedCenter.width = 80.0f;
            UIBarButtonItem *fixedRight = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
            fixedRight.width = 40.0f;
            
            UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"pl_left.png"] style:UIBarButtonItemStylePlain target:self action:@selector(moveBack:)];
            UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"pl_right.png"] style:UIBarButtonItemStylePlain target:self action:@selector(moveForward:)];
            
            [self setToolbarItems:[NSArray arrayWithObjects:deleteItem, flex, left, fixedCenter, right, flex, fixedRight, nil]];
            
            _rightButton = right;
            _leftButton = left;
            
            [fixedCenter release];
            [fixedRight release];
            [right release];
            [left release];
            
        } else {
            [self setToolbarItems:[NSArray arrayWithObjects:deleteItem, flex, nil]];
        }
        [deleteItem release];
        
        UIBarButtonItem *actionItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(actionButtonHit:)];
        self.navigationItem.rightBarButtonItem = actionItem;
        _addButton=actionItem;
        [actionItem release];
        
        [flex release];
    }
    else
    {
        UIBarButtonItem *action = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(actionButtonHit:)];
        UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        if ([self.photoSource numberOfPhotos] > 1) {
            
            UIBarButtonItem *fixedCenter = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
            fixedCenter.width = 80.0f;
            UIBarButtonItem *fixedLeft = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
            fixedLeft.width = 40.0f;
            
            UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"pl_left.png"] style:UIBarButtonItemStylePlain target:self action:@selector(moveBack:)];
            UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"pl_right.png"] style:UIBarButtonItemStylePlain target:self action:@selector(moveForward:)];
            
            [self setToolbarItems:[NSArray arrayWithObjects:fixedLeft, flex, left, fixedCenter, right, flex, action, nil]];
            
            _rightButton = right;
            _leftButton = left;
            
            [fixedCenter release];
            [fixedLeft release];
            [right release];
            [left release];
            
        } else {
            [self setToolbarItems:[NSArray arrayWithObjects:flex, action, nil]];
        }
        
        _actionButton=action;
        
        [action release];
        [flex release];
    }
}

- (void)setupScrollViewContentSize{
	
	CGSize contentSize = self.view.bounds.size;
	contentSize.width = (contentSize.width * [self.photoSource numberOfPhotos]);
	
	if (!CGSizeEqualToSize(contentSize, self.scrollView.contentSize)) {
		self.scrollView.contentSize = contentSize;
	}
	
}

- (void)moveToPhotoAtIndex:(NSInteger)index animated:(BOOL)animated {
	NSAssert(index < [self.photoSource numberOfPhotos] && index >= 0, @"Photo index passed out of bounds");
	
	_pageIndex = index;
    
    /////solve ios 5 issue about the function order
    if (!self.photoViews) {
        return;
    }
    
	[self setViewState];
	
	[self enqueuePhotoViewAtIndex:index];
	
	[self loadScrollViewWithPage:index-1];
	[self loadScrollViewWithPage:index];
	[self loadScrollViewWithPage:index+1];
	
	[self.scrollView scrollRectToVisible:((PhotoImageView*)[self.photoViews objectAtIndex:index]).frame animated:animated];
	
	if ([[self.photoSource photoAtIndex:_pageIndex] didFail]) {
		[self setBarsHidden:NO animated:YES];
	}
	
	//  reset any zoomed side views
	if (index + 1 < [self.photoSource numberOfPhotos] && (NSNull*)[self.photoViews objectAtIndex:index+1] != [NSNull null]) {
		[((PhotoImageView*)[self.photoViews objectAtIndex:index+1]) killScrollViewZoom];
	} 
	if (index - 1 >= 0 && (NSNull*)[self.photoViews objectAtIndex:index-1] != [NSNull null]) {
		[((PhotoImageView*)[self.photoViews objectAtIndex:index-1]) killScrollViewZoom];
	} 	
	
}

- (void)setViewState {	
	
	if (_leftButton) {
		_leftButton.enabled = !(_pageIndex-1 < 0);
	}
	
	if (_rightButton) {
		_rightButton.enabled = !(_pageIndex+1 >= [self.photoSource numberOfPhotos]);
	}
	
	if (_actionButton) {
		PhotoImageView *imageView = [_photoViews objectAtIndex:[self centerPhotoIndex]];
		if ((NSNull*)imageView != [NSNull null]) {
			_actionButton.enabled = ![imageView isLoading];
		} else {
			_actionButton.enabled = NO;
		}
	}
	
	if ([self.photoSource numberOfPhotos] > 1) {
		self.title = [NSString stringWithFormat:@"%i of %i", _pageIndex+1, [self.photoSource numberOfPhotos]];
	} else {
		self.title = @"";
	}
	
}

- (void)enqueuePhotoViewAtIndex:(NSInteger)theIndex{
	NSInteger count = 0;
	for (PhotoImageView *view in self.photoViews){
		if ([view isKindOfClass:[PhotoImageView class]]) {
			if (count > theIndex+1 || count < theIndex-1) {
				[view prepareForReusue];
				[view removeFromSuperview];
			} else {
				view.tag = 0;
			}
		} 
		count++;
	}	
}

- (PhotoImageView*)dequeuePhotoView{
	
	NSInteger count = 0;
	for (PhotoImageView *view in self.photoViews){
		if ([view isKindOfClass:[PhotoImageView class]]) {
			if (view.superview == nil) {
				view.tag = count;
				return view;
			}
		}
		count ++;
	}	
	return nil;
	
}

- (void)loadScrollViewWithPage:(NSInteger)page {
	
    if (page < 0) return;
    if (page >= [self.photoSource numberOfPhotos]) return;
	
	PhotoImageView * photoView = [self.photoViews objectAtIndex:page];
	if ((NSNull*)photoView == [NSNull null]) {
		photoView = [self dequeuePhotoView];
		if (photoView != nil) {
			[self.photoViews exchangeObjectAtIndex:photoView.tag withObjectAtIndex:page];
			photoView = [self.photoViews objectAtIndex:page];
		}
	}
	
	if (photoView == nil || (NSNull*)photoView == [NSNull null]) {
		photoView = [[PhotoImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height)];
		[self.photoViews replaceObjectAtIndex:page withObject:photoView];
		[photoView release];
	} 
	
	[photoView setPhoto:[self.photoSource photoAtIndex:page]];
	
    if (photoView.superview == nil) {
		[self.scrollView addSubview:photoView];
	}
	
	CGRect frame = self.scrollView.frame;
	NSInteger centerPageIndex = _pageIndex;
	CGFloat xOrigin = (frame.size.width * page);
	if (page > centerPageIndex) {
		xOrigin = (frame.size.width * page) + IMAGE_GAP;
	} else if (page < centerPageIndex) {
		xOrigin = (frame.size.width * page) - IMAGE_GAP;
	}
	
	frame.origin.x = xOrigin;
	frame.origin.y = 0;
	photoView.frame = frame;
}

- (void)photoViewDidFinishLoading:(NSNotification*)notification{
	if (notification == nil) return;
	if ([[[notification object] objectForKey:@"photo"] isEqual:[self.photoSource photoAtIndex:[self centerPhotoIndex]]]) {
		if ([[[notification object] objectForKey:@"failed"] boolValue]) {
			if (_barsHidden) {
				//  image failed loading
				[self setBarsHidden:NO animated:YES];
			}
		} 
		[self setViewState];
	}
}

#pragma mark -
#pragma mark UIScrollView Delegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	
	NSInteger _index = [self centerPhotoIndex];
	if (_index >= [self.photoSource numberOfPhotos] || _index < 0) {
		return;
	}
	
	if (_pageIndex != _index ) {
		
		[self setBarsHidden:YES animated:YES];
		_pageIndex = _index;
		[self setViewState];
		
		if (![scrollView isTracking]) {
			[self layoutScrollViewSubviews];
		}
		
	}
	
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	
	NSInteger _index = [self centerPhotoIndex];
	if (_index >= [self.photoSource numberOfPhotos] || _index < 0) {
		return;
	}
	
	[self moveToPhotoAtIndex:_index animated:YES];
	
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
	[self layoutScrollViewSubviews];
}

- (void)layoutScrollViewSubviews{
	
	NSInteger _index = [self currentPhotoIndex];
	
	for (NSInteger page = _index -1; page < _index+3; page++) {
		
		if (page >= 0 && page < [self.photoSource numberOfPhotos]){
			
			CGFloat originX = self.scrollView.bounds.size.width * page;
			
			if (page < _index) {
				originX -= IMAGE_GAP;
			} 
			if (page > _index) {
				originX += IMAGE_GAP;
			}
			
			if ([self.photoViews objectAtIndex:page] == [NSNull null] || !((UIView*)[self.photoViews objectAtIndex:page]).superview){
				[self loadScrollViewWithPage:page];
			}
			
			PhotoImageView *_photoView = (PhotoImageView*)[self.photoViews objectAtIndex:page];
			CGRect newframe = CGRectMake(originX, 0.0f, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height);
			
			if (!CGRectEqualToRect(_photoView.frame, newframe)) {	
				
				[UIView beginAnimations:nil context:NULL];
				[UIView setAnimationDuration:0.1];
				_photoView.frame = newframe;
				[UIView commitAnimations];
				
			}
			
		}
	}
	
}


#pragma mark -
#pragma mark Bar/Caption Methods

- (void)setBarsHidden:(BOOL)hidden animated:(BOOL)animated{
	if (hidden&&_barsHidden) return;
	
	[[UIApplication sharedApplication] setStatusBarHidden:hidden withAnimation:UIStatusBarAnimationFade];
	[self.navigationController setNavigationBarHidden:hidden animated:animated];
	[self.navigationController setToolbarHidden:hidden animated:animated];
	
	_barsHidden=hidden;
	
}

- (void)toggleBarsNotification:(NSNotification*)notification{
	[self setBarsHidden:!_barsHidden animated:YES];
}

#pragma mark -
#pragma mark UIActionSheet Methods

- (void)actionButtonHit:(id)sender{
	
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", @"") destructiveButtonTitle:nil otherButtonTitles:@"Save", nil];

	actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
	actionSheet.delegate = self;
	
	[actionSheet showInView:self.view];
	[self setBarsHidden:YES animated:YES];
	
	[actionSheet release];
	
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
	
	[self setBarsHidden:NO animated:YES];
	
    if (buttonIndex == actionSheet.firstOtherButtonIndex) {
        [self savePhoto];
	}
	if (buttonIndex == actionSheet.cancelButtonIndex) {
		return;
	} 
}

//- (void)actionButtonHit:(id)sender{
//	
//	UIActionSheet *actionSheet;
//	if (_isOffer) {
//        if ( [_photoSource numberOfPhotos] >= KUploadPhotoLimitation) {
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil 
//                                                                message:KUploadPhotoReachLimitWarning
//                                                               delegate:self 
//                                                      cancelButtonTitle:NSLocalizedString(@"OK", @"")
//                                                      otherButtonTitles:nil];
//            [alertView show];
//            [alertView release];
//            return;
//        }
//        else{
//            if([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
//            {
//                actionSheet = [[UIActionSheet alloc] initWithTitle:nil 
//                                                          delegate:self 
//                                                 cancelButtonTitle:NSLocalizedString(@"Cancel", @"") 
//                                            destructiveButtonTitle:nil 
//                                                 otherButtonTitles:@"Take Photo",
//                               @"Choose From Library", 
//                               nil];
//                
//            }
//            else
//            {
//                actionSheet = [[UIActionSheet alloc] initWithTitle:nil 
//                                                          delegate:self 
//                                                 cancelButtonTitle:NSLocalizedString(@"Cancel", @"") 
//                                            destructiveButtonTitle:nil 
//                                                 otherButtonTitles:@"Choose From Library", 
//                               nil];
//            }
//        }
//	}
//	else {
//		actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", @"") destructiveButtonTitle:nil otherButtonTitles:@"Save", @"Copy", nil];
//	}
//	actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
//	actionSheet.delegate = self;
//	
//	[actionSheet showInView:self.view];
//	[self setBarsHidden:YES animated:YES];
//	
//	[actionSheet release];
//	
//}
//
//- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
//	
//	[self setBarsHidden:NO animated:YES];
//	
//	if (buttonIndex == actionSheet.cancelButtonIndex) {
//		return;
//	} 
//	if (_isOffer) {
//        if([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
//        {
//            if (buttonIndex == actionSheet.firstOtherButtonIndex) {
//                [self.photoSourceDelegate pushTakePhotoCtrInPhotoSourceView];
//            } else if (buttonIndex == actionSheet.firstOtherButtonIndex + 1) {
//                [self.photoSourceDelegate pushLibraryCtrInPhotoSourceView];	
//            } 
//        }
//        else
//        {
//            if (buttonIndex == actionSheet.firstOtherButtonIndex) {
//                [self.photoSourceDelegate pushLibraryCtrInPhotoSourceView];
//            } 
//        }
////		if (buttonIndex == actionSheet.firstOtherButtonIndex) {
////			//[self takeAnotherPhoto];
////		} else if (buttonIndex == actionSheet.firstOtherButtonIndex + 1) {
////			//[self selectPhoto];	
////		} else if (buttonIndex == actionSheet.firstOtherButtonIndex + 2) {
////			//[self deletePhoto];	
////		}
//	}
//	else {
//		if (buttonIndex == actionSheet.firstOtherButtonIndex) {
//			[self savePhoto];
//		} else if (buttonIndex == actionSheet.firstOtherButtonIndex + 1) {
//			[self copyPhoto];	
//		}
//	}
//}

#pragma mark  -
#pragma mark  UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	NSArray *keyArray = [info allKeys];
	UIImage *baseImage = [info objectForKey:UIImagePickerControllerOriginalImage];
	if ([keyArray containsObject:UIImagePickerControllerMediaMetadata]) {
		NSData  *data = UIImageJPEGRepresentation(baseImage,0.5);
		UIImage *photo = [[UIImage alloc] initWithData:data];
		[[PhotoCache currentCache] saveLocalImage:photo];
		[photo release];
	}
	else {
		[[PhotoCache currentCache] saveLocalImage:baseImage];
	}
	
	[_photoSource release];
	PhotoSourceModel *source = [[PhotoSourceModel alloc] initWithPhotos:[PhotoCache currentCache].localCacheArray];
	self.photoSource = source;
    [source release];
	if ( [[PhotoCache currentCache].localCacheArray count] ) {
		[self.photoViews addObject:[NSNull null]];
	}
	
	[_scrollView removeFromSuperview];
	[_scrollView release];
	_scrollView = nil;
	_scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
	[self setScrollViewAttribute];
	[self.view addSubview:_scrollView];
	
	[_photoViews release];
	_photoViews = nil;
	NSMutableArray *views = [[NSMutableArray alloc] init];
	for (unsigned i = 0; i < [self.photoSource numberOfPhotos]; i++) {
		[views addObject:[NSNull null]];
	}
	self.photoViews = views;
	[views release];
	_pageIndex = 0;
	
	[picker dismissModalViewControllerAnimated:YES];
	
	_actionButton.enabled = YES;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark Actions

- (void)takeAnotherPhoto{
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
		UIImagePickerController *picker = [[UIImagePickerController alloc] init];
		picker.delegate = self;
		picker.sourceType = UIImagePickerControllerSourceTypeCamera;
		[self presentModalViewController:picker animated:YES];
		[picker release];
		_isSelectingPhoto = YES;
	}
	else {
		return;
	}
}

- (void)selectPhoto{
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
		UIImagePickerController *picker = [[UIImagePickerController alloc] init];
		picker.delegate = self;
		picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
		[self presentModalViewController:picker animated:YES];
		[picker release];
		_isSelectingPhoto = YES;
	}
	else {
		return;
	}
}

- (void)deletePhoto{
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Delete", @"") 
                                                     message:NSLocalizedString(@"SureToDeletePhoto", @"") 
                                                    delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", @"") 
                                           otherButtonTitles:NSLocalizedString(@"Delete", @""), nil] autorelease];
    [alert show];    
}


//- (void)handleResult:(BOOL)success withIndex:(NSInteger)index withArray:(NSArray*)array{
//    [_activityView stopAnimating];
//    if (success) {
//        [_photoSource release];
//        _photoSource = nil;
//        NSMutableArray *picArray = [[NSMutableArray alloc] init];
//        for ( AlertAttachment* attachment in array ) {
//            PhotoModel *photo = [[PhotoModel alloc] initWithImageURL:[NSURL URLWithString:attachment.URL]];
//            [picArray addObject:photo];
//            [photo release];
//        }
//        PhotoSourceModel *source = [[PhotoSourceModel alloc] initWithPhotos:picArray];
//        _photoSource = [source retain];
//        //self.photoSource = source;
//        if ( ![picArray count] ) {
//            [self photoNumberZero];
//            _deleteButton.enabled = NO;
//        }
//        else{
//            _deleteButton.enabled = YES;
//        }
//        _addButton.enabled = YES;
//        [source release];
//        
//        [_scrollView removeFromSuperview];
//        [_scrollView release];
//        _scrollView = nil;
//        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
//        [self setScrollViewAttribute];
//        [self.view addSubview:_scrollView];
//        
//        [self.photoViews release];
//        _photoViews = nil;
//        NSMutableArray *views = [[NSMutableArray alloc] init];
//        for (unsigned i = 0; i < [self.photoSource numberOfPhotos]; i++) {
//            [views addObject:[NSNull null]];
//        }
//        self.photoViews = views;
//        [views release];
//        
//        [self setupScrollViewContentSize];
//        if ( 0 >= index || index >=[picArray count]) {
//            [self moveToPhotoAtIndex:0 animated:NO];
//            _pageIndex = 0;
//        }
//        else{
//            [self moveToPhotoAtIndex:index animated:NO];
//            _pageIndex = index;
//        }
//        [picArray release];
//    }
//}

- (void)savePhoto{
	UIImageWriteToSavedPhotosAlbum(((PhotoImageView*)[self.photoViews objectAtIndex:_pageIndex]).imageView.image, nil, nil, nil);
}

- (void)copyPhoto{
	[[UIPasteboard generalPasteboard] setData:UIImagePNGRepresentation(((PhotoImageView*)[self.photoViews objectAtIndex:_pageIndex]).imageView.image) forPasteboardType:@"public.png"];
}

#pragma mark -
#pragma mark UIAlertViewDelegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ([alertView.title isEqualToString:NSLocalizedString(@"Delete", @"")]) {
		if (buttonIndex == 1) {
            [_activityView startAnimating];
            _deleteButton.enabled = NO;
            _rightButton.enabled = NO;
            _leftButton.enabled = NO;
            _addButton.enabled = NO;
            //NSInteger index = [self currentPhotoIndex];
            //[self.photoSourceDelegate willDeletePhoto:index];
		}
        else{
            
        }
	}
}

#pragma mark -
#pragma mark Memory

- (void)didReceiveMemoryWarning{
	[super didReceiveMemoryWarning];
}

- (void)viewDidUnload{
	
	self.photoViews=nil;
	self.scrollView=nil;
	
}

- (void)dealloc {
	
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	[_photoViews release], _photoViews=nil;
	[_photoSource release], _photoSource=nil;
	[_scrollView release], _scrollView=nil;
	[_oldToolBarTintColor release], _oldToolBarTintColor = nil;
	[_oldNavBarTintColor release], _oldNavBarTintColor = nil;
	
    if (_activityView) {
        [_activityView release];
    }
    if (_oldBackGroundImage) {
        [_oldBackGroundImage release];
    }
    
    [super dealloc];
}


@end

