//
//  MagazineUndownloadedViewController.h
//  JingYingCar
//
//  Created by JiaMing Yan on 12-5-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface MagazineUndownloadedViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,ASIHTTPRequestDelegate>
{
    NSMutableArray *arr_magazineList;
    UITableView *tbl_magazineList;
    
    NSMutableArray *arr_magazineData;
}

@end
