//
//  ImagesViewController.m
//  JingYingCar
//
//  Created by JiaMing Yan on 12-4-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ImagesViewController.h"
#import "CustomImageView.h"

//static UIImage *barImage = nil;
//@implementation UINavigationBar (CustomImage)
//
//- (void) drawRect: (CGRect)rect
//{
//    if (barImage != nil)
//    {
//        [barImage drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
//        barImage = nil;
//    }
//    else
//    {
//        //        UIColor *color = [UIColor redColor];
//        //        CGContextRef context = UIGraphicsGetCurrentContext();
//        //        CGContextSetFillColor(context, CGColorGetComponents( [color CGColor]));
//        //        CGContextFillRect(context, rect);
//        //        self.tintColor = color;
//    }
//    
//}
//
//- (void) setImage: (NSString *)image
//{
//    barImage = [ UIImage imageNamed:image];
//    [self setNeedsDisplay];
//}
//@end

@interface ImagesViewController ()

@end

@implementation ImagesViewController

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
    [super loadView];
    // If you create your views manually, you MUST override this method and use it to create your views.
    // If you use Interface Builder to create your views, then you must NOT override this method.
    arr_requests = [[NSMutableArray alloc] init];
    arr_imgList = [[NSMutableArray alloc] initWithArray:[[SqlManager sharedManager] getImagesList]];
    arr_topImgs = [[NSMutableArray alloc] initWithArray:[[SqlManager sharedManager] getImagesTopList]];
    
    indViewLarge = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [indViewLarge setCenter:self.view.center];
    [indViewLarge startAnimating];
    [self.view addSubview:indViewLarge];
    
    [self requestTopImg];
    if ([arr_imgList count] == 0) {
        [self requestImgList:@"before"];
    }
    else {
        [self requestImgList:@"later"];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
//    NSString *str_version = [UIDevice currentDevice].systemVersion;
//    if ([str_version intValue] > 4) {
//        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navHotNews.png"] forBarMetrics:UIBarMetricsDefault];
//        UILabel *lb_title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 55)];
//        lb_title.backgroundColor = [UIColor clearColor];
//        lb_title.font = [UIFont boldSystemFontOfSize:24];
//        lb_title.textAlignment = UITextAlignmentCenter;
//        lb_title.text = @"精英图库";
//        [self.navigationController.navigationBar addSubview:lb_title];
//    }
//    else {
//        [self.navigationController.navigationBar setImage:@"navHotNews.png"];
//    }
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"topicBackground.png"]];
    
    UIView *view_nav = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 45)];
    view_nav.backgroundColor = [UIColor clearColor];
    view_nav.layer.shadowOffset = CGSizeMake(0, 1);
    view_nav.layer.shadowOpacity = 1;
    view_nav.layer.shadowColor = [UIColor blackColor].CGColor;
    [self.view addSubview:view_nav];
    
    UIImageView *imgView_navBK = [[UIImageView alloc] initWithFrame:view_nav.bounds];
    imgView_navBK.image = [UIImage imageNamed:@"imagesNav.png"];
    [view_nav addSubview:imgView_navBK];
    
    UIButton *btn_search = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_search.frame = CGRectMake(10, 10, 25, 25);
    [btn_search setBackgroundImage:[UIImage imageNamed:@"search.png"] forState:UIControlStateNormal];
    [btn_search addTarget:self action:@selector(turnToSearch:) forControlEvents:UIControlEventTouchUpInside];
    [view_nav addSubview:btn_search];
    
    UIButton *btn_setting = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_setting.frame = CGRectMake(285, 10, 25, 25);
    [btn_setting setBackgroundImage:[UIImage imageNamed:@"setting.png"] forState:UIControlStateNormal];
    [btn_setting addTarget:self action:@selector(showSetting) forControlEvents:UIControlEventTouchUpInside];
    [view_nav addSubview:btn_setting];
    
    UIView *view_content = [[UIView alloc] initWithFrame:CGRectMake(0, 45, 320, 415)];
    view_content.backgroundColor = [UIColor clearColor];
    [self.view addSubview:view_content];
    
    arr_buttons = [[NSMutableArray alloc] init];
    
    arr_topID = [[NSMutableArray alloc] init];
    arr_listID = [[NSMutableArray alloc] init];
    
    sclView_top = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 160)];
    sclView_top.contentSize = CGSizeMake(320, 160);
    sclView_top.pagingEnabled = YES;
    sclView_top.showsHorizontalScrollIndicator = NO;
    sclView_top.showsVerticalScrollIndicator = NO;
    sclView_top.scrollsToTop = NO;
    sclView_top.directionalLockEnabled = YES;
    sclView_top.delegate = self;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapLargeImage:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    tap.delegate = self;
    [sclView_top addGestureRecognizer:tap];
    
    [view_content addSubview:sclView_top];
    
    for (int i = 0; i < [arr_topImgs count]; i++) {
        NSMutableDictionary *dic_info = [[NSMutableDictionary alloc] initWithDictionary:[arr_topImgs objectAtIndex:i]];
        NSString *str_id = [dic_info objectForKey:@"id"];
        CustomImageView *imgView;
        NSString *str_imgAddress = [dic_info objectForKey:@"largeImgAddress"];
        if ([str_imgAddress length] > 0) {
            UIImage *img = [UIImage imageWithContentsOfFile:str_imgAddress];
            imgView = [[CustomImageView alloc] initWithFrame:CGRectMake(320*i, 0, 320, 160) withID:str_id img:img];
            [dic_info setObject:imgView forKey:@"imgView"];
        }
        else {
            imgView = [[CustomImageView alloc] initWithFrame:CGRectMake(320*i, 0, 320, 160) withID:str_id img:nil];
//            UIActivityIndicatorView *indView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
//            [indView setCenter:imgView.center];
//            indView.tag = 101;
//            [indView startAnimating];
//            [imgView addSubview:indView];
            [dic_info setObject:imgView forKey:@"imgView"];
            [self requestImage:dic_info imgType:@"0"];
        }
        UIView *view_imgTitle = [[UIView alloc] initWithFrame:CGRectMake(0, 130, 320, 30)];
        view_imgTitle.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8f];
        [imgView addSubview:view_imgTitle];
        
        UILabel *lb_imgTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 310, 30)];
        lb_imgTitle.textColor = [UIColor whiteColor];
        lb_imgTitle.text = [NSString stringWithFormat:@"每日图片    %@",[dic_info objectForKey:@"title"]];
        lb_imgTitle.backgroundColor = [UIColor clearColor];
        [view_imgTitle addSubview:lb_imgTitle];
        [sclView_top addSubview:imgView];
        
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)];
//        tap.numberOfTapsRequired = 1;
//        tap.numberOfTouchesRequired = 1;
//        tap.delegate = self;
//        [imgView addGestureRecognizer:tap];
        
        [arr_topImgs replaceObjectAtIndex:i withObject:dic_info];
    }
    
    con_page.numberOfPages = [arr_topImgs count];
    sclView_top.contentSize = CGSizeMake(320*[arr_topImgs count], 160);
    
    con_page = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 105, 320, 20)];
    con_page.currentPage = 0;
    con_page.backgroundColor = [UIColor clearColor];
    //[view_content addSubview:con_page];
    
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 160, 320, 30)];
//    view.backgroundColor = [UIColor colorWithWhite:0 alpha:1];
//    UILabel *lb_header = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 180, 30)];
//    lb_header.text = @"每日图片";
//    lb_header.textColor = [UIColor whiteColor];
//    lb_header.font = [UIFont boldSystemFontOfSize:20];
//    lb_header.backgroundColor = [UIColor clearColor];
//    [view addSubview:lb_header];
//    [view_content addSubview:view];
    
    sclView_imgList = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 160, 320, 210)];
    sclView_imgList.contentSize = CGSizeMake(320, 210);
    sclView_imgList.pagingEnabled = NO;
    sclView_imgList.showsHorizontalScrollIndicator = NO;
    sclView_imgList.showsVerticalScrollIndicator = NO;
    sclView_imgList.scrollsToTop = NO;
    sclView_imgList.directionalLockEnabled = YES;
    sclView_imgList.delegate = self;
    int rows = [arr_imgList count]/3;
    sclView_imgList.contentSize = CGSizeMake(320, 5+75*(rows+1));
    [view_content addSubview:sclView_imgList];
    
    for (int i = 0; i < [arr_imgList count]; i++) {
        NSMutableDictionary *dic_info = [[NSMutableDictionary alloc] initWithDictionary:[arr_imgList objectAtIndex:i]];
        NSString *str_id = [dic_info objectForKey:@"id"];
        int row = i/3;
        int col = i%3;
        
        CustomImageView *imgView;
        NSString *str_imgAddress = [dic_info objectForKey:@"smallImgAddress"];
        if ([str_imgAddress length] > 0) {
            UIImage *img = [UIImage imageWithContentsOfFile:str_imgAddress];
            imgView = [[CustomImageView alloc] initWithFrame:CGRectMake(5+105*col, 5+75*row, 100, 70) withID:str_id img:img];
            [dic_info setObject:imgView forKey:@"imgView"];
        }
        else {
            imgView = [[CustomImageView alloc] initWithFrame:CGRectMake(5+105*col, 5+75*row, 100, 70) withID:str_id img:nil];
//            UIActivityIndicatorView *indView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
//            [indView setCenter:imgView.center];
//            indView.tag = 101;
//            [indView startAnimating];
//            [imgView addSubview:indView];
            [dic_info setObject:imgView forKey:@"imgView"];
            [self requestImage:dic_info imgType:@"1"];
        }
        [sclView_imgList addSubview:imgView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        tap.delegate = self;
        [imgView addGestureRecognizer:tap];
        
        [arr_imgList replaceObjectAtIndex:i withObject:dic_info];
    }
    
    [self.view bringSubviewToFront:indViewLarge];
    [self.view bringSubviewToFront:view_nav];
}

