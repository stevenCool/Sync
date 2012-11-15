//
//  MyAudio.h
//  Button Fun
//
//  Created by Xue Yan on 09-12-6.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>



/// Class MyAudio is a singleton class provide
/// audio playing functions. It provides an static 
/// GetInstance, which always return the signleton instance.
/// It also provides functions like PlayBackgroundMusic 
/// or PlaySoundEffect, so that users can use it to play 
/// sound directly.

@interface RAAudio : NSObject {
	AVAudioPlayer* m_pSoundPlayer1;		//black jump
	AVAudioPlayer* m_pSoundPlayer2;		//black hiten
	AVAudioPlayer* m_pSoundPlayer3;		//black spit
	AVAudioPlayer* m_pMenuViewBackgroundPlayer;
	AVAudioPlayer* m_pPlayViewBackgroundPlayer;
	double m_dBackgroundVolumn;
	double m_dSoundeffectVolumn;
}

+ (RAAudio *) GetInstance;
-(id)init;
-(void) PlayMenuViewBackgroundMusic;// play the background music of menu view
-(void) PlayPlayViewBackgroundMusic;// play the background music of playview
-(void) StopBackgroundMusic;		// Stop the background music
-(void) PlaySoundEffect1;			//Play black bug jump sound
-(void) PlaySoundEffect2;			//Play black bug hit sound
-(void) PlaySoundEffect3;			//Play black bug spit sound
/*-(void) PlaySoundEffect4;			//Play red bug jump sound
-(void) PlaySoundEffect5;			//Play red bug hit sound
-(void) PlaySoundEffect6;			//Play blue bug hit sound
-(void) PlaySoundEffect7;			//Play green bug hit sound
-(void) PlaySoundEffect8;			//Play green bug hit sound
-(void) PlaySoundEffect9;			//Play green bug hit sound*/
-(void) StopSoundEffect3;			//Stop black bug spit sound when black bug is killed
//-(void) StopSoundEffect8;
-(void) StopSoundEffect1;

//init the audio player
//@param argFileName,the sound file's name;
//@param argExtension,the sound file's extension
//@param argVolumn,the volumn.

-(AVAudioPlayer*)CreateAudioPlayer:(NSString *)argFileName
				   withExtension:(NSString *)argExtension
					  withVolumn:(double)argVolumn;
@end

/// the information is useless