//
//  TopicViewController_IPad.h
//  JingYingCar
//
//  Created by JiaMing Yan on 12-4-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate_IPad.h"

@interface TopicViewController_IPad : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *tbl_topicList;
    
    NSMutableArray *arr_topicList;
    NSArray *arr_class;
    NSMutableArray *arr_topicID;
    
    UIActivityIndicatorView *indViewLarge;
    
    NSMutableArray *arr_requests;
}

@end
