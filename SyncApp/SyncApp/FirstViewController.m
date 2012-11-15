//
//  FirstViewController.m
//  SyncApp
//
//  Created by steven on 8/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FirstViewController.h"
#import "ELCImagePickerController.h"
#import "ELCAlbumPickerController.h"
#import "ALLoginView.h"

@interface FirstViewController ()

@end

@implementation FirstViewController
@synthesize app;
@synthesize photoItems=_photoItems;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self.tableView setSeparatorColor:[UIColor clearColor]];
	[self.tableView setAllowsSelection:NO];
    app = [UIApplication sharedApplication].delegate;
    app.rdelegate = self;
    _photoItems = [[NSMutableArray alloc] init];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.topItem.title = app.account;
    if (app.isLogIn) {
        UIBarButtonItem* addItem = [self createButtonItemWithTitle:NSLocalizedString(@"Add", @"")
                                                             action:@selector(addItemPressed:)];
        self.navigationController.navigationBar.topItem.leftBarButtonItem = addItem;
//        UIBarButtonItem* syncItem = [self createButtonItemWithTitle:NSLocalizedString(@"Sync", @"")
//                                                             action:@selector(syncItemPressed:)];
//        self.navigationController.navigationBar.topItem.leftBarButtonItem = syncItem;
        
        
        self.navigationController.navigationBar.topItem.rightBarButtonItem = nil;
        UIBarButtonItem* manageItem = [self createButtonItemWithTitle:NSLocalizedString(@"Manage", @"")
                                                               action:@selector(manageItemPressed:)];
        self.navigationController.navigationBar.topItem.rightBarButtonItem = manageItem;
        
        if (app.firstOpen && [[NSUserDefaults standardUserDefaults] boolForKey:@"RefreshWhenLogIn"]) {
            [self syncPhotoStatus];
        }
        app.firstOpen = NO;
    }
    else {
        UIBarButtonItem* loginItem = [self createButtonItemWithTitle:NSLocalizedString(@"Login", @"")
                                                              action:@selector(loginItemPressed:)];
        self.navigationController.navigationBar.topItem.leftBarButtonItem = loginItem;
        self.navigationController.navigationBar.topItem.rightBarButtonItem = nil;
        if (app.firstOpen && !app.lanuchedFromOther) {
            [app showLogIn:self];
        }
    }
    
    [self.photoItems removeAllObjects];
    for (NSDictionary* dic in app.photos) {
        UIImage* localImage = [dic objectForKey:@"image"];
        PhotoAtom* atom = [[PhotoAtom alloc] initWithImage:localImage withType:ShowMode];
        atom.imageName = [dic objectForKey:@"name"];
        atom.isInServer = [[dic objectForKey:@"status"] boolValue];
        atom.delegate = self;
        [self.photoItems addObject:atom];   
    }
    
    [self.tableView reloadData];
}

- (UIBarButtonItem*)createButtonItemWithTitle:(NSString*)title action:(SEL)action
{
	UIBarButtonItem* buttonItem = [[UIBarButtonItem alloc] initWithTitle:title
																   style:UIBarButtonItemStyleBordered
																  target:self
																  action:action];
	return buttonItem;
}

#pragma mark -

