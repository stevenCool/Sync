//
//  ABUserData.m
//  audiTest
//
//  Created by Yan Xue on 12-7-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ALVehicleData.h"

@implementation ALVehicleData
@synthesize m_strVehicleId;
@synthesize m_strModel;
@synthesize m_strEmission;
@synthesize m_strAudiId;
@synthesize m_strCarClass;
@synthesize m_strDriveType;
@synthesize m_strGearbox;
@synthesize m_strSubstract;
@synthesize m_strYear;



- (void)dealloc
{
    [m_strVehicleId release];
    [m_strModel release];
    [m_strEmission release];
    [m_strAudiId release];
    [m_strCarClass release];
    [m_strDriveType release];
    [m_strGearbox release];
    [m_strSubstract release];
    [m_strYear release];
    [super dealloc];
}

@end
