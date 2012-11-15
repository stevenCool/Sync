//
//  LoginViewController.m
//  SyncApp
//
//  Created by steven on 8/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LoginViewController.h"
#import "Constant.h"
#import "AppDelegate.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIBarButtonItem *cancelItem = [self createButtonItemWithTitle:NSLocalizedString(@"Cancel", @"")
                                                         action:@selector(cancelItemPressed:)];
    self.navigationController.navigationBar.topItem.leftBarButtonItem = cancelItem;
    UIBarButtonItem *LoginItem = [self createButtonItemWithTitle:NSLocalizedString(@"Log in", @"")
                                                           action:@selector(loginItemPressed:)];
    self.navigationController.navigationBar.topItem.rightBarButtonItem = LoginItem;
    
}

- (UIBarButtonItem*)createButtonItemWithTitle:(NSString*)title action:(SEL)action
{
	UIBarButtonItem* buttonItem = [[UIBarButtonItem alloc] initWithTitle:title
																   style:UIBarButtonItemStyleBordered
																  target:self
																  action:action];
	return buttonItem;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    account.text = @"testsdk";
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)loginItemPressed:(UIBarButtonItem*)buttonItem
{
    AppDelegate* app = [UIApplication sharedApplication].delegate;
    [account resignFirstResponder];
    [password resignFirstResponder];
    [MBProgressHUD showHUDAddedTo:app.window animated:YES];
    
    __weak ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:LoginURL]];
    [request setPostValue:@"0" forKey:@"appid"];
    [request setPostValue:account.text forKey:@"account"];
    [request setPostValue:password.text forKey:@"pw"];
    
    [request setCompletionBlock:^{
        NSError *error = [request error];
        NSString *response = [request responseString];
        NSData *jsonData = [response dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options: NSJSONReadingMutableContainers error: &error];
        if (!jsonDic) {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Login error." message:nil delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
        } else {
            app.isLogIn = YES;
            app.openid = [jsonDic objectForKey:@"openId"];
            app.openkey = [jsonDic objectForKey:@"openKey"];
            app.account = account.text;
            app.firstOpen = YES;
            [app readFromLocal];
            [self dismissModalViewControllerAnimated:YES];
        }
        [MBProgressHUD hideHUDForView:app.window animated:YES];
    }];
    [request setFailedBlock:^{
        [MBProgressHUD hideHUDForView:app.window animated:YES];
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Login error." message:nil delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }];
    
    [request startAsynchronous];
}

- (void)cancelItemPressed:(UIBarButtonItem*)buttonItem
{
    [self dismissModalViewControllerAnimated:YES];
}


@end
