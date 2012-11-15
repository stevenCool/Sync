//
//  BUTransformDataTypeUtilities.m
//  WeddingHelper
//
//  Created by jie zhou on 10-9-20.
//  Copyright 2010 1bu2bu. All rights reserved.
//

#import "BUTransformDataTypeUtilities.h"


@implementation BUTransformDataTypeUtilities
static BUTransformDataTypeUtilities *myTransformDataTypeUtilities = nil;

#pragma mark init FUNCTION
+ (BUTransformDataTypeUtilities *) GetInstance
{
	// synchronized is used to lock the object and handle multiple threads accessing this method at
	// the same time
	@synchronized(self) {
		
		if(myTransformDataTypeUtilities == nil) {
			// Allocate and initialize an instance of this class
			myTransformDataTypeUtilities = [[self alloc] init];			
		}
	}
	
	// Return the myResourceTable
	return myTransformDataTypeUtilities;
}

- (id)init{
	return self;
}

#pragma mark Transform Method
//Transform Char into NSString
-(NSString *)TransformCharIntoString:(char *)argChar{
	if (argChar==nil) {
		NSString * string = nil;
		return string;
	}
	NSString * string = [[NSString alloc] initWithUTF8String:argChar];
	return string;
}

-(float)TransformStringIntofloat:(NSString *)argString{
	if (argString!=nil) {
		argString = [argString substringToIndex:[argString length]-1];
		return [argString floatValue];
	}
	return 0.00;
}

-(NSString *)TransformBoolIntoString:(BOOL)argBool{
	if (argBool) {
		return @"YES";
	}
	return @"NO";
	
}

-(NSDate *)TransformCharIntoDate:(char *)argChar{
	NSString * string;
	if (argChar==nil) {
		string = [[NSString alloc] initWithString:@"0000-00-00"];
	}else {
		string = [[NSString alloc] initWithUTF8String:argChar];
	}
	NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:kCFDateFormatterFullStyle];
    NSDate* date = [dateFormatter dateFromString:string];
    [dateFormatter release];
    [string release];
	return date;
}

-(NSMutableArray *)ReverseArray:(NSMutableArray *)argArray{
	int index =[argArray count];
	NSMutableArray * swapArray = [[NSMutableArray alloc] init];
	for(int i = index-1;i>=0;i--){
		[swapArray addObject:[argArray objectAtIndex:i]];
	}
	return swapArray;
}
@end
