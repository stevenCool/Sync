//
//  SecondViewController.h
//  SyncApp
//
//  Created by steven on 8/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "LoginViewController.h"

@interface SecondViewController : UITableViewController<UIActionSheetDelegate>
{
    AppDelegate* app;
}

@property (nonatomic, strong) AppDelegate* app;

@end
