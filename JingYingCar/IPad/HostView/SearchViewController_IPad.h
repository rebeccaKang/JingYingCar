//
//  SearchViewController_IPad.h
//  JingYingCar
//
//  Created by JiaMing Yan on 12-4-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate_IPad.h"

@interface SearchViewController_IPad : UIViewController<UISearchBarDelegate,UISearchDisplayDelegate,UIScrollViewDelegate,UIGestureRecognizerDelegate>
{
    UISearchBar *schBar;
    
    NSMutableArray *arr_result;
    
    UIActivityIndicatorView *indViewLarge;
    
    NSMutableArray *arr_requests;
    
    UIScrollView *sclView_imgList;
}

@end
