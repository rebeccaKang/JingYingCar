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
#import "SettingMainView_ipad.h"

@interface HostViewController_IPad : UIViewController<UITableViewDelegate,UITableViewDataSource,ASIHTTPRequestDelegate,UIScrollViewDelegate,UIGestureRecognizerDelegate>
{
    NSMutableArray *arr_news;
    NSMutableArray *arr_largeImage;
    
    UIScrollView *sclView_largeImage;
    UIScrollView *sclView_imgList;
    
    UIPageControl *con_page;

    SettingViewController_IPad *con_setting;
//    SearchViewController *con_search;
    
    BOOL isGettingBefore;
    BOOL isGettingLater;
    
    UIActivityIndicatorView *indViewLarge;
    
    NSMutableArray *arr_requests;
    
    UIView *view_loadingAtTop;
    UIView *view_loadingAtBottom;
    
    //SettingMainView_ipad *view_setting;
}

@end
