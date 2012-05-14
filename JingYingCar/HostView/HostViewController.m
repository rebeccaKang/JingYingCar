//
//  HostViewController.m
//  JingYingCar
//
//  Created by JiaMing Yan on 12-4-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "HostViewController.h"
#import "CustomImageView.h"

static UIImage *barImage = nil;
@implementation UINavigationBar (CustomImage)

- (void) drawRect: (CGRect)rect
{
    if (barImage != nil)
    {
        [barImage drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        barImage = nil;
    }
    else
    {
        //        UIColor *color = [UIColor redColor];
        //        CGContextRef context = UIGraphicsGetCurrentContext();
        //        CGContextSetFillColor(context, CGColorGetComponents( [color CGColor]));
        //        CGContextFillRect(context, rect);
        //        self.tintColor = color;
    }
    
}

- (void) setImage: (NSString *)image
{
    barImage = [ UIImage imageNamed:image];
    [self setNeedsDisplay];
}
@end

@interface HostViewController ()

@end

@implementation HostViewController

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
    
    NSArray *arr_history = [[SqlManager sharedManager] getHotNewsList];
    arr_news = [[NSMutableArray alloc] initWithArray:[arr_history objectAtIndex:1]];
    arr_largeImage = [[NSMutableArray alloc] initWithArray:[arr_history objectAtIndex:0]];
    
    indViewLarge = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [indViewLarge setCenter:self.view.center];
    [self.view addSubview:indViewLarge];
    
    if ([arr_news count] == 0) {
        [self requestHotNews:@"before"];
    }
    
    [self requestHotNewsTop];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    NSLog(@"hotnews");
    
//    NSString *str_version = [UIDevice currentDevice].systemVersion;
//    if ([str_version intValue] > 4) {
//        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navDefault.png"] forBarMetrics:UIBarMetricsDefault];
//        UILabel *lb_title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 55)];
//        lb_title.backgroundColor = [UIColor clearColor];
//        lb_title.font = [UIFont boldSystemFontOfSize:24];
//        lb_title.textAlignment = UITextAlignmentCenter;
//        //lb_title.text = @"精英车主";
//        [self.navigationController.navigationBar addSubview:lb_title];
//
//    }
//    else {
//        [self.navigationController.navigationBar setImage:@"navDefault.png"];
//    }
    
    //UILabel *lb_title = (UILabel *)[self.navigationController.navigationBar viewWithTag:0];
    //lb_title.text = @"精英车主";
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
    
    arr_topID = [[NSMutableArray alloc] init];
    arr_listID = [[NSMutableArray alloc] init];
    
    UIView *view_nav = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 45)];
    view_nav.backgroundColor = [UIColor clearColor];
    [self.view addSubview:view_nav];
    
    UIImageView *imgView_navBK = [[UIImageView alloc] initWithFrame:view_nav.bounds];
    imgView_navBK.image = [UIImage imageNamed:@"navDefault.png"];
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
    
    UIView *view_content = [[UIView alloc] initWithFrame:CGRectMake(0, 45, 320, 370)];
    view_content.backgroundColor = [UIColor clearColor];
    [self.view addSubview:view_content];
    
    sclView_largeImage = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 160)];
    sclView_largeImage.contentSize = CGSizeMake(320, 160);
    sclView_largeImage.pagingEnabled = YES;
    sclView_largeImage.showsHorizontalScrollIndicator = NO;
    sclView_largeImage.showsVerticalScrollIndicator = NO;
    sclView_largeImage.scrollsToTop = NO;
    sclView_largeImage.directionalLockEnabled = YES;
    sclView_largeImage.delegate = self;
    [view_content addSubview:sclView_largeImage];
    
    for (int i = 0; i < [arr_largeImage count]; i++) {
        NSMutableDictionary *dic_info = [[NSMutableDictionary alloc] initWithDictionary:[arr_largeImage objectAtIndex:i]];
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
        lb_imgTitle.text = [NSString stringWithFormat:@"%@",[dic_info objectForKey:@"title"]];
        lb_imgTitle.backgroundColor = [UIColor clearColor];
        [view_imgTitle addSubview:lb_imgTitle];
        [sclView_largeImage addSubview:imgView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        tap.delegate = self;
        [imgView addGestureRecognizer:tap];
        
        [arr_largeImage replaceObjectAtIndex:i withObject:dic_info];
    }
    
    con_page = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 105, 320, 20)];
    con_page.numberOfPages = 0;
    con_page.currentPage = 0;
    con_page.backgroundColor = [UIColor clearColor];
    [view_content addSubview:con_page];
    
