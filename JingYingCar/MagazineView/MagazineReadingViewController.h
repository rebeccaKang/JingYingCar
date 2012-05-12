//
//  MagazineReadingViewController.h
//  JingYingCar
//
//  Created by JiaMing Yan on 12-5-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "PDFReadingView.h"

@interface MagazineReadingViewController : UIViewController <UIScrollViewDelegate>
{
    NSDictionary *dic_magazineInfo;
    NSString *magazineID;
    PDFReadingView *view_pdfReading;
    
    UIPageControl *con_page;
    
    UILabel *lb_page;
    NSArray *arr_images;
}

@property (nonatomic,retain) NSString *magazineID;

@end
