//
//  SearchViewController_IPad.m
//  JingYingCar
//
//  Created by JiaMing Yan on 12-4-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SearchViewController_IPad.h"
#import "CustomImageView_IPad.h"

@interface SearchViewController_IPad ()

@end

@implementation SearchViewController_IPad

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
    indViewLarge = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [indViewLarge setCenter:self.view.center];
    [self.view addSubview:indViewLarge];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //self.title = @"搜索";
    
    [self.navigationController setNavigationBarHidden:YES];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"blackBackground_ipad.png"]];
    
    UIView *view_nav = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 768, 45)];
    view_nav.backgroundColor = [UIColor clearColor];
    [self.view addSubview:view_nav];
    
    UIImageView *imgView_navBK = [[UIImageView alloc] initWithFrame:view_nav.bounds];
    imgView_navBK.image = [UIImage imageNamed:@"hostNav_ipad.png"];
    [view_nav addSubview:imgView_navBK];
    
    UIButton *btn_back = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_back.frame = CGRectMake(10, 7.5f, 55, 30);
    [btn_back setBackgroundImage:[UIImage imageNamed:@"back_ipad.png"] forState:UIControlStateNormal];
    //[btn_back setTitle:@" 返回" forState:UIControlStateNormal];
    [btn_back addTarget:self action:@selector(turnBack) forControlEvents:UIControlEventTouchUpInside];
    [btn_back setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn_back.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    btn_back.titleLabel.textAlignment = UITextAlignmentRight;
    [view_nav addSubview:btn_back];
    
    UIView *view_content = [[UIView alloc] initWithFrame:CGRectMake(0, 90, 768, 915)];
    view_content.backgroundColor = [UIColor clearColor];
    [self.view addSubview:view_content];
    
    schBar = [[UISearchBar alloc] init];
    schBar.frame = CGRectMake(0, 45, 768, 45);
    schBar.tintColor = [UIColor colorWithRed:0.721 green:0.76 blue:0.788 alpha:1];
    schBar.delegate = self;
    [self.view addSubview:schBar];
    
    sclView_imgList = [[UIScrollView alloc] initWithFrame:view_content.bounds];
    sclView_imgList.contentSize = view_content.frame.size;
    sclView_imgList.pagingEnabled = NO;
    sclView_imgList.directionalLockEnabled = YES;
    sclView_imgList.delegate = self;
    [view_content addSubview:sclView_imgList];
    
    arr_result = [[NSMutableArray alloc] init];
    
    [schBar becomeFirstResponder];
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
    //[self.navigationController popViewControllerAnimated:YES];
    //[delegate hideSearchView:self.view];
    [self cancelAllRequests];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark searchbar
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [arr_result removeAllObjects];
    [schBar resignFirstResponder];
    [self requestSearch];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if ([searchText length] == 0) {
        [arr_result removeAllObjects];
    }
}

#pragma mark -
#pragma mark connection
-(void)requestSearch
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
    NSString *httpBodyString = [self searchRequestBody];
	NSLog(@"request search  httpBodyString :%@",httpBodyString);
	
    NSData *postData = [httpBodyString dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *dic_userInfo = [[NSMutableDictionary alloc] init];
    [dic_userInfo setObject:@"search" forKey:@"operate"];
    [request setUserInfo:dic_userInfo];
    [request setPostBody:postData];
    [request setRequestMethod:@"POST"];
    //添加到ASINetworkQueue队列去下载
    AppDelegate_IPad *app = (AppDelegate_IPad *)[UIApplication sharedApplication].delegate;
	[app.netWorkQueue addOperation:request];
    [arr_requests addObject:request];
}

