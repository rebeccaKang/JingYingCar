//
//  AppDelegate_IPad.h
//  JingYingCar
//
//  Created by JiaMing Yan on 12-4-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASINetworkQueue.h"
#import "ASIHTTPRequest.h"
#import "DDXML.h"
#import "SqlManager.h"
#import "TopicDetailViewController_IPad.h"
#import "ImageDetailViewController_IPad.h"
#import "SearchViewController_IPad.h"
#import "SettingViewController_IPad.h"
#import "CustomImageView_IPad.h"

#define DEFAULT_URL @"http://classic.wangfan.com/default.ashx"
#define BASIC_URL @"http://classic.wangfan.com"

#define kWBSDKDemoAppKey @"2034724276"
#define kWBSDKDemoAppSecret @"0647718f8f56e657beb989117a3766bd"

#define kWBAlertViewLogOutTag 100
#define kWBAlertViewLogInTag  101

#define settingViewTag 999

@interface AppDelegate_IPad : UIResponder <UIApplicationDelegate,UITabBarControllerDelegate,ASIHTTPRequestDelegate>
{
    UITabBarController *tabCon_main;
    
    ASINetworkQueue *netWorkQueue;

    UINavigationController *nav_main;
    
    NSInteger fontSize;
    NSInteger bufferTime;
    
    NSMutableArray *arr_shouldRequest;
    
    NSMutableArray *arr_requests;
    
    BOOL isShowSetting;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navCon_main;
@property (strong, nonatomic) ASINetworkQueue *netWorkQueue;
@property (nonatomic) NSInteger fontSize;
@property (nonatomic) NSInteger bufferTime;
@property (nonatomic,retain) NSMutableArray *arr_shouldRequest;
@property (nonatomic) BOOL isShowSetting;

@end
