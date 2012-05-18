//
//  MagazineDownloadedViewController.h
//  JingYingCar
//
//  Created by JiaMing Yan on 12-4-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface MagazineDownloadedViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,ASIHTTPRequestDelegate>
{
    NSMutableArray *arr_magazineList;
    UITableView *tbl_magazineList;
    
    NSMutableArray *arr_magazineData;
    
    NSMutableArray *arr_requests;
}

@property (nonatomic,retain) NSArray *arr_magazineList;

@end
