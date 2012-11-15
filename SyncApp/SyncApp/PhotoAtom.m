//
//  PhotoAtom.m
//  SyncApp
//
//  Created by steven on 8/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PhotoAtom.h"

@implementation PhotoAtom
@synthesize originImage;
@synthesize imageName;
@synthesize delegate;
@synthesize isInServer;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
    }
    return self;
}

-(id)initWithImage:(UIImage*)origin withType:(ATOMTYPE)type{
	
	if (self = [super initWithFrame:CGRectMake(0, 0, 0, 0)]) {
		
		self.originImage = origin;
		
		CGRect viewFrames = CGRectMake(0, 0, 75, 75);
		
		statusView = [[UIImageView alloc] initWithFrame:viewFrames];
		[statusView setContentMode:UIViewContentModeScaleToFill];
		[statusView setImage:self.originImage];
        //statusView.alpha = 0.2;
		[self addSubview:statusView];
		
		overlayView = [[UIImageView alloc] initWithFrame:viewFrames];
		[overlayView setImage:[UIImage imageNamed:@"Overlay.png"]];
		[overlayView setHidden:YES];
		[self addSubview:overlayView];
        
        self.isInServer = NO;
        mode = type;
    }
    
	return self;	
}

-(void)toggleSelection {
    
    if (ShowMode == mode) {
        if ([delegate respondsToSelector:@selector(photoClicked:)]) {
            [delegate photoClicked:originImage];
        }
    }
    else {
        overlayView.hidden = !overlayView.hidden;
    }
	
    //    if([(ELCAssetTablePicker*)self.parent totalSelectedAssets] >= 10) {
    //        
    //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Maximum Reached" message:@"" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
    //		[alert show];
    //		[alert release];	
    //
    //        [(ELCAssetTablePicker*)self.parent doneAction:nil];
    //    }
}

-(BOOL)selected {
	
	return !overlayView.hidden;
}

-(void)setSelected:(BOOL)_selected {
    
	[overlayView setHidden:!_selected];
}

-(void)setIsInServer:(BOOL)status{
    isInServer = status;
    if (status) {
        statusView.alpha = 1.0;
    }
    else{
        statusView.alpha = 0.2;
    }
}

@end
