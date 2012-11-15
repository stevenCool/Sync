//
//  ABUserData.h
//  audiTest
//
//  Created by Yan Xue on 12-7-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ALVehicleData : NSObject {
    NSString *m_strAudiId;
    NSString *m_strVehicleId;
    NSString *m_strCarClass;
    NSString *m_strDriveType;
    NSString *m_strEmission;
    NSString *m_strGearbox;
    NSString *m_strModel;
    NSString *m_strSubstract;
    NSString *m_strYear;

}

@property (retain,nonatomic) NSString *m_strVehicleId;
@property (retain,nonatomic) NSString *m_strModel;
@property (retain,nonatomic) NSString *m_strEmission;
@property (retain,nonatomic) NSString *m_strAudiId;
@property (retain,nonatomic) NSString *m_strCarClass;
@property (retain,nonatomic) NSString *m_strDriveType;
@property (retain,nonatomic) NSString *m_strGearbox;
@property (retain,nonatomic) NSString *m_strSubstract;
@property (retain,nonatomic) NSString *m_strYear;



@end
