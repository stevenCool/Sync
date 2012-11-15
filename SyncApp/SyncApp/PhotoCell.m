//
//  PhotoCell.m
//  SyncApp
//
//  Created by steven on 8/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PhotoCell.h"

@implementation PhotoCell

@synthesize atomArray;

-(id)initWithImages:(NSArray*)atoms reuseIdentifier:(NSString*)_identifier {
    
	if(self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:_identifier]) {

		self.atomArray = atoms;
	}
	
	return self;
}

-(void)setImages:(NSArray*)atoms {
	
	for(UIView *view in [self subviews]) 
    {		
		[view removeFromSuperview];
	}
	
	self.atomArray = atoms;
}

-(void)layoutSubviews {
    
	CGRect frame = CGRectMake(4, 2, 75, 75);
	
	for(PhotoAtom *atom in self.atomArray) {
		[atom setFrame:frame];
		[atom addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:atom action:@selector(toggleSelection)]];
		[self addSubview:atom];
		
		frame.origin.x = frame.origin.x + frame.size.width + 4;
	}
}

@end
