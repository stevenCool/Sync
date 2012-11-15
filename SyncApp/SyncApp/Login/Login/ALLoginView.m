//
//  ABLoginView.m
//  audiTest
//
//  Created by Yan Xue on 12-7-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ALLoginView.h"
#import <QuartzCore/QuartzCore.h>
//#import "ALImport.h"
#import "BUCoreUtility.h"
#import "IYCCoreUtility.h"
#import "ALLoginDataParser.h"
#import "ALWaitingView.h"

@implementation ALLoginView
@synthesize m_pDelegate;
@synthesize m_pUserNameField;
@synthesize m_pPasswordField;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
//        self.frame = CGRectMake(0, 0, 320, 480-44);
        
        UIView *pBlackView = [[UIView alloc] initWithFrame:self.bounds];
        pBlackView.backgroundColor = [UIColor blackColor];
        pBlackView.alpha = 0.7;
        [self addSubview:pBlackView];
        [pBlackView release];
        
        UIImageView *pBgView = [BUCoreUtility newImageView:@"loginboard.png"];
        pBgView.frame = CGRectMake(self.bounds.size.width/2-pBgView.frame.size.width/2, self.bounds.size.height/2-pBgView.frame.size.height/2, pBgView.bounds.size.width, pBgView.bounds.size.height);
        pBgView.userInteractionEnabled = YES;
        NSLog(@"pBgView ~~~~~ :%@",NSStringFromCGRect(pBgView.frame));
        [self addSubview:pBgView];
        [pBgView release];
        
        m_pUserNameField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 194, 35)];
        m_pUserNameField.center = CGPointMake(pBgView.frame.size.width/2, 30);
        m_pUserNameField.text = @"testsdk";
        [self SetCommonTextFiled:m_pUserNameField];
        m_pUserNameField.placeholder = @"Account";
        [pBgView addSubview:m_pUserNameField];
        [m_pUserNameField release];
        
        m_pPasswordField = [[UITextField alloc] initWithFrame:CGRectMake(15, 70, 194, 35)];
        m_pPasswordField.center = CGPointMake(pBgView.frame.size.width/2, 70);
        m_pPasswordField.text = @"abc";        
        [self SetCommonTextFiled:m_pPasswordField];
        m_pPasswordField.placeholder = @"Password";
        [pBgView addSubview:m_pPasswordField];
        [m_pPasswordField release];
        
        UIImage *pimage = [UIImage imageNamed:@"loginbutton.png"];
        UIButton *pLoginButton = [[UIButton alloc] initWithFrame:CGRectMake(self.bounds.size.width/2-pimage.size.width/2, 220, pimage.size.width, pimage.size.height)];//?
        pLoginButton.center = CGPointMake(pBgView.frame.size.width/2, 120);
        pLoginButton.backgroundColor = [UIColor clearColor];
        [pLoginButton setTitle:@"登录" forState:UIControlStateNormal];
        [pLoginButton setImage:pimage forState:UIControlStateNormal];
        [pLoginButton addTarget:self action:@selector(TapLoginButton) forControlEvents:UIControlEventTouchDown];
        [pBgView addSubview:pLoginButton];
        [pLoginButton release];

//        UIImage *pimage1 = [UIImage imageNamed:@"cancelbutton.png"];
//        UIButton *pCancelButton = [[UIButton alloc] initWithFrame:CGRectMake(self.bounds.size.width/2-pimage1.size.width/2, 270, pimage1.size.width, pimage1.size.height)];
//        [pCancelButton addTarget:self action:@selector(Cancel) forControlEvents:UIControlEventTouchUpInside];
//        pCancelButton.backgroundColor = [UIColor clearColor];
//        [pCancelButton setImage:pimage1 forState:UIControlStateNormal];
//        [self addSubview:pCancelButton];
//        [pCancelButton release];
//
//        UIImage *pimage2 = [UIImage imageNamed:@"newaccount.png"];
//        UIButton *pNewbutton = [[UIButton alloc] initWithFrame:CGRectMake(self.bounds.size.width/4-pimage2.size.width/2+28, 335, pimage2.size.width, pimage2.size.height)];
//        [pNewbutton setImage:pimage2 forState:UIControlStateNormal];
//        pNewbutton.backgroundColor = [UIColor clearColor];
//        [self addSubview:pNewbutton];
//        [pNewbutton release];
//        
//        UIImage *pimage3 = [UIImage imageNamed:@"forgetpassword.png"];
//        UIButton *pForgetButton = [[UIButton alloc] initWithFrame:CGRectMake(self.bounds.size.width*3/4-pimage3.size.width/2-28, 335, pimage3.size.width, pimage3.size.height)];
//        [pForgetButton setImage:pimage3 forState:UIControlStateNormal];
//        pForgetButton.backgroundColor = [UIColor clearColor];
//        [self addSubview:pForgetButton];
//        [pForgetButton release];
        
        UISwipeGestureRecognizer *pGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(HandleDown)];
        pGesture.direction = UISwipeGestureRecognizerDirectionDown;
        pGesture.delegate = self;
        [self addGestureRecognizer:pGesture];
        [pGesture release];
    }
    return self;
}

