//
//  SecondViewController.m
//  SyncApp
//
//  Created by steven on 8/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()

@end

@implementation SecondViewController
@synthesize app;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    app = [UIApplication sharedApplication].delegate;
    self.title = @"Setting";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark UITableViewDataSource Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 3;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (1 == section) {
        return 3;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {    
    UITableViewCell *cell = nil;
    
    if ( 0 == indexPath.section ) {
        cell = [self configureAccountCellAtIndexPath:indexPath withTableView:tableView];
	}
    else if ( 1 == indexPath.section ) {
        cell = [self configureSettingCellAtIndexPath:indexPath withTableView:tableView];
	}
    else if ( 2 == indexPath.section ) {
        cell = [self configureVersionCellAtIndexPath:indexPath withTableView:tableView];
	}
    else{
        return nil;
    }
    
    return cell;
}

- (UITableViewCell*)configureAccountCellAtIndexPath:(NSIndexPath *)indexPath withTableView:(UITableView *)tableView{
    static NSString *CellIdentifier = @"AccountCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"AccountCell" owner:self options:nil]; 
        cell = [array objectAtIndex:0];
    }
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.backgroundColor = [UIColor whiteColor];
    
    UILabel *key = (UILabel *)[cell viewWithTag:1];
    if (app.isLogIn) {
        key.text = app.account;
    }
    else {
        key.text = @"Log in";
    }
    
	return cell;
}

- (UITableViewCell*)configureSettingCellAtIndexPath:(NSIndexPath *)indexPath withTableView:(UITableView *)tableView{
    static NSString *CellIdentifier = @"SettingCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"SettingCell" owner:self options:nil]; 
        cell = [array objectAtIndex:0];
    }
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    
    UILabel *key = (UILabel *)[cell viewWithTag:1];
    UISwitch *toggle = (UISwitch *)[cell viewWithTag:2];
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    
    if ( 0 == indexPath.row) {
        key.text = @"Sync with WIFI only";
        toggle.on = [defaults boolForKey:@"SyncWIFIOnly"];
        [toggle addTarget:self action:@selector(syncWIFIChanged:) forControlEvents:UIControlEventValueChanged];
    }
    else if ( 1 == indexPath.row) {
        key.text = @"Refresh when Log in";
        toggle.on = [defaults boolForKey:@"RefreshWhenLogIn"];
        [toggle addTarget:self action:@selector(syncLogInChanged:) forControlEvents:UIControlEventValueChanged];
    }
    else if ( 2 == indexPath.row) {
        key.text = @"Clear all local files";
        toggle.hidden = YES;
        //toggle.on = [defaults boolForKey:@"SyncEveryTenMinutes"];
        //[toggle addTarget:self action:@selector(syncFrequencyChanged:) forControlEvents:UIControlEventValueChanged];
    }
    
	return cell;
}

- (void)syncWIFIChanged:(id)sender
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:[(UISwitch*)sender isOn] forKey:@"SyncWIFIOnly"];
    [defaults synchronize];
}

- (void)syncLogInChanged:(id)sender
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:[(UISwitch*)sender isOn] forKey:@"RefreshWhenLogIn"];
    [defaults synchronize];
}

- (void)syncFrequencyChanged:(id)sender
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:[(UISwitch*)sender isOn] forKey:@"SyncEveryTenMinutes"];
    [defaults synchronize];
}


- (UITableViewCell*)configureVersionCellAtIndexPath:(NSIndexPath *)indexPath withTableView:(UITableView *)tableView{
    static NSString *CellIdentifier = @"VersionCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"VersionCell" owner:self options:nil]; 
        cell = [array objectAtIndex:0];
    }
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	return 40;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return @"Account";
    }
    if (section == 1)
    {
        return @"General";
    }
    if (section == 2)
    {
        return @"Version";
    }
    
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
	if ( 0 == indexPath.row && 0 == indexPath.section) {
        if (app.isLogIn) {
            UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:nil 
                                                                     delegate:self 
                                                            cancelButtonTitle:@"Cancel"
                                                       destructiveButtonTitle:nil 
                                                            otherButtonTitles:@"Log out",
                                                                            nil];
            actionSheet.tag = 1;
            [actionSheet showFromTabBar:self.tabBarController.tabBar];
        }
        else {
            [app showLogIn:self];
        }
    }
    if ( 2 == indexPath.row && 1 == indexPath.section) {
        if (app.isLogIn) {
            UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:nil 
                                                                     delegate:self 
                                                            cancelButtonTitle:@"Cancel"
                                                       destructiveButtonTitle:nil 
                                                            otherButtonTitles:@"Are you sure to clear?",
                                          nil];
            actionSheet.tag = 2;
            [actionSheet showFromTabBar:self.tabBarController.tabBar];
        }
        else {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"You need to log in first." message:nil delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
        }
    }
    return;
}

#pragma mark -
#pragma mark UIActionSheetDelegate methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 0) {
        if (1 == actionSheet.tag) {
            [app logOut];
            [self viewWillAppear:YES];
        }
		if (2 == actionSheet.tag) {
            [app clearAllLocalFiles];
        }
	}
    else{   
    }
}

@end