-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSString *str_shouldRequest = [app.arr_shouldRequest objectAtIndex:1];
    if ([str_shouldRequest isEqualToString:@"0"]) {
        [self requestTopImg];
        //[self requestImgList];
        [app.arr_shouldRequest replaceObjectAtIndex:1 withObject:@"1"];
    }
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
-(void)turnToSearch:(UIButton *)sender
{
    SearchViewController *con_search = [[SearchViewController alloc] init];
    //[self.navigationController pushViewController:con_seach animated:YES];
    UINavigationController *nav_search = [[UINavigationController alloc] initWithRootViewController:con_search];
    [self presentViewController:nav_search animated:YES completion:nil];
}

-(void)showSetting
{
    SettingViewController *con_setting = [[SettingViewController alloc] init];
    //[self.navigationController pushViewController:con_setting animated:YES];
    UINavigationController *nav_setting = [[UINavigationController alloc] initWithRootViewController:con_setting];
    [self presentViewController:nav_setting animated:YES completion:nil];
}

-(void)turnToDetail:(UIButton *)sender
{
    for (int i = 0; i < [arr_imgList count]; i++) {
        UIButton *btn_temp = [arr_buttons objectAtIndex:i];
        if (btn_temp == sender) {
            NSDictionary *dic_img = [arr_imgList objectAtIndex:i];
            ImageDetailViewController *con_detail = [[ImageDetailViewController alloc] init];
            
            con_detail.str_id = [dic_img objectForKey:@"id"];
            
            [self.navigationController pushViewController:con_detail animated:YES]; 
            break;
        }
    }
}