- (void)syncPhotoStatus{
    if (![app isNetworkAvailable]) {
        return;
    }
    __weak ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:SyncURL]];
    [request setPostValue:app.appid forKey:@"appid"];
    [request setPostValue:app.openid forKey:@"openid"];
    [request setPostValue:app.openkey forKey:@"openkey"];
    [request setPostValue:@"IOS" forKey:@"device"];
    
    [request setCompletionBlock:^{
        NSError *error = [request error];
        NSString *response = [request responseString];
        NSData *jsonData = [response dataUsingEncoding:NSUTF8StringEncoding];
        NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:jsonData options: NSJSONReadingMutableContainers error: &error];
        if (!jsonArray) {
            NSLog(@"Error parsing JSON: %@", error);
        } else {
            NSArray* photoArray = [[NSArray alloc] initWithArray:jsonArray];
            NSMutableArray* serverArray = [[NSMutableArray alloc] init];
            int newServerPhotoNum = 0;
            int newLocalPhotoNum = 0;
            for (NSDictionary* dic in photoArray) {
                NSString* name = [dic objectForKey:@"syncName"];                
                NSArray* pathArray = [name componentsSeparatedByString:@"/"];
                NSString* fileName = [pathArray objectAtIndex:[pathArray count]-1];
                
                if ([[pathArray objectAtIndex:1] isEqualToString:@"IOS"]) {
                    [serverArray addObject:fileName];
                }
                else {
                    fileName = [dic objectForKey:@"byName"];
                    [serverArray addObject:fileName];
                }
                NSLog(@"%@, find in server, %@",fileName,name);
                
                for (PhotoAtom* atom in self.photoItems) {
                    if ([atom.imageName isEqualToString:fileName]) {
                        atom.isInServer = YES;
                    }
                }
                
                if (![app checkExist:fileName]) {
                    newServerPhotoNum++;
                }
            }   
            
            [self savePhotos];
            
            NSLog(@"Begin upload...");
            
            NSMutableArray* localArray = [[NSMutableArray alloc] init];
            for (PhotoAtom* atom in self.photoItems) {
                [localArray addObject:atom.imageName];
            }
            [localArray removeObjectsInArray:serverArray];
            newLocalPhotoNum = [localArray count];
            [self showHintWithServerNumber:newServerPhotoNum withLocalNumber:newLocalPhotoNum];

        }
    }];
    [request setFailedBlock:^{
        NSLog(@"Upload error");
    }];
    [request startAsynchronous];
}

- (void)showHintWithServerNumber:(int)serverNum withLocalNumber:(int)localNum{
    if (!hintView) {
        hintView = [[UIView alloc] initWithFrame:CGRectMake(0, -40, 320, 40)];
        hintView.backgroundColor = [UIColor colorWithRed:117/255.0 green:138/255.0 blue:153/255.0 alpha:1.0];
        
        UILabel* serverContent = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
        serverContent.backgroundColor = [UIColor clearColor];
        serverContent.textColor = [UIColor whiteColor];
        serverContent.textAlignment = UITextAlignmentCenter;
        serverContent.tag = 1;
        serverContent.font = [UIFont fontWithName:@"Helvetica" size:12];
        [hintView addSubview:serverContent];
        
        UILabel* localContent = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 320, 20)];
        localContent.backgroundColor = [UIColor clearColor];
        localContent.textColor = [UIColor whiteColor];
        localContent.textAlignment = UITextAlignmentCenter;
        localContent.tag = 2;
        localContent.font = [UIFont fontWithName:@"Helvetica" size:12];
        [hintView addSubview:localContent];
    }
    [self.view addSubview:hintView];
    
    for (UILabel* label in [hintView subviews]) {
        if (1 == label.tag) {
            NSString* serverString = @"No new photos in server";
            if (serverNum == 1) {
                serverString = @"1 new photo in server";
            }
            if (serverNum > 1) {
                serverString = [NSString stringWithFormat:@"%d new photos in server",serverNum];
            }
            label.text = serverString;
        }
        if (2 == label.tag) {
            NSString* localString = @"No new photos in local";
            if (localNum == 1) {
                localString = @"1 new photo in local";
            }
            if (localNum > 1) {
                localString = [NSString stringWithFormat:@"%d new photos in local",localNum];
            }
            label.text = localString;
        }
    }
    
    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(removeHintAnimation)];
    
    hintView.frame = CGRectMake(0, 0, 320, 40);
	
	[UIView commitAnimations];
    
    [self performSelector:@selector(removeHint) withObject:nil afterDelay:3];
}

- (void)removeHint{
    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(removeHintAnimation)];
    
    hintView.frame = CGRectMake(0, -40, 320, 40);
	
	[UIView commitAnimations];
    
    [hintView removeFromSuperview];
}


- (void)addItemPressed:(UIBarButtonItem*)buttonItem
{
    UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:nil 
                                                             delegate:self 
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil 
                                                    otherButtonTitles:@"Take a photo",
                                                                      @"Import new images", 
                                                                      nil];
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
}

#pragma mark -

- (void)loginItemPressed:(UIBarButtonItem*)buttonItem
{
    [app showLogIn:self];
}

