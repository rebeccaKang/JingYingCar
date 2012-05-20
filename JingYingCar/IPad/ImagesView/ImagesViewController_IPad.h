//
//  ImagesViewController_IPad.h
//  JingYingCar
//
//  Created by JiaMing Yan on 12-4-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate_IPad.h"

@interface ImagesViewController_IPad : UIViewController<UIScrollViewDelegate,ASIHTTPRequestDelegate,UIGestureRecognizerDelegate>
{
    UIScrollView *sclView_top;
    UIPageControl *con_page;
    int largeImgNum;
    
    UIScrollView *sclView_imgList;
    
    NSMutableArray *arr_topImgs;
    NSMutableArray *arr_imgList;
    NSMutableArray *arr_buttons;
    
    NSMutableArray *arr_topID;
    NSMutableArray *arr_listID;
    
    UIActivityIndicatorView *indViewLarge;
    
    BOOL isGettingBefore;
    BOOL isGettingLater;
    
    NSMutableArray *arr_requests;
}

@end