#pragma mark -
#pragma mark connection
-(void)requestTopImg
{
    if ([indViewLarge isAnimating] == NO) {
        [indViewLarge startAnimating];
    }
    NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@",DEFAULT_URL]];
    //设置
	ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:url];
	//设置ASIHTTPRequest代理
	request.delegate = self;
    //设置是是否支持断点下载
	[request setAllowResumeForFileDownloads:NO];
	//设置基本信息
    NSString *httpBodyString = [self topImgRequestBody];
	NSLog(@"request topimg  httpBodyString :%@",httpBodyString);
	
    NSData *postData = [httpBodyString dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *dic_userInfo = [[NSMutableDictionary alloc] init];
    [dic_userInfo setObject:@"requestTopImg" forKey:@"operate"];
    [request setUserInfo:dic_userInfo];
    [request setPostBody:postData];
    [request setRequestMethod:@"POST"];
    //添加到ASINetworkQueue队列去下载
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
	[app.netWorkQueue addOperation:request];
    [arr_requests addObject:request];
}

-(NSString *)topImgRequestBody
{
    DDXMLNode *node_operate = [DDXMLNode elementWithName:@"Operate" stringValue:@"GetTopImageList"];
    DDXMLNode *node_device = [DDXMLNode elementWithName:@"Device" stringValue:@"iphone"];
    NSArray *arr_request = [[NSArray alloc] initWithObjects:node_operate,node_device,nil];
    DDXMLElement *element_request = [[DDXMLElement alloc] initWithName: @"Request"];
    [element_request setChildren:arr_request];
    return [element_request XMLString];
}

-(void)requestImgList:(NSString *)direction
{
    if ([indViewLarge isAnimating] == NO) {
        [indViewLarge startAnimating];
    }
    NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@",DEFAULT_URL]];
    //设置
	ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:url];
	//设置ASIHTTPRequest代理
	request.delegate = self;
    //设置是是否支持断点下载
	[request setAllowResumeForFileDownloads:NO];
	//设置基本信息
    NSString *httpBodyString = [self imgListRequestBody:direction];
	NSLog(@"request imglist  httpBodyString :%@",httpBodyString);
	
    NSData *postData = [httpBodyString dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *dic_userInfo = [[NSMutableDictionary alloc] init];
    [dic_userInfo setObject:@"requestImgList" forKey:@"operate"];
    [dic_userInfo setObject:direction forKey:@"direction"];
    [request setUserInfo:dic_userInfo];
    [request setPostBody:postData];
    [request setRequestMethod:@"POST"];
    //添加到ASINetworkQueue队列去下载
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
	[app.netWorkQueue addOperation:request];
    [arr_requests addObject:request];
}

