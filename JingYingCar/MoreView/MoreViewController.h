//
//  MoreViewController.h
//  JingYingCar
//
//  Created by JiaMing Yan on 12-4-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface MoreViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *arr_list;
    NSArray *arr_listID;
    UITableView *tbl_list;
}

@end