- (void)showPhotos{
    NSString* photoDir =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    photoDir = [NSString stringWithFormat:@"%@/%@",photoDir,[app.account lowercaseString]];
    NSDirectoryEnumerator *directoryEnumerator = [[NSFileManager defaultManager] enumeratorAtPath:photoDir];
    for (NSString *path in directoryEnumerator) 
    {
        if ([[[path pathExtension] lowercaseString] isEqualToString:@"jpg"] || [[[path pathExtension] lowercaseString] isEqualToString:@"png"] ) 
        { 
            NSString* wholePath = [NSString stringWithFormat:@"%@/%@",photoDir,path];
            UIImage* localImage = [UIImage imageWithContentsOfFile:wholePath];
            PhotoAtom* atom = [[PhotoAtom alloc] initWithImage:localImage withType:ShowMode];
            atom.imageName = path;
            atom.delegate = self;
            [self.photoItems addObject:atom];        
        }
    }
    
    [self.tableView reloadData];
    //[self savePhotos];
}

- (void)savePhotos{
    [app.photos removeAllObjects];
    for (PhotoAtom* atom in self.photoItems) {
        NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
        [dic setValue:atom.imageName forKey:@"name"];
        [dic setValue:atom.originImage forKey:@"image"];
        [dic setValue:[NSNumber numberWithBool:atom.isInServer] forKey:@"status"];
        [app.photos addObject:dic];
    }
    [app witeFiles];
}

- (void)manageItemPressed:(UIBarButtonItem*)buttonItem
{
    PhotoManageViewController* manageCtl = [[PhotoManageViewController alloc] initWithNibName:@"PhotoManageViewController" bundle:[NSBundle mainBundle]];
    manageCtl.hidesBottomBarWhenPushed = YES;
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] 
                                   initWithTitle: @"Back" 
                                   style: UIBarButtonItemStyleBordered
                                   target: nil action: nil];
    [self.navigationItem setBackBarButtonItem: backButton];
    [self.navigationController pushViewController:manageCtl animated:YES];
}

- (void)syncItemPressed:(UIBarButtonItem*)buttonItem{  
    if (![app isNetworkAvailable]) {
        return;
    }
    
    if (!app.firstOpen) {
        [MBProgressHUD showHUDAddedTo:app.window animated:YES];
    }
    
    __weak ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:SyncURL]];
    [request setPostValue:app.appid forKey:@"appid"];
    [request setPostValue:app.openid forKey:@"openid"];
    [request setPostValue:app.openkey forKey:@"openkey"];
    [request setPostValue:@"IOS" forKey:@"device"];
    
    [request setCompletionBlock:^{
        NSError *error = [request error];
        NSString *response = [request responseString];
        NSData *jsonData = [response dataUsingEncoding:NSUTF8StringEncoding];
        NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:jsonData options: NSJSONReadingMutableContainers error: &error];
        if (!jsonArray) {
            NSLog(@"Error parsing JSON: %@", error);
        } else {
            NSArray* photoArray = [[NSArray alloc] initWithArray:jsonArray];
            NSMutableArray* serverArray = [[NSMutableArray alloc] init];
            for (NSDictionary* dic in photoArray) {
                NSString* name = [dic objectForKey:@"syncName"];
                //NSString* folderName = [[name componentsSeparatedByString:@"/"] objectAtIndex:0];
                //NSString* fileName = [[name componentsSeparatedByString:@"/"] objectAtIndex:1];
                
                //if ([folderName isEqualToString:@"iphoto"]) {
                
                NSArray* pathArray = [name componentsSeparatedByString:@"/"];
                NSString* fileName = [pathArray objectAtIndex:[pathArray count]-1];
                
                if ([[pathArray objectAtIndex:1] isEqualToString:@"IOS"]) {
                    [serverArray addObject:fileName];
                }
                else {
                    fileName = [dic objectForKey:@"byName"];
                    [serverArray addObject:fileName];
                }
                NSLog(@"%@, find in server, %@",fileName,name);
                
                for (PhotoAtom* atom in self.photoItems) {
                    if ([atom.imageName isEqualToString:fileName]) {
                        atom.isInServer = YES;
                    }
                }
                
                if (![app checkExist:fileName]) {
                    NSLog(@"download %@",fileName);
                    NSURL*url =[NSURL URLWithString:[dic objectForKey:@"downloadUrl"]];
                    UIImage *image =[UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
                    
                    PhotoAtom* atom = [[PhotoAtom alloc] initWithImage:image withType:ShowMode];
                    atom.imageName = fileName;
                    atom.delegate = self;
                    atom.isInServer = YES;
                    [self.photoItems addObject:atom];
                }
            }   
            
            NSLog(@"Begin upload...");
            
            NSMutableArray* localArray = [[NSMutableArray alloc] init];
            for (PhotoAtom* atom in self.photoItems) {
                [localArray addObject:atom.imageName];
            }
            [localArray removeObjectsInArray:serverArray];
            NSMutableArray* uploadArray = [[NSMutableArray alloc] initWithArray:localArray];
            
            if ([uploadArray count]) {
                for ( NSString* name in uploadArray ) {
                    PhotoAtom* atom = [self findAtomByName:name];
                    __weak ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:UploadURL]];
                    [request setPostValue:app.appid forKey:@"appid"];
                    [request setPostValue:app.openid forKey:@"openid"];
                    [request setPostValue:app.openkey forKey:@"openkey"];
                    [request setPostValue:@"IOS" forKey:@"device"];
                    
                    //[request setPostValue:[NSString stringWithFormat:@"iphoto/%@",atom.imageName] forKey:@"syncname"];
                    //[request setPostValue:[NSString stringWithFormat:@"%@",atom.imageName] forKey:@"syncname"];
                    [request setPostValue:@"PHOTO" forKey:@"type"];
                    
                    NSData *imageData = UIImageJPEGRepresentation(atom.originImage,1.0);
                    [request setData:imageData withFileName:atom.imageName andContentType:@"image/jpeg;charset=utf-8" forKey:@"file"];
                    
                    [request setCompletionBlock:^{
                        NSError *error = [request error];
                        NSString *response = [request responseString];
                        NSData *jsonData = [response dataUsingEncoding:NSUTF8StringEncoding];
                        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options: NSJSONReadingMutableContainers error: &error];
                        if (!jsonDic) {
                            NSLog(@"Error parsing JSON: %@", error);
                        } else {
                            atom.isInServer = YES;
                        }
                    }];
                    [request setFailedBlock:^{
                        NSLog(@"Upload error");
                    }];
                    [request startAsynchronous];
                }
            }
            
            [self savePhotos];
            [self.tableView reloadData];
            
        }
        [MBProgressHUD hideHUDForView:app.window animated:YES];
    }];
    [request setFailedBlock:^{
        NSLog(@"sync error");
        [MBProgressHUD hideHUDForView:app.window animated:YES];
    }];
    
    [request startAsynchronous];
}