-(NSString *)imgListRequestBody:(NSString *)direction
{
    NSString *strTime = @"";
    if ([arr_imgList count] > 0) {
        NSDictionary *dic_temp;
        if ([direction isEqualToString:@"before"]) {
            dic_temp = [arr_imgList objectAtIndex:[arr_imgList count]-1];
        }
        else if ([direction isEqualToString:@"later"]) {
            dic_temp = [arr_imgList objectAtIndex:0];
        }
        strTime = [dic_temp objectForKey:@"createTime"];
    }
    else {
        NSDate *time = [NSDate date];
        NSDateFormatter *dateForm_time = [[NSDateFormatter alloc] init];
        [dateForm_time setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
        [dateForm_time setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        strTime = [dateForm_time stringFromDate:time];
    }
    NSLog(@"strTime:%@",strTime);
    DDXMLNode *node_operate = [DDXMLNode elementWithName:@"Operate" stringValue:@"GetImageList"];
    DDXMLNode *node_device = [DDXMLNode elementWithName:@"Device" stringValue:@"iphone"];
    DDXMLNode *node_update = [DDXMLNode elementWithName:@"Update" stringValue:strTime];
    DDXMLNode *node_direction = [DDXMLNode elementWithName:@"Direction" stringValue:direction];
    NSArray *arr_request = [[NSArray alloc] initWithObjects:node_operate,node_device,node_update,node_direction,nil];
    DDXMLElement *element_request = [[DDXMLElement alloc] initWithName: @"Request"];
    [element_request setChildren:arr_request];
    return [element_request XMLString];
}

//type:1-大图 2-列表
-(void)requestImage:(NSDictionary *)info imgType:(NSString *)type
{
    NSString *str_imgUrl = @"";
    if ([type intValue] == 0) {
        str_imgUrl = [info objectForKey:@"largeImgUrl"];
    }
    else if([type intValue] == 1)
    {
        str_imgUrl = [info objectForKey:@"smallImgUrl"];
    }
    if ([str_imgUrl length] == 0) {
        return;
    }
    NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@/%@",BASIC_URL,str_imgUrl]];
    //设置
	ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:url];
	//设置ASIHTTPRequest代理
	request.delegate = self;
    //设置是是否支持断点下载
	[request setAllowResumeForFileDownloads:YES];
	//设置基本信息
    //NSString *httpBodyString = [self setGetHotNewsRequestBody];
	//NSLog(@"request total  httpBodyString :%@",httpBodyString);
	
    //NSData *postData = [httpBodyString dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *dic_userInfo = [[NSMutableDictionary alloc] initWithDictionary:info];
    [dic_userInfo setObject:type forKey:@"imgType"];
    [dic_userInfo setObject:@"downloadImg" forKey:@"operate"];
    [request setUserInfo:dic_userInfo];
    //[request setPostBody:postData];
    //[request setRequestMethod:@"POST"];
    //添加到ASINetworkQueue队列去下载
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
	[app.netWorkQueue addOperation:request];
    [arr_requests addObject:request];
}

#pragma mark -
#pragma mark ASIHttpRequestDelegate
//ASIHTTPRequestDelegate,下载之前获取信息的方法,主要获取下载内容的大小
- (void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders
{
}
//ASIHTTPRequestDelegate,下载完成时,执行的方法
- (void)requestFinished:(ASIHTTPRequest *)request {
    NSDictionary *dic_userInfo = request.userInfo;
    NSString *str_operate = [dic_userInfo objectForKey:@"operate"];
    //NSLog(@"str_operate:%@",str_operate);
    
    NSData *_data = request.responseData;
    NSString *responseString = [[NSString alloc] initWithData:_data encoding:NSUTF8StringEncoding];
    NSLog(@"responseString2:%@,%@",responseString,str_operate);
    
    if ([indViewLarge isAnimating] == YES) {
        [indViewLarge stopAnimating];
    }
    
    if ([str_operate isEqualToString:@"requestTopImg"]) {
        NSError *error = nil;
        DDXMLDocument* xmlDoc = [[DDXMLDocument alloc] initWithXMLString:responseString options:0 error:&error];
        if (error) {
            NSLog(@"%@",[error localizedDescription]);
        }
        else {
            //[[SqlManager sharedManager] initImagesLastShow];
        }
        NSArray *arr_response = [xmlDoc nodesForXPath:@"//Response" error:&error];
        NSMutableArray *arr_total = [[NSMutableArray alloc] init];
        for (DDXMLElement *element_response in arr_response) {
            NSArray *arr_code = [element_response elementsForName:@"Code"];
            NSString *str_code = [[arr_code objectAtIndex:0] stringValue];
            NSArray *arr_items = [element_response elementsForName:@"Item"];
            for (DDXMLElement *element_item in arr_items) {
                NSMutableDictionary *dic_itemSaved = [[NSMutableDictionary alloc] init];
                NSArray *arr_id = [element_item elementsForName:@"ID"];
                NSString *str_id = [[arr_id objectAtIndex:0] stringValue];
                [dic_itemSaved setObject:str_id forKey:@"id"];
                NSArray *arr_title = [element_item elementsForName:@"Title"];
                NSString *str_title = [[arr_title objectAtIndex:0] stringValue];
                [dic_itemSaved setObject:str_title forKey:@"title"];
                NSArray *arr_update = [element_item elementsForName:@"Update"];
                NSString *str_update = [[arr_update objectAtIndex:0] stringValue];
                [dic_itemSaved setObject:str_update forKey:@"createTime"];
                NSArray *arr_summary = [element_item elementsForName:@"Summary"];
                NSString *str_summary = [[arr_summary objectAtIndex:0] stringValue];
                [dic_itemSaved setObject:str_summary forKey:@"summary"];
                NSArray *arr_smallImg = [element_item elementsForName:@"SmallImage"];
                NSString *str_smallImg = [[arr_smallImg objectAtIndex:0] stringValue];
                [dic_itemSaved setObject:str_smallImg forKey:@"smallImgUrl"];
                NSArray *arr_largeImg = [element_item elementsForName:@"LargeImage"];
                NSString *str_largeImg = [[arr_largeImg objectAtIndex:0] stringValue];
                [dic_itemSaved setObject:str_largeImg forKey:@"largeImgUrl"];
                [arr_topID addObject:str_id];
                [arr_total addObject:dic_itemSaved];
                int result = [[SqlManager sharedManager] saveImageListInfo:dic_itemSaved isTopOrList:@"0"];
                NSMutableDictionary *dic_newInfo = [[NSMutableDictionary alloc] initWithDictionary:[[SqlManager sharedManager] getImageListWithID:str_id]];
                //102-更新 103-新增
                if (result == 102) {
                    for (int i = 0; i < [arr_topImgs count]; i++) {
                        NSDictionary *dic_topImg = [arr_topImgs objectAtIndex:i];
                        NSString *str_tempId = [dic_topImg objectForKey:@"id"];
                        if ([str_tempId isEqualToString:str_id] ) {
                            CustomImageView *imgView = (CustomImageView *)[dic_topImg objectForKey:@"imgView"];
                            [dic_newInfo setObject:imgView forKey:@"imgView"];
                            [arr_topImgs replaceObjectAtIndex:i withObject:dic_newInfo];
//                            UIActivityIndicatorView *indView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
//                            [indView setCenter:imgView.center];
//                            indView.tag = 101;
//                            [indView startAnimating];
//                            [imgView addSubview:indView];
                            [self requestImage:dic_newInfo imgType:@"0"];
                            break;
                        }
                    }
                }
                else if(result == 103)
                {
                    BOOL isExist = NO;
                    for (int i = 0; i < [arr_topImgs count]; i++) {
                        NSDictionary *dic_topImg = [arr_topImgs objectAtIndex:i];
                        NSString *str_tempId = [dic_topImg objectForKey:@"id"];
                        if ([str_tempId isEqualToString:str_id] ) {
                            isExist = YES;
                            break;
                        }
                    }
                    if (isExist == NO) {
                        NSDateFormatter *dateForm_time = [[NSDateFormatter alloc] init];
                        [dateForm_time setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
                        [dateForm_time setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                        for (int i = 0; i < [arr_topImgs count]; i++) {
                            NSDictionary *dic_topImg = [arr_topImgs objectAtIndex:i];
                            NSString *str_tempCreateTime = [dic_topImg objectForKey:@"createTime"];
                            NSDate *date_temp = [dateForm_time dateFromString:str_tempCreateTime];
                            NSDate *date_current = [dateForm_time dateFromString:str_update];
                            CustomImageView *imgView;
                            if ([date_current compare:date_temp] == NSOrderedDescending || i == [arr_topImgs count] - 1) {
                                imgView = [[CustomImageView alloc] initWithFrame:CGRectMake(320*i, 0, 320, 160) withID:str_id img:nil];
//                                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)];
//                                tap.numberOfTapsRequired = 1;
//                                tap.numberOfTouchesRequired = 1;
//                                tap.delegate = self;
//                                [imgView addGestureRecognizer:tap];
                                
                                
                                //                            UIActivityIndicatorView *indView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
                                //                            indView.tag = 101;
                                //                            [indView setCenter:imgView.center];
                                //                            [indView startAnimating];
                                //                            [imgView addSubview:indView];
                                
                                UIView *view_imgTitle = [[UIView alloc] initWithFrame:CGRectMake(0, 130, 320, 30)];
                                view_imgTitle.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8f];
                                [imgView addSubview:view_imgTitle];
                                
                                UILabel *lb_imgTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 310, 30)];
                                lb_imgTitle.textColor = [UIColor whiteColor];
                                lb_imgTitle.text = [NSString stringWithFormat:@"每日图片    %@",[dic_newInfo objectForKey:@"title"]];
                                lb_imgTitle.backgroundColor = [UIColor clearColor];
                                [view_imgTitle addSubview:lb_imgTitle];
                                [sclView_top addSubview:imgView];
                                
                                [dic_newInfo setObject:imgView forKey:@"imgView"];
                                if ([date_current compare:date_temp] == NSOrderedDescending) {
                                    [arr_topImgs insertObject:dic_newInfo atIndex:i];
                                }
                                else if(i == [arr_topImgs count] - 1)
                                {
                                    [arr_topImgs addObject:dic_newInfo];
                                }
                                
                                
                                [self requestImage:dic_newInfo imgType:@"0"];
                                break;
                            }
                        }
                        if ([arr_topImgs count] == 0) {
                            CustomImageView *imgView = [[CustomImageView alloc] initWithFrame:CGRectMake(320, 0, 320, 160) withID:str_id img:nil];
                            //                        UIActivityIndicatorView *indView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
                            //                        indView.tag = 101;
                            //                        [imgView addSubview:indView];
                            //                        [indView startAnimating];
                            //                        [indView setCenter:imgView.center];
                            UIView *view_imgTitle = [[UIView alloc] initWithFrame:CGRectMake(0, 130, 320, 30)];
                            view_imgTitle.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8f];
                            [imgView addSubview:view_imgTitle];
                            
                            UILabel *lb_imgTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 310, 30)];
                            lb_imgTitle.textColor = [UIColor whiteColor];
                            lb_imgTitle.text = [NSString stringWithFormat:@"每日图片    %@",[dic_newInfo objectForKey:@"title"]];
                            lb_imgTitle.backgroundColor = [UIColor clearColor];
                            [view_imgTitle addSubview:lb_imgTitle];
                            [sclView_top addSubview:imgView];
                            
//                            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)];
//                            tap.numberOfTapsRequired = 1;
//                            tap.numberOfTouchesRequired = 1;
//                            tap.delegate = self;
//                            [imgView addGestureRecognizer:tap];
                            
                            [dic_newInfo setObject:imgView forKey:@"imgView"];
                            [arr_topImgs addObject:dic_newInfo];
                            
                            [self requestImage:dic_newInfo imgType:@"0"];
                        }
                        NSLog(@"大图:%d",[arr_topImgs count]);
                        con_page.numberOfPages = [arr_topImgs count];
                        sclView_top.contentSize = CGSizeMake(320*[arr_topImgs count], 160);
                        for (int i = 0; i < [arr_topImgs count]; i++) {
                            NSDictionary *dic_topImg = [arr_topImgs objectAtIndex:i];
                            CustomImageView *imgView = (CustomImageView *)[dic_topImg objectForKey:@"imgView"];
                            imgView.frame = CGRectMake(320*i, 0, 320, 16);
                        }
                    }
                }
            }
        }
