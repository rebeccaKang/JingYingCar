//
//  MoreViewController_IPad.h
//  JingYingCar
//
//  Created by JiaMing Yan on 12-4-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate_IPad.h"

@interface MoreViewController_IPad : UIViewController<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
{
    NSMutableArray *arr_list;
    NSArray *arr_listID;
    UITableView *tbl_list;
    
    UIScrollView *sclView_imgList;
}

@end
