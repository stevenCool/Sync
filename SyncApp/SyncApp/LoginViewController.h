//
//  LoginViewController.h
//  SyncApp
//
//  Created by steven on 8/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "MBProgressHUD.h"

@interface LoginViewController : UIViewController
{
    IBOutlet UITextField* account;
    IBOutlet UITextField* password;
}

@end