//        int result = [[SqlManager sharedManager] saveImagesList:arr_total isTopOrList:@"0"];
//        if (result == 0) {
//            for (int i = 0; i < [arr_topID count]; i++) {
//                NSString *str_id = [arr_topID objectAtIndex:i];
//                NSDictionary *dic_temp = [[SqlManager sharedManager] getImageListWithID:str_id];
//                NSString *str_largeImgAddress = [dic_temp objectForKey:@"largeImgAddress"];
//                if ([str_largeImgAddress length] < 1) {
//                    [self requestImage:dic_temp imgType:@"0"];
//                }
//                else{
//                    UIImage *img;
//                    NSString *str_imgAddress = [dic_temp objectForKey:@"largeImgAddress"];
//                    if ([str_imgAddress length] > 0) {
//                        NSFileManager *fileManager = [NSFileManager defaultManager];
//                        NSData *data_img = [fileManager contentsAtPath:str_imgAddress];
//                        img = [UIImage imageWithData:data_img];
//                    }
//                    else {
//                        //imgView.backgroundColor = [UIColor grayColor];
//                    }
//                    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(320*largeImgNum, 0, 320, 160)];
//                    imgView.backgroundColor = [UIColor grayColor];
//                    imgView.image = img;
//                    UILabel *lb_imgTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 130, 320, 30)];
//                    lb_imgTitle.textColor = [UIColor whiteColor];
//                    lb_imgTitle.text = [NSString stringWithFormat:@"  每日图片    %@",[dic_temp objectForKey:@"title"]];
//                    lb_imgTitle.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8f];
//                    [imgView addSubview:lb_imgTitle];
//                    largeImgNum ++;
//                    con_page.numberOfPages = largeImgNum;
//                    sclView_top.contentSize = CGSizeMake(320*largeImgNum, 160);
//                    [sclView_top addSubview:imgView];
//                    
//                    [arr_topImgs addObject:dic_temp];
//                }
//            }
//        }
    }
    else if ([str_operate isEqualToString:@"requestImgList"]) {
        NSError *error = nil;
        DDXMLDocument* xmlDoc = [[DDXMLDocument alloc] initWithXMLString:responseString options:0 error:&error];
        if (error) {
            NSLog(@"%@",[error localizedDescription]);
        }
        NSArray *arr_response = [xmlDoc nodesForXPath:@"//Response" error:&error];
        NSMutableArray *arr_total = [[NSMutableArray alloc] init];
        for (DDXMLElement *element_response in arr_response) {
            NSArray *arr_code = [element_response elementsForName:@"Code"];
            NSString *str_code = [[arr_code objectAtIndex:0] stringValue];
            NSArray *arr_items = [element_response elementsForName:@"Item"];
            NSMutableArray *arr_itemsSaved = [[NSMutableArray alloc] init];
            for (DDXMLElement *element_item in arr_items) {
                NSMutableDictionary *dic_itemSaved = [[NSMutableDictionary alloc] init];
                NSArray *arr_id = [element_item elementsForName:@"ID"];
                NSString *str_id = [[arr_id objectAtIndex:0] stringValue];
                [dic_itemSaved setObject:str_id forKey:@"id"];
                NSArray *arr_title = [element_item elementsForName:@"Title"];
                NSString *str_title = [[arr_title objectAtIndex:0] stringValue];
                [dic_itemSaved setObject:str_title forKey:@"title"];
                NSArray *arr_update = [element_item elementsForName:@"Update"];
                NSString *str_update = [[arr_update objectAtIndex:0] stringValue];
                [dic_itemSaved setObject:str_update forKey:@"createTime"];
                NSArray *arr_summary = [element_item elementsForName:@"Summary"];
                NSString *str_summary = [[arr_summary objectAtIndex:0] stringValue];
                [dic_itemSaved setObject:str_summary forKey:@"summary"];
                NSArray *arr_smallImg = [element_item elementsForName:@"SmallImage"];
                NSString *str_smallImg = [[arr_smallImg objectAtIndex:0] stringValue];
                [dic_itemSaved setObject:str_smallImg forKey:@"smallImgUrl"];
                NSArray *arr_largeImg = [element_item elementsForName:@"LargeImage"];
                NSString *str_largeImg = [[arr_largeImg objectAtIndex:0] stringValue];
                [dic_itemSaved setObject:str_largeImg forKey:@"largeImgUrl"];
                [arr_listID addObject:str_id];
                [arr_total addObject:dic_itemSaved];
                int result = [[SqlManager sharedManager] saveImageListInfo:dic_itemSaved isTopOrList:@"1"];
                NSMutableDictionary *dic_newInfo = [[NSMutableDictionary alloc] initWithDictionary:[[SqlManager sharedManager] getImageListWithID:str_id]];
                //102-更新 103-新增
                if (result == 102) {
                    for (int i = 0; i < [arr_imgList count]; i++) {
                        NSDictionary *dic_topImg = [arr_imgList objectAtIndex:i];
                        NSString *str_tempId = [dic_topImg objectForKey:@"id"];
                        if ([str_tempId isEqualToString:str_id] ) {
                            CustomImageView *imgView = (CustomImageView *)[dic_topImg objectForKey:@"imgView"];
                            [dic_newInfo setObject:imgView forKey:@"imgView"];
                            [arr_imgList replaceObjectAtIndex:i withObject:dic_newInfo];
//                            UIActivityIndicatorView *indView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
//                            [indView setCenter:imgView.center];
//                            indView.tag = 101;
//                            [indView startAnimating];
//                            [imgView addSubview:indView];
                            
                            [self requestImage:dic_newInfo imgType:@"1"];
                            break;
                        }
                    }
                }
                else if(result == 103)
                {
                    BOOL isExist = NO;
                    for (int i = 0; i < [arr_imgList count]; i++) {
                        NSDictionary *dic_topImg = [arr_imgList objectAtIndex:i];
                        NSString *str_tempId = [dic_topImg objectForKey:@"id"];
                        if ([str_tempId isEqualToString:str_id] ) {
                            isExist = YES;
                            break;
                        }
                    }
                    if (isExist == NO) {
                        NSDateFormatter *dateForm_time = [[NSDateFormatter alloc] init];
                        [dateForm_time setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
                        [dateForm_time setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                        for (int i = 0; i < [arr_imgList count]; i++) {
                            NSDictionary *dic_topImg = [arr_imgList objectAtIndex:i];
                            NSString *str_tempCreateTime = [dic_topImg objectForKey:@"createTime"];
                            NSDate *date_temp = [dateForm_time dateFromString:str_tempCreateTime];
                            NSDate *date_current = [dateForm_time dateFromString:str_update];
                            CustomImageView *imgView;
                            if ([date_current compare:date_temp] == NSOrderedDescending || i == [arr_imgList count] - 1) {
                                int row = i/3;
                                int col = i%3;
                                
                                imgView = [[CustomImageView alloc] initWithFrame:CGRectMake(5+105*col, 5+75*row, 100, 70) withID:str_id img:nil];
                                //                            UIActivityIndicatorView *indView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
                                //                            [indView setCenter:imgView.center];
                                //                            indView.tag = 101;
                                //                            [indView startAnimating];
                                //                            [imgView addSubview:indView];
                                [sclView_imgList addSubview:imgView];
                                
                                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)];
                                tap.numberOfTapsRequired = 1;
                                tap.numberOfTouchesRequired = 1;
                                tap.delegate = self;
                                [imgView addGestureRecognizer:tap];
                                
                                [dic_newInfo setObject:imgView forKey:@"imgView"];
                                if ([date_current compare:date_temp] == NSOrderedDescending) {
                                    [arr_imgList insertObject:dic_newInfo atIndex:i];
                                }
                                else if (i == [arr_imgList count] - 1) {
                                    [arr_imgList addObject:dic_newInfo];
                                }
                                
                                [self requestImage:dic_newInfo imgType:@"1"];
                                break;
                            }
                        }
                        if ([arr_imgList count] == 0) {              
                            CustomImageView *imgView = [[CustomImageView alloc] initWithFrame:CGRectMake(5, 5, 100, 70) withID:str_id img:nil];
                            //                        UIActivityIndicatorView *indView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
                            //                        [indView setCenter:imgView.center];
                            //                        indView.tag = 101;
                            //                        [indView startAnimating];
                            //                        [imgView addSubview:indView];
                            
                            [sclView_imgList addSubview:imgView];
                            
                            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)];
                            tap.numberOfTapsRequired = 1;
                            tap.numberOfTouchesRequired = 1;
                            tap.delegate = self;
                            [imgView addGestureRecognizer:tap];
                            
                            [dic_newInfo setObject:imgView forKey:@"imgView"];
                            [arr_imgList addObject:dic_newInfo];
                            
                            [self requestImage:dic_newInfo imgType:@"1"];
                        }
                        int rows = [arr_imgList count]/3;
                        sclView_imgList.contentSize = CGSizeMake(320, 5+75*(rows+1));
                        for (int i = 0; i < [arr_imgList count]; i++) {
                            NSDictionary *dic_topImg = [arr_imgList objectAtIndex:i];
                            CustomImageView *imgView = (CustomImageView *)[dic_topImg objectForKey:@"imgView"];
                            int row = i/3;
                            int col = i%3;
                            imgView.frame = CGRectMake(5+105*col, 5+75*row, 100, 70);
                        }
                    }
                }
            }
        }
        NSString *str_direction = [dic_userInfo objectForKey:@"direction"];
        if ([str_direction isEqualToString:@"before"]) {
            isGettingBefore = NO;
        }
        else if ([str_direction isEqualToString:@"later"]) {
            isGettingLater = NO;
        }
