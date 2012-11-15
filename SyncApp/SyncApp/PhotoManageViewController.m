//
//  PhotoManageViewController.m
//  SyncApp
//
//  Created by steven on 8/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PhotoManageViewController.h"
#import "PhotoCell.h"
#import "ELCImagePickerController.h"
#import "ELCAlbumPickerController.h"

@interface PhotoManageViewController ()
- (void)importImages;
- (void)uploadImages;
- (void)deleteLocalImages;
- (void)deleteServerImages;
@end

@implementation PhotoManageViewController
@synthesize app;
@synthesize photoItems=_photoItems;
@synthesize selectedItems=_selectedItems;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView setSeparatorColor:[UIColor clearColor]];
	[self.tableView setAllowsSelection:NO];
    app = [UIApplication sharedApplication].delegate;
    _photoItems = [[NSMutableArray alloc] init];
    _selectedItems = [[NSMutableArray alloc] init];
    for (NSDictionary* dic in app.photos) {
        UIImage* localImage = [dic objectForKey:@"image"];
        PhotoAtom* atom = [[PhotoAtom alloc] initWithImage:localImage withType:EditMode];
        atom.imageName = [dic objectForKey:@"name"];
        atom.isInServer = [[dic objectForKey:@"status"] boolValue];
        [self.photoItems addObject:atom];   
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    
    UIBarButtonItem* actionItem = [self createButtonItemWithTitle:NSLocalizedString(@"Action", @"")
                                                           action:@selector(actionPressed:)];
    self.navigationItem.rightBarButtonItem = actionItem;
    self.title = @"Manage";
}

- (void)actionPressed:(UIBarButtonItem*)buttonItem
{
    UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:nil 
                                                  delegate:self 
                                         cancelButtonTitle:@"Cancel"
                                    destructiveButtonTitle:nil 
                                         otherButtonTitles:@"Sync all with server",
                                                           //@"Import new images",
                                                           @"Delete local images", 
                                                           @"Upload images to server", 
                                                           @"Delete images from server",
                                                           nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];
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
#pragma mark UIActionSheetDelegate methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self collectSelected];
	if (buttonIndex == 0) {
		//[self importImages];
        [self sync];
	}
    else if(buttonIndex == 1){
        if ([_selectedItems count]>0) {
            [self deleteLocalImages];
        }
        else {
            [self showHint];
        }
    }
	else if(buttonIndex == 2) {
        if ([_selectedItems count]>0) {
            [self uploadImages];
        }
        else {
            [self showHint];
        }
	}
    else if(buttonIndex == 3){
        if ([_selectedItems count]>0) {
            [self deleteServerImages];
        }
        else {
            [self showHint];
        }
    }
    else{        
    }
    [self clearSelected];
}

- (void)collectSelected{
    for (PhotoAtom* atom in self.photoItems) {
        if (YES == atom.selected) {
            [_selectedItems addObject:atom];
        }
    }
}

- (void)clearSelected{
    for (PhotoAtom* atom in _selectedItems) {
        [atom setSelected:NO];
    }
    [_selectedItems removeAllObjects];
    [self.tableView reloadData];
}

- (void)sync{  
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
                    
                    PhotoAtom* atom = [[PhotoAtom alloc] initWithImage:image withType:EditMode];
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
                            [self savePhotoStatus];
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
        NSLog(@"sync error: %@ ",[request responseString]);
        [MBProgressHUD hideHUDForView:app.window animated:YES];
    }];
    
    [request startAsynchronous];
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

- (PhotoAtom*)findAtomByName:(NSString*)name{
    for (PhotoAtom* atom in self.photoItems) {
        if ([atom.imageName isEqualToString:name]) {
            return atom;
        }
    }
    return nil;
}

- (void)showHint{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"You should select photos." message:nil delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}

- (void)importImages{
    ELCAlbumPickerController *albumController = [[ELCAlbumPickerController alloc] initWithNibName:@"ELCAlbumPickerController" bundle:[NSBundle mainBundle]];    
    ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initWithRootViewController:albumController];
    [albumController setParent:elcPicker];
    [elcPicker setDelegate:self];

    [self presentModalViewController:elcPicker animated:YES];
}

- (void)deleteLocalImages{
    [self.photoItems removeObjectsInArray:_selectedItems];
    [self.tableView reloadData];
    
    NSMutableArray* delArray = [[NSMutableArray alloc] init];
    for (PhotoAtom* atom in _selectedItems) {
        for (NSMutableDictionary* dic in app.photos) {
            if ([[dic objectForKey:@"name"] isEqualToString:atom.imageName]) {
                [delArray addObject:dic];
            }
        }
    }
    [app.photos removeObjectsInArray:delArray];
    
    [app deleteFiles:_selectedItems];
}

