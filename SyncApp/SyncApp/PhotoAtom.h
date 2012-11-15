//
//  PhotoAtom.h
//  SyncApp
//
//  Created by steven on 8/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    ShowMode,
    EditMode
} ATOMTYPE;

@protocol PhotoAtomDelegate<NSObject>
-(void)photoClicked:(UIImage*)image;
@end

@interface PhotoAtom : UIView {
	UIImage *originImage;
    UIImageView *statusView;
    NSString *imageName;
	UIImageView *overlayView;
   
	BOOL selected;
	id<PhotoAtomDelegate> _delegate;
    BOOL isInServer;
    ATOMTYPE mode;
}

@property (nonatomic, strong) UIImage *originImage;
@property (nonatomic, strong) NSString *imageName;
@property (nonatomic, assign) id<PhotoAtomDelegate> delegate;
@property (nonatomic, assign) BOOL isInServer;

-(id)initWithImage:(UIImage*)origin withType:(ATOMTYPE)type;
-(BOOL)selected;
-(void)setSelected:(BOOL)_selected;

-(void)setIsInServer:(BOOL)status;

@end
