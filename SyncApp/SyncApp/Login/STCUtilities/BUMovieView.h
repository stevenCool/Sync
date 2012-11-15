//
//  RATrailorView.h
//  KiaK5
//
//  Created by apple on 10-9-1.
//  Copyright 2010 shooting chance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@protocol BUMovieViewDelegate <NSObject>

-(void)MovieDidFinish;

@end

@interface BUMovieView : UIView {
	NSURL* m_MovieUrl;
	id<BUMovieViewDelegate> delegate;
	MPMoviePlayerController* m_pMoviePlayer;
	bool m_bPlaying;
	bool m_bTouchToFinish;
	bool m_bFinishToRelease;
}

@property (assign) id<BUMovieViewDelegate> delegate;
- (id)initWithFrame:(CGRect)frame withMovieName:(NSString*)argMovieName andType:(NSString*)argType andScalingMode:(NSString*)argScalingMode 
    andControlStyle:(MPMovieControlStyle)argControlStyle
    andStartPoint:(int)argStartPoint;

- (id)initWithFrame:(CGRect)frame withMovieName:(NSString*)argMovieName andType:(NSString*)argType andScalingMode:(NSString*)argScalingMode 
    andControlStyle:(MPMovieControlStyle)argControlStyle;

-(void) SetTouchToFinish:(bool) argFlag;
-(void) Stop;
-(void) movieFinishedCallback: (NSNotification*) aNotification;
-(void) SetMovieRepeat;
-(void) SetFinishToRelease:(bool)argFlag;
-(void) SetNewMovie:(NSString*) argMovieName andType:(NSString*)argType;
-(void) StopButRetain;
-(void) SetFrame:(CGRect)argRect;
-(CGSize) GetMovieSize;
-(void)SetFullScreen;

@end
