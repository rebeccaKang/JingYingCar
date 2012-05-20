//
//  SettingViewController_IPad.h
//  JingYingCar
//
//  Created by JiaMing Yan on 12-4-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingAboutViewController_IPad.h"
#import "SettingTechSupportViewController_IPad.h"
#import "SettingBufferViewController_IPad.h"
#import "WBEngine.h"

@interface SettingViewController_IPad : UIViewController<UITableViewDelegate,UITableViewDataSource,WBEngineDelegate>
{
    NSArray *arr_settings;
    UITableView *tbl_setting;
    NSArray *arr_time;
    
    WBEngine *SinaEngine;
}

@end