//    imgView_largePic = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 120)];
//    imgView_largePic.image = [UIImage imageNamed:@""];
//    [self.view addSubview:imgView_largePic];
    
    lb_largePic = [[UILabel alloc] initWithFrame:CGRectMake(0, 120, 320, 40)];
    lb_largePic.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8];
    lb_largePic.font = [UIFont systemFontOfSize:14];
    
    tbl_hotNews = [[UITableView alloc] initWithFrame:CGRectMake(0, 160, 320, 205) style:UITableViewStylePlain];
    tbl_hotNews.backgroundColor = [UIColor whiteColor];
    tbl_hotNews.delegate = self;
    tbl_hotNews.dataSource = self;
    tbl_hotNews.bounces = YES;
    [view_content addSubview:tbl_hotNews];
    
    [self.view bringSubviewToFront:indViewLarge];
    
//    con_setting = [[SettingViewController alloc] init];
//    con_setting.view.frame = CGRectMake(0, 480, 320, 480);
//    con_setting.delegate = self;
//    //[self.view addSubview:con_setting.view];
//    
//    con_search = [[SearchViewController alloc] init];
//    con_search.view.frame = CGRectMake(0, 480, 320, 480);
//    con_search.delegate = self;
//    //[self.view addSubview:con_search.view];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSString *str_shouldRequest = [app.arr_shouldRequest objectAtIndex:0];
    if ([str_shouldRequest isEqualToString:@"0"]) {
        //[self requestHotNews];
        [self requestHotNewsTop];
    }
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
//    CATransition *transition = [CATransition animation];
//    transition.duration = 0.5f;
//    transition.timingFunction = UIViewAnimationCurveEaseInOut;
//	transition.fillMode = kCAFillModeForwards;
//    transition.type = kCATransitionMoveIn;
//    transition.subtype = kCATransitionFromTop;
//    [self.navigationController.view.layer addAnimation:transition forKey:nil];
//    [self.navigationController pushViewController:con_seach animated:NO];
//    [self.view addSubview:con_search.view];
//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationDuration:0.4f];
//    con_search.view.frame = CGRectMake(0, 0, 320, 480);
//    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:con_search.view cache:NO];
//    [UIView commitAnimations];
    UINavigationController *nav_search = [[UINavigationController alloc] initWithRootViewController:con_search];
    [self presentViewController:nav_search animated:YES completion:nil];
}

-(void)showSetting
{
    SettingViewController *con_setting = [[SettingViewController alloc] init];
    UINavigationController *nav_setting = [[UINavigationController alloc] initWithRootViewController:con_setting];
    [self presentViewController:nav_setting animated:YES completion:nil];
}

