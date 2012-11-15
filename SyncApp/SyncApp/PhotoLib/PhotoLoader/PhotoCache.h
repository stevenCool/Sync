//
//  PhotoCache.h
//  Aekitas
//
//  Created by steven on 10-12-30.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PhotoGlobal.h"

@protocol ImageLoadConnectionDelegate;

@interface PhotoCache : NSObject {
@private
	NSMutableDictionary* cacheDictionary;
	NSMutableArray* localCacheArray;
	NSOperationQueue* diskOperationQueue;
	NSTimeInterval defaultTimeoutInterval;
}

@property(nonatomic,retain) NSMutableArray* localCacheArray;
@property(nonatomic,assign) NSTimeInterval defaultTimeoutInterval; // Default is 1 day

+ (PhotoCache*)currentCache;

- (void)saveLocalImage:(UIImage*)image;
- (void)clearLocalCache;
- (void)deleteLocalCacheAtIndex:(NSInteger)index;

- (void)clearCache;
- (void)removeCacheForKey:(NSString*)key;
- (BOOL)hasCacheForKey:(NSString*)key;
- (NSData*)dataForKey:(NSString*)key;

- (void)setData:(NSData*)data forKey:(NSString*)key;
- (void)setData:(NSData*)data forKey:(NSString*)key withTimeoutInterval:(NSTimeInterval)timeoutInterval;

- (UIImage*)imageForKey:(NSString*)key;

@end

