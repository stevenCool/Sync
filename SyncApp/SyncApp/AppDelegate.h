//
//  AppDelegate.h
//  SyncApp
//
//  Created by steven on 8/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"
#import "Constant.h"
#import "Reachability.h"
#import "PhotoAtom.h"
#import "ALLoginView.h"
#import "ALDataSourceMgr.h"
#import "ALUserData.h"

@protocol RefreshDelegate<NSObject>
- (void)RefreshDataSource;
@end

@interface AppDelegate : UIResponder <UIApplicationDelegate,ALLoginViewDelegate>{
    NSString* _account;
    NSString* _pwd;
    NSString* _appid;
    
    NSString* _openid;
    NSString* _openkey;
    
    NSMutableArray *_photos;
    
    BOOL _isLogIn;
    BOOL _firstOpen;
    BOOL _lanuchedFromOther;
    
    UIViewController* refreshCtl;
    
    LoginViewController* loginCtl;

    NSTimer* timer;
    
    id<RefreshDelegate> _rdelegate;
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) NSString* account;
@property (strong, nonatomic) NSString* pwd;
@property (strong, nonatomic) NSString* appid;

@property (strong, nonatomic) NSString* openid;
@property (strong, nonatomic) NSString* openkey;

@property (assign, nonatomic) BOOL isLogIn;
@property (assign, nonatomic) BOOL firstOpen;
@property (assign, nonatomic) BOOL lanuchedFromOther;

@property (nonatomic, strong) NSMutableArray *photos;

@property (strong,nonatomic) id<RefreshDelegate> rdelegate;

- (BOOL)checkExist:(NSString*)name;

- (void)logOut;
- (void)showLogIn:(UIViewController*)controller;

- (void)readFromLocal;
- (void)clearAllLocalFiles;
- (void)witeFiles;
- (void)addFiles:(NSMutableArray*)array;
- (void)deleteFiles:(NSMutableArray*)array;

- (BOOL)isNetworkAvailable;

- (void)refresh:(NSTimer*)theTimer;

@end