#pragma mark - Table view data source
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    view.backgroundColor = [UIColor colorWithWhite:0.2 alpha:1];
    UILabel *lb_header = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 180, 30)];
    lb_header.text = @"最新动态资讯 NEWS";
    lb_header.textColor = [UIColor colorWithRed:0.99 green:0.878 blue:0.0 alpha:1.0];
    lb_header.font = [UIFont boldSystemFontOfSize:14];
    lb_header.backgroundColor = [UIColor clearColor];
    [view addSubview:lb_header];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [arr_news count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        CustomImageView *imgView = [[CustomImageView alloc] initWithFrame:CGRectMake(15, 5, 80, 50) withID:@"" img:nil];
        imgView.tag = 10;
        [cell addSubview:imgView];
        
        UILabel *lb_title = [[UILabel alloc] initWithFrame:CGRectMake(110, 0, 180, 20)];
        lb_title.textColor = [UIColor grayColor];
        lb_title.font = [UIFont systemFontOfSize:12];
        lb_title.backgroundColor = [UIColor clearColor];
        lb_title.tag = 1;
        [cell addSubview:lb_title];
        
        UILabel *lb_summary = [[UILabel alloc] initWithFrame:CGRectMake(110, 20, 180, 20)];
        lb_summary.textColor = [UIColor blackColor];
        lb_summary.font = [UIFont systemFontOfSize:14];
        lb_summary.backgroundColor = [UIColor clearColor];
        lb_summary.tag = 2;
        [cell addSubview:lb_summary];
        
        UILabel *lb_update = [[UILabel alloc] initWithFrame:CGRectMake(110, 40, 180, 20)];
        lb_update.textColor = [UIColor colorWithRed:0.384 green:0.286 blue:0.224 alpha:1];
        lb_update.font = [UIFont systemFontOfSize:12];
        lb_update.backgroundColor = [UIColor clearColor];
        lb_update.tag = 3;
        [cell addSubview:lb_update];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    if (arr_news.count > indexPath.row) {
        NSDictionary *dic_news = [arr_news objectAtIndex:indexPath.row];
        
        CustomImageView *imgView = (CustomImageView *)[cell viewWithTag:10];
        UIImage *img;
        NSString *str_imgAddress = [dic_news objectForKey:@"smallImgAddress"];
        if ([str_imgAddress length] > 0) {
            img = [UIImage imageWithContentsOfFile:str_imgAddress];
            imgView.img = img;
        }
        else {
            [self requestImage:dic_news imgType:@"1"];
        }
        
        UILabel *lb_title = (UILabel *)[cell viewWithTag:1];
        lb_title.text = [dic_news objectForKey:@"title"];
        
        UILabel *lb_summary = (UILabel *)[cell viewWithTag:2];
        lb_summary.text = [dic_news objectForKey:@"summary"];
        
        UILabel *lb_update = (UILabel *)[cell viewWithTag:3];
        lb_update.text = [[dic_news objectForKey:@"createTime"] substringToIndex:10];
    }
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    
    if ([arr_news count] >= indexPath.row +1) {
        TopicDetailViewController *con_detail = [[TopicDetailViewController alloc] init];
        
        NSDictionary *dic_news = [arr_news objectAtIndex:indexPath.row];
        con_detail.str_id = [dic_news objectForKey:@"id"];
        con_detail.type = 0;
        
        [self.navigationController pushViewController:con_detail animated:YES];
        //self.tabBarController.tabBar.hidden = YES;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark connection
-(void)requestHotNews:(NSString *)direction
{
    if ([direction length] == 0) {
        return;
    }
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
    NSString *httpBodyString = [self setGetHotNewsRequestBody:direction];
	NSLog(@"request hotNews  httpBodyString :%@",httpBodyString);
	
    NSData *postData = [httpBodyString dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *dic_userInfo = [[NSMutableDictionary alloc] init];
    [dic_userInfo setObject:@"GetHotNews" forKey:@"operate"];
    [dic_userInfo setObject:direction forKey:@"direction"];
    [request setUserInfo:dic_userInfo];
    [request setPostBody:postData];
    [request setRequestMethod:@"POST"];
    //添加到ASINetworkQueue队列去下载
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
	[app.netWorkQueue addOperation:request];
}

-(void)requestHotNewsTop
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
    NSString *httpBodyString = [self hotNewsTopRequestBody];
	NSLog(@"request hotNewsTop  httpBodyString :%@",httpBodyString);
	
    NSData *postData = [httpBodyString dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *dic_userInfo = [[NSMutableDictionary alloc] init];
    [dic_userInfo setObject:@"GetHotNewsTop" forKey:@"operate"];
    [request setUserInfo:dic_userInfo];
    [request setPostBody:postData];
    [request setRequestMethod:@"POST"];
    //添加到ASINetworkQueue队列去下载
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
	[app.netWorkQueue addOperation:request];
    NSLog(@"hotnews");
}

-(NSString *)setGetHotNewsRequestBody:(NSString *)str_direction
{
    NSString *strTime = @"";
    if ([arr_news count] > 0) {
        NSDictionary *dic_temp;
        if ([str_direction isEqualToString:@"before"]) {
            dic_temp = [arr_news objectAtIndex:[arr_news count]-1];
        }
        else if ([str_direction isEqualToString:@"later"]) {
            dic_temp = [arr_news objectAtIndex:0];
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
    DDXMLNode *node_operate = [DDXMLNode elementWithName:@"Operate" stringValue:@"GetHotNews"];
    DDXMLNode *node_direction = [DDXMLNode elementWithName:@"Direction" stringValue:str_direction];
    DDXMLNode *node_update = [DDXMLNode elementWithName:@"Update" stringValue:strTime];
    NSArray *arr_request = [[NSArray alloc] initWithObjects:node_operate,node_direction,node_update,nil];
    DDXMLElement *element_request = [[DDXMLElement alloc] initWithName: @"Request"];
    [element_request setChildren:arr_request];
    return [element_request XMLString];
}

-(NSString *)hotNewsTopRequestBody
{
    DDXMLNode *node_operate = [DDXMLNode elementWithName:@"Operate" stringValue:@"GetHotNewsTop"];
    NSArray *arr_request = [[NSArray alloc] initWithObjects:node_operate,nil];
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
    NSLog(@"str_operate:%@",str_operate);
    
    NSData *_data = request.responseData;
    NSString *responseString = [[NSString alloc] initWithData:_data encoding:NSUTF8StringEncoding];
    NSLog(@"responseString2:%@",responseString);
    
    if ([indViewLarge isAnimating] == YES) {
        [indViewLarge stopAnimating];
    }
    
    if ([str_operate isEqualToString:@"GetHotNewsTop"]) {
        NSError *error = nil;
        DDXMLDocument* xmlDoc = [[DDXMLDocument alloc] initWithXMLString:responseString options:0 error:&error];
        if (error) {
            NSLog(@"%@",[error localizedDescription]);
        }
        else {
            [[SqlManager sharedManager] initHotNewsLastShow];
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
                NSArray *arr_class = [element_item elementsForName:@"Class"];
                NSString *str_class = [[arr_class objectAtIndex:0] stringValue];
                [dic_itemSaved setObject:str_class forKey:@"class"];
                [arr_topID addObject:str_id];
                [arr_total addObject:dic_itemSaved];
                int result = [[SqlManager sharedManager] saveHotNewsListInfo:dic_itemSaved isTopOrList:@"0"];
                NSMutableDictionary *dic_newInfo = [[NSMutableDictionary alloc] initWithDictionary:[[SqlManager sharedManager] getNewsListWithID:str_id]];
                if (result == 102) {
                    for (int i = 0; i < [arr_largeImage count]; i++) {
                        NSDictionary *dic_topImg = [arr_largeImage objectAtIndex:i];
                        NSString *str_tempId = [dic_topImg objectForKey:@"id"];
                        if ([str_tempId isEqualToString:str_id] ) {
                            CustomImageView *imgView = (CustomImageView *)[dic_topImg objectForKey:@"imgView"];
                            [dic_newInfo setObject:imgView forKey:@"imgView"];
                            [arr_largeImage replaceObjectAtIndex:i withObject:dic_newInfo];
                            [self requestImage:dic_newInfo imgType:@"0"];
                            break;
                        }
                    }
                }
                else if(result == 103)
                {
                    NSDateFormatter *dateForm_time = [[NSDateFormatter alloc] init];
                    [dateForm_time setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
                    [dateForm_time setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                    for (int i = 0; i < [arr_largeImage count]; i++) {
                        NSDictionary *dic_topImg = [arr_largeImage objectAtIndex:i];
                        NSString *str_tempCreateTime = [dic_topImg objectForKey:@"createTime"];
                        NSDate *date_temp = [dateForm_time dateFromString:str_tempCreateTime];
                        NSDate *date_current = [dateForm_time dateFromString:str_update];
                        CustomImageView *imgView;
                        if ([date_current compare:date_temp] == NSOrderedDescending || i == [arr_largeImage count] - 1) {
                            imgView = [[CustomImageView alloc] initWithFrame:CGRectMake(320*i, 0, 320, 160) withID:str_id img:nil];
                            
                            UIView *view_imgTitle = [[UIView alloc] initWithFrame:CGRectMake(0, 130, 320, 30)];
                            view_imgTitle.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8f];
                            [imgView addSubview:view_imgTitle];
                            
                            UILabel *lb_imgTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 310, 30)];
                            lb_imgTitle.textColor = [UIColor whiteColor];
                            lb_imgTitle.text = [NSString stringWithFormat:@"%@",[dic_newInfo objectForKey:@"title"]];
                            lb_imgTitle.backgroundColor = [UIColor clearColor];
                            [view_imgTitle addSubview:lb_imgTitle];
                            [sclView_largeImage addSubview:imgView];
                            
                            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)];
                            tap.numberOfTapsRequired = 1;
                            tap.numberOfTouchesRequired = 1;
                            tap.delegate = self;
                            [imgView addGestureRecognizer:tap];
                            
                            [dic_newInfo setObject:imgView forKey:@"imgView"];
                            if ([date_current compare:date_temp] == NSOrderedDescending) {
                                [arr_largeImage insertObject:dic_newInfo atIndex:i];
                            }
                            else if(i == [arr_largeImage count] - 1)
                            {
                                [arr_largeImage addObject:dic_newInfo];
                            }
                            
                            
                            [self requestImage:dic_newInfo imgType:@"0"];
                            break;
                        }
                    }
                    if ([arr_largeImage count] == 0) {
                        CustomImageView *imgView = [[CustomImageView alloc] initWithFrame:CGRectMake(320, 0, 320, 160) withID:str_id img:nil];
                        UIView *view_imgTitle = [[UIView alloc] initWithFrame:CGRectMake(0, 130, 320, 30)];
                        view_imgTitle.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8f];
                        [imgView addSubview:view_imgTitle];
                        
                        UILabel *lb_imgTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 310, 30)];
                        lb_imgTitle.textColor = [UIColor whiteColor];
                        lb_imgTitle.text = [NSString stringWithFormat:@"%@",[dic_newInfo objectForKey:@"title"]];
                        lb_imgTitle.backgroundColor = [UIColor clearColor];
                        [view_imgTitle addSubview:lb_imgTitle];
                        [sclView_largeImage addSubview:imgView];
                        
                        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)];
                        tap.numberOfTapsRequired = 1;
                        tap.numberOfTouchesRequired = 1;
                        tap.delegate = self;
                        [imgView addGestureRecognizer:tap];
                        
                        [dic_newInfo setObject:imgView forKey:@"imgView"];
                        [arr_largeImage addObject:dic_newInfo];
                        
                        [self requestImage:dic_newInfo imgType:@"0"];
                    }
                    con_page.numberOfPages = [arr_largeImage count];
                    sclView_largeImage.contentSize = CGSizeMake(320*[arr_largeImage count], 160);
                    for (int i = 0; i < [arr_largeImage count]; i++) {
                        NSDictionary *dic_topImg = [arr_largeImage objectAtIndex:i];
                        CustomImageView *imgView = (CustomImageView *)[dic_topImg objectForKey:@"imgView"];
                        imgView.frame = CGRectMake(320*i, 0, 320, 16);
                    }
                }
            }
        }
