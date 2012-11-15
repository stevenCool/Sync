//
//  BUCustomPageControl.h
//  QMGLegend
//
//  Created by Xue Yan on 11-10-10.
//  Copyright 2011年 ShootingChance. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BUCustomPageControl : UIPageControl {
    UIImage *imagePageStateNormal;
    UIImage *imagePageStateHighlighted;
}

@property (nonatomic, retain) UIImage *imagePageStateNormal;
@property (nonatomic, retain) UIImage *imagePageStateHighlighted;

- (id)initWithFrame:(CGRect)frame;

@end
