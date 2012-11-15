//
//  AppDelegate.m
//  SyncApp
//
//  Created by steven on 8/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize account = _account;
@synthesize pwd = _pwd;
@synthesize appid = _appid;
@synthesize openid = _openid;
@synthesize openkey = _openkey;
@synthesize photos = _photos;
@synthesize isLogIn = _isLogIn;
@synthesize lanuchedFromOther = _lanuchedFromOther;
@synthesize firstOpen = _firstOpen;
@synthesize rdelegate = _rdelegate;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    _photos = [[NSMutableArray alloc] init];
    self.firstOpen = YES;
//    if (launchOptions) {
//        NSURL* url = [launchOptions objectForKey:UIApplicationLaunchOptionsURLKey];
//        NSDictionary *dict = [self parseQueryString:[url query]];
//        self.isLogIn = YES;
//        self.openid = [dict objectForKey:@"openId"];
//        self.openkey = [dict objectForKey:@"openKey"];
//        self.account = [dict objectForKey:@"account"];
//        self.firstOpen = YES;
//        [self readFromLocal]; 
//    }
//    loginCtl = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    
//    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
//    if ([defaults boolForKey:@"SyncEveryTenMinutes"]) {
//        timer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(refresh:) userInfo:nil repeats:YES];
//    }
    
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url 
{
    // 处理传递过来的参数
//    NSString *text = [[url absoluteString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSLog(@"handleOpenURL%@",url);
//    
//    NSArray *pArray = [text componentsSeparatedByString:@"//"];
//    NSArray *arrAttributes = [[pArray lastObject] componentsSeparatedByString:@"&"];
//    if ([arrAttributes count]>=2) 
//    {
//        NSString *strUserName = [[[arrAttributes objectAtIndex:0] componentsSeparatedByString:@"="] lastObject];
//        NSString *strPassword = [[[arrAttributes objectAtIndex:1] componentsSeparatedByString:@"="] lastObject];
//        
//        ALLoginView *pLongin = nil;
//        for (UIView *pView in [UIApplication sharedApplication].keyWindow.subviews) 
//        {
//            if ([pView isKindOfClass:[ALLoginView class]])// && isLogin == NO 
//                pLongin = (ALLoginView *)pView;
//        }

    
//        if (pLongin != nil)
//        {
//            UIAlertView *pAlert = [[UIAlertView alloc] initWithTitle:@"OpenURL" message:@"" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
//            [pAlert show];
//        }
        
//        pLongin.m_pUserNameField.text = strUserName;
//        pLongin.m_pPasswordField.text = strPassword;//@"1";
//        [pLongin loginWithAPPId:@"32"];
//    }
    
//    NSLog(@"url recieved: %@", url);
//    NSLog(@"query string: %@", [url query]);
//    NSLog(@"host: %@", [url host]);
//    NSLog(@"url path: %@", [url path]);
//    NSDictionary *dict = [self parseQueryString:[url query]];
//    NSLog(@"query dict: %@", dict);
//
//    if ([dict count]){
//        if (_isLogIn) {
//            if ([[dict objectForKey:@"openId"] isEqualToString:self.openid]) {
//                return YES;
//            }
//            else {
//                [self logOut];
//            }
//        }
//        self.isLogIn = YES;
//        self.openid = [dict objectForKey:@"openId"];
//        self.openkey = [dict objectForKey:@"openKey"];
//        self.account = [dict objectForKey:@"account"];
//        self.firstOpen = YES;
//        [self readFromLocal]; 
//        [loginCtl dismissModalViewControllerAnimated:YES];
//    }
    
    return YES;
}