- (void)dealloc
{
   
    [super dealloc];
}


-(void)HandleDown
{
    [m_pUserNameField resignFirstResponder];
    [m_pPasswordField resignFirstResponder];
}

-(void) SetCommonTextFiled:(UITextField *)argField {
    argField.delegate = self;
    [argField.layer setBorderColor: [[UIColor grayColor] CGColor]];      
    [argField.layer setBorderWidth: 1.0];
//    [argField.layer setCornerRadius:8.0f];      
    [argField.layer setMasksToBounds:YES];  
    argField.borderStyle = UITextBorderStyleLine;
    argField.font = [UIFont systemFontOfSize:15];
    argField.textColor = [UIColor whiteColor];
    argField.autocorrectionType = UITextAutocorrectionTypeNo;
    argField.keyboardType = UIKeyboardTypeDefault;
    argField.returnKeyType = UIReturnKeyDone;
    argField.clearButtonMode = UITextFieldViewModeWhileEditing;
    argField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;    
}

#pragma mark - button
-(void)TapLoginButton
{
    [self loginWithAPPId:@"74"];
}

- (void)loginWithAPPId:(NSString *)argAppId 
{

    if ([self checkInfoCompete] == NO) 
        return;

    [NSThread detachNewThreadSelector:@selector(InitWaitView) toTarget:self withObject:nil];

    
    if ([[ALLoginDataParser GetInstcnce] ParserLoginData:m_pUserNameField.text Password:m_pPasswordField.text AppId:argAppId])
    {
//        UIAlertView *pAlert = [[UIAlertView alloc] initWithTitle:@"OpenURL" message:@"" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
//        [pAlert show];

        if (self.m_pDelegate!=nil && [self.m_pDelegate respondsToSelector:@selector(LoginSuccess:)])
            [self.m_pDelegate LoginSuccess:m_pUserNameField.text];
    } 
    else 
    {
//        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"" message:@"用户名或密码错误" delegate:nil cancelButtonTitle:@"好" 
//                                              otherButtonTitles:nil] autorelease];
//        [alert show];
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Login error." message:nil delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
    [m_pWaiteView removeFromSuperview];
}

-(void)InitWaitView
{
    m_pWaiteView = [[ALWaitingView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    [[UIApplication sharedApplication].keyWindow addSubview:m_pWaiteView];
}

-(void)Cancel
{
    if (self.m_pDelegate!=nil && [self.m_pDelegate respondsToSelector:@selector(LoginCancel)])
        [self.m_pDelegate LoginCancel];
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 3.2) 
    {
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(AddDismissButton) 
                                                     name:UIKeyboardDidShowNotification 
                                                   object:nil];     
    } 
    else 
    {
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(AddDismissButton) 
                                                     name:UIKeyboardWillShowNotification 
                                                   object:nil];
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

-(BOOL) checkInfoCompete {
    if ([self isEmptyString:m_pUserNameField.text] == YES) {
//        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"" message:@"用户名不能为空" delegate:nil cancelButtonTitle:@"好" 
//                                               otherButtonTitles:nil] autorelease];
//        [alert show];
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Login error." message:nil delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        return NO;
    } else if ([self isEmptyString:m_pPasswordField.text] == YES) {
//        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"" message:@"密码不能为空" delegate:nil cancelButtonTitle:@"好" 
//                                               otherButtonTitles:nil] autorelease];
//        [alert show];
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Login error." message:nil delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        return NO;
    } else {
        return YES;
    }
}

- (BOOL) isEmptyString:(NSString *) string {
    if([string length] == 0) { //string is empty or nil
        return YES;
    } else if([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0) {
        //string is all whitespace
        return YES;
    }
    return NO;
}


#pragma -mark 
- (void)AddDismissButton
{
	[IYCCoreUtility AddDismissButtonToKeypadWithTarget:self withSelector:@selector(DismissKeypad)];
}

- (void)DismissKeypad
{
	[m_pUserNameField resignFirstResponder];
    [m_pPasswordField resignFirstResponder];
}
@end
