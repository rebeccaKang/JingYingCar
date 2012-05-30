//
//  ImagesViewController_IPad.h
//  JingYingCar
//
//  Created by JiaMing Yan on 12-4-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate_IPad.h"
#import "SettingMainView_ipad.h"

@interface ImagesViewController_IPad : UIViewController<UIScrollViewDelegate,ASIHTTPRequestDelegate,UIGestureRecognizerDelegate>
{
    UIScrollView *sclView_imgList;
    
    NSMutableArray *arr_imgList;
    NSMutableArray *arr_buttons;
    
    UIActivityIndicatorView *indViewLarge;
    
    BOOL isGettingBefore;
    BOOL isGettingLater;
    
    NSMutableArray *arr_requests;
}

@end
