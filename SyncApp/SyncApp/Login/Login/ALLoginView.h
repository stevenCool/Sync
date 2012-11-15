//
//  ABLoginView.h
//  audiTest
//
//  Created by Yan Xue on 12-7-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ALLoginViewDelegate <NSObject>


@optional


//-(void)LoginSwitchMainContrller;//到登录Control

//-(void)LoginSuccess;
-(void)LoginSuccess:(NSString*)accountName;
-(void)LoginFail;

-(void)LoginCancel;



@end
@class ALWaitingView;

@interface ALLoginView : UIView<UITextFieldDelegate,UIGestureRecognizerDelegate> 
{
    UITextField *m_pUserNameField;
    UITextField *m_pPasswordField;
    id<ALLoginViewDelegate> m_pDelegate;
    ALWaitingView *m_pWaiteView;
}

@property (assign,nonatomic)id<ALLoginViewDelegate> m_pDelegate;
@property (assign,nonatomic) UITextField *m_pUserNameField;
@property (assign,nonatomic) UITextField * m_pPasswordField;

- (void)loginWithAPPId:(NSString *)argAppId;

@end
