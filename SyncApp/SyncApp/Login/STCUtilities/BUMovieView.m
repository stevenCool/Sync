//
//  RATrailorView.m
//  KiaK5
//
//  Created by apple on 10-9-1.
//  Copyright 2010 shooting chance. All rights reserved.
//

#import "BUMovieView.h"
//#import "RAMovieUtility.h"


@implementation BUMovieView
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame withMovieName:(NSString*)argMovieName andType:(NSString*)argType andScalingMode:(NSString*)argScalingMode andControlStyle:(MPMovieControlStyle)argControlStyle;
{
    if ((self = [super initWithFrame:frame])) 
	{
		//[[RAAudio GetInstance] StopBackgroundMusic];
		self.backgroundColor = [UIColor clearColor];
		m_bTouchToFinish = YES;
		m_bFinishToRelease = YES;
		
		NSBundle *bundle = [NSBundle mainBundle];
		NSString *moviePath = [bundle pathForResource:argMovieName ofType:argType];
		NSURL* pURL = [[NSURL alloc] initFileURLWithPath: moviePath];
		m_pMoviePlayer =[[MPMoviePlayerController alloc] initWithContentURL: pURL];
		[pURL release];
		
        //m_pMoviePlayer.
		m_pMoviePlayer.useApplicationAudioSession = YES;
        
		//m_pMoviePlayer = [[RAMovieUtility GetInstance] GetMoviePlayer:argMovieName withType:argType];
		if(m_pMoviePlayer != nil)
		{
			//Following code is IOS version based
#ifdef __IPHONE_3_2 || __IPHONE_4_0 || __IPHONE_4_1 ||__IPHONE_5_0
			UIView* pView = [m_pMoviePlayer view];
			[pView setFrame: [self bounds]];  // frame must match parent view
			[self addSubview:pView];
			pView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
			self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
			
            
            
			m_pMoviePlayer.fullscreen = YES;
			m_pMoviePlayer.controlStyle = argControlStyle;
			if([argScalingMode isEqualToString:@"None"])
				m_pMoviePlayer.scalingMode = MPMovieScalingModeNone;
			else if([argScalingMode isEqualToString:@"Fill"])
				m_pMoviePlayer.scalingMode = MPMovieScalingModeFill;
            else if([argScalingMode isEqualToString:@"Fit"])
                m_pMoviePlayer.scalingMode = MPMovieScalingModeAspectFit;
            
#else ifdef __IPHONE_3_0 || __IPHONE_3_1 || __IPHONE_2_0 || __IPHONE_2_1 || __IPHONE_2_2
			m_pMoviePlayer.movieControlMode = MPMovieControlModeDefault;
#endif
			
			// Register for the playback finished notification
			[[NSNotificationCenter defaultCenter] addObserver: self
													 selector: @selector(movieFinishedCallback:)
														 name: MPMoviePlayerPlaybackDidFinishNotification
													   object: m_pMoviePlayer];
			
			[m_pMoviePlayer play];
            
			m_bPlaying = YES;
		}
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame withMovieName:(NSString*)argMovieName andType:(NSString*)argType andScalingMode:(NSString*)argScalingMode 
    andControlStyle:(MPMovieControlStyle)argControlStyle
      andStartPoint:(int)argStartPoint
{
    if ((self = [super initWithFrame:frame])) 
	{
		//[[RAAudio GetInstance] StopBackgroundMusic];
		self.backgroundColor = [UIColor clearColor];
		m_bTouchToFinish = YES;
		m_bFinishToRelease = YES;
		
		NSBundle *bundle = [NSBundle mainBundle];
		NSString *moviePath = [bundle pathForResource:argMovieName ofType:argType];
		NSURL* pURL = [[NSURL alloc] initFileURLWithPath: moviePath];
		m_pMoviePlayer =[[MPMoviePlayerController alloc] initWithContentURL: pURL];
		[pURL release];
		
        //m_pMoviePlayer.
		m_pMoviePlayer.useApplicationAudioSession = YES;
        
		//m_pMoviePlayer = [[RAMovieUtility GetInstance] GetMoviePlayer:argMovieName withType:argType];
		if(m_pMoviePlayer != nil)
		{
			//Following code is IOS version based
#ifdef __IPHONE_3_2 || __IPHONE_4_0 || __IPHONE_4_1 ||__IPHONE_5_0
			UIView* pView = [m_pMoviePlayer view];
			[pView setFrame: [self bounds]];  // frame must match parent view
			[self addSubview:pView];
			pView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
			self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
			
            
            
			m_pMoviePlayer.fullscreen = YES;
			m_pMoviePlayer.controlStyle = argControlStyle;
			if([argScalingMode isEqualToString:@"None"])
				m_pMoviePlayer.scalingMode = MPMovieScalingModeNone;
			else if([argScalingMode isEqualToString:@"Fill"])
				m_pMoviePlayer.scalingMode = MPMovieScalingModeFill;
            else if([argScalingMode isEqualToString:@"Fit"])
                m_pMoviePlayer.scalingMode = MPMovieScalingModeAspectFit;
            
#else ifdef __IPHONE_3_0 || __IPHONE_3_1 || __IPHONE_2_0 || __IPHONE_2_1 || __IPHONE_2_2
			m_pMoviePlayer.movieControlMode = MPMovieControlModeDefault;
#endif
			
			// Register for the playback finished notification
			[[NSNotificationCenter defaultCenter] addObserver: self
													 selector: @selector(movieFinishedCallback:)
														 name: MPMoviePlayerPlaybackDidFinishNotification
													   object: m_pMoviePlayer];
			
			m_pMoviePlayer.currentPlaybackTime = argStartPoint;
            [m_pMoviePlayer play];
			m_bPlaying = YES;
		}
    }
    return self;
}


-(void) SetTouchToFinish:(bool)argFlag
{
	m_bTouchToFinish = argFlag;
}



// When the movie is done, release the controller.
-(void) movieFinishedCallback: (NSNotification*) aNotification
{
    if(m_bFinishToRelease == NO)
		return;
	MPMoviePlayerController* theMovie = [aNotification object];
	[[NSNotificationCenter defaultCenter]
	 removeObserver: self
	 name: MPMoviePlayerPlaybackDidFinishNotification
	 object: theMovie];
	
    // Release the movie instance created in playMovieAtURL:
    [theMovie release];
	m_pMoviePlayer = nil;
	m_bPlaying = NO;
    
	if (self.delegate!=nil && [self.delegate respondsToSelector:@selector(MovieDidFinish)])
	{
		[self.delegate MovieDidFinish];
	}
}


-(void) Stop
{
    if(m_bPlaying == NO)
		return;
	
	[[NSNotificationCenter defaultCenter]
	 removeObserver: self
	 name: MPMoviePlayerPlaybackDidFinishNotification
	 object: m_pMoviePlayer];
	
	m_bPlaying = NO;
	
	[m_pMoviePlayer stop];
	
    // Release the movie instance created in playMovieAtURL:
    [m_pMoviePlayer release]; 
	m_pMoviePlayer=nil;
	
	if (self.delegate!=nil && [self.delegate respondsToSelector:@selector(MovieDidFinish)])
	{
		[self.delegate MovieDidFinish];
	}
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event 
{	
	if(m_bTouchToFinish == YES && m_bPlaying==YES)
		[self Stop];
}


-(void)SetMovieRepeat{
	m_pMoviePlayer.repeatMode = MPMovieRepeatModeOne;
}

-(void) SetFinishToRelease:(bool)argFlag
{
	m_bFinishToRelease = argFlag;
}

-(void) SetNewMovie:(NSString*) argMovieName andType:(NSString*)argType
{
	
	NSBundle *bundle = [NSBundle mainBundle];
	NSString *moviePath = [bundle pathForResource:argMovieName ofType:argType];
	NSURL* pURL = [[NSURL alloc] initFileURLWithPath: moviePath];
	//if(![[m_pMoviePlayer contentURL] isEqual:pURL])
		[m_pMoviePlayer setContentURL:pURL];
	[pURL release];
	//[m_pMoviePlayer stop];
	[m_pMoviePlayer play];
	//return pMoviePlayer;
}



-(void) StopButRetain
{
	[m_pMoviePlayer stop];
	//[m_pMoviePlayer t
}

-(void) SetFrame:(CGRect)argRect
{
	self.frame = argRect;
	[m_pMoviePlayer view].frame = self.bounds;
}

-(CGSize) GetMovieSize
{
	return [m_pMoviePlayer naturalSize];
}

-(void)SetFullScreen
{
    [m_pMoviePlayer setFullscreen:YES];
}


- (void)dealloc {    
    if(m_pMoviePlayer != nil && m_bPlaying == YES)
	{
		[self Stop];
	}
	//[m_pMoviePlayer release];
    [super dealloc];
	//[[RAAudio GetInstance] PlayBackgroundMusic];
}


@end
