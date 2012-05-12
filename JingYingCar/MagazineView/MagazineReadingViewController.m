//
//  MagazineReadingViewController.m
//  JingYingCar
//
//  Created by JiaMing Yan on 12-5-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MagazineReadingViewController.h"

@interface MagazineReadingViewController ()

@end

@implementation MagazineReadingViewController
@synthesize magazineID;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView
{
    // If you create your views manually, you MUST override this method and use it to create your views.
    // If you use Interface Builder to create your views, then you must NOT override this method.
    [super loadView];
    UIView *view_nav = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 45)];
    view_nav.backgroundColor = [UIColor clearColor];
    [self.view addSubview:view_nav];
    
    UIImageView *imgView_navBK = [[UIImageView alloc] initWithFrame:view_nav.bounds];
    imgView_navBK.image = [UIImage imageNamed:@"magazineNav.png"];
    [view_nav addSubview:imgView_navBK];
    
    UIButton *btn_back = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_back.frame = CGRectMake(10, 7, 50, 30);
    [btn_back setBackgroundImage:[UIImage imageNamed:@"backBtn.png"] forState:UIControlStateNormal];
    //[btn_back setTitle:@" 返回" forState:UIControlStateNormal];
    [btn_back addTarget:self action:@selector(turnBack) forControlEvents:UIControlEventTouchUpInside];
    [btn_back setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn_back.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    btn_back.titleLabel.textAlignment = UITextAlignmentRight;
    [view_nav addSubview:btn_back];
    
//    UIButton *btn_lastPage = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn_lastPage.frame = CGRectMake(210, 10, 50, 25);
//    [btn_lastPage setBackgroundImage:[UIImage imageNamed:@"rectButton.png"] forState:UIControlStateNormal];
//    [btn_lastPage setTitle:@"上一页" forState:UIControlStateNormal];
//    [btn_lastPage addTarget:self action:@selector(turnToLastPage) forControlEvents:UIControlEventTouchUpInside];
//    [btn_lastPage setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    btn_lastPage.titleLabel.font = [UIFont boldSystemFontOfSize:14];
//    btn_lastPage.titleLabel.textAlignment = UITextAlignmentRight;
//    [view_nav addSubview:btn_lastPage];
//    
//    UIButton *btn_nextPage = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn_nextPage.frame = CGRectMake(265, 10, 50, 25);
//    [btn_nextPage setBackgroundImage:[UIImage imageNamed:@"rectButton.png"] forState:UIControlStateNormal];
//    [btn_nextPage setTitle:@"下一页" forState:UIControlStateNormal];
//    [btn_nextPage addTarget:self action:@selector(turnToNextPage) forControlEvents:UIControlEventTouchUpInside];
//    [btn_nextPage setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    btn_nextPage.titleLabel.font = [UIFont boldSystemFontOfSize:14];
//    btn_nextPage.titleLabel.textAlignment = UITextAlignmentRight;
//    [view_nav addSubview:btn_nextPage];
    
    UIView *view_content = [[UIView alloc] initWithFrame:CGRectMake(0, 45, 320, 415)];
    view_content.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
    [self.view addSubview:view_content];
    
    dic_magazineInfo = [[SqlManager sharedManager] getMagazineInfoWithID:magazineID];
//    NSString *str_address = [dic_magazineInfo objectForKey:@"address"];
//    if ([str_address length] > 0) {
//        view_pdfReading = [[PDFReadingView alloc] initWithFrame:CGRectMake(0, 0, 320, 415) pdfAddress:str_address];
//        [view_content addSubview:view_pdfReading];
//    }
    arr_images = [[NSArray alloc] initWithArray:[self getPDFImages]];
    UIScrollView *sclView_pdf = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 415)];
    sclView_pdf.contentSize = CGSizeMake(320 * [arr_images count], 415);
    sclView_pdf.pagingEnabled = YES;
    sclView_pdf.showsHorizontalScrollIndicator = NO;
    sclView_pdf.showsVerticalScrollIndicator = NO;
    sclView_pdf.scrollsToTop = NO;
    sclView_pdf.directionalLockEnabled = YES;
    sclView_pdf.delegate = self;
    [view_content addSubview:sclView_pdf];
    for (int i = 0; i < [arr_images count]; i++) {
        UIScrollView *sclView_img = [[UIScrollView alloc] initWithFrame:CGRectMake(320*i, 0, 320, 415)];
        sclView_img.showsHorizontalScrollIndicator = NO;
        sclView_img.showsVerticalScrollIndicator = NO;
        sclView_img.directionalLockEnabled = YES;
        sclView_img.delegate = self;
        sclView_img.minimumZoomScale = 1;
        sclView_img.maximumZoomScale = 2.0f;
        [sclView_pdf addSubview:sclView_img];
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 415)];
        imgView.image = [arr_images objectAtIndex:i];
        [sclView_img addSubview:imgView];
    }
    
    con_page = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 385, 320, 20)];
    con_page.numberOfPages = [arr_images count];
    con_page.currentPage = 0;
    con_page.backgroundColor = [UIColor clearColor];
    //[view_content addSubview:con_page];
    
    lb_page = [[UILabel alloc] initWithFrame:CGRectMake(0, 375, 320, 30)];
    lb_page.backgroundColor = [UIColor clearColor];
    lb_page.textAlignment = UITextAlignmentCenter;
    lb_page.text = [NSString stringWithFormat:@"1/%d",[arr_images count]];
    lb_page.textColor = [UIColor blackColor];
    [view_content addSubview:lb_page];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark buttonFunction