//        int result = [[SqlManager sharedManager] saveImagesList:arr_total isTopOrList:@"1"];
//        if (result == 0) {
//            for (int i = 0; i < [arr_listID count]; i++) {
//                NSString *str_id = [arr_listID objectAtIndex:i];
//                NSDictionary *dic_temp = [[SqlManager sharedManager] getImageListWithID:str_id];
//                NSString *str_smallImgAddress= [dic_temp objectForKey:@"smallImgAddress"];
//                if ([str_smallImgAddress length] < 1) {
//                    [self requestImage:dic_temp imgType:@"1"];
//                }
//                else{
//                    UIImage *img;
//                    NSString *str_imgAddress = [dic_temp objectForKey:@"smallImgAddress"];
//                    if ([str_imgAddress length] > 0) {
//                        NSFileManager *fileManager = [NSFileManager defaultManager];
//                        NSData *data_img = [fileManager contentsAtPath:str_imgAddress];
//                        img = [UIImage imageWithData:data_img];
//                    }
//                    else {
//                        img = [UIImage imageNamed:@"defaultLoading.png"];
//                    }
//                    UIButton *btn_temp = [UIButton buttonWithType:UIButtonTypeCustom];
//                    int row = [arr_buttons count]/3;
//                    int col = [arr_buttons count]%3;
//                    btn_temp.frame = CGRectMake(5+105*col, 5+75*row, 100, 70);
//                    [btn_temp setBackgroundColor:[UIColor grayColor]];
//                    [btn_temp setBackgroundImage:img forState:UIControlStateNormal];
//                    [btn_temp addTarget:self action:@selector(turnToDetail:) forControlEvents:UIControlEventTouchUpInside];
//                    sclView_imgList.contentSize = CGSizeMake(320, 5+75*(row+1));
//                    [sclView_imgList addSubview:btn_temp];
//                    
//                    [arr_imgList addObject:dic_temp];
//                    
//                    [arr_buttons addObject:btn_temp];
//                }
//            }
//        }
        
    }
    else if ([str_operate isEqualToString:@"downloadImg"]) {
        UIImage *img = [[UIImage alloc] initWithData:request.responseData];
        NSString *str_imgType = [dic_userInfo objectForKey:@"imgType"];
        NSString *str_id = [dic_userInfo objectForKey:@"id"];
        NSString *str_fileName = request.url.lastPathComponent;
        str_fileName = [NSString stringWithFormat:@"%@@2x%@",[str_fileName substringToIndex:[str_fileName length] -4],[str_fileName substringFromIndex:[str_fileName length]-4]];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *str_address = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/Caches/Image/%@",str_fileName]];
        if ([[SqlManager sharedManager] saveDoc:request.responseData address:str_address] == YES) {
            [[SqlManager sharedManager] saveImagesImg:str_id imgAddress:str_address imgType:[str_imgType intValue]];
        }
        NSMutableDictionary *dic_newInfo = [[NSMutableDictionary alloc] initWithDictionary:[[SqlManager sharedManager] getImageListWithID:str_id]];
        CustomImageView *imgView = (CustomImageView *)[dic_userInfo objectForKey:@"imgView"];
        imgView.img = img;
//        if ([str_imgType isEqualToString:@"0"]) {
//            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(320*largeImgNum, 0, 320, 160)];
//            imgView.image = img;
//            UILabel *lb_imgTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 130, 320, 30)];
//            lb_imgTitle.textColor = [UIColor whiteColor];
//            lb_imgTitle.text = [NSString stringWithFormat:@"  每日图片    %@",[dic_item objectForKey:@"title"]];
//            lb_imgTitle.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8f];
//            [imgView addSubview:lb_imgTitle];
//            largeImgNum ++;
//            con_page.numberOfPages = largeImgNum;
//            sclView_top.contentSize = CGSizeMake(320*largeImgNum, 160);
//            [sclView_top addSubview:imgView];
//            
//            [arr_topImgs addObject:dic_item];
//        }
//        else if ([str_imgType isEqualToString:@"1"]) {
//            UIButton *btn_temp = [UIButton buttonWithType:UIButtonTypeCustom];
//            int row = [arr_buttons count]/3;
//            int col = [arr_buttons count]%3;
//            btn_temp.frame = CGRectMake(5+105*col, 5+75*row, 100, 70);
//            [btn_temp setBackgroundImage:img forState:UIControlStateNormal];
//            [btn_temp addTarget:self action:@selector(turnToDetail:) forControlEvents:UIControlEventTouchUpInside];
//            sclView_imgList.contentSize = CGSizeMake(320, 5+75*(row+1));
//            [sclView_imgList addSubview:btn_temp];
//            
//            [arr_imgList addObject:dic_item];
//            
//            [arr_buttons addObject:btn_temp];
//        }
    }
}


