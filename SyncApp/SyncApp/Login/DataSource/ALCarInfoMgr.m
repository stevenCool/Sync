//
//  ALCarInfoMgr.m
//  pbuAudiBox
//
//  Created by Xue Yan on 12-7-9.
//  Copyright (c) 2012年 ShootingChance. All rights reserved.
//

#import "ALCarInfoMgr.h"
#import "ALCarInfoObject.h"

@implementation ALCarInfoMgr

@synthesize m_arrDayArray;
@synthesize m_arrWeekArray;
@synthesize m_arrMonthArray;

static ALCarInfoMgr *myDataMgr = nil;
 
+ (ALCarInfoMgr *) GetInstance
{
	// synchronized is used to lock the object and handle multiple threads accessing this method at
	// the same time
	@synchronized(self) 
    {
		if(myDataMgr == nil) 
        {
			// Allocate and initialize an instance of this class
			myDataMgr = [[self alloc] init];			
		}
	}
	
	// Return the myCaseMgr
	return myDataMgr;
}

- (id)init
{
    ALCarInfoObject *pData1 = [[ALCarInfoObject alloc] init];
    pData1.m_strDate = @"Mon  Aug 1,2012";
    pData1.m_strAverageSpeed = @"20km/h";
    pData1.m_strHighestSpeed = @"120km/h";
    pData1.m_strFuel = @"11.3L/100km";
    pData1.m_strTime = @"03:20:00";
    pData1.m_strDistance = @"100km";
    
    ALCarInfoObject *pData2 = [[ALCarInfoObject alloc] init];
    pData2.m_strDate = @"Sun  Jul 31,2012";
    pData2.m_strAverageSpeed = @"50km/h";
    pData2.m_strHighestSpeed = @"100km/h";
    pData2.m_strFuel = @"9.3L/100km";
    pData2.m_strTime = @"01:20:00";
    pData2.m_strDistance = @"120km";
    
    ALCarInfoObject *pData3 = [[ALCarInfoObject alloc] init];
    pData3.m_strDate = @"Sat  Jul 30,2012";
    pData3.m_strAverageSpeed = @"30km/h";
    pData3.m_strHighestSpeed = @"90km/h";
    pData3.m_strFuel = @"10.3L/100km";
    pData3.m_strTime = @"00:40:00";
    pData3.m_strDistance =@"50km";
    
    ALCarInfoObject *pData4 = [[ALCarInfoObject alloc] init];
    pData4.m_strDate = @"Fri  Jul 29,2012";
    pData4.m_strAverageSpeed = @"28km/h";
    pData4.m_strHighestSpeed = @"110km/h";
    pData4.m_strFuel = @"12.3L/100km";
    pData4.m_strTime = @"01:00:00";
    pData4.m_strDistance = @"60km";

    ALCarInfoObject *pData5 = [[ALCarInfoObject alloc] init];
    pData5.m_strDate = @"Fri  Jul 28,2012";
    pData5.m_strAverageSpeed = @"28km/h";
    pData5.m_strHighestSpeed = @"110km/h";
    pData5.m_strFuel = @"12.3L/100km";
    pData5.m_strTime = @"01:00:00";
    pData5.m_strDistance = @"20km";

    ALCarInfoObject *pData6 = [[ALCarInfoObject alloc] init];
    pData6.m_strDate = @"Fri  Jul 27,2012";
    pData6.m_strAverageSpeed = @"28km/h";
    pData6.m_strHighestSpeed = @"110km/h";
    pData6.m_strFuel = @"12.3L/100km";
    pData6.m_strTime = @"01:00:00";
    pData6.m_strDistance = @"70km";

    ALCarInfoObject *pData7 = [[ALCarInfoObject alloc] init];
    pData7.m_strDate = @"Fri  Jul 26,2012";
    pData7.m_strAverageSpeed = @"28km/h";
    pData7.m_strHighestSpeed = @"110km/h";
    pData7.m_strFuel = @"12.3L/100km";
    pData7.m_strTime = @"01:00:00";
    pData7.m_strDistance = @"50km";

    m_arrDayArray = [[NSMutableArray alloc] initWithObjects:pData7,pData6,pData5,pData4,pData3,pData2,pData1,nil];
    [pData1 release];
    [pData2 release];
    [pData3 release];
    [pData4 release];
    [pData5 release];
    [pData6 release];
    [pData7 release];
    
    ALCarInfoObject *pData10 = [[ALCarInfoObject alloc] init];
    pData10.m_strDate = @"Aug 1-Aug7,2012";
    pData10.m_strAverageSpeed = @"20km/h";
    pData10.m_strHighestSpeed = @"120km/h";
    pData10.m_strFuel = @"11.3L/100km";
    pData10.m_strTime = @"23:20:00";
    pData10.m_strDistance = @"180km";
    
    ALCarInfoObject *pData11 = [[ALCarInfoObject alloc] init];
    pData11.m_strDate = @"Jul 24-Jul 31,2012";
    pData11.m_strAverageSpeed = @"50km/h";
    pData11.m_strHighestSpeed = @"100km/h";
    pData11.m_strFuel = @"9.3L/100km";
    pData11.m_strTime = @"21:20:00";
    pData11.m_strDistance = @"420km";
    
    ALCarInfoObject *pData12 = [[ALCarInfoObject alloc] init];
    pData12.m_strDate = @"Jul 16-Jul 23,2012";
    pData12.m_strAverageSpeed = @"30km/h";
    pData12.m_strHighestSpeed = @"90km/h";
    pData12.m_strFuel = @"10.3L/100km";
    pData12.m_strTime = @"20:40:00";
    pData12.m_strDistance =@"350km";
    
    ALCarInfoObject *pData13 = [[ALCarInfoObject alloc] init];
    pData13.m_strDate = @"Jul 8-Jul 15,2012";
    pData13.m_strAverageSpeed = @"28km/h";
    pData13.m_strHighestSpeed = @"110km/h";
    pData13.m_strFuel = @"12.3L/100km";
    pData13.m_strTime = @"31:00:00";
    pData13.m_strDistance = @"360km";

    ALCarInfoObject *pData14 = [[ALCarInfoObject alloc] init];
    pData14.m_strDate = @"Jun 30-Jul 7,2012";
    pData14.m_strAverageSpeed = @"28km/h";
    pData14.m_strHighestSpeed = @"110km/h";
    pData14.m_strFuel = @"12.3L/100km";
    pData14.m_strTime = @"31:00:00";
    pData14.m_strDistance = @"360km";

    ALCarInfoObject *pData15 = [[ALCarInfoObject alloc] init];
    pData15.m_strDate = @"Ju0 22-Jun 29,2012";
    pData15.m_strAverageSpeed = @"28km/h";
    pData15.m_strHighestSpeed = @"110km/h";
    pData15.m_strFuel = @"12.3L/100km";
    pData15.m_strTime = @"31:00:00";
    pData15.m_strDistance = @"360km";

    ALCarInfoObject *pData16 = [[ALCarInfoObject alloc] init];
    pData16.m_strDate = @"Jun 14-Jun 21,2012";
    pData16.m_strAverageSpeed = @"28km/h";
    pData16.m_strHighestSpeed = @"110km/h";
    pData16.m_strFuel = @"12.3L/100km";
    pData16.m_strTime = @"31:00:00";
    pData16.m_strDistance = @"360km";

    m_arrWeekArray = [[NSMutableArray alloc] initWithObjects:pData16,pData15,pData14,pData13,pData12,pData11,pData10,nil];
    [pData10 release];
    [pData11 release];
    [pData12 release];
    [pData13 release];
    [pData14 release];
    [pData15 release];
    [pData16 release];

    ALCarInfoObject *pData20 = [[ALCarInfoObject alloc] init];
    pData20.m_strDate = @"Aug,2012";
    pData20.m_strAverageSpeed = @"20km/h";
    pData20.m_strHighestSpeed = @"120km/h";
    pData20.m_strFuel = @"11.3L/100km";
    pData20.m_strTime = @"83:20:00";
    pData20.m_strDistance = @"1100km";
    
    ALCarInfoObject *pData21 = [[ALCarInfoObject alloc] init];
    pData21.m_strDate = @"Jul,2012";
    pData21.m_strAverageSpeed = @"50km/h";
    pData21.m_strHighestSpeed = @"100km/h";
    pData21.m_strFuel = @"9.3L/100km";
    pData21.m_strTime = @"101:20:00";
    pData21.m_strDistance = @"2120km";
    
    ALCarInfoObject *pData22 = [[ALCarInfoObject alloc] init];
    pData22.m_strDate = @"Jun,2012";
    pData22.m_strAverageSpeed = @"30km/h";
    pData22.m_strHighestSpeed = @"90km/h";
    pData22.m_strFuel = @"10.3L/100km";
    pData22.m_strTime = @"200:40:00";
    pData22.m_strDistance =@"2350km";
    
    ALCarInfoObject *pData23 = [[ALCarInfoObject alloc] init];
    pData23.m_strDate = @"May,2012";
    pData23.m_strAverageSpeed = @"28km/h";
    pData23.m_strHighestSpeed = @"110km/h";
    pData23.m_strFuel = @"12.3L/100km";
    pData23.m_strTime = @"111:00:00";
    pData23.m_strDistance = @"2600km";

    ALCarInfoObject *pData24 = [[ALCarInfoObject alloc] init];
    pData24.m_strDate = @"Apr,2012";
    pData24.m_strAverageSpeed = @"28km/h";
    pData24.m_strHighestSpeed = @"110km/h";
    pData24.m_strFuel = @"12.3L/100km";
    pData24.m_strTime = @"111:00:00";
    pData24.m_strDistance = @"2600km";

    ALCarInfoObject *pData25 = [[ALCarInfoObject alloc] init];
    pData25.m_strDate = @"Mar,2012";
    pData25.m_strAverageSpeed = @"28km/h";
    pData25.m_strHighestSpeed = @"110km/h";
    pData25.m_strFuel = @"12.3L/100km";
    pData25.m_strTime = @"111:00:00";
    pData25.m_strDistance = @"2600km";

    ALCarInfoObject *pData26 = [[ALCarInfoObject alloc] init];
    pData26.m_strDate = @"Fed,2012";
    pData26.m_strAverageSpeed = @"28km/h";
    pData26.m_strHighestSpeed = @"110km/h";
    pData26.m_strFuel = @"12.3L/100km";
    pData26.m_strTime = @"111:00:00";
    pData26.m_strDistance = @"2600km";

    m_arrMonthArray = [[NSMutableArray alloc] initWithObjects:pData26,pData25,pData24,pData23,pData22,pData21,pData20,nil];
    [pData20 release];
    [pData21 release];
    [pData22 release];
    [pData23 release];
    [pData24 release];
    [pData25 release];
    [pData26 release];
    
    
	return self;
}

-(void)dealloc
{
    [m_arrDayArray release];
    [m_arrWeekArray release];
    [m_arrMonthArray release];
    
	[super dealloc];
}

@end
