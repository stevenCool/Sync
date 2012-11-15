//
//  DDProgressView.m
//  DDProgressView
//
//  Created by Damien DeVille on 3/13/11.
//  Copyright 2011 Snappy Code. All rights reserved.
//

#import "DDProgressView.h"

#define kProgressBarHeight  3.0f
#define kProgressBarWidth	160.0f

@implementation DDProgressView

@synthesize innerColor ;
@synthesize outerColor ;
@synthesize emptyColor ;
@synthesize progress ;

- (id)init
{
	return [self initWithFrame: CGRectZero] ;
}

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame: frame] ;
	if (self)
	{
		self.backgroundColor = [UIColor clearColor] ;
		self.innerColor = [UIColor lightGrayColor] ;
		self.outerColor = [UIColor lightGrayColor] ;
		self.emptyColor = [UIColor clearColor] ;
		if (frame.size.width == 0.0f)
			frame.size.width = kProgressBarWidth ;
	}
	return self ;
}

//- (void)dealloc
//{
//	[innerColor release], innerColor = nil ;
//	[outerColor release], outerColor = nil ;
//	[emptyColor release], emptyColor = nil ;
//	
//	[super dealloc] ;
//}

- (void)setProgress:(float)theProgress
{
	// make sure the user does not try to set the progress outside of the bounds
	if (theProgress > 1.0f)
		theProgress = 1.0f ;
	if (theProgress < 0.0f)
		theProgress = 0.0f ;
	
	progress = theProgress ;
	[self setNeedsDisplay] ;
}

- (void)setFrame:(CGRect)frame
{
	// we set the height ourselves since it is fixed
	frame.size.height = kProgressBarHeight ;
	[super setFrame: frame] ;
}

- (void)setBounds:(CGRect)bounds
{
	// we set the height ourselves since it is fixed
	bounds.size.height = kProgressBarHeight ;
	[super setBounds: bounds] ;
}


static void functionEvaluateCallbacks(void *info, const CGFloat *in, CGFloat *out)  
{  
    CGFloat *colors = (CGFloat *)info;  
    *out++ = colors[0] + *in * colors[8];  
    *out++ = colors[1] + *in * colors[9];  
    *out++ = colors[2] + *in * colors[10];  
    *out++ = colors[3] + *in * colors[11];  
} 


