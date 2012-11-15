//
//  BUCoreUtility.h
//  RainbowHotel
//
//  Created by apple on 10-9-12.
//  Copyright 2010 1bu2bu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BUCoreUtility : NSObject {

}

+(UIImage *)newImageFromResource:(NSString *)filename;
+(UIImageView*)newImageView:(NSString *)imageFileName;
+ (UIImage *)newImageFromDocuments:(NSString *)filename;

+(void)SaveImageToDocuments:(UIImage*)image
          WithImageFileName:(NSString*)imageFileName;


+ (UIImage *)newImageFromURL:(NSString *)url;

@end
 