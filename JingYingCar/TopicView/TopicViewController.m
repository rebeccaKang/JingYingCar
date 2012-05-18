//
//  TopicViewController.m
//  JingYingCar
//
//  Created by JiaMing Yan on 12-4-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TopicViewController.h"
#import "SingleTopicListViewController.h"
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

@interface TopicViewController ()

@end

@implementation TopicViewController

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
    indViewLarge = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [indViewLarge setCenter:self.view.center];
    [self.view addSubview:indViewLarge];
    arr_requests = [[NSMutableArray alloc] init];
    arr_topicList = [[NSMutableArray alloc] initWithArray:[[SqlManager sharedManager] getTopicList]];
    [self requestTopicList];
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
//        lb_title.text = @"文章";
//        [self.navigationController.navigationBar addSubview:lb_title];
//    }
//    else {
//        [self.navigationController.navigationBar setImage:@"navHotNews.png"];
//    }
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
    
    UIView *view_nav = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 45)];
    view_nav.backgroundColor = [UIColor clearColor];
    view_nav.layer.shadowOffset = CGSizeMake(0, 1);
    view_nav.layer.shadowOpacity = 1;
    view_nav.layer.shadowColor = [UIColor blackColor].CGColor;
    [self.view addSubview:view_nav];
    
    UIImageView *imgView_navBK = [[UIImageView alloc] initWithFrame:view_nav.bounds];
    imgView_navBK.image = [UIImage imageNamed:@"topicNav.png"];
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
    
    arr_class = [NSArray arrayWithObjects:@"引擎Engine",@"在路上On the way",@"眼界View",@"加速度Acceleration", nil];
    arr_topicID = [[NSMutableArray alloc] init];
    
    tbl_topicList = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 370) style:UITableViewStylePlain];
    tbl_topicList.backgroundColor = [UIColor whiteColor];
    tbl_topicList.delegate = self;
    tbl_topicList.dataSource = self;
    tbl_topicList.scrollEnabled = YES;
    [view_content addSubview:tbl_topicList];
    
    [self.view bringSubviewToFront:indViewLarge];
    [self.view bringSubviewToFront:view_nav];
}

