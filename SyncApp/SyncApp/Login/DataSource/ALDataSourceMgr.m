//
//  ALDataSourceMgr.m
//  pbuAudiLog
//
//  Created by Yan Xue on 12-8-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ALDataSourceMgr.h"

@implementation ALDataSourceMgr
@synthesize m_pCurrentUser;
@synthesize m_pCurrenUserInfo;
@synthesize m_arrDayData;
@synthesize m_arrWeekData;
@synthesize m_arrMonthData;

static ALDataSourceMgr *m_sDataSourceMgr;

+ (ALDataSourceMgr *)GetInstance 
{
    if (nil == m_sDataSourceMgr) 
        m_sDataSourceMgr = [[ALDataSourceMgr alloc] init];
    return m_sDataSourceMgr;
}

- (void)dealloc
{
    [m_pCurrentUser release];
    [m_arrDayData release];
    [m_arrWeekData release];
    [m_arrMonthData release];
    [super dealloc];
}

@end