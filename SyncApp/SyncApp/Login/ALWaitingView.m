//
//  ALWaitingView.m
//  pbuAudiLog
//
//  Created by Yan Xue on 12-8-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ALWaitingView.h"

@implementation ALWaitingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
        
//        UILabel *pLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 80)];
//        pLabel.center = CGPointMake(self.frame.size.width/2, 200);
//        pLabel.text = @"数据正在加载, 请等待";
//        pLabel.textAlignment = UITextAlignmentCenter;
//        pLabel.backgroundColor = [UIColor clearColor];
//        pLabel.textColor = [UIColor whiteColor];
//        [self addSubview:pLabel];
//        [pLabel release];
        
        UIActivityIndicatorView *pActiv = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        pActiv.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        [pActiv startAnimating];
        [self addSubview:pActiv];
        [pActiv release];
        
        if ([UIApplication sharedApplication].statusBarOrientation ==  UIInterfaceOrientationPortraitUpsideDown)
            self.transform = CGAffineTransformMakeRotation(M_PI);
    }
    return self;
}

@end