-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSString *str_shouldRequest = [app.arr_shouldRequest objectAtIndex:2];
    if ([str_shouldRequest isEqualToString:@"0"]) {
        [self requestTopicList];
        [app.arr_shouldRequest replaceObjectAtIndex:2 withObject:@"1"];
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

-(void)showMore:(UIButton *)sender
{
    SingleTopicListViewController *con_singleList = [[SingleTopicListViewController alloc] init];
    switch (sender.tag) {
        case 100:
        {
            con_singleList.type = 0;
        }
            break;
        case 101:
        {
            con_singleList.type = 1;
        }
            break;
        case 102:
        {
            con_singleList.type = 2;
        }
            break;
        case 103:
        {
            con_singleList.type = 3;
        }
            break;
        default:
            break;
    }
    [self.navigationController pushViewController:con_singleList animated:YES];
}

#pragma mark -
#pragma mark connection
-(void)requestTopicList
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
    NSString *httpBodyString = [self topicListRequestBody];
	NSLog(@"request topiclist  httpBodyString :%@",httpBodyString);
	
    NSData *postData = [httpBodyString dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *dic_userInfo = [[NSMutableDictionary alloc] init];
    [dic_userInfo setObject:@"requestTopicList" forKey:@"operate"];
    [request setUserInfo:dic_userInfo];
    [request setPostBody:postData];
    [request setRequestMethod:@"POST"];
    //添加到ASINetworkQueue队列去下载
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
	[app.netWorkQueue addOperation:request];
    [arr_requests addObject:request];
}

-(NSString *)topicListRequestBody
{
    DDXMLNode *node_operate = [DDXMLNode elementWithName:@"Operate" stringValue:@"GetTopicList"];
    NSArray *arr_request = [[NSArray alloc] initWithObjects:node_operate,nil];
    DDXMLElement *element_request = [[DDXMLElement alloc] initWithName: @"Request"];
    [element_request setChildren:arr_request];
    return [element_request XMLString];
}

-(void)requestImage:(NSDictionary *)info
{
    NSString *str_imgUrl = [info objectForKey:@"smallImgUrl"];
    NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@/%@",BASIC_URL,str_imgUrl]];
    if ([str_imgUrl length] == 0) {
        return;
    }
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
    [dic_userInfo setObject:@"downloadImg" forKey:@"operate"];
    [request setUserInfo:dic_userInfo];
    //[request setPostBody:postData];
    //[request setRequestMethod:@"POST"];
    //添加到ASINetworkQueue队列去下载
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
	[app.netWorkQueue addOperation:request];
    [arr_requests addObject:request];
}

#pragma mark - Table view data source
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    view.backgroundColor = [UIColor clearColor];
    
    UIImageView *imgView_background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tableHeader.png"]];
    imgView_background.frame = view.bounds;
    [view addSubview:imgView_background];
    
    UILabel *lb_header = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 220, 30)];
    lb_header.text = [arr_class objectAtIndex:section];
    lb_header.textColor = [UIColor whiteColor];
    lb_header.font = [UIFont boldSystemFontOfSize:14];
    lb_header.backgroundColor = [UIColor clearColor];
    [view addSubview:lb_header];
    
    UIButton *btn_more = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_more.frame = CGRectMake(260, 0, 60, 30);
    [btn_more setTitle:@"更多" forState:UIControlStateNormal];
    btn_more.backgroundColor = [UIColor clearColor];
    [btn_more setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn_more.titleLabel.font = [UIFont systemFontOfSize:12];
    btn_more.titleLabel.textAlignment = UITextAlignmentRight;
    btn_more.tag = 100+section;
    [btn_more addTarget:self action:@selector(showMore:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn_more];
    
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [arr_class count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSArray *arr_topics;
    if ([arr_topicList count] > section) {
        arr_topics = [arr_topicList objectAtIndex:section];
    }
    return [arr_topics count];
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
        lb_title.textColor = [UIColor colorWithWhite:0.4f alpha:1];
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
    
    NSArray *arr_topics;
    if ([arr_topicList count] > indexPath.section) {
        arr_topics = [arr_topicList objectAtIndex:indexPath.section];
    }
    else {
        return cell;
    }
    
    if (arr_topics.count > indexPath.row) {
        NSDictionary *dic_news = [arr_topics objectAtIndex:indexPath.row];
        
        CustomImageView *imgView = (CustomImageView *)[cell viewWithTag:10];
        UIImage *img;
        NSString *str_imgAddress = [dic_news objectForKey:@"smallImgAddress"];
        if ([str_imgAddress length] > 0) {
            img = [UIImage imageWithContentsOfFile:str_imgAddress];
            imgView.img = img;
        }
        else {
            //[self requestImage:dic_news];
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

-(void)reloadImage
{
    for (int i = 0; i < [arr_topicList count]; i++) {
        NSArray *arr_topics = [arr_topicList objectAtIndex:i];
        for (int j = 0; j < [arr_topics count]; j++) {
            NSDictionary *dic_news = [arr_topics objectAtIndex:j];
            NSString *str_imgAddress = [dic_news objectForKey:@"smallImgAddress"];
            if ([str_imgAddress length] == 0) {
                [self requestImage:dic_news];
            }
        }
    }
}

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
    
    TopicDetailViewController *con_detail = [[TopicDetailViewController alloc] init];
    
    NSArray *arr_list = [arr_topicList objectAtIndex:indexPath.section];
    
    NSDictionary *dic_news = [arr_list objectAtIndex:indexPath.row];
    con_detail.str_id = [dic_news objectForKey:@"id"];
    con_detail.type = 2;
    
    [self.navigationController pushViewController:con_detail animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
    NSLog(@"responseString3:%@",responseString);
    
    if ([str_operate isEqualToString:@"requestTopicList"]) {
        if ([indViewLarge isAnimating] == YES) {
            [indViewLarge stopAnimating];
        }
        NSError *error = nil;
        DDXMLDocument* xmlDoc = [[DDXMLDocument alloc] initWithXMLString:responseString options:0 error:&error];
        if (error) {
            NSLog(@"%@",[error localizedDescription]);
        }
        NSArray *arr_response = [xmlDoc nodesForXPath:@"//Response" error:&error];
        
//        NSMutableArray *arr_engine = [[NSMutableArray alloc] init];
//        NSMutableArray *arr_ontheway = [[NSMutableArray alloc] init];
//        NSMutableArray *arr_view = [[NSMutableArray alloc] init];
//        NSMutableArray *arr_acceraltion = [[NSMutableArray alloc] init];
        
        NSMutableArray *arr_temp = [[NSMutableArray alloc] init];
        
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
                NSArray *arr_class2 = [element_item elementsForName:@"Class"];
                NSString *str_class = [[arr_class2 objectAtIndex:0] stringValue];
                [dic_itemSaved setObject:str_class forKey:@"class"];
                NSArray *arr_fatherID = [element_item elementsForName:@"FatherID"];
                NSString *str_fatherID = [[arr_fatherID objectAtIndex:0] stringValue];
                [dic_itemSaved setObject:str_fatherID forKey:@"fatherID"];
                [arr_temp addObject:dic_itemSaved];
                [arr_topicID addObject:str_id];
                
                int result = [[SqlManager sharedManager] saveTopicInfo:dic_itemSaved];
                
                NSMutableDictionary *dic_newInfo = [[NSMutableDictionary alloc] initWithDictionary:[[SqlManager sharedManager] getTopicListWithID:str_id]];
                NSMutableArray *arr_oldInfo = [arr_topicList objectAtIndex:[str_fatherID intValue]];
                if (result == 102) {
                    for (int i = 0; i < [arr_oldInfo count]; i++) {
                        NSDictionary *dic_topImg = [arr_oldInfo objectAtIndex:i];
                        NSString *str_tempId = [dic_topImg objectForKey:@"id"];
                        if ([str_tempId isEqualToString:str_id] ) {
                            [arr_oldInfo replaceObjectAtIndex:i withObject:dic_newInfo];
                            break;
                        }
                    }
                }
                else if(result == 103)
                {
                    BOOL isExist = NO;
                    for (int i = 0; i < [arr_oldInfo count]; i++) {
                        NSDictionary *dic_topImg = [arr_oldInfo objectAtIndex:i];
                        NSString *str_tempId = [dic_topImg objectForKey:@"id"];
                        if ([str_tempId isEqualToString:str_id] ) {
                            [arr_oldInfo replaceObjectAtIndex:i withObject:dic_newInfo];
                            isExist = YES;
                            break;
                        }
                    }
                    if (isExist == NO) {
                        NSDateFormatter *dateForm_time = [[NSDateFormatter alloc] init];
                        [dateForm_time setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
                        [dateForm_time setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                        for (int i = 0; i < [arr_oldInfo count]; i++) {
                            NSDictionary *dic_topImg = [arr_oldInfo objectAtIndex:i];
                            NSString *str_tempCreateTime = [dic_topImg objectForKey:@"createTime"];
                            NSDate *date_temp = [dateForm_time dateFromString:str_tempCreateTime];
                            NSDate *date_current = [dateForm_time dateFromString:str_update];
                            if ([date_current compare:date_temp] == NSOrderedDescending) {
                                [arr_oldInfo insertObject:dic_newInfo atIndex:i];
                                break;
                            }
                            else if(i == [arr_oldInfo count] - 1) 
                            {
                                [arr_oldInfo addObject:dic_newInfo];
                                break;
                            }
                        }
                        if ([arr_oldInfo count] == 0) {
                            [arr_oldInfo addObject:dic_newInfo];
                        }
                    }
                }
                [tbl_topicList reloadData];
            }
        }
        [self reloadImage];
//        [[SqlManager sharedManager] saveTopicList:arr_temp];
//        for (int i = 0; i < [arr_topicID count]; i++) {
//            NSString *str_id = [arr_topicID objectAtIndex:i];
//            NSMutableDictionary *dic_temp = [[[NSMutableDictionary alloc] initWithDictionary:[[SqlManager sharedManager] getTopicListWithID:str_id]] mutableCopy];
//            NSString *str_shouldRefresh = [dic_temp objectForKey:@"shouldRefresh"];
//            if ([str_shouldRefresh isEqualToString:@"0"]) {
//                [self requestImage:dic_temp];
//            }
//            else if ([str_shouldRefresh isEqualToString:@"1"]) {
//                NSString *str_fatherID = [dic_temp objectForKey:@"fatherID"];
//                switch ([str_fatherID intValue]) {
//                    case 0:
//                    {
//                        [arr_engine addObject:dic_temp];
//                    }
//                        break;
//                    case 1:
//                    {
//                        [arr_ontheway addObject:dic_temp];
//                    }
//                        break;
//                    case 2:
//                    {
//                        [arr_view addObject:dic_temp];
//                    }
//                        break;
//                    case 3:
//                    {
//                        [arr_acceraltion addObject:dic_temp];
//                    }
//                        break;
//                        
//                    default:
//                        break;
//                }
//            }
//        }
//        [arr_topicList addObject:arr_engine];
//        [arr_topicList addObject:arr_ontheway];
//        [arr_topicList addObject:arr_view];
//        [arr_topicList addObject:arr_acceraltion];
//        [tbl_topicList reloadData];
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
        NSString *str_fatherID = [dic_item objectForKey:@"fatherID"];
        NSMutableArray *arr_temp = [arr_topicList objectAtIndex:[str_fatherID intValue]];
        for (int i = 0; i < [arr_temp count]; i++) {
            NSDictionary *dic_temp = [arr_temp objectAtIndex:i];
            NSString *str_tempID = [dic_temp objectForKey:@"id"];
            if ([str_newsId isEqualToString:str_tempID]) {
                [arr_temp replaceObjectAtIndex:i withObject:dic_item];
            }
        }
        [tbl_topicList reloadData];
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


@end