//ASIHTTPRequestDelegate,下载失败
- (void)requestFailed:(ASIHTTPRequest *)request {
    //    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" 
    //                                                        message:@"下载失败，请检查网络状况"
    //                                                       delegate:self 
    //                                              cancelButtonTitle:@"确定"
    //                                              otherButtonTitles:nil];
    //    
    //    [alertView show];
    NSDictionary *dic_userInfo = request.userInfo;
    NSString *str_operate = [dic_userInfo objectForKey:@"operate"];
    if ([str_operate isEqualToString:@"downloadImg"]) {
        NSLog(@"fail:%@",dic_userInfo);
        NSString *str_type = [dic_userInfo objectForKey:@"imgType"];
        //[self requestImage:dic_userInfo imgType:str_type];
    }
    else {
        if ([indViewLarge isAnimating] == YES) {
            [indViewLarge stopAnimating];
        }
    }
}

-(void)cancelAllRequests
{
    for (int i = 0; i < [arr_requests count]; i++) {
        ASIHTTPRequest *request = [arr_requests objectAtIndex:i];
        [request cancel];
    }
    [arr_requests removeAllObjects];
}

#pragma mark -
#pragma mark UIGestureRecognizer
-(void)tapLargeImage:(id)sender
{
    UITapGestureRecognizer *tap = (UITapGestureRecognizer *)sender;
//    CustomImageView *view = (CustomImageView *)tap.view;
//    NSLog(@"CustomImageView:%@",view.str_id);
    int index = [tap locationInView:tap.view].x/320;
    if ([arr_topImgs count] >= index +1) {
        NSMutableDictionary *dic_news = [arr_topImgs objectAtIndex:index];
        ImageDetailViewController *con_detail = [[ImageDetailViewController alloc] init];
        con_detail.str_id = [dic_news objectForKey:@"id"];
    
        [self.navigationController pushViewController:con_detail animated:YES]; 
    }
}

