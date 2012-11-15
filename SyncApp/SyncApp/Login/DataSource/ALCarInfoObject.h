//
//  ALCarInfoObject.h
//  pbuAudiLog
//
//  Created by 杰 周 on 12-8-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define CarInfoKey_DriveTime (@"drive_time")
#define CarInfoKey_AverageSpeed (@"average_speed")
#define CarInfoKey_HighestSpeed (@"highest_speed")
#define CarInfoKey_Fuel (@"fuel")
#define CarInfoKey_Time (@"time")
#define CarInfoKey_Distance (@"distance")

@interface ALCarInfoObject : NSObject
{
    NSString * m_strDate;
    NSString * m_strAverageSpeed;
    NSString * m_strHighestSpeed;
    NSString * m_strFuel;
    NSString * m_strTime;
    NSString * m_strDistance;
}

@property (nonatomic,retain) NSString * m_strDate;
@property (nonatomic,retain) NSString * m_strAverageSpeed;
@property (nonatomic,retain) NSString * m_strHighestSpeed;
@property (nonatomic,retain) NSString * m_strFuel;
@property (nonatomic,retain) NSString * m_strTime;
@property (nonatomic,retain) NSString * m_strDistance;



@end
