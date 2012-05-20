//
//  SettingViewController.h
//  JingYingCar
//
//  Created by JiaMing Yan on 12-4-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingAboutViewController.h"
#import "SettingTechSupportViewController.h"
#import "SettingBufferViewController.h"
#import "WBEngine.h"

@interface SettingViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,WBEngineDelegate>
{
    NSArray *arr_settings;
    UITableView *tbl_setting;
    NSArray *arr_time;
    
    WBEngine *SinaEngine;
}

@end

