//
//  BUCoreUtility.m
//  RainbowHotel
//
//  Created by apple on 10-9-12.
//  Copyright 2010 1bu2bu. All rights reserved.
//

#import "BUCoreUtility.h"
 

@implementation BUCoreUtility

+ (UIImage *)newImageFromResource:(NSString *)filename
{
    NSString *imageFile = [[NSString alloc] initWithFormat:@"%@/%@",
                           [[NSBundle mainBundle] resourcePath], filename];
    UIImage *image = nil;
    image = [[UIImage alloc] initWithContentsOfFile:imageFile];
    [imageFile release];
    return image;
}

+ (UIImage *)newImageFromDocuments:(NSString *)filename
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *imageFile = [[NSString alloc] initWithFormat:@"%@/%@",
                           documentsDirectory, filename];
    UIImage *image = nil;
    image = [[UIImage alloc] initWithContentsOfFile:imageFile];
    [imageFile release];
    return image;
}

+ (UIImage *)newImageFromURL:(NSString *)url
{
    NSData * pImageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:url]];

    UIImage *image = nil;
    image = [[UIImage alloc] initWithData:pImageData];
    [pImageData release];
    return image;
}


+(UIImageView*) newImageView:(NSString*)imageFileName
{
	UIImage* image = [BUCoreUtility newImageFromResource:imageFileName];
	UIImageView* pImageView = [[UIImageView alloc] initWithImage:image];
	[image release];
	return pImageView;
}

+(void)SaveImageToDocuments:(UIImage*)image
          WithImageFileName:(NSString*)imageFileName 
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *imageFile = [[NSString alloc] initWithFormat:@"%@/%@",
                           documentsDirectory,imageFileName];
    //NSLog(@"%@",imageFileName);
    if ([imageFileName hasSuffix:@".jpg"]) {
        // The value 'image' must be a UIImage object  
        // The value '1.0' represents image compression quality as value from 0.0 to 1.0  
        [UIImageJPEGRepresentation(image, 1.0) writeToFile:imageFile atomically:YES];  
    }
    else
    {
        // Write image to PNG  
        [UIImagePNGRepresentation(image) writeToFile:imageFile atomically:YES];
    }
    [imageFile release];
}
@end