- (PhotoAtom*)findAtomByName:(NSString*)name{
    for (PhotoAtom* atom in self.photoItems) {
        if ([atom.imageName isEqualToString:name]) {
            return atom;
        }
    }
    return nil;
}

- (void)RefreshDataSource{
    if (![app isNetworkAvailable]) {
        return;
    }
    
    __weak ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:SyncURL]];
    [request setPostValue:app.appid forKey:@"appid"];
    [request setPostValue:app.openid forKey:@"openid"];
    [request setPostValue:app.openkey forKey:@"openkey"];
    
    [request setCompletionBlock:^{
        NSError *error = [request error];
        NSString *response = [request responseString];
        NSData *jsonData = [response dataUsingEncoding:NSUTF8StringEncoding];
        NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:jsonData options: NSJSONReadingMutableContainers error: &error];
        if (!jsonArray) {
            NSLog(@"Error parsing JSON: %@", error);
        } else {
            NSArray* photoArray = [[NSArray alloc] initWithArray:jsonArray];
            NSMutableArray* serverArray = [[NSMutableArray alloc] init];
            for (NSDictionary* dic in photoArray) {
                NSString* name = [dic objectForKey:@"syncName"];
                
                NSArray* pathArray = [name componentsSeparatedByString:@"/"];
                NSString* fileName = [pathArray objectAtIndex:[pathArray count]-1];
                
                if ([[pathArray objectAtIndex:1] isEqualToString:@"IOS"]) {
                    [serverArray addObject:fileName];
                }
                else {
                    [serverArray addObject:[dic objectForKey:@"byName"]];
                    fileName = [dic objectForKey:@"byName"];
                }
                NSLog(@"%@, find in server",fileName);
                
                for (PhotoAtom* atom in self.photoItems) {
                    if ([atom.imageName isEqualToString:fileName]) {
                        atom.isInServer = YES;
                    }
                }
                
                if (![app checkExist:fileName]) {
                    NSLog(@"download %@",fileName);
                    NSURL*url =[NSURL URLWithString:[dic objectForKey:@"downloadUrl"]];
                    UIImage *image =[UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
                    
                    PhotoAtom* atom = [[PhotoAtom alloc] initWithImage:image withType:ShowMode];
                    atom.imageName = fileName;
                    atom.delegate = self;
                    [self.photoItems addObject:atom];
                    
                }
            }   
            
            NSLog(@"Begin upload...");
            
            NSMutableArray* localArray = [[NSMutableArray alloc] init];
            for (PhotoAtom* atom in self.photoItems) {
                [localArray addObject:atom.imageName];
            }
            [localArray removeObjectsInArray:serverArray];
            NSMutableArray* uploadArray = [[NSMutableArray alloc] initWithArray:localArray];
            
            if ([uploadArray count]) {
                for ( NSString* name in uploadArray ) {
                    PhotoAtom* atom = [self findAtomByName:name];
                    __weak ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:UploadURL]];
                    [request setPostValue:app.appid forKey:@"appid"];
                    [request setPostValue:app.openid forKey:@"openid"];
                    [request setPostValue:app.openkey forKey:@"openkey"];
                    [request setPostValue:[NSString stringWithFormat:@"%@",atom.imageName] forKey:@"syncname"];
                    [request setPostValue:@"PHOTO" forKey:@"type"];
                    
                    NSData *imageData = UIImageJPEGRepresentation(atom.originImage,1.0);
                    [request setData:imageData withFileName:atom.imageName andContentType:@"image/jpeg;charset=utf-8" forKey:@"file"];
                    
                    [request setCompletionBlock:^{
                        NSError *error = [request error];
                        NSString *response = [request responseString];
                        NSData *jsonData = [response dataUsingEncoding:NSUTF8StringEncoding];
                        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options: NSJSONReadingMutableContainers error: &error];
                        if (!jsonDic) {
                            NSLog(@"Error parsing JSON: %@", error);
                        } else {
                            atom.isInServer = YES;
                        }
                    }];
                    [request setFailedBlock:^{
                        NSLog(@"Upload error");
                    }];
                    [request startAsynchronous];
                }
            }
            
            [self.tableView reloadData];
            
            [self savePhotos];
        }
    }];
    [request setFailedBlock:^{
        NSLog(@"sync error");
    }];
    
    [request startAsynchronous];
    
}