- (void)drawRect:(CGRect)rect
{
	
    
    
    CGContextRef context = UIGraphicsGetCurrentContext() ;
	
    
    
    
	// save the context
	CGContextSaveGState(context) ;
	
	// allow antialiasing
	CGContextSetAllowsAntialiasing(context, TRUE) ;
	
	// we first draw the outter rounded rectangle
	rect = CGRectInset(rect, 0.0f, 0.0f) ;
	CGFloat radius = 0.5f * rect.size.height ;
    
	[outerColor setStroke];
	CGContextSetLineWidth(context, 0.5f) ;
    
	CGContextBeginPath(context) ;
	CGContextMoveToPoint(context, CGRectGetMinX(rect), CGRectGetMidY(rect)) ;
	CGContextAddArcToPoint(context, CGRectGetMinX(rect), CGRectGetMinY(rect), CGRectGetMidX(rect), CGRectGetMinY(rect), radius) ;
	CGContextAddArcToPoint(context, CGRectGetMaxX(rect), CGRectGetMinY(rect), CGRectGetMaxX(rect), CGRectGetMidY(rect), radius) ;
	CGContextAddArcToPoint(context, CGRectGetMaxX(rect), CGRectGetMaxY(rect), CGRectGetMidX(rect), CGRectGetMaxY(rect), radius) ;
	CGContextAddArcToPoint(context, CGRectGetMinX(rect), CGRectGetMaxY(rect), CGRectGetMinX(rect), CGRectGetMidY(rect), radius) ;
	CGContextClosePath(context) ;
	CGContextDrawPath(context, kCGPathStroke) ;
    
    
    size_t num_locations = 3;
    //三种颜色所处的位置.0.0表示起始位置,0.5表示中间,1.0表示结尾处
    CGFloat locations[3] = { 0.0,0.5,1.0};
    //表示三种颜色的渐变,数组中每四个元素表示一种颜色,对应于red,green,blue和alpha,
    CGFloat components[12] = {  
        1, 1, 1, 0.010,
        1.0, 1.0, 1.0, 0.3,
        1, 1, 1, 0.010
    };
    //CGShadingRef、CGGradientRef：用于绘制渐变
    CGGradientRef myGradient;
    //CGColorRef, CGColorSpaceRef：用于告诉Quartz如何解释颜色,色彩空间rgb
    CGColorSpaceRef myColorspace = CGColorSpaceCreateDeviceRGB();
    //绘制渐变色
    myGradient = CGGradientCreateWithColorComponents (myColorspace, components,
                                                      locations, num_locations);
    //绘图区域
    CGPoint myStartPoint0, myEndPoint0,myStartPoint1, myEndPoint1;
    //headHeight == 60

    myStartPoint1.x = rect.origin.x;
    myStartPoint1.y = 2;
    myEndPoint1.x = rect.origin.x;
    myEndPoint1.y = 5; 
    
    
    //填充渐变色,绘制线性渐变
    CGContextDrawLinearGradient(context,myGradient,myStartPoint1,myEndPoint1,0);
    
    
    
    // draw the empty rounded rectangle (shown for the "unfilled" portions of the progress
    rect = CGRectInset(rect, 0.0f, 0.0f) ;
	radius = 0.5f * rect.size.height ;
//	
	[emptyColor setFill] ;

	CGContextBeginPath(context) ;
	CGContextMoveToPoint(context, CGRectGetMinX(rect), CGRectGetMidY(rect)) ;
	CGContextAddArcToPoint(context, CGRectGetMinX(rect), CGRectGetMinY(rect), CGRectGetMidX(rect), CGRectGetMinY(rect), radius) ;
	CGContextAddArcToPoint(context, CGRectGetMaxX(rect), CGRectGetMinY(rect), CGRectGetMaxX(rect), CGRectGetMidY(rect), radius) ;
	CGContextAddArcToPoint(context, CGRectGetMaxX(rect), CGRectGetMaxY(rect), CGRectGetMidX(rect), CGRectGetMaxY(rect), radius) ;
	CGContextAddArcToPoint(context, CGRectGetMinX(rect), CGRectGetMaxY(rect), CGRectGetMinX(rect), CGRectGetMidY(rect), radius) ;
	CGContextClosePath(context) ;
	CGContextFillPath(context) ;
    
	// draw the inside moving filled rounded rectangle
	radius = 0.5f * rect.size.height ;
	
	// make sure the filled rounded rectangle is not smaller than 2 times the radius
	rect.size.width *= progress ;
	if (rect.size.width < 2 * radius)
		rect.size.width = 2 * radius ;
	
	[innerColor setFill] ;
    
	CGContextSetRGBStrokeColor(context,1, 1, 1, 0.5);
	
   // CGContextSetStrokeColorWithColor(context,[[UIColor lightGrayColor] CGColor]);
   // CGContextAddLineToPoint(context, rect.size.width - radius, 2);
    
	CGContextBeginPath(context) ;
	CGContextMoveToPoint(context, CGRectGetMinX(rect), CGRectGetMidY(rect)) ;
	CGContextAddArcToPoint(context, CGRectGetMinX(rect), CGRectGetMinY(rect), CGRectGetMidX(rect), CGRectGetMinY(rect), radius) ;
	CGContextAddArcToPoint(context, CGRectGetMaxX(rect), CGRectGetMinY(rect), CGRectGetMaxX(rect), CGRectGetMidY(rect), radius) ;
	CGContextAddArcToPoint(context, CGRectGetMaxX(rect), CGRectGetMaxY(rect), CGRectGetMidX(rect), CGRectGetMaxY(rect), radius) ;
	CGContextAddArcToPoint(context, CGRectGetMinX(rect), CGRectGetMaxY(rect), CGRectGetMinX(rect), CGRectGetMidY(rect), radius) ;
    
	CGContextClosePath(context) ;
	CGContextFillPath(context) ;
    
    
    
    myStartPoint0.x =CGRectGetMinX(rect);
    myStartPoint0.y =  CGRectGetMidY(rect);
    myEndPoint0.x = CGRectGetMinX(rect);
    myEndPoint0.y =  CGRectGetMidY(rect); 
    
   // [[UIColor whiteColor] setFill];
	
    //填充渐变色,绘制线性渐变
    CGContextDrawLinearGradient(context,myGradient,myStartPoint0,myEndPoint0,0);
    
	// restore the context
	CGContextRestoreGState(context) ;
    
    
    
    //释放渐变对象
    CGGradientRelease(myGradient);

    
}


@end
