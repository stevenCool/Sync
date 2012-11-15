//
//  ALDataSourceMgr.h
//  pbuAudiLog
//
//  Created by Yan Xue on 12-8-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ALUserData;
@class ALPersonalData;

@interface ALDataSourceMgr : NSObject
{
    ALUserData *m_pCurrentUser;
    ALPersonalData *m_pCurrenUserInfo;

    NSArray *m_arrDayData;
    NSArray *m_arrWeekData;
    NSArray *m_arrMonthData;    
}

+ (ALDataSourceMgr *)GetInstance;

@property (retain,nonatomic) ALUserData *m_pCurrentUser;
@property (retain,nonatomic) ALPersonalData *m_pCurrenUserInfo;
@property (retain,nonatomic) NSArray *m_arrDayData;
@property (retain,nonatomic) NSArray *m_arrWeekData;
@property (retain,nonatomic) NSArray *m_arrMonthData;    

@end