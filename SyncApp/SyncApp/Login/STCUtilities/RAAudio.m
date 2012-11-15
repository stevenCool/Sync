//
//  MyAudio.m
//  Button Fun
//
//  Created by Xue Yan on 09-12-6.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "RAAudio.h"


@implementation RAAudio

// This var will hold our Singleton class instance that will be handed to anyone who asks for it
static RAAudio *myAudioPlayer = nil;

// Class method which provides access to the sharedSoundManager var.
+ (RAAudio *) GetInstance
{
	
	// synchronized is used to lock the object and handle multiple threads accessing this method at
	// the same time
	@synchronized(self) {
		
		// If the sharedSoundManager var is nil then we need to allocate it.
		if(myAudioPlayer == nil) {
			// Allocate and initialize an instance of this class
			myAudioPlayer = [[self alloc] init];			
		}
	}
	
	// Return the sharedSoundManager
	return myAudioPlayer;
}

-(id) init
{
	
	m_dBackgroundVolumn = 0.9;
	m_dSoundeffectVolumn = 0.5;
	m_pPlayViewBackgroundPlayer = nil;
	m_pMenuViewBackgroundPlayer = nil;
	// initilize the audio enviroment;	
	// Registers this class as the delegate of the audio session.
	[[AVAudioSession sharedInstance] setDelegate: self];
	
	// The AmbientSound category allows application audio to mix with Media Player
	// audio. The category also indicates that application audio should stop playing 
	// if the Ring/Siilent switch is set to "silent" or the screen locks.
	NSError *setCategoryError = nil;
	[[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error: &setCategoryError];
	if (setCategoryError)
		NSLog(@"Error setting category! %@", setCategoryError);
	
	// Activates the audio session.
	NSError *activationError1 = nil;
	[[AVAudioSession sharedInstance] setActive: YES error: &activationError1];
	if (activationError1)
		NSLog(@"Error active music! %@", activationError1);

	
	
	//black jump
	m_pSoundPlayer1=[self CreateAudioPlayer:@"main fx"
							withExtension:@"mp3"
							   withVolumn:m_dSoundeffectVolumn];
	//black hiten
	m_pSoundPlayer2=[self CreateAudioPlayer:@"paper"
							withExtension:@"mp3"
							   withVolumn:m_dSoundeffectVolumn];
	//black spit
	m_pSoundPlayer3=[self CreateAudioPlayer:@"pin"
							withExtension:@"mp3"
							   withVolumn:m_dSoundeffectVolumn];
	return self;
}

-(void) dealloc {
	if (m_pMenuViewBackgroundPlayer != nil) {
		[m_pMenuViewBackgroundPlayer release];
	}
	if (m_pPlayViewBackgroundPlayer != nil) {
		[m_pPlayViewBackgroundPlayer release];
	}
	[m_pSoundPlayer1 release];
	[m_pSoundPlayer2 release];
	[m_pSoundPlayer3 release];
	/*[m_pSoundPlayer4 release];
	[m_pSoundPlayer5 release];
	[m_pSoundPlayer6 release];
	[m_pSoundPlayer7 release];
	[m_pSoundPlayer8 release];
	[m_pSoundPlayer9 release];*/
	[super dealloc];
}

-(AVAudioPlayer *)CreateAudioPlayer:(NSString *)argFileName
					withExtension:(NSString *)argExtension
					   withVolumn:(double)argVolumn{
	
	//initilize the m_pSoundEffect the sound effect player
	NSString * soundFilePath = [[NSBundle mainBundle]	pathForResource:[NSString stringWithFormat:@"%@",argFileName]
															   ofType:[NSString stringWithFormat:@"%@",argExtension]];
	//Converts the sound's file path to an NSURL object
	NSURL* pURL = [[NSURL alloc] initFileURLWithPath: soundFilePath];
	//Crate the sound effect player
	AVAudioPlayer* pSoundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL: pURL error: nil];
	pSoundPlayer.delegate = nil;
	[pURL release];
	//[soundFilePath release];
	//"Preparing to play" attaches to the audio hardware and ensures that playback
	//starts quickly when the user taps Play
	[pSoundPlayer prepareToPlay];
	[pSoundPlayer setVolume: argVolumn];
	return pSoundPlayer;
}

-(void) PlayMenuViewBackgroundMusic
{	
	if([m_pMenuViewBackgroundPlayer isPlaying]==YES){
		return;
	}
	if (m_pPlayViewBackgroundPlayer!=nil) 
	{
		[m_pPlayViewBackgroundPlayer stop];
		[m_pPlayViewBackgroundPlayer release];
		m_pPlayViewBackgroundPlayer = nil;
	}
	//initilize the backgournd music player 
	m_pMenuViewBackgroundPlayer = [self CreateAudioPlayer:@"menuviewmusic"
											withExtension:@"mp3"
											   withVolumn:m_dBackgroundVolumn];
	// The background music should play always, set it to loop infinite times.
	m_pMenuViewBackgroundPlayer.numberOfLoops = -1;
	NSUserDefaults * AudioRecord = [NSUserDefaults standardUserDefaults];
	if([AudioRecord boolForKey:@"BackgroundMusic"]==YES)
	{
		[m_pMenuViewBackgroundPlayer play];
	}
}

-(void) PlayPlayViewBackgroundMusic
{	
	[self StopBackgroundMusic];
	//initilize the backgournd music player 
	m_pPlayViewBackgroundPlayer=[self CreateAudioPlayer:@"playviewmusic"
										withExtension:@"mp3"
										   withVolumn:m_dBackgroundVolumn];
	// The background music should play always, set it to loop infinite times.
	m_pPlayViewBackgroundPlayer.numberOfLoops = -1;
	NSUserDefaults * AudioRecord = [NSUserDefaults standardUserDefaults];
	if([AudioRecord boolForKey:@"BackgroundMusic"]==YES)
	{
		[m_pPlayViewBackgroundPlayer play];	
	}
}


-(void) StopBackgroundMusic
{
	if (m_pMenuViewBackgroundPlayer!=nil)
	{
		[m_pMenuViewBackgroundPlayer stop];
		[m_pMenuViewBackgroundPlayer release];
		m_pMenuViewBackgroundPlayer = nil;
	}
	if (m_pPlayViewBackgroundPlayer!=nil) 
	{
		[m_pPlayViewBackgroundPlayer stop];
		[m_pPlayViewBackgroundPlayer release];
		m_pPlayViewBackgroundPlayer = nil;
	}
//	[m_pMenuViewBackgroundPlayer stop];	
//	[m_pPlayViewBackgroundPlayer stop];
//	m_pMenuViewBackgroundPlayer.currentTime = 0;
//	m_pPlayViewBackgroundPlayer.currentTime = 0;
}
//Play black bug jump sound
-(void) PlaySoundEffect1
{
    [m_pSoundPlayer1 stop];
    m_pSoundPlayer1.currentTime = 0; 
    [m_pSoundPlayer1 play];
}

//Play black bug hit sound
-(void) PlaySoundEffect2
{
    [m_pSoundPlayer2 stop];
    m_pSoundPlayer2.currentTime = 0; 
    [m_pSoundPlayer2 play];
	
}
//Play black bug spit sound
-(void) PlaySoundEffect3
{

    [m_pSoundPlayer3 stop];
    m_pSoundPlayer3.currentTime = 0; 
    [m_pSoundPlayer3 play];
}

/*//Play red bug jump sound
-(void) PlaySoundEffect4
{
    [m_pSoundPlayer4 stop];
    m_pSoundPlayer4.currentTime = 0; 
    [m_pSoundPlayer4 play];
	
}
//Play red bug hit sound
-(void) PlaySoundEffect5
{	
    [m_pSoundPlayer5 stop];
    m_pSoundPlayer5.currentTime = 0; 
    [m_pSoundPlayer5 play];
}

//Play blue bug hit sound
-(void) PlaySoundEffect6
{
    [m_pSoundPlayer6 stop];
    m_pSoundPlayer6.currentTime = 0; 
    [m_pSoundPlayer6 play];
}


//Play green bug hit sound
-(void) PlaySoundEffect7
{
    [m_pSoundPlayer7 stop];
    m_pSoundPlayer7.currentTime = 0; 
    [m_pSoundPlayer7 play];	
}

//Play green bug hit sound
-(void) PlaySoundEffect8
{
	
    [self StopSoundEffect8]; 
    [m_pSoundPlayer8 play];
	
}*/

//Stop black bug spit sound when black bug is killed
-(void) StopSoundEffect3
{
	[m_pSoundPlayer3 stop];
	m_pSoundPlayer3.currentTime = 0;
}
/*-(void) StopSoundEffect8
{
	[m_pSoundPlayer8 stop];
	m_pSoundPlayer8.currentTime = 0;
}*/

-(void) StopSoundEffect1
{
    [m_pSoundPlayer1 stop];
    m_pSoundPlayer1.currentTime = 0;
}

@end
