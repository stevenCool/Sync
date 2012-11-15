//
//  IYCCoreUtility.m
//  icbcyidaicard
//
//  Created by 杨阳 on 11-6-12.
//  Copyright 2011 ShootingChance. All rights reserved.
//

#import "IYCCoreUtility.h"
#import "BUCoreUtility.h"

@implementation IYCCoreUtility


+ (void)AddDismissButtonToKeypadWithTarget:(id)argTarget withSelector:(SEL)action
{
	// create custom button
	UIButton *pButton = [UIButton buttonWithType:UIButtonTypeCustom];
	UIImage* pImage = [BUCoreUtility newImageFromResource:@"dismisskeypad.png"];
	[pButton setBackgroundImage:pImage forState:UIControlStateNormal];
	//[pButton setTitle:@"隐藏键盘" forState:UIControlStateNormal];
	pButton.frame = CGRectMake(320-pImage.size.width, -pImage.size.height, pImage.size.width, pImage.size.height);
	pButton.alpha = 1.0;
	[pButton setBackgroundColor:[UIColor clearColor]];
	[pButton addTarget:argTarget
				action:action
	  forControlEvents:UIControlEventTouchUpInside];
	[pImage release];
	
	// locate keyboard view
	UIWindow* tempWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:1];
	UIView* keyboard;
	for(int i=0; i<[tempWindow.subviews count]; i++) {
		keyboard = [tempWindow.subviews objectAtIndex:i];
		// keyboard found, add the button
		if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 3.2) {
			if([[keyboard description] hasPrefix:@"<UIPeripheralHost"] == YES)
				[keyboard addSubview:pButton];
		} else {
			if([[keyboard description] hasPrefix:@"<UIKeyboard"] == YES)
				[keyboard addSubview:pButton];
		}
	}
}

+ (void)NewAddDismissButtonToKeypadWithTarget:(id)argTarget withSelector:(SEL)action
{
	// create custom button
	UIButton *pButton = [UIButton buttonWithType:UIButtonTypeCustom];
	UIImage* pImage = [BUCoreUtility newImageFromResource:@"dismisskeypad.png"];
	[pButton setBackgroundImage:pImage forState:UIControlStateNormal];
	//[pButton setTitle:@"隐藏键盘" forState:UIControlStateNormal];
	pButton.frame = CGRectMake(320-pImage.size.width, -pImage.size.height+20, pImage.size.width, pImage.size.height);
	pButton.alpha = 1.0;
	[pButton setBackgroundColor:[UIColor clearColor]];
	[pButton addTarget:argTarget
				action:action
	  forControlEvents:UIControlEventTouchUpInside];
	[pImage release];
	
	// locate keyboard view
	UIWindow* tempWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:1];
	UIView* keyboard;
	for(int i=0; i<[tempWindow.subviews count]; i++) {
		keyboard = [tempWindow.subviews objectAtIndex:i];
		// keyboard found, add the button
		if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 3.2) {
			if([[keyboard description] hasPrefix:@"<UIPeripheralHost"] == YES)
				[keyboard addSubview:pButton];
		} else {
			if([[keyboard description] hasPrefix:@"<UIKeyboard"] == YES)
				[keyboard addSubview:pButton];
		}
	}
}

@end