#pragma mark -
#pragma mark UIActionSheetDelegate methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 0) {
		[self takePhoto];
	}
    else if(buttonIndex == 1){
        [self importImages];
    }
    else{        
    }
}

- (void)takePhoto{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
		UIImagePickerController *picker = [[UIImagePickerController alloc] init];
		picker.delegate = self;
		picker.sourceType = UIImagePickerControllerSourceTypeCamera;
		[self presentModalViewController:picker animated:YES];
	}
	else {
		return;
	}
}

- (void)importImages{
    ELCAlbumPickerController *albumController = [[ELCAlbumPickerController alloc] initWithNibName:@"ELCAlbumPickerController" bundle:[NSBundle mainBundle]];    
    ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initWithRootViewController:albumController];
    [albumController setParent:elcPicker];
    [elcPicker setDelegate:self];
    
    [self presentModalViewController:elcPicker animated:YES];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    //[super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark ELCImagePickerControllerDelegate Methods

- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info {
	
	[self dismissModalViewControllerAnimated:YES];
    
    NSMutableArray* addArray = [[NSMutableArray alloc] init];
	for(NSDictionary *dict in info) {
        NSString* filename = [dict objectForKey:@"UIImagePickerControllerOriginalFileName"];
        if (![app checkExist:filename]) {
            UIImage* baseImage = [dict objectForKey:UIImagePickerControllerOriginalImage];
            UIImage *photo = [self imageWithImage:baseImage scaledToSize:CGSizeMake(baseImage.size.width/4, baseImage.size.height/4)];
            PhotoAtom* atom = [[PhotoAtom alloc] initWithImage:photo withType:ShowMode];
            atom.imageName = filename;
            atom.delegate = self;
            [self.photoItems addObject:atom];
            [addArray addObject:atom]; 
        }
	}
    
    for (PhotoAtom* atom in addArray) {
        NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
        [dic setValue:atom.imageName forKey:@"name"];
        [dic setValue:atom.originImage forKey:@"image"];
        [dic setValue:[NSNumber numberWithBool:atom.isInServer] forKey:@"status"];
        [app.photos addObject:dic];
    }
    
    [self.tableView reloadData];
    [app addFiles:addArray];
}

- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker {
    
	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark  -
#pragma mark  UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	[picker dismissModalViewControllerAnimated:YES];
	NSArray *keyArray = [info allKeys];
	UIImage *baseImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    long long tick = [[NSDate date] timeIntervalSince1970] * 1000;
    NSString *filename = [NSString stringWithFormat:@"%lld.JPG", tick];
    
    NSMutableArray* addArray = [[NSMutableArray alloc] init];
    
	if ([keyArray containsObject:UIImagePickerControllerMediaMetadata]) {
		//NSData  *data = UIImageJPEGRepresentation(baseImage,0.1);
		UIImage *photo = [self imageWithImage:baseImage scaledToSize:CGSizeMake(baseImage.size.width/4, baseImage.size.height/4)];
        
        PhotoAtom* atom = [[PhotoAtom alloc] initWithImage:photo withType:ShowMode];
        atom.imageName = filename;
        atom.delegate = self;
        [self.photoItems addObject:atom];
        [addArray addObject:atom]; 
        
        NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
        [dic setValue:atom.imageName forKey:@"name"];
        [dic setValue:atom.originImage forKey:@"image"];
        [dic setValue:[NSNumber numberWithBool:atom.isInServer] forKey:@"status"];
        [app.photos addObject:dic];
        
        [self.tableView reloadData];
        [app addFiles:addArray];
	}
	else {
	}
}

- (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissModalViewControllerAnimated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
    //return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark UITableViewDataSource Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ceil([self.photoItems count] / 4.0);
}

- (NSArray*)atomsForIndexPath:(NSIndexPath*)_indexPath {
    
	int index = (_indexPath.row*4);
	int maxIndex = (_indexPath.row*4+3);
    
	// NSLog(@"Getting assets for %d to %d with array count %d", index, maxIndex, [assets count]);
    
	if(maxIndex < [self.photoItems count]) {
        
		return [NSArray arrayWithObjects:[self.photoItems objectAtIndex:index],
				[self.photoItems objectAtIndex:index+1],
				[self.photoItems objectAtIndex:index+2],
				[self.photoItems objectAtIndex:index+3],
				nil];
	}
    
	else if(maxIndex-1 < [self.photoItems count]) {
        
		return [NSArray arrayWithObjects:[self.photoItems objectAtIndex:index],
				[self.photoItems objectAtIndex:index+1],
				[self.photoItems objectAtIndex:index+2],
				nil];
	}
    
	else if(maxIndex-2 < [self.photoItems count]) {
        
		return [NSArray arrayWithObjects:[self.photoItems objectAtIndex:index],
				[self.photoItems objectAtIndex:index+1],
				nil];
	}
    
	else if(maxIndex-3 < [self.photoItems count]) {
        
		return [NSArray arrayWithObject:[self.photoItems objectAtIndex:index]];
	}
    
	return nil;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    PhotoCell *cell = (PhotoCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) 
    {		        
        cell = [[PhotoCell alloc] initWithImages:[self atomsForIndexPath:indexPath] reuseIdentifier:CellIdentifier];
    }	
	else 
    {		
		[cell setImages:[self atomsForIndexPath:indexPath]];
	}
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	return 79;
}

-(void)photoClicked:(UIImage*)image{
    NSLog(@"showBigPhoto");
    NSMutableArray *picArray = [[NSMutableArray alloc] init];
    for ( PhotoAtom* atom in self.photoItems ) {
        PhotoModel *photo = [[PhotoModel alloc] initWithImage:atom.originImage];
        [picArray addObject:photo];
    }
    PhotoSourceModel *source = [[PhotoSourceModel alloc] initWithPhotos:picArray];
    
    PhotoViewController *photoController = [[PhotoViewController alloc] initWithPhotoSource:source isOffer:NO storeStyle:YES];
    photoController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:photoController animated:YES];
    int index = 0;
    for (; index<[self.photoItems count]; index++) {
        PhotoAtom* atom = [self.photoItems objectAtIndex:index];
        if ([atom.originImage isEqual:image]) {
            NSLog(@"%@",atom.imageName);
            break;
        }
    }
    [photoController moveToPhotoAtIndex:index animated:NO];
}

@end
