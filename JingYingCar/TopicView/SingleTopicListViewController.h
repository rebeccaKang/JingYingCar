//
//  SingleTopicListViewController.h
//  JingYingCar
//
//  Created by JiaMing Yan on 12-4-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface SingleTopicListViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
{
    NSInteger type;
    
    NSMutableArray *arr_topicList;
    
    UITableView *tbl_topicList;
    
    BOOL isGettingBefore;
    BOOL isGettingLater;
    
    UIActivityIndicatorView *indViewLarge;
}

@property (nonatomic) NSInteger type;

@end
