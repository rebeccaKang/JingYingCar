//
//  SingleTopicListViewController.m
//  JingYingCar
//
//  Created by JiaMing Yan on 12-4-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SingleTopicListViewController.h"
#import "CustomImageView.h"

@interface SingleTopicListViewController ()

@end

@implementation SingleTopicListViewController

@synthesize type;

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
    arr_topicList = [[NSMutableArray alloc] initWithArray:[[SqlManager sharedManager] getTopicListWithFatherID:[NSString stringWithFormat:@"%d",type]]];
    
    if ([arr_topicList count] == 0) {
        [self requestTopicList:@"before"];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    UIView *view_nav = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 45)];
    view_nav.backgroundColor = [UIColor clearColor];
    [self.view addSubview:view_nav];
    
    UIImageView *imgView_navBK = [[UIImageView alloc] initWithFrame:view_nav.bounds];
    imgView_navBK.image = [UIImage imageNamed:@"topicNav.png"];
    [view_nav addSubview:imgView_navBK];
    
    UIButton *btn_back = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_back.frame = CGRectMake(10, 7.5f, 50, 30);
    btn_back.backgroundColor = [UIColor clearColor];
    [btn_back setBackgroundImage:[UIImage imageNamed:@"backBtn.png"] forState:UIControlStateNormal];
    //[btn_back setTitle:@" 返回" forState:UIControlStateNormal];
    [btn_back addTarget:self action:@selector(turnBack) forControlEvents:UIControlEventTouchUpInside];
    [btn_back setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn_back.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    btn_back.titleLabel.textAlignment = UITextAlignmentRight;
    [view_nav addSubview:btn_back];
    
    UIView *view_content = [[UIView alloc] initWithFrame:CGRectMake(0, 45, 320, 415)];
    view_content.backgroundColor = [UIColor clearColor];
    [self.view addSubview:view_content];
    
    tbl_topicList = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 360) style:UITableViewStylePlain];
    tbl_topicList.backgroundColor = [UIColor clearColor];
    tbl_topicList.delegate = self;
    tbl_topicList.dataSource = self;
    [view_content addSubview:tbl_topicList];
    
    UIButton *btn_left = [UIButton buttonWithType:UIButtonTypeCustom];
	btn_left.frame = CGRectMake(0, 0, 80, 30);
    [btn_left setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];	
    [btn_left addTarget:self action:@selector(turnBack) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *barBtn_left = [[UIBarButtonItem alloc] initWithCustomView:btn_left];
    self.navigationItem.leftBarButtonItem = barBtn_left;
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
    [self cancelAllRequests];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark connection
-(void)requestTopicList:(NSString *)direction
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
    NSString *httpBodyString = [self topicListRequestBody:direction];
	NSLog(@"request topiclist  httpBodyString :%@",httpBodyString);
	
    NSData *postData = [httpBodyString dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *dic_userInfo = [[NSMutableDictionary alloc] init];
    [dic_userInfo setObject:@"requestTopicList" forKey:@"operate"];
    [dic_userInfo setObject:direction forKey:@"direction"];
    [request setUserInfo:dic_userInfo];
    [request setPostBody:postData];
    [request setRequestMethod:@"POST"];
    //添加到ASINetworkQueue队列去下载
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
	[app.netWorkQueue addOperation:request];
    [arr_requests addObject:request];
}

-(NSString *)topicListRequestBody:(NSString *)direction
{
    NSString *strTime = @"";
    if ([arr_topicList count] > 0) {
        NSDictionary *dic_temp;
        if ([direction isEqualToString:@"before"]) {
            dic_temp = [arr_topicList objectAtIndex:[arr_topicList count]-1];
        }
        else if ([direction isEqualToString:@"later"]) {
            dic_temp = [arr_topicList objectAtIndex:0];
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
    DDXMLNode *node_operate = [DDXMLNode elementWithName:@"Operate" stringValue:@"GetOneTopicList"];
    DDXMLNode *node_fatherID = [DDXMLNode elementWithName:@"FatherID" stringValue:[NSString stringWithFormat:@"%d",type]];
    DDXMLNode *node_update = [DDXMLNode elementWithName:@"Update" stringValue:strTime];
    DDXMLNode *node_direction = [DDXMLNode elementWithName:@"Direction" stringValue:direction];
    NSArray *arr_request = [[NSArray alloc] initWithObjects:node_operate,node_fatherID,node_update,node_direction,nil];
    DDXMLElement *element_request = [[DDXMLElement alloc] initWithName: @"Request"];
    [element_request setChildren:arr_request];
    return [element_request XMLString];
}

-(void)requestImage:(NSDictionary *)dic_info
{
    NSString *str_url = [dic_info objectForKey:@"smallImgUrl"];
    NSURL *_url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@/%@",BASIC_URL,str_url]];
    if ([str_url length] == 0) {
        return;
    }
    //设置
	ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:_url];
	//设置ASIHTTPRequest代理
	request.delegate = self;
    //设置是是否支持断点下载
	[request setAllowResumeForFileDownloads:YES];
	//设置基本信息
    //NSString *httpBodyString = [self setGetHotNewsRequestBody];
	//NSLog(@"request total  httpBodyString :%@",httpBodyString);
	
    //NSData *postData = [httpBodyString dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *dic_userInfo = [[NSMutableDictionary alloc] initWithDictionary:dic_info];
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
    NSLog(@"responseString3:%@",responseString);
    
    if ([indViewLarge isAnimating] == YES) {
        [indViewLarge stopAnimating];
    }
    
    if ([str_operate isEqualToString:@"requestTopicList"]) {
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
                if (result == 102) {
                    for (int i = 0; i < [arr_topicList count]; i++) {
                        NSDictionary *dic_topImg = [arr_topicList objectAtIndex:i];
                        NSString *str_tempId = [dic_topImg objectForKey:@"id"];
                        if ([str_tempId isEqualToString:str_id] ) {
                            [arr_topicList replaceObjectAtIndex:i withObject:dic_newInfo];
                            break;
                        }
                    }
                }
                else if(result == 103)
                {
                    NSDateFormatter *dateForm_time = [[NSDateFormatter alloc] init];
                    [dateForm_time setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
                    [dateForm_time setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                    for (int i = 0; i < [arr_topicList count]; i++) {
                        NSDictionary *dic_topImg = [arr_topicList objectAtIndex:i];
                        NSString *str_tempCreateTime = [dic_topImg objectForKey:@"createTime"];
                        NSDate *date_temp = [dateForm_time dateFromString:str_tempCreateTime];
                        NSDate *date_current = [dateForm_time dateFromString:str_update];
                        if ([date_current compare:date_temp] == NSOrderedDescending) {
                            [arr_topicList insertObject:dic_newInfo atIndex:i];
                            break;
                        }
                        else if(i == [arr_topicList count] - 1) 
                        {
                            [arr_topicList addObject:dic_newInfo];
                            break;
                        }
                    }
                    if ([arr_topicList count] == 0) {
                        [arr_topicList addObject:dic_newInfo];
                    }
                }
                [tbl_topicList reloadData];
            }
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
        for (int i = 0; i < [arr_topicList count]; i++) {
            NSDictionary *dic_temp = [arr_topicList objectAtIndex:i];
            NSString *str_tempID = [dic_temp objectForKey:@"id"];
            if ([str_newsId isEqualToString:str_tempID]) {
                [arr_topicList replaceObjectAtIndex:i withObject:dic_item];
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

#pragma mark - Table view data source
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    view.backgroundColor = [UIColor clearColor];
    
    UIImageView *imgView_background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tableHeader.png"]];
    imgView_background.frame = view.bounds;
    [view addSubview:imgView_background];
    
    UILabel *lb_header = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 220, 30)];
    NSString *str_title = @"";
    switch (type) {
        case 0:
        {
            str_title = @"引擎Engine";
        }
            break;
        case 1:
        {
            str_title = @"在路上On the way";
        }
            break;
        case 2:
        {
            str_title = @"眼界View";
        }
            break;
        case 3:
        {
            str_title = @"加速度Acceleration";
        }
            break;
        default:
            break;
    }
    lb_header.text = str_title;
    lb_header.textColor = [UIColor whiteColor];
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
    return [arr_topicList count];
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
    
    if (arr_topicList.count > indexPath.row) {
        NSDictionary *dic_news = [arr_topicList objectAtIndex:indexPath.row];
        
        CustomImageView *imgView = (CustomImageView *)[cell viewWithTag:10];
        UIImage *img;
        NSString *str_imgAddress = [dic_news objectForKey:@"smallImgAddress"];
        if ([str_imgAddress length] > 0) {
            img = [UIImage imageWithContentsOfFile:str_imgAddress];
            imgView.img = img;
        }
        else {
            [self requestImage:dic_news];
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
    
    NSDictionary *dic_news = [arr_topicList objectAtIndex:indexPath.row];
    con_detail.str_id = [dic_news objectForKey:@"id"];
    con_detail.type = 0;
    
    [self.navigationController pushViewController:con_detail animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark scrollview
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView 
{
    if (scrollView.contentOffset.y + scrollView.frame.size.height == scrollView.contentSize.height) {
        if (isGettingBefore == NO) {
            [self requestTopicList:@"before"];
            isGettingBefore = YES;
        }
    }
    else if (scrollView.contentOffset.y == 0) {
        if (isGettingLater == NO) {
            [self requestTopicList:@"later"];
            isGettingLater = YES;
        }
    }
}

@end
