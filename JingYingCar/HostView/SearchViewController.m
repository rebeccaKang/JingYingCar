//
//  SearchViewController.m
//  JingYingCar
//
//  Created by JiaMing Yan on 12-4-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SearchViewController.h"
#import "CustomImageView.h"

@interface SearchViewController ()

@end

@implementation SearchViewController

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
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *view_nav = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 45)];
    view_nav.backgroundColor = [UIColor clearColor];
    [self.view addSubview:view_nav];
    
    UIImageView *imgView_navBK = [[UIImageView alloc] initWithFrame:view_nav.bounds];
    imgView_navBK.image = [UIImage imageNamed:@"navDefault.png"];
    [view_nav addSubview:imgView_navBK];
    
    UIButton *btn_back = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_back.frame = CGRectMake(10, 7.5f, 50, 30);
    [btn_back setBackgroundImage:[UIImage imageNamed:@"backBtn.png"] forState:UIControlStateNormal];
    //[btn_back setTitle:@" 返回" forState:UIControlStateNormal];
    [btn_back addTarget:self action:@selector(turnBack) forControlEvents:UIControlEventTouchUpInside];
    [btn_back setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn_back.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    btn_back.titleLabel.textAlignment = UITextAlignmentRight;
    [view_nav addSubview:btn_back];
    
    UIView *view_content = [[UIView alloc] initWithFrame:CGRectMake(0, 45, 320, 415)];
    view_content.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view_content];
    
    schBar = [[UISearchBar alloc] init];
    schBar.frame = CGRectMake(0, 0, 320, 40);
    schBar.tintColor = [UIColor colorWithRed:0.721 green:0.76 blue:0.788 alpha:1];
    schBar.delegate = self;
    [view_content addSubview:schBar];
    
    arr_result = [[NSMutableArray alloc] init];
    
    tbl_result = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, 320, 320) style:UITableViewStylePlain];
    tbl_result.delegate = self;
    tbl_result.dataSource = self;
    [view_content addSubview:tbl_result];
    if ([arr_result count] == 0) {
        tbl_result.hidden = YES;
    }
    
    UIButton *btn_left = [UIButton buttonWithType:UIButtonTypeCustom];
	btn_left.frame = CGRectMake(0, 0, 80, 30);
    [btn_left setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];	
    [btn_left addTarget:self action:@selector(turnBack) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *barBtn_left = [[UIBarButtonItem alloc] initWithCustomView:btn_left];
    self.navigationItem.leftBarButtonItem = barBtn_left;
    
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
        [tbl_result reloadData];
        tbl_result.hidden = YES;
    }
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [arr_result count];
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
    
    if (arr_result.count > indexPath.row) {
        NSDictionary *dic_news = [arr_result objectAtIndex:indexPath.row];
        NSLog(@"dic_news:%@",dic_news);
        
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
    
    NSDictionary *dic_news = [arr_result objectAtIndex:indexPath.row];
    //NSString *str_id = [dic_news objectForKey:@"id"];
    
    TopicDetailViewController *con_detail = [[TopicDetailViewController alloc] init];
    con_detail.str_id = [dic_news objectForKey:@"id"];
    con_detail.type = 2;
    
    [self.navigationController pushViewController:con_detail animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
	[app.netWorkQueue addOperation:request];
    [arr_requests addObject:request];
}

-(NSString *)searchRequestBody
{
    DDXMLNode *node_operate = [DDXMLNode elementWithName:@"Operate" stringValue:@"Search"];
    DDXMLNode *node_keyWord = [DDXMLNode elementWithName:@"Keyword" stringValue:schBar.text];
    NSArray *arr_request = [[NSArray alloc] initWithObjects:node_operate,node_keyWord,nil];
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
                [tbl_result reloadData];
            }
        }
        if ([arr_result count] > 0) {
            tbl_result.hidden = NO;
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
        [tbl_result reloadData];
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
