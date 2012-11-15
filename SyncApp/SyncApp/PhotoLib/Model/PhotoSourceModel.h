//
//  PhotoSourceModel.h
//  Aekitas
//
//  Created by steven on 10-12-30.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PhotoViewProtocol.h"

@interface PhotoSourceModel : NSObject <PhotoViewSource> {
@private
	NSArray* _photos;
	NSInteger _numberOfPhotos;
}

- (id)initWithPhotos:(NSArray*)photos;

@end