-(void)tapImage:(id)sender
{
    UITapGestureRecognizer *tap = (UITapGestureRecognizer *)sender;
    CustomImageView *imgView = (CustomImageView *)tap.view;
    ImageDetailViewController *con_detail = [[ImageDetailViewController alloc] init];
    con_detail.str_id = imgView.str_id;
    [self.navigationController pushViewController:con_detail animated:YES];
}


#pragma mark -
#pragma mark scrollview

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // We don't want a "feedback loop" between the UIPageControl and the scroll delegate in
    // which a scroll event generated from the user hitting the page control triggers updates from
    // the delegate method. We use a boolean to disable the delegate logic when the page control is used.
    if (scrollView == sclView_imgList) {

    }
    else if (scrollView == sclView_top) {
        if (scrollView.pagingEnabled == NO) {
            // do nothing - the scroll was initiated from the page control, not the user dragging
            return;
        }
        
        // Switch the indicator when more than 50% of the previous/next page is visible
        int index = fabs(scrollView.contentOffset.x) / scrollView.frame.size.width;
        
        con_page.currentPage = index;
    }
    
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    
    
    // A possible optimization would be to unload the views+controllers which are no longer visible
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView 
{
    if (scrollView == sclView_imgList) {
        if (scrollView.contentOffset.y + scrollView.frame.size.height == scrollView.contentSize.height) {
            if (isGettingBefore == NO) {
                [self requestImgList:@"before"];
                isGettingBefore = YES;
            }
        }
        else if (scrollView.contentOffset.y == 0) {
            if (isGettingLater == NO) {
                [self requestImgList:@"later"];
                isGettingLater = YES;
            }
        }
    }
}

@end
