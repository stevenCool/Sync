//
//  PhotoManageViewController.h
//  SyncApp
//
//  Created by steven on 8/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "MBProgressHUD.h"

@interface PhotoManageViewController : UITableViewController<UIActionSheetDelegate,PhotoAtomDelegate>
{
    AppDelegate* app;
    NSMutableArray *_photoItems;
    NSMutableArray *_selectedItems;
}

@property (nonatomic, strong) AppDelegate* app;
@property (nonatomic, strong) NSMutableArray* photoItems;
@property (nonatomic, strong) NSMutableArray* selectedItems;

@end
