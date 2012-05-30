//
//  SettingMainView_ipad.h
//  JingYingCar
//
//  Created by JiaMing Yan on 12-5-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate_IPad.h"

@interface SettingMainView_ipad : UIView<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *arr_settings;
    UITableView *tbl_setting;
    NSArray *arr_time;
    
    UIView *view_main;
    UIView *view_techSupport;
    UIView *view_about;
    UIView *view_bufferTime;
    
    UITableView *tbl_bufferTime;
    int choice;
    
    UIView *view_mainContentView;
}

-(void)show:(BOOL)animated;
- (void)hide:(BOOL)animated;

@end