//        int result = [[SqlManager sharedManager] saveHotNewsList:arr_total isTopOrList:@"0"];
//        if (result == 0) {
//            [arr_largeImage removeAllObjects];
//            for (int i = 0; i < [arr_topID count]; i++) {
//                NSString *str_id = [arr_topID objectAtIndex:i];
//                NSMutableDictionary *dic_temp = [[[NSMutableDictionary alloc] initWithDictionary:[[SqlManager sharedManager] getNewsListWithID:str_id]] mutableCopy];
//                NSString *str_largeImgAddress = [dic_temp objectForKey:@"largeImgAddress"];
//                [arr_largeImage addObject:dic_temp];
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
//                        //img = [UIImage imageNamed:@"defaultLoading.png"];
//                    }
//                    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(320*largeImgNum, 0, 320, 160)];
//                    imgView.backgroundColor = [UIColor grayColor];
//                    imgView.image = img;
//                    UILabel *lb_imgTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 130, 320, 30)];
//                    lb_imgTitle.textColor = [UIColor whiteColor];
//                    lb_imgTitle.text = [NSString stringWithFormat:@"  %@",[dic_temp objectForKey:@"title"]];
//                    lb_imgTitle.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8f];
//                    [imgView addSubview:lb_imgTitle];
//                    largeImgNum ++;
//                    con_page.numberOfPages = largeImgNum;
//                    sclView_largeImage.contentSize = CGSizeMake(320*largeImgNum, 160);
//                    [sclView_largeImage addSubview:imgView];
//                }
//            }
//        }
    }
    else if ([str_operate isEqualToString:@"GetHotNews"]) {
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
                NSArray *arr_class = [element_item elementsForName:@"Class"];
                NSString *str_class = [[arr_class objectAtIndex:0] stringValue];
                [dic_itemSaved setObject:str_class forKey:@"class"];
                [arr_listID addObject:str_id];
                [arr_total addObject:dic_itemSaved];
                
                int result = [[SqlManager sharedManager] saveHotNewsListInfo:dic_itemSaved isTopOrList:@"1"];
                NSMutableDictionary *dic_newInfo = [[NSMutableDictionary alloc] initWithDictionary:[[SqlManager sharedManager] getNewsListWithID:str_id]];
                if (result == 102) {
                    for (int i = 0; i < [arr_news count]; i++) {
                        NSDictionary *dic_topImg = [arr_news objectAtIndex:i];
                        NSString *str_tempId = [dic_topImg objectForKey:@"id"];
                        if ([str_tempId isEqualToString:str_id] ) {
                            [arr_news replaceObjectAtIndex:i withObject:dic_newInfo];
                            break;
                        }
                    }
                }
                else if(result == 103)
                {
                    NSDateFormatter *dateForm_time = [[NSDateFormatter alloc] init];
                    [dateForm_time setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
                    [dateForm_time setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                    for (int i = 0; i < [arr_news count]; i++) {
                        NSDictionary *dic_topImg = [arr_news objectAtIndex:i];
                        NSString *str_tempCreateTime = [dic_topImg objectForKey:@"createTime"];
                        NSDate *date_temp = [dateForm_time dateFromString:str_tempCreateTime];
                        NSDate *date_current = [dateForm_time dateFromString:str_update];
                        if ([date_current compare:date_temp] == NSOrderedDescending) {
                            [arr_news insertObject:dic_newInfo atIndex:i];
                            break;
                        }
                        else if(i == [arr_news count] - 1) 
                        {
                            [arr_news addObject:dic_newInfo];
                            break;
                        }
                    }
                    if ([arr_news count] == 0) {
                        [arr_news addObject:dic_newInfo];
                    }
                }
                [tbl_hotNews reloadData];
            }
        }
        
        NSString *str_direction = [dic_userInfo objectForKey:@"direction"];
        if ([str_direction isEqualToString:@"before"]) {
            isGettingBefore = NO;
        }
        else if ([str_direction isEqualToString:@"later"]) {
            isGettingLater = NO;
        }
//        int result = [[SqlManager sharedManager] saveHotNewsList:arr_total isTopOrList:@"1"];
//        if (result == 0) {
//            [arr_news removeAllObjects];
//            for (int i = 0; i < [arr_listID count]; i++) {
//                NSString *str_id = [arr_listID objectAtIndex:i];
//                NSMutableDictionary *dic_temp = [[[NSMutableDictionary alloc] initWithDictionary:[[SqlManager sharedManager] getNewsListWithID:str_id]] mutableCopy];
//                NSString *str_smallImgAddress = [dic_temp objectForKey:@"smallImgAddress"];
//                [arr_news addObject:dic_temp];
//                if ([str_smallImgAddress length] < 1) {
//                    [self requestImage:dic_temp imgType:@"1"];
//                }
//                else{
//                    [tbl_hotNews reloadData];
//                }
//            }
//        }
    }
    else if ([str_operate isEqualToString:@"downloadImg"]) {
        UIImage *img = [[UIImage alloc] initWithData:request.responseData];
        NSString *str_imgType = [dic_userInfo objectForKey:@"imgType"];
        NSString *str_newsId = [dic_userInfo objectForKey:@"id"];
        NSString *str_fileName = request.url.lastPathComponent;
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *str_address = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/Caches/Host/%@",str_fileName]];
        if ([[SqlManager sharedManager] saveDoc:request.responseData address:str_address] == YES) {
            [[SqlManager sharedManager] saveHotNewsImg:str_newsId imgAddress:str_address imgType:[str_imgType intValue]];
        }
        NSMutableDictionary *dic_newInfo = [[NSMutableDictionary alloc] initWithDictionary:[[SqlManager sharedManager] getNewsListWithID:str_newsId]];
        if ([str_imgType isEqualToString:@"0"]) {
            CustomImageView *imgView = (CustomImageView *)[dic_userInfo objectForKey:@"imgView"];
            imgView.img = img;
            
            //[arr_largeImage addObject:dic_item];
        }
        else if ([str_imgType isEqualToString:@"1"]) {
            for (int i = 0; i < [arr_listID count]; i++) {
                NSDictionary *dic_tempInfo = [arr_news objectAtIndex:i];
                NSString *str_tempID = [dic_tempInfo objectForKey:@"id"];
                if ([str_tempID isEqualToString:str_newsId]) {
                    [arr_news replaceObjectAtIndex:i withObject:dic_newInfo];
                }
            }
            //[arr_news addObject:dic_item];
            [tbl_hotNews reloadData];
        }
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
}

