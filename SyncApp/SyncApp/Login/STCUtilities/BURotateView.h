//
//  BURotateView.h
//  KiaSoul
//
//  Created by Xue Yan on 11-3-23.
//  Copyright 2011 ShootingChance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

typedef enum {
    BURotateForward           =  2,      
    BURotateBackward		  = -2			
}BURotateDirect;
// BURotateDirect RotateDirect;

@interface BURotateView : UIView {
	
}

//@property(nonatomic) BURotateDirect RotateDirect;

- (id)initWithImageName:(NSString*)argImageName 
		   WithPosition:(CGPoint)argPosition
		   WithDuration:(float)argDuration
			 WithDirect:(BURotateDirect)argRotateDirect;

@end
