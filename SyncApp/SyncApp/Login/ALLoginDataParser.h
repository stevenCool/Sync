//
//  ALLoginDataParser.h
//  pbuAudiLog
//
//  Created by Yan Xue on 12-8-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ALLoginDataParser : NSObject

+ (ALLoginDataParser *)GetInstcnce;

- (BOOL)ParserLoginData:(NSString *)strAccount Password:(NSString *)argPassword AppId:(NSString *)argAppID;
- (void)ParserUserInfo;
- (void)ParserUserCarInfo;

@end
