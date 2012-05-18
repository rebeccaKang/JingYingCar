//
//  AppDelegate.h
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
#import "TopicDetailViewController.h"
#import "ImageDetailViewController.h"
#import "SearchViewController.h"
#import "SettingViewController.h"
#import "CustomImageView.h"

#define DEFAULT_URL @"http://classic.wangfan.com/default.ashx"
#define BASIC_URL @"http://classic.wangfan.com"

#define kWBSDKDemoAppKey @"2034724276"
#define kWBSDKDemoAppSecret @"0647718f8f56e657beb989117a3766bd"

#define kWBAlertViewLogOutTag 100
#define kWBAlertViewLogInTag  101

@interface AppDelegate : UIResponder <UIApplicationDelegate,UITabBarControllerDelegate,ASIHTTPRequestDelegate>
{
    UITabBarController *tabCon_main;
    
    ASINetworkQueue *netWorkQueue;

    UINavigationController *nav_main;
    
    NSInteger fontSize;
    NSInteger bufferTime;
    
    NSMutableArray *arr_shouldRequest;
    
    NSMutableArray *arr_requests;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navCon_main;
@property (strong, nonatomic) ASINetworkQueue *netWorkQueue;
@property (nonatomic) NSInteger fontSize;
@property (nonatomic) NSInteger bufferTime;
@property (nonatomic,retain) NSMutableArray *arr_shouldRequest;

@end
