//
//  PDFReadingView_IPad.h
//  JingYingCar
//
//  Created by JiaMing Yan on 12-5-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDFReadingView_IPad : UIView
{
    CGPDFDocumentRef pdf;
    int currentPage;
    NSString *pdfAddress;
    int pageCount;
    NSMutableArray *arr_pdfImages;
}

- (id)initWithFrame:(CGRect)frame pdfAddress:(NSString *)str_address;
-(void)turnToNextPage;
-(void)turnToLastPage;

@end
