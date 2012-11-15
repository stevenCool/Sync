//
//  BURotateView.m
//  KiaSoul
//
//  Created by Xue Yan on 11-3-23.
//  Copyright 2011 ShootingChance. All rights reserved.
//

#import "BURotateView.h"
#import "BUCoreUtility.h"

@implementation BURotateView


- (id)initWithImageName:(NSString*)argImageName 
		   WithPosition:(CGPoint)argPosition
		   WithDuration:(float)argDuration
			 WithDirect:(BURotateDirect)argRotateDirect
{
	
    self = [super init];
    if (self) {
		// The animation to rotate the image view
		CABasicAnimation* spinAnimation = [CABasicAnimation
										   animationWithKeyPath:@"transform.rotation"];
		spinAnimation.toValue = [NSNumber numberWithFloat:argRotateDirect*3.14f];//[NSValue valueWithCATransform3D:CATransform3DMakeRotation(3.1415, 0, 0, 1.0)];
		spinAnimation.repeatCount = 10000;
		spinAnimation.duration = argDuration;
		spinAnimation.removedOnCompletion = NO;	
		spinAnimation.fillMode = kCAFillModeForwards;
		[spinAnimation setTimingFunction:[CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionLinear]];
		
		
		
        UIImage * pImage = [BUCoreUtility newImageFromResource:argImageName];
		UIImageView * pImageView = [[UIImageView alloc] initWithImage:pImage];
		[pImageView setCenter:argPosition];
		[self addSubview:pImageView];
		[pImageView.layer addAnimation:spinAnimation forKey:@"spinAnimation"];
		[pImageView release];
		[pImage release];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

- (void)dealloc {
    [super dealloc];
}


@end
