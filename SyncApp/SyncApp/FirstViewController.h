//
//  FirstViewController.h
//  SyncApp
//
//  Created by steven on 8/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "MBProgressHUD.h"
#import "PhotoCell.h"
#import "PhotoAtom.h"
#import "PhotoManageViewController.h"
#import "PhotoGlobal.h"

@interface FirstViewController : UITableViewController<PhotoAtomDelegate,RefreshDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    AppDelegate* app;
    NSMutableArray *_photoItems;
    
    UIView* hintView;
}

@property (nonatomic, strong) AppDelegate* app;
@property (nonatomic, strong) NSMutableArray* photoItems;

@end
