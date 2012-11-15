//
//  PhotoModel.h
//  Aekitas
//
//  Created by steven on 10-12-30.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PhotoViewProtocol.h"

@interface PhotoModel : NSObject <PhotoView> {
@private
	NSURL *_URL;
	UIImage *_image;
	
	BOOL _failed;
}

- (id)initWithImageURL:(NSURL*)aURL image:(UIImage*)aImage;
- (id)initWithImageURL:(NSURL*)aURL;
- (id)initWithImage:(UIImage*)aImage;

@end
