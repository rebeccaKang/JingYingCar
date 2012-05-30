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
    NSMutableArray *arr_topicList;
    NSArray *arr_class;
    
    UIActivityIndicatorView *indViewLarge;
    
    NSMutableArray *arr_requests;
    
    UITableView *tbl_topic;
    
    int currentType;
    
    UIButton *btn_engine;
    UIButton *btn_ontheway;
    UIButton *btn_view;
    UIButton *btn_acceleration;
}

@end
