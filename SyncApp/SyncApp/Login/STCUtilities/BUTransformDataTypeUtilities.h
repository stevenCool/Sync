//
//  BUTransformDataTypeUtilities.h
//  WeddingHelper
//
//  Created by jie zhou on 10-9-20.
//  Copyright 2010 1bu2bu. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BUTransformDataTypeUtilities : NSObject {

}

//init singleton method
+ (BUTransformDataTypeUtilities *) GetInstance;
-(NSString *)TransformCharIntoString:(char *)argChar;
-(float)TransformStringIntofloat:(NSString *)argString;
-(NSString *)TransformBoolIntoString:(BOOL)argBool;
-(NSDate *)TransformCharIntoDate:(char *)argChar;

-(NSMutableArray *)ReverseArray:(NSMutableArray *)argArray;
@end
