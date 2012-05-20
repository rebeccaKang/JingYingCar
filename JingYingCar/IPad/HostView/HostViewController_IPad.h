//
//  HostViewController_IPad.h
//  JingYingCar
//
//  Created by JiaMing Yan on 12-4-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "AppDelegate_IPad.h"

@interface HostViewController_IPad : UIViewController<UITableViewDelegate,UITableViewDataSource,ASIHTTPRequestDelegate,UIScrollViewDelegate,UIGestureRecognizerDelegate>
{
    UITableView *tbl_hotNews;
    NSMutableArray *arr_news;
    NSMutableArray *arr_largeImage;
    
    UIScrollView *sclView_largeImage;
    
    UIPageControl *con_page;
    
    UIImageView *imgView_largePic;
    UILabel *lb_largePic;
    
    NSMutableArray *arr_topID;
    NSMutableArray *arr_listID;
    
    int largeImgNum;

//    SettingViewController *con_setting;
//    SearchViewController *con_search;
    
    BOOL isGettingBefore;
    BOOL isGettingLater;
    
    UIActivityIndicatorView *indViewLarge;
    
    NSMutableArray *arr_requests;
    
    UIView *view_loadingAtTop;
    UIView *view_loadingAtBottom;
}

@end