- (void)uploadImages{   
    if (![app isNetworkAvailable]) {
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:app.window animated:YES];
    for (PhotoAtom* atom in _selectedItems) {
        __weak ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:UploadURL]];
        [request setPostValue:app.appid forKey:@"appid"];
        [request setPostValue:app.openid forKey:@"openid"];
        [request setPostValue:app.openkey forKey:@"openkey"];
        [request setPostValue:@"IOS" forKey:@"device"];
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
                [self savePhotoStatus];
            }
            [MBProgressHUD hideHUDForView:app.window animated:YES];
        }];
        [request setFailedBlock:^{
            NSLog(@"Upload error");
            [MBProgressHUD hideHUDForView:app.window animated:YES];
        }];
        
        [request startAsynchronous];
    }
}

- (void)deleteServerImages{
    if (![app isNetworkAvailable]) {
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:app.window animated:YES];
    __weak ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:DeleteURL]];
    
    [request setPostValue:app.appid forKey:@"appid"];
    [request setPostValue:app.openid forKey:@"openid"];
    [request setPostValue:app.openkey forKey:@"openkey"];
    [request setPostValue:@"IOS" forKey:@"device"];
    
    NSString* delNames;
    for (int i = 0; i< [_selectedItems count]; i++) {
        PhotoAtom* atom = [_selectedItems objectAtIndex:i];
        if (i) {
            delNames = [NSString stringWithFormat:@"%@,%@",delNames,atom.imageName];
        }
        else {
            delNames = [NSString stringWithFormat:@"%@",atom.imageName];
        }
    }
    [request setPostValue:delNames forKey:@"filename"];
    
    [request setCompletionBlock:^{
        NSError *error = [request error];
        NSString *response = [request responseString];
        NSData *jsonData = [response dataUsingEncoding:NSUTF8StringEncoding];
        NSArray *fileArray = [NSJSONSerialization JSONObjectWithData:jsonData options: NSJSONReadingMutableContainers error: &error];
        if (!fileArray) {
            NSLog(@"Delete Error: %@", error);
        } else {
//            NSMutableArray* fileArray = [[NSMutableArray alloc] init];
//            for (NSDictionary* dic in jsonArray) {
//                [fileArray addObject:[dic objectForKey:@"syncName"]];
//            }
            
            NSMutableArray* deletedItems = [[NSMutableArray alloc] init];
            NSMutableArray* delArray = [[NSMutableArray alloc] init];
            
            for (NSString* name in fileArray) {
                for (PhotoAtom* atom in self.photoItems) {
                    if ([atom.imageName isEqualToString:name]) {
                        [deletedItems addObject:atom];
                    }
                }
                for (NSMutableDictionary* dic in app.photos) {
                    if ([[dic objectForKey:@"name"] isEqualToString:name]) {
                        [delArray addObject:dic];
                    }
                }
            }
            [self.photoItems removeObjectsInArray:deletedItems];
            [app.photos removeObjectsInArray:delArray];
            [self.tableView reloadData];
            [app deleteFiles:deletedItems];
        }
        [MBProgressHUD hideHUDForView:app.window animated:YES];
    }];
    [request setFailedBlock:^{
        NSLog(@"Delete error");
        [MBProgressHUD hideHUDForView:app.window animated:YES];
    }];
    
    [request startAsynchronous];
}

#pragma mark ELCImagePickerControllerDelegate Methods

- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info {
	
	[self dismissModalViewControllerAnimated:YES];

    NSMutableArray* addArray = [[NSMutableArray alloc] init];
	for(NSDictionary *dict in info) {
        NSString* filename = [dict objectForKey:@"UIImagePickerControllerOriginalFileName"];
        if (![app checkExist:filename]) {
            PhotoAtom* atom = [[PhotoAtom alloc] initWithImage:[dict objectForKey:UIImagePickerControllerOriginalImage] withType:EditMode];
            atom.imageName = filename;
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

- (void)savePhotoStatus{
    [app.photos removeAllObjects];
    for (PhotoAtom* atom in self.photoItems) {
        NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
        [dic setValue:atom.imageName forKey:@"name"];
        [dic setValue:atom.originImage forKey:@"image"];
        [dic setValue:[NSNumber numberWithBool:atom.isInServer] forKey:@"status"];
        [app.photos addObject:dic];
    }
}

- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker {
    
	[self dismissModalViewControllerAnimated:YES];
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
    
    static NSString *CellIdentifier = @"ManageCell";
    
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

@end