- (NSDictionary *)parseQueryString:(NSString *)query {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    for (NSString *pair in pairs) {
        NSArray *elements = [pair componentsSeparatedByString:@"="];
        NSString *key = [[elements objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *val = [[elements objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [dict setObject:val forKey:key];
    }
    return dict;
}

#pragma mark -
- (BOOL)checkExist:(NSString*)name
{
    for (NSDictionary* dic in self.photos) {
        NSString* fname = [dic objectForKey:@"name"];
        if ([fname isEqualToString:name]) {
            return YES;
        }
    }
    return NO;
}

- (void)logOut
{
    _isLogIn = FALSE;
    self.account = @"";
    self.pwd = @"";
    self.openid = @"";
    self.openkey = @"";
    [self.photos removeAllObjects];
}

- (void)showLogIn:(UIViewController*)controller
{
//    UIAlertView *pAlert = [[UIAlertView alloc] initWithTitle:@"show" message:@"" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
//    [pAlert show];
    
    ALLoginView *m_pLoginView = [[ALLoginView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    m_pLoginView.m_pDelegate = self;
    [[UIApplication sharedApplication].keyWindow addSubview:m_pLoginView];//
    [m_pLoginView release];
    
    refreshCtl = controller;
    
//    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:loginCtl];
//    [self.window.rootViewController presentModalViewController:navController animated:YES];
}

-(void)LoginSuccess:(NSString*)accountName
{
    for (UIView *pView in [[UIApplication sharedApplication].keyWindow subviews]) {
        if ([pView isKindOfClass:[ALLoginView class]]) {
            [pView removeFromSuperview];
        }
    }
    self.isLogIn = YES;
    self.openid = [ALDataSourceMgr GetInstance].m_pCurrentUser.m_strOpenId;
    self.openkey = [ALDataSourceMgr GetInstance].m_pCurrentUser.m_strOpenKey;
    self.appid = [ALDataSourceMgr GetInstance].m_pCurrentUser.m_strAppId;
    self.account = accountName;
    self.firstOpen = YES;
    [self readFromLocal];
    [refreshCtl viewWillAppear:YES];
}

-(void)LoginFail
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Login error." message:nil delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
    [refreshCtl viewWillAppear:YES];
}

-(void)LoginCancel{
    for (UIView *pView in [[UIApplication sharedApplication].keyWindow subviews]) {
        if ([pView isKindOfClass:[ALLoginView class]]) {
            [pView removeFromSuperview];
        }
    }
}

- (void)readFromLocal{
    NSString* photoDir =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    photoDir = [NSString stringWithFormat:@"%@/%@",photoDir,[self.account lowercaseString]];
    NSDirectoryEnumerator *directoryEnumerator = [[NSFileManager defaultManager] enumeratorAtPath:photoDir];
    if (directoryEnumerator) {
        for (NSString *path in directoryEnumerator) 
        {
            if ([[[path pathExtension] lowercaseString] isEqualToString:@"jpg"] || [[[path pathExtension] lowercaseString] isEqualToString:@"jpeg"] || [[[path pathExtension] lowercaseString] isEqualToString:@"png"] ) 
            { 
                NSString* wholePath = [NSString stringWithFormat:@"%@/%@",photoDir,path];
                UIImage* localImage = [UIImage imageWithContentsOfFile:wholePath];
                
                NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
                [dic setValue:localImage forKey:@"image"];
                [dic setValue:path forKey:@"name"];
                [dic setValue:[NSNumber numberWithBool:NO] forKey:@"status"];
                [self.photos addObject:dic];   
                NSLog(@"read %@",path);
            }
            else {
//            NSFileManager *fileMgr = [[NSFileManager alloc] init];
//            NSString* wholePath = [NSString stringWithFormat:@"%@/%@",photoDir,path];
//            BOOL removeSuccess = [fileMgr removeItemAtPath:wholePath error:nil];
            }
        }
    }
    else {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager createDirectoryAtPath:photoDir withIntermediateDirectories:NO attributes:nil error:nil];
    }

}

- (void)addFiles:(NSMutableArray*)array{    
    for (PhotoAtom* atom in array) {
        NSString* fileName = atom.imageName;
        UIImage* image = atom.originImage;
        NSString* photoDir =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        photoDir = [NSString stringWithFormat:@"%@/%@",photoDir,[self.account lowercaseString]];
        NSString *FilePath =[NSString stringWithFormat:@"%@/%@",photoDir,fileName];
        NSData *data =[NSData dataWithData:UIImageJPEGRepresentation(image, 1.0f)];
        [data writeToFile:FilePath atomically:YES];
    }
}

- (void)deleteFiles:(NSMutableArray*)array{    
    for (PhotoAtom* atom in array) {
        NSString* fileName = atom.imageName;
        NSString* photoDir =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        photoDir = [NSString stringWithFormat:@"%@/%@",photoDir,[self.account lowercaseString]];
        NSString *FilePath =[NSString stringWithFormat:@"%@/%@",photoDir,fileName];
        
        NSFileManager *fileMgr = [[NSFileManager alloc] init];
        BOOL removeSuccess = [fileMgr removeItemAtPath:FilePath error:nil];
        NSLog(@"Delete %@: %d",FilePath,removeSuccess);
    }
}

- (void)witeFiles{    
    for (NSDictionary* dic in self.photos) {
        NSString* fileName = [dic objectForKey:@"name"];
        UIImage* image = [dic objectForKey:@"image"];
        NSString* photoDir =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        photoDir = [NSString stringWithFormat:@"%@/%@",photoDir,[self.account lowercaseString]];
//        NSDirectoryEnumerator *directoryEnumerator = [[NSFileManager defaultManager] enumeratorAtPath:photoDir];
//        BOOL isExist = NO;
//        for (NSString *path in directoryEnumerator) 
//        {
//            if ([path isEqualToString:fileName]) {
//                isExist = YES;
//                break;
//            }
//        }
//        if (!isExist) {
            NSString *FilePath =[NSString stringWithFormat:@"%@/%@",photoDir,fileName];
            NSData *data =[NSData dataWithData:UIImageJPEGRepresentation(image, 1.0f)];
            [data writeToFile:FilePath atomically:YES];
//        }
    }
}

- (BOOL)isNetworkAvailable{
    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable){
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"No connection" message:nil delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        return NO;
    }
    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == kReachableViaWWAN){
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        if ([defaults boolForKey:@"SyncWIFIOnly"]) {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"It's not WIFI connection now" message:nil delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
            return NO;
        }
    }
    
    return YES;
}

- (void)clearAllLocalFiles{
    NSString* photoDir =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    photoDir = [NSString stringWithFormat:@"%@/%@",photoDir,[self.account lowercaseString]];
    NSDirectoryEnumerator *directoryEnumerator = [[NSFileManager defaultManager] enumeratorAtPath:photoDir];
    if (directoryEnumerator) {
        for (NSString *path in directoryEnumerator) 
        {
            NSFileManager *fileMgr = [[NSFileManager alloc] init];
            NSString* wholePath = [NSString stringWithFormat:@"%@/%@",photoDir,path];
            BOOL removeSuccess = [fileMgr removeItemAtPath:wholePath error:nil];
            NSLog(@"Delete %@: %d",wholePath,removeSuccess);
        }
    }
    [self.photos removeAllObjects];
}

- (void)refresh:(NSTimer*)theTimer{
    NSLog(@"timer");
    if (self.isLogIn && self.rdelegate && [self.rdelegate respondsToSelector:@selector(RefreshDataSource)]) {
        [self.rdelegate RefreshDataSource];
    }
}

#pragma mark -

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
