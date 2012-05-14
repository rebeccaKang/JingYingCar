//
//  SettingBufferViewController.h
//  JingYingCar
//
//  Created by JiaMing Yan on 12-5-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface SettingBufferViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *tbl_setting;
    NSArray *arr_time;
    int choice;
}

@end