#pragma mark -
#pragma mark UIGestureRecognizer
-(void)tapImage:(id)sender
{
    UITapGestureRecognizer *tap = (UITapGestureRecognizer *)sender;
    int index = [tap locationInView:tap.view].x/320;
    if ([arr_largeImage count] >= index +1) {
        NSMutableDictionary *dic_news = [arr_largeImage objectAtIndex:index];
        TopicDetailViewController *con_detail = [[TopicDetailViewController alloc] init];
        
        con_detail.str_id = [dic_news objectForKey:@"id"];
        con_detail.type = 0;
        
        [self.navigationController pushViewController:con_detail animated:YES]; 
    }
}

#pragma mark -
#pragma mark scrollview
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // We don't want a "feedback loop" between the UIPageControl and the scroll delegate in
    // which a scroll event generated from the user hitting the page control triggers updates from
    // the delegate method. We use a boolean to disable the delegate logic when the page control is used.
    if (scrollView == tbl_hotNews) {
        
    }
    else {
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
    if (scrollView.contentOffset.y + scrollView.frame.size.height == scrollView.contentSize.height) {
        if (isGettingBefore == NO) {
            [self requestHotNews:@"before"];
            isGettingBefore = YES;
        }
    }
    else if (scrollView.contentOffset.y == 0) {
        if (isGettingLater == NO) {
            [self requestHotNews:@"later"];
            isGettingLater = YES;
        }
    }
    
}

@end
