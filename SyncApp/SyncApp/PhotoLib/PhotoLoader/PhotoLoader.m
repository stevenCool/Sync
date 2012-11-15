//
//  PhotoLoader.m
//  Aekitas
//
//  Created by steven on 10-12-30.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PhotoLoader.h"
#import "PhotoLoadConnection.h"
#import "PhotoCache.h"

inline static NSString* keyForURL(NSURL* url) {
	return [NSString stringWithFormat:@"ImageLoader-%u", [[url description] hash]];
}

#define kImageNotificationLoaded(s) [@"kImageLoaderNotificationLoaded-" stringByAppendingString:keyForURL(s)]
#define kImageNotificationLoadFailed(s) [@"kImageLoaderNotificationLoadFailed-" stringByAppendingString:keyForURL(s)]

static PhotoLoader* __imageLoader;

@interface PhotoLoader(Private)
- (PhotoLoadConnection*)loadingConnectionForURL:(NSURL*)aURL;
- (void)cleanUpConnection:(PhotoLoadConnection*)connection;
@end


@implementation PhotoLoader
@synthesize currentConnections=_currentConnections;

+ (PhotoLoader*)sharedImageLoader {
	@synchronized(self) {
		if(!__imageLoader) {
			__imageLoader = [[[self class] alloc] init];
		}
	}
	
	return __imageLoader;
}

- (id)init {
	if((self = [super init])) {
		connectionsLock = [[NSLock alloc] init];
		currentConnections = [[NSMutableDictionary alloc] init];
	}
	
	return self;
}

#pragma mark -
#pragma mark Load Image

- (UIImage*)imageForURL:(NSURL*)aURL shouldLoadWithObserver:(id<PhotoLoaderObserver>)observer
{
	if(!aURL) return nil;
	
	id anImage = [[PhotoCache currentCache] imageForKey:keyForURL(aURL)];
	
	if(anImage) {
		return anImage;
	} else {
		[self loadImageForURL:(NSURL*)aURL observer:observer];
		return nil;
	}
}

- (void)loadImageForURL:(NSURL*)aURL observer:(id<PhotoLoaderObserver>)observer {
	if(!aURL) return;
	
	if([observer respondsToSelector:@selector(imageLoaderDidLoad:)]) {
		[[NSNotificationCenter defaultCenter] addObserver:observer selector:@selector(imageLoaderDidLoad:) name:kImageNotificationLoaded(aURL) object:self];
	}
	
	if([observer respondsToSelector:@selector(imageLoaderDidFailToLoad:)]) {
		[[NSNotificationCenter defaultCenter] addObserver:observer selector:@selector(imageLoaderDidFailToLoad:) name:kImageNotificationLoadFailed(aURL) object:self];
	}
	
	if([self loadingConnectionForURL:aURL]) {
		return;
	}
	
	PhotoLoadConnection* connection = [[PhotoLoadConnection alloc] initWithImageURL:aURL delegate:self];
	
	[connectionsLock lock];
	[currentConnections setObject:connection forKey:aURL];
	self.currentConnections = [[currentConnections copy] autorelease];
	[connectionsLock unlock];
	[connection performSelector:@selector(start) withObject:nil afterDelay:0.01];
	[connection release];
}

- (PhotoLoadConnection*)loadingConnectionForURL:(NSURL*)aURL {
	PhotoLoadConnection* connection = [[self.currentConnections objectForKey:aURL] retain];
	if(!connection) return nil;
	else return [connection autorelease];
}

- (void)cleanUpConnection:(PhotoLoadConnection*)connection {
	if(!connection.imageURL) return;
	
	connection.delegate = nil;
	
	[connectionsLock lock];
	[currentConnections removeObjectForKey:connection.imageURL];
	self.currentConnections = [[currentConnections copy] autorelease];
	[connectionsLock unlock];	
}

- (void)cancelLoadForURL:(NSURL*)aURL {
	PhotoLoadConnection* connection = [self loadingConnectionForURL:aURL];
	[NSObject cancelPreviousPerformRequestsWithTarget:connection selector:@selector(start) object:nil];
	[connection cancel];
	[self cleanUpConnection:connection];
}

- (BOOL)isLoadingImageURL:(NSURL*)aURL {
	return [self loadingConnectionForURL:aURL] ? YES : NO;
}

- (BOOL)hasLoadedImageURL:(NSURL*)aURL {
	return [[PhotoCache currentCache] hasCacheForKey:keyForURL(aURL)];
}

- (void)removeObserver:(id<PhotoLoaderObserver>)observer {
	[[NSNotificationCenter defaultCenter] removeObserver:observer name:nil object:self];
}

- (void)removeObserver:(id<PhotoLoaderObserver>)observer forURL:(NSURL*)aURL {
	[[NSNotificationCenter defaultCenter] removeObserver:observer name:kImageNotificationLoaded(aURL) object:self];
	[[NSNotificationCenter defaultCenter] removeObserver:observer name:kImageNotificationLoadFailed(aURL) object:self];
}

#pragma mark -
#pragma mark URL Connection delegate methods

- (void)imageLoadConnectionDidFinishLoading:(PhotoLoadConnection *)connection {
	UIImage* anImage = [UIImage imageWithData:connection.responseData];
	
	if(!anImage) {
		NSError* error = [NSError errorWithDomain:[connection.imageURL host] code:406 userInfo:nil];
		NSNotification* notification = [NSNotification notificationWithName:kImageNotificationLoadFailed(connection.imageURL)
																	 object:self
																   userInfo:[NSDictionary dictionaryWithObjectsAndKeys:error,@"error",connection.imageURL,@"imageURL",nil]];
		
		[[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:notification waitUntilDone:YES];
	} else {
		
		[[PhotoCache currentCache] setData:connection.responseData forKey:keyForURL(connection.imageURL) withTimeoutInterval:604800];
		
		[currentConnections removeObjectForKey:connection.imageURL];
		self.currentConnections = [[currentConnections copy] autorelease];
		
		NSNotification* notification = [NSNotification notificationWithName:kImageNotificationLoaded(connection.imageURL)
																	 object:self
																   userInfo:[NSDictionary dictionaryWithObjectsAndKeys:anImage,@"image",connection.imageURL,@"imageURL",nil]];
		
		[[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:notification waitUntilDone:YES];
	}
	
	[self cleanUpConnection:connection];
}

- (void)imageLoadConnection:(PhotoLoadConnection *)connection didFailWithError:(NSError *)error {
	[currentConnections removeObjectForKey:connection.imageURL];
	self.currentConnections = [[currentConnections copy] autorelease];
	
	NSNotification* notification = [NSNotification notificationWithName:kImageNotificationLoadFailed(connection.imageURL)
																 object:self
															   userInfo:[NSDictionary dictionaryWithObjectsAndKeys:error,@"error",connection.imageURL,@"imageURL",nil]];
	
	[[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:notification waitUntilDone:YES];
	
	[self cleanUpConnection:connection];
}

#pragma mark -

- (void)dealloc {
	self.currentConnections = nil;
	[currentConnections release];
	[connectionsLock release];
	[super dealloc];
}

@end
