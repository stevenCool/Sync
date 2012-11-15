//
//  ALCarInfoMgr.h
//  pbuAudiBox
//
//  Created by Xue Yan on 12-7-9.
//  Copyright (c) 2012年 ShootingChance. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ABAppData;

@interface ALCarInfoMgr : NSObject
{
    NSMutableArray *m_arrDayArray;
    NSMutableArray *m_arrWeekArray;
    NSMutableArray *m_arrMonthArray;
   // NSMutableArray *arrDataArray;
}


@property (nonatomic,retain) NSMutableArray *m_arrDayArray;
@property (nonatomic,retain) NSMutableArray *m_arrWeekArray;
@property (nonatomic,retain) NSMutableArray *m_arrMonthArray;


+(ALCarInfoMgr *) GetInstance;



@end
