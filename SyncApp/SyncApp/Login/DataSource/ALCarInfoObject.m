//
//  ALCarInfoObject.m
//  pbuAudiLog
//
//  Created by 杰 周 on 12-8-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ALCarInfoObject.h"

@implementation ALCarInfoObject
@synthesize m_strDate;
@synthesize m_strAverageSpeed;
@synthesize m_strHighestSpeed;
@synthesize m_strFuel;
@synthesize m_strTime;
@synthesize m_strDistance;


- (void)dealloc
{
    [m_strDate release];
    [m_strAverageSpeed release];
    [m_strHighestSpeed release];
    [m_strFuel release];
    [m_strTime release];
    [m_strDistance release];
    [super dealloc];
}

@end