-(void)turnBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)turnToNextPage
{
    if (view_pdfReading != nil) {
        [view_pdfReading turnToNextPage];
    }
}

-(void)turnToLastPage
{
    if (view_pdfReading != nil) {
        [view_pdfReading turnToLastPage];
    }
}

-(NSArray *)getPDFImages
{
    NSMutableArray *arr_result = [[NSMutableArray alloc] init];
    CGRect rect = CGRectMake(0, 0, 320, 415);
    NSString *str_address = [dic_magazineInfo objectForKey:@"address"];
    NSURL *url_pdf = [[NSURL alloc] initFileURLWithPath:str_address];
    CGPDFDocumentRef pdf = CGPDFDocumentCreateWithURL((__bridge CFURLRef)url_pdf);
    //CFRelease((__bridge CFURLRef)url_pdf);
    int pageCount = CGPDFDocumentGetNumberOfPages(pdf);
    for (int i = 1; i <= pageCount; i++) {
        CGPDFPageRef page = CGPDFDocumentGetPage(pdf, i);
        CGRect pdfcropBox = CGRectIntegral(CGPDFPageGetBoxRect(page, kCGPDFCropBox));
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGContextRef context = CGBitmapContextCreate(NULL,rect.size.width,
                                                     rect.size.height,
                                                     8,
                                                     (int)rect.size.width * 4,
                                                     colorSpace, 
                                                     kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
        
        CGColorSpaceRelease(colorSpace);
        colorSpace = nil;
        
        CGPDFPageRetain(page);
        CGAffineTransform pdfTransform = CGPDFPageGetDrawingTransform(page,
                                                                      kCGPDFCropBox,
                                                                      CGRectMake(0, 0, rect.size.width,rect.size.height),
                                                                      0, true);
        CGContextSaveGState(context);
        CGContextConcatCTM(context, pdfTransform);
        CGContextDrawPDFPage(context, page);
        CGPDFPageRelease (page);
        page = nil;
        CGContextRestoreGState(context);    
        CGImageRef image = CGBitmapContextCreateImage(context);
        UIImage *backgroundImage =  [UIImage imageWithCGImage:image];
        CGContextClearRect(context, rect);
        CGContextClearRect(context, pdfcropBox);
        
        CGContextRelease(context);
        CGImageRelease(image);
        context = nil; 
        [arr_result addObject:backgroundImage];
    }
    return arr_result;
}

#pragma mark -
#pragma mark scrollview
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.pagingEnabled == NO) {
        // do nothing - the scroll was initiated from the page control, not the user dragging
        return;
    }
	
    // Switch the indicator when more than 50% of the previous/next page is visible
    int index = fabs(scrollView.contentOffset.x) / scrollView.frame.size.width;
	
	//con_page.currentPage = index;
    
    lb_page.text = [NSString stringWithFormat:@"%d/%d",index +1,[arr_images count]];
}
- (void)scrollViewDidScroll:(UIScrollView *)sender {
    // We don't want a "feedback loop" between the UIPageControl and the scroll delegate in
    // which a scroll event generated from the user hitting the page control triggers updates from
    // the delegate method. We use a boolean to disable the delegate logic when the page control is used.
    
    
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    
    
    // A possible optimization would be to unload the views+controllers which are no longer visible
}

@end
