//
//  PhotoCell.h
//  SyncApp
//
//  Created by steven on 8/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PhotoAtom.h"

@interface PhotoCell : UITableViewCell
{
	NSArray *atomArray;
}

-(id)initWithImages:(NSArray*)atoms reuseIdentifier:(NSString*)_identifier;
-(void)setImages:(NSArray*)images;

@property (nonatomic,retain) NSArray *atomArray;

@end
