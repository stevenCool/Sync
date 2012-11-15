//
//  PhotoCache.m
//  Aekitas
//
//  Created by steven on 10-12-30.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PhotoCache.h"

#define CHECK_FOR_PHOTOCACHE_PLIST() if([key isEqualToString:@"PhotoCache.plist"]) return;

static NSString* _CacheDirectory;

static inline NSString* CacheDirectory() {
	if(!_CacheDirectory) {
		NSString* cachesDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
		_CacheDirectory = [[[cachesDirectory stringByAppendingPathComponent:[[NSProcessInfo processInfo] processName]] stringByAppendingPathComponent:@"PhotoCache"] copy];
	}
	
	return _CacheDirectory;
}

static inline NSString* cachePathForKey(NSString* key) {
	return [CacheDirectory() stringByAppendingPathComponent:key];
}

static PhotoCache* __instance;

@interface PhotoCache (Private)
- (void)removeItemFromCache:(NSString*)key;
- (void)performDiskWriteOperation:(NSInvocation *)invoction;
- (void)saveCacheDictionary;
@end

@implementation PhotoCache
@synthesize localCacheArray;
@synthesize defaultTimeoutInterval;

+ (PhotoCache*)currentCache {
	@synchronized(self) {
		if(!__instance) {
			__instance = [[PhotoCache alloc] init];
			__instance.defaultTimeoutInterval = 86400;
		}
	}
	
	return __instance;
}

- (id)init {
	if((self = [super init])) {
		NSDictionary* dict = [NSDictionary dictionaryWithContentsOfFile:cachePathForKey(@"PhotoCache.plist")];
		
		if([dict isKindOfClass:[NSDictionary class]]) {
			cacheDictionary = [dict mutableCopy];
		} else {
			cacheDictionary = [[NSMutableDictionary alloc] init];
		}
		
		[[NSFileManager defaultManager] createDirectoryAtPath:CacheDirectory() 
								  withIntermediateDirectories:YES 
												   attributes:nil 
														error:NULL];
		
		for(NSString* key in cacheDictionary) {
			NSDate* date = [cacheDictionary objectForKey:key];
			if([[[NSDate date] earlierDate:date] isEqualToDate:date]) {
				[[NSFileManager defaultManager] removeItemAtPath:cachePathForKey(key) error:NULL];
			}
		}
		
		diskOperationQueue = [[NSOperationQueue alloc] init];
		
		localCacheArray = [[NSMutableArray alloc] init];
	}
	
	return self;
}

- (void)clearCache {
	for(NSString* key in [cacheDictionary allKeys]) {
		[self removeItemFromCache:key];
	}
	
	[self saveCacheDictionary];
}

- (void)removeCacheForKey:(NSString*)key {
	CHECK_FOR_PHOTOCACHE_PLIST();
	
	[self removeItemFromCache:key];
	[self saveCacheDictionary];
}

- (void)removeItemFromCache:(NSString*)key {
	NSString* cachePath = cachePathForKey(key);
	
	NSInvocation* deleteInvocation = [NSInvocation invocationWithMethodSignature:[self methodSignatureForSelector:@selector(deleteDataAtPath:)]];
	[deleteInvocation setTarget:self];
	[deleteInvocation setSelector:@selector(deleteDataAtPath:)];
	[deleteInvocation setArgument:&cachePath atIndex:2];
	
	[self performDiskWriteOperation:deleteInvocation];
	[cacheDictionary removeObjectForKey:key];
}

- (BOOL)hasCacheForKey:(NSString*)key {
	NSDate* date = [cacheDictionary objectForKey:key];
	if(!date) return NO;
	if([[[NSDate date] earlierDate:date] isEqualToDate:date]) return NO;
	return [[NSFileManager defaultManager] fileExistsAtPath:cachePathForKey(key)];
}

- (UIImage*)imageForKey:(NSString*)key {
	return [UIImage imageWithData:[self dataForKey:key]];
}

#pragma mark -
#pragma mark Data methods
- (void)saveLocalImage:(UIImage*)image
{
	PhotoModel *photo = [[PhotoModel alloc] initWithImage:image];
	[localCacheArray insertObject:photo atIndex:0];
    [photo release];
}

- (void)clearLocalCache
{
	[localCacheArray removeAllObjects];
}

- (void)deleteLocalCacheAtIndex:(NSInteger)index
{
	[localCacheArray removeObjectAtIndex:index];
}

- (void)setData:(NSData*)data forKey:(NSString*)key {
	[self setData:data forKey:key withTimeoutInterval:self.defaultTimeoutInterval];
}

- (void)setData:(NSData*)data forKey:(NSString*)key withTimeoutInterval:(NSTimeInterval)timeoutInterval {
	CHECK_FOR_PHOTOCACHE_PLIST();
	
	NSString* cachePath = cachePathForKey(key);
	NSInvocation* writeInvocation = [NSInvocation invocationWithMethodSignature:[self methodSignatureForSelector:@selector(writeData:toPath:)]];
	[writeInvocation setTarget:self];
	[writeInvocation setSelector:@selector(writeData:toPath:)];
	[writeInvocation setArgument:&data atIndex:2];
	[writeInvocation setArgument:&cachePath atIndex:3];
	
	[self performDiskWriteOperation:writeInvocation];
	[cacheDictionary setObject:[NSDate dateWithTimeIntervalSinceNow:timeoutInterval] forKey:key];
	
	[self performSelectorOnMainThread:@selector(saveAfterDelay) withObject:nil waitUntilDone:YES]; // Need to make sure the save delay get scheduled in the main runloop, not the current threads
}

- (void)saveAfterDelay { // Prevents multiple-rapid saves from happening, which will slow down your app
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(saveCacheDictionary) object:nil];
	[self performSelector:@selector(saveCacheDictionary) withObject:nil afterDelay:0.3];
}

- (void)writeData:(NSData*)data toPath:(NSString *)path; {
	[data writeToFile:path atomically:YES];
} 

- (void)saveCacheDictionary {
	@synchronized(self) {
		[cacheDictionary writeToFile:cachePathForKey(@"PhotoCache.plist") atomically:YES];
	}
}

- (NSData*)dataForKey:(NSString*)key {
	if([self hasCacheForKey:key]) {
		return [NSData dataWithContentsOfFile:cachePathForKey(key) options:0 error:NULL];
	} else {
		return nil;
	}
}

#pragma mark -
#pragma mark Disk writing operations

- (void)performDiskWriteOperation:(NSInvocation *)invoction {
	NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithInvocation:invoction];
	[diskOperationQueue addOperation:operation];
	[operation release];
}

#pragma mark -

- (void)dealloc {
	[diskOperationQueue release];
	[cacheDictionary release];
	[localCacheArray release];
	[super dealloc];
}

@end