-(NSString *)searchRequestBody
{
    DDXMLNode *node_operate = [DDXMLNode elementWithName:@"Operate" stringValue:@"Search"];
    DDXMLNode *node_device = [DDXMLNode elementWithName:@"Device" stringValue:@"ipad"];
    DDXMLNode *node_keyWord = [DDXMLNode elementWithName:@"Keyword" stringValue:schBar.text];
    NSArray *arr_request = [[NSArray alloc] initWithObjects:node_operate,node_device,node_keyWord,nil];
    DDXMLElement *element_request = [[DDXMLElement alloc] initWithName: @"Request"];
    [element_request setChildren:arr_request];
    return [element_request XMLString];
}

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
    AppDelegate_IPad *app = (AppDelegate_IPad *)[UIApplication sharedApplication].delegate;
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
    NSLog(@"responseString5:%@",responseString);
    
    if ([indViewLarge isAnimating] == YES) {
        [indViewLarge stopAnimating];
    }
    
    if ([str_operate isEqualToString:@"search"]) {
        NSError *error = nil;
        DDXMLDocument* xmlDoc = [[DDXMLDocument alloc] initWithXMLString:responseString options:0 error:&error];
        if (error) {
            NSLog(@"%@",[error localizedDescription]);
        }
        NSArray *arr_response = [xmlDoc nodesForXPath:@"//Response" error:&error];
        
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
                NSArray *arr_image = [element_item elementsForName:@"Image"];
                NSString *str_image = [[arr_image objectAtIndex:0] stringValue];
                [dic_itemSaved setObject:str_image forKey:@"smallImgUrl"];
                NSArray *arr_class = [element_item elementsForName:@"Class"];
                NSString *str_class = [[arr_class objectAtIndex:0] stringValue];
                [dic_itemSaved setObject:str_class forKey:@"class"];
                NSArray *arr_fatherID = [element_item elementsForName:@"FatherID"];
                NSString *str_fatherID = [[arr_fatherID objectAtIndex:0] stringValue];
                [dic_itemSaved setObject:str_fatherID forKey:@"fatherID"];
                
                int result = [[SqlManager sharedManager] saveTopicInfo:dic_itemSaved];
                NSMutableDictionary *dic_newInfo = [[NSMutableDictionary alloc] initWithDictionary:[[SqlManager sharedManager] getTopicListWithID:str_id]];
                NSDateFormatter *dateForm_time = [[NSDateFormatter alloc] init];
                [dateForm_time setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
                [dateForm_time setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                for (int i = 0; i < [arr_result count]; i++) {
                    NSDictionary *dic_topImg = [arr_result objectAtIndex:i];
                    NSString *str_tempCreateTime = [dic_topImg objectForKey:@"createTime"];
                    NSDate *date_temp = [dateForm_time dateFromString:str_tempCreateTime];
                    NSDate *date_current = [dateForm_time dateFromString:str_update];
                    if ([date_current compare:date_temp] == NSOrderedDescending) {
                        [arr_result insertObject:dic_newInfo atIndex:i];
                        break;
                    }
                    else if(i == [arr_result count] - 1) 
                    {
                        [arr_result addObject:dic_newInfo];
                        break;
                    }
                }
                if ([arr_result count] == 0) {
                    [arr_result addObject:dic_newInfo];
                }
                //[tbl_result reloadData];
                [self reloadSearchResultViews];
            }
        }
        if ([arr_result count] > 0) {
            //tbl_result.hidden = NO;
        }
    }
    else if ([str_operate isEqualToString:@"downloadImg"]) {
        NSString *str_newsId = [dic_userInfo objectForKey:@"id"];
        NSString *str_fileName = request.url.lastPathComponent;
        str_fileName = [NSString stringWithFormat:@"%@@2x%@",[str_fileName substringToIndex:[str_fileName length] -4],[str_fileName substringFromIndex:[str_fileName length]-4]];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *str_address = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/Caches/Topic/%@",str_fileName]];
        if ([[SqlManager sharedManager] saveDoc:request.responseData address:str_address] == YES) {
            [[SqlManager sharedManager] saveTopicImage:str_newsId imgAddress:str_address];
        }
        NSDictionary *dic_item = [[SqlManager sharedManager] getTopicListWithID:str_newsId];
        for (int i = 0; i < [arr_result count]; i++) {
            NSDictionary *dic_temp = [arr_result objectAtIndex:i];
            NSString *str_tempID = [dic_temp objectForKey:@"id"];
            if ([str_newsId isEqualToString:str_tempID]) {
                [arr_result replaceObjectAtIndex:i withObject:dic_item];
            }
        }
        //[tbl_result reloadData];
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
    if ([indViewLarge isAnimating] == YES) {
        [indViewLarge stopAnimating];
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

-(void)reloadSearchResultViews
{
    NSArray *arr_subviews = [sclView_imgList subviews];
    for (int i = 0; i < [arr_subviews count]; i++) {
        UIView *view = [arr_subviews objectAtIndex:i];
        [view removeFromSuperview];
    }
    for (int i = 0; i < [arr_result count]; i++) {
        NSDictionary *dic_info = [arr_result objectAtIndex:i];
        NSString *str_id = [dic_info objectForKey:@"id"];
        NSString *str_title = [dic_info objectForKey:@"title"];
        NSString *str_summary = [dic_info objectForKey:@"summary"];
        NSString *str_time = [dic_info objectForKey:@"createTime"];
        NSString *str_smallImgAddress = [dic_info objectForKey:@"smallImgAddress"];
        
        int row = i/2;
        int col = i%2;
        UIImage *img;
        if ([str_smallImgAddress length] > 0) {
            img = [UIImage imageWithContentsOfFile:str_smallImgAddress]; 
        }
        else {
            [self requestImage:dic_info imgType:@"1"];
        }
        CustomImageView_IPad *imgView = [[CustomImageView_IPad alloc] initWithFrame:CGRectMake(16+376*col, 16+216*row, 360, 200) withID:str_id img:img];
        [sclView_imgList addSubview:imgView];
        
        UIImageView *imgView_arrow = [[UIImageView alloc] initWithFrame:CGRectMake(315, 5, 40, 40)];
        imgView_arrow.image = [UIImage imageNamed:@"arrow_ipad.png"];
        [imgView addSubview:imgView_arrow];
        
        UIView *view_summary = [[UIView alloc] initWithFrame:CGRectMake(0, 120, 360, 80)];
        view_summary.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8f];
        [imgView addSubview:view_summary];
        
        UILabel *lb_title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 360, 30)];
        lb_title.backgroundColor = [UIColor clearColor];
        lb_title.font = [UIFont boldSystemFontOfSize:20];
        lb_title.textColor = [UIColor whiteColor];
        lb_title.text = str_title;
        [view_summary addSubview:lb_title];
        
        UILabel *lb_summary = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, 360, 25)];
        lb_summary.backgroundColor = [UIColor clearColor];
        lb_summary.font = [UIFont boldSystemFontOfSize:17];
        lb_summary.textColor = [UIColor whiteColor];
        lb_summary.text = str_summary;
        [view_summary addSubview:lb_summary];
        
        UILabel *lb_time = [[UILabel alloc] initWithFrame:CGRectMake(0, 55, 360, 25)];
        lb_time.backgroundColor = [UIColor clearColor];
        lb_time.font = [UIFont boldSystemFontOfSize:17];
        lb_time.textColor = [UIColor colorWithRed:0.196f green:0.008f blue:0.486f alpha:1];
        lb_time.text = [str_time substringToIndex:10];
        [view_summary addSubview:lb_time];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        tap.delegate = self;
        [imgView addGestureRecognizer:tap];
    }
}

#pragma mark -
#pragma mark UIGestureRecognizer
-(void)tapImage:(id)sender
{
    UITapGestureRecognizer *tap = (UITapGestureRecognizer *)sender;
    CustomImageView_IPad *imgView = (CustomImageView_IPad *)tap.view;
    TopicDetailViewController_IPad *con_detail = [[TopicDetailViewController_IPad alloc] init];
    
    con_detail.str_id = imgView.str_id;
    
    [self.navigationController pushViewController:con_detail animated:YES]; 
}

@end
