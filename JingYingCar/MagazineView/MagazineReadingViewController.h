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

@interface MagazineReadingViewController : UIViewController <UIScrollViewDelegate,UIAlertViewDelegate>
{
    NSDictionary *dic_magazineInfo;
    NSString *magazineID;
    PDFReadingView *view_pdfReading;
    UIScrollView *sclView_pdf;
    
    UIPageControl *con_page;
    
    UILabel *lb_page;
    NSMutableArray *arr_images;
    int pageCount;
}

@property (nonatomic,retain) NSString *magazineID;

@end
