//
//  BUCustomPageControl.m
//  QMGLegend
//
//  Created by Xue Yan on 11-10-10.
//  Copyright 2011年 ShootingChance. All rights reserved.
//

#import "BUCustomPageControl.h"
#import "BUCoreUtility.h"
@interface BUCustomPageControl(private)  // 声明一个私有方法, 该方法不允许对象直接使用
- (void)updateDots;
@end

@implementation BUCustomPageControl

@synthesize imagePageStateNormal;
@synthesize imagePageStateHighlighted;
- (id)initWithFrame:(CGRect)frame { // 初始化
    self = [super initWithFrame:frame];
    imagePageStateNormal = [BUCoreUtility newImageFromResource:@"pageControlStateNormal.png"];
    imagePageStateHighlighted = [BUCoreUtility newImageFromResource:@"pageControlStateHighlighted.png"];
    
    return self;
}
- (void)setImagePageStateNormal:(UIImage *)image {  // 设置正常状态点按钮的图片
    [imagePageStateNormal release];
    imagePageStateNormal = [image retain];
    [self updateDots];
}
- (void)setImagePageStateHighlighted:(UIImage *)image { // 设置高亮状态点按钮图片
    [imagePageStateHighlighted release];
    imagePageStateHighlighted = [image retain];
    [self updateDots];
}
- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event { // 点击事件
    [super endTrackingWithTouch:touch withEvent:event];
    [self updateDots];
}
- (void)updateDots { // 更新显示所有的点按钮
    if (imagePageStateNormal || imagePageStateHighlighted)
    {
        NSArray *subview = self.subviews;  // 获取所有子视图
        for (NSInteger i = 0; i < [subview count]; i++)
        {
            UIImageView *dot = [subview objectAtIndex:i];  // 以下不解释, 看了基本明白
            if (i == self.currentPage) 
                dot.image = imagePageStateNormal;
            else
                dot.image = imagePageStateHighlighted;
        }
    }
}

-(void) setCurrentPage:(NSInteger)page
{
    [super setCurrentPage:page];
    [self updateDots];
}

- (void)dealloc { // 释放内存
    [imagePageStateNormal release], imagePageStateNormal = nil;
    [imagePageStateHighlighted release], imagePageStateHighlighted = nil;
    [super dealloc];
}

@end
