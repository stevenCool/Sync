//
//  ALLoginDataParser.m
//  pbuAudiLog
//
//  Created by Yan Xue on 12-8-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ALLoginDataParser.h"
#import "ASIHTTPRequest.h"
//#import "ALCommon.h"
#import "SBJsonParser.h"
#import "ALUserData.h"
#import "ALDataSourceMgr.h"
#import "ALUserData.h"
//#import "ALPersonalData.h"
#import "ALVehicleData.h"

@implementation ALLoginDataParser

static ALLoginDataParser *m_sLoginDataParser;

+ (ALLoginDataParser *)GetInstcnce 
{
    if (nil == m_sLoginDataParser) 
        m_sLoginDataParser = [[ALLoginDataParser alloc] init];
    return m_sLoginDataParser;
}
#define AudiServerAddress (@"122.112.10.68:8080")

-(BOOL)ParserLoginData:(NSString *)strAccount Password:(NSString *)argPassword AppId:(NSString *)argAppID
{

    NSString *apiUrlStr = [NSString stringWithFormat:@"http://%@/sns/oauth/login?account=%@&pw=%@&appid=%@",
                           AudiServerAddress,strAccount,argPassword,argAppID];
    
    NSURL *apiUrl = [NSURL URLWithString:[apiUrlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    ASIHTTPRequest *pRequest = [ASIHTTPRequest requestWithURL:apiUrl];
    [pRequest startSynchronous];
    NSString *apiRepsponse = [pRequest responseString];
    NSLog(@"%@",apiRepsponse);
    
    SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
    NSError *error = nil;
    NSDictionary *pDic = [jsonParser objectWithString:apiRepsponse error:&error];

    if (pDic) 
    {
        ALUserData *pUser = [[ALUserData alloc] init];        
        pUser.m_strAppId = [pDic objectForKey:UserKey_AppId];
        pUser.m_strOpenId = [pDic objectForKey:UserKey_OpenId];
        pUser.m_strOpenKey = [pDic objectForKey:UserKey_OpenKey];
        pUser.m_strAvailVehicleId = [pDic objectForKey:UserKey_Sig];

        [ALDataSourceMgr GetInstance].m_pCurrentUser = pUser;
        [pUser release];
        [jsonParser release];
        
        return YES;
    } else {
        [jsonParser release];
        return NO;
    }
}

-(void)ParserUserInfo
{
//    NSString *strAppId = [ALDataSourceMgr GetInstance].m_pCurrentUser.m_strAppId;
//    NSString *strOpenId = [ALDataSourceMgr GetInstance].m_pCurrentUser.m_strOpenId;
//    NSString *strOpenKey = [ALDataSourceMgr GetInstance].m_pCurrentUser.m_strOpenKey;
//    
//    //    http://[Address:PORT]/core/search_car_parameters?from=2012-08-01&to=2012-08-11&openid=xx&openkey=xx&appid=xx&vehicleid=xx
//    NSString *apiUrlStr = [NSString stringWithFormat:@"http://%@/sns/user/info?openid=%@&openkey=%@&appid=%@",//&vehicleid=xx
//                           AudiServerAddress,strOpenId,strOpenKey,strAppId];
//    
//    NSURL *apiUrl = [NSURL URLWithString:[apiUrlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//    ASIHTTPRequest *pRequest = [ASIHTTPRequest requestWithURL:apiUrl];
//    [pRequest startSynchronous];
//    NSString *apiRepsponse = [pRequest responseString];
//    NSLog(@"%@",apiRepsponse);
//    
//    SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
//    NSError *error = nil;
//    NSDictionary *pDic = [jsonParser objectWithString:apiRepsponse error:&error];
//    ALPersonalData *pUserInfo = [[ALPersonalData alloc] init];
//    if (pDic) {
//        pUserInfo.m_strAudiClubId = [NSString stringWithFormat:@"%d",[[pDic objectForKey:UserInfoKey_Id] intValue]];
//        pUserInfo.m_strUserName = [pDic objectForKey:UserInfoKey_Name];
//        pUserInfo.m_strGender = [pDic objectForKey:UserInfoKey_Sex];
//        pUserInfo.m_strTelephone = [pDic objectForKey:UserInfoKey_Phone];
//        pUserInfo.m_strAddress = [pDic objectForKey:UserInfoKey_City];
//        pUserInfo.m_strWebSite = [pDic objectForKey:UserInfoKey_Email];
//        pUserInfo.m_strNickName = [pDic objectForKey:UserInfoKey_NickName];
//        pUserInfo.m_strDriveAge = [[pDic objectForKey:UserInfoKey_Driving] stringValue];
//        pUserInfo.m_strCarImage = [pDic objectForKey:UserInfoKey_AvatarUrl];
//    }
//    [ALDataSourceMgr GetInstance].m_pCurrenUserInfo = pUserInfo;
//    [pUserInfo release];
//    [jsonParser release];
}

-(void)ParserUserCarInfo
{
//    NSString *strAppId = [ALDataSourceMgr GetInstance].m_pCurrentUser.m_strAppId;
//    NSString *strOpenId = [ALDataSourceMgr GetInstance].m_pCurrentUser.m_strOpenId;
//    NSString *strOpenKey = [ALDataSourceMgr GetInstance].m_pCurrentUser.m_strOpenKey;
//    
//    NSString *apiUrlStr = [NSString stringWithFormat:@"http://%@/sns/vehicle/list?openid=%@&openkey=%@&appid=%@",
//                           AudiServerAddress,strOpenId,strOpenKey,strAppId];
//    
//    NSURL *apiUrl = [NSURL URLWithString:[apiUrlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//    ASIHTTPRequest *pRequest = [ASIHTTPRequest requestWithURL:apiUrl];
//    [pRequest startSynchronous];
//    NSString *apiRepsponse = [pRequest responseString];
//    NSLog(@"%@",apiRepsponse);
//    
//    SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
//    NSError *error = nil;
//    id sender = [jsonParser objectWithString:apiRepsponse error:&error];
//    
//    NSMutableArray *arrVehicles = [[NSMutableArray alloc] init];
//    if ([sender isKindOfClass:[NSArray class]])
//    {
//        NSArray *pArray = (NSArray*)sender;
//        for (NSDictionary * dic in pArray)
//        {
//            ALVehicleData * pData = [[ALVehicleData alloc] init];
//            pData.m_strAudiId =[dic objectForKey:@"audiId"];
//            pData.m_strCarClass =[dic objectForKey:@"carClass"];
//            pData.m_strDriveType =[dic objectForKey:@"driveType"];
//            pData.m_strGearbox =[dic objectForKey:@"gearbox"];
//            pData.m_strSubstract =[dic objectForKey:@"substract"];
//            pData.m_strYear =[dic objectForKey:@"year"];
//            pData.m_strVehicleId =[[dic objectForKey:@"id"] stringValue];
//            pData.m_strModel =[dic objectForKey:@"model"];
//            pData.m_strEmission =[dic objectForKey:@"emission"];
//            
//            [arrVehicles addObject:pData];
//            [pData release];
//            
//        }
//    }
//    [jsonParser release];
//    ALVehicleData *pVehicle = [arrVehicles objectAtIndex:0];
//    [ALDataSourceMgr GetInstance].m_pCurrentUser.m_strAvailVehicleId = pVehicle.m_strVehicleId;
//    [ALDataSourceMgr GetInstance].m_pCurrenUserInfo.m_arrCars = arrVehicles;
//    [arrVehicles release];
}

@end