//
//  ALUserData.h
//  pbuAudiLog
//
//  Created by Yan Xue on 12-8-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define UserKey_AppId (@"appId")
#define UserKey_OpenId (@"openId")
#define UserKey_OpenKey (@"openKey")
#define UserKey_Sig (@"sig")

@interface ALUserData : NSObject
{
    NSString *m_strAppId;
    NSString *m_strOpenId;
    NSString *m_strOpenKey;
    NSString *m_strAvailVehicleId;
}

@property (retain,nonatomic)  NSString *m_strAppId;
@property (retain,nonatomic)  NSString *m_strOpenId;
@property (retain,nonatomic)  NSString *m_strOpenKey;
@property (retain,nonatomic)  NSString *m_strAvailVehicleId;



@end
