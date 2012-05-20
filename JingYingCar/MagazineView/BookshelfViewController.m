//
//  BookshelfViewController.m
//  JingYingCar
//
//  Created by JiaMing Yan on 12-4-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BookshelfViewController.h"
#import "MagazineDownloadedViewController.h"
#import "MagazineReadingViewController.h"

@interface BookshelfViewController ()

@end

@implementation BookshelfViewController

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
    arr_magazine = [[NSMutableArray alloc] initWithArray:[[SqlManager sharedManager] getMagazineList]];
    //arr_magzine = [[NSMutableArray alloc] init];
    [self requestMagazineList];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    UIView *view_nav = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 45)];
    view_nav.backgroundColor = [UIColor clearColor];
    view_nav.layer.shadowOffset = CGSizeMake(0, 1);
    view_nav.layer.shadowOpacity = 1;
    view_nav.layer.shadowColor = [UIColor blackColor].CGColor;
    [self.view addSubview:view_nav];
    
    UIImageView *imgView_navBK = [[UIImageView alloc] initWithFrame:view_nav.bounds];
    imgView_navBK.image = [UIImage imageNamed:@"magazineNav.png"];
    [view_nav addSubview:imgView_navBK];
    
    UIButton *btn_edit = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_edit.frame = CGRectMake(260, 7.5, 52, 30);
    [btn_edit setBackgroundImage:[UIImage imageNamed:@"edit.png"] forState:UIControlStateNormal];
    //[btn_edit setTitle:@"编辑" forState:UIControlStateNormal];
    btn_edit.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [btn_edit setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn_edit.titleLabel.textAlignment = UITextAlignmentLeft;
    [btn_edit addTarget:self action:@selector(turnToEditMagazine:) forControlEvents:UIControlEventTouchUpInside];
    [view_nav addSubview:btn_edit];
    
//    UIButton *btn_get = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn_get.frame = CGRectMake(10, 10, 50, 25);
//    [btn_get setBackgroundImage:[UIImage imageNamed:@"rectButton.png"] forState:UIControlStateNormal];
//    [btn_get setTitle:@"获取" forState:UIControlStateNormal];
//    btn_get.titleLabel.font = [UIFont systemFontOfSize:14];
//    [btn_get setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    btn_get.titleLabel.textAlignment = UITextAlignmentLeft;
//    [btn_get addTarget:self action:@selector(turnToGetMagazine:) forControlEvents:UIControlEventTouchUpInside];
//    [view_nav addSubview:btn_get];
    
    view_content = [[UIView alloc] initWithFrame:CGRectMake(0, 44, 320, 415)];
    view_content.backgroundColor = [UIColor clearColor];
    [self.view addSubview:view_content];
    
    UIImageView *imgView_background = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 380)];
    imgView_background.image = [UIImage imageNamed:@"bookshelf.png"];
    [view_content addSubview:imgView_background];
    
    arr_buttons = [[NSMutableArray alloc] init];
    
    [self.view bringSubviewToFront:view_nav];
    
//    for (int i = 0; i < 13; i++) {
//        UIButton *btn_magzine = [UIButton buttonWithType:UIButtonTypeCustom];
//        int row = i/4;
//        int col = i%4;
//        btn_magzine.frame = CGRectMake(10+80*col, 10+93*row, 60, 60);
//        [btn_magzine setBackgroundImage:[UIImage imageNamed:@"bookcover.png"] forState:UIControlStateNormal];
//        [view_content addSubview:btn_magzine];
//    }
}

-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSString *str_shouldRequest = [app.arr_shouldRequest objectAtIndex:3];
    if ([str_shouldRequest isEqualToString:@"0"]) {
        [self requestMagazineList];
        [app.arr_shouldRequest replaceObjectAtIndex:3 withObject:@"1"];
    }
    [self reloadViews];
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

-(void)reloadViews
{
    for (int i = 0; i < [arr_magazine count]; i++) {
        NSDictionary *dic_magazine = [arr_magazine objectAtIndex:i];
        UIButton *btn_magazine = [dic_magazine objectForKey:@"button"];
        if (btn_magazine == nil) {
            btn_magazine = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn_magazine addTarget:self action:@selector(turnToDetail:) forControlEvents:UIControlEventTouchUpInside];
            [view_content addSubview:btn_magazine];
            [arr_magazine replaceObjectAtIndex:i withObject:dic_magazine];
        }
        NSString *str_id = [dic_magazine objectForKey:@"id"];
        NSMutableDictionary *dic_newInfo = [[NSMutableDictionary alloc] initWithDictionary:[[SqlManager sharedManager] getMagazineInfoWithID:str_id]];
        [dic_newInfo setObject:btn_magazine forKey:@"button"];
        [arr_magazine replaceObjectAtIndex:i withObject:dic_newInfo];
        int row = i/4;
        int col = i%4;
        btn_magazine.frame = CGRectMake(28+73*col, 10+93*row, 45, 65);
        UIImage *img;
        NSString *str_address = [dic_newInfo objectForKey:@"address"];
        NSString *str_imgAddress = [dic_newInfo objectForKey:@"coverImgAddress"];
        if ([str_address length] > 0) {
            if ([str_imgAddress length] > 0) {
                img = [UIImage imageWithContentsOfFile:str_imgAddress];
            }
            else {
                [self requestCover:dic_newInfo];
            }
        }
        else {
            if ([str_imgAddress length] > 0) {
                UIImage *image = [UIImage imageWithContentsOfFile:str_imgAddress];
                UIGraphicsBeginImageContext(image.size);
                [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height) blendMode:kCGBlendModeLuminosity alpha:0.6f]; 
                //CGContextRef context = UIGraphicsGetCurrentContext();
                CGImageRef imageRef = CGBitmapContextCreateImage(UIGraphicsGetCurrentContext());
                img =  [UIImage imageWithCGImage:imageRef];  
                UIGraphicsEndImageContext();
            }
            else {
                UIImage *image = [UIImage imageNamed:@"bookcover.png"];
                UIGraphicsBeginImageContext(image.size);
                [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height) blendMode:kCGBlendModeLuminosity alpha:0.6f]; 
                //CGContextRef context = UIGraphicsGetCurrentContext();
                CGImageRef imageRef = CGBitmapContextCreateImage(UIGraphicsGetCurrentContext());
                img =  [UIImage imageWithCGImage:imageRef];  
                UIGraphicsEndImageContext();
                [self requestCover:dic_newInfo];
            }
        }
        [btn_magazine setBackgroundImage:img forState:UIControlStateNormal];
    }
}

#pragma mark -
#pragma mark buttonFunction
-(void)turnToDetail:(UIButton *)sender
{
    for (int i = 0; i < [arr_magazine count]; i++) {
        NSDictionary *dic_temp = [arr_magazine objectAtIndex:i];
        UIButton *btn_temp = [dic_temp objectForKey:@"button"];
        if (btn_temp == sender) {
            NSString *str_address = [dic_temp objectForKey:@"address"];
            if ([str_address length] > 0) {
                MagazineReadingViewController *con_reading = [[MagazineReadingViewController alloc] init];
                NSString *str_id = [dic_temp objectForKey:@"id"];
                con_reading.magazineID = str_id;
                [self.navigationController pushViewController:con_reading animated:YES];
            }
            else {
                [self turnToGetMagazine:sender];
            }
            break;
        }
    }
}

-(void)turnToGetMagazine:(UIButton *)sender
{
    MagazineUndownloadedViewController *con_magazineInfo = [[MagazineUndownloadedViewController alloc] init];
    [self.navigationController pushViewController:con_magazineInfo animated:YES];
}

-(void)turnToEditMagazine:(UIButton *)sender
{
//    MagazineDownloadedViewController *con_magazineInfo = [[MagazineDownloadedViewController alloc] init];
//    [self.navigationController pushViewController:con_magazineInfo animated:YES];
    MagazineUndownloadedViewController *con_magazineInfo = [[MagazineUndownloadedViewController alloc] init];
    con_magazineInfo.delegate = self;
    [self.navigationController pushViewController:con_magazineInfo animated:YES];
}

#pragma mark - editMagazineDelegate
-(void)commitEditing:(NSString *)str_id
{
    for (int i = 0; i < [arr_magazine count]; i++) {
        NSDictionary *dic_oldInfo = [arr_magazine objectAtIndex:i];
        NSString *str_oldId = [dic_oldInfo objectForKey:@"id"];
        if ([str_id isEqualToString:str_oldId]) {
            NSMutableDictionary *dic_newInfo = [[NSMutableDictionary alloc] initWithDictionary:[[SqlManager sharedManager] getMagazineInfoWithID:str_id]];
            NSLog(@"%@",dic_newInfo);
            UIButton *btn_old = [dic_oldInfo objectForKey:@"button"];
            [dic_newInfo setObject:btn_old forKey:@"button"];
            [arr_magazine replaceObjectAtIndex:i withObject:dic_newInfo];
            break;
        }
    }
}


#pragma mark -
#pragma mark connection
-(void)requestMagazineList
{
    NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@",DEFAULT_URL]];
    //设置
	ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:url];
	//设置ASIHTTPRequest代理
	request.delegate = self;
    //设置是是否支持断点下载
	[request setAllowResumeForFileDownloads:NO];
	//设置基本信息
    NSString *httpBodyString = [self magazineListRequestBody];
	NSLog(@"request topiclist  httpBodyString :%@",httpBodyString);
	
    NSData *postData = [httpBodyString dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *dic_userInfo = [[NSMutableDictionary alloc] init];
    [dic_userInfo setObject:@"requestMagazineList" forKey:@"operate"];
    [request setUserInfo:dic_userInfo];
    [request setPostBody:postData];
    [request setRequestMethod:@"POST"];
    //添加到ASINetworkQueue队列去下载
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
	[app.netWorkQueue addOperation:request];
    [arr_requests addObject:request];
}

-(NSString *)magazineListRequestBody
{
    DDXMLNode *node_operate = [DDXMLNode elementWithName:@"Operate" stringValue:@"GetMagazine"];
    NSArray *arr_request = [[NSArray alloc] initWithObjects:node_operate,nil];
    DDXMLElement *element_request = [[DDXMLElement alloc] initWithName: @"Request"];
    [element_request setChildren:arr_request];
    return [element_request XMLString];
}

-(void)requestCover:(NSDictionary *)info
{
    NSString *str_imgUrl = [info objectForKey:@"coverImgUrl"];
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
    [dic_userInfo setObject:@"downloadImg" forKey:@"operate"];
    [request setUserInfo:dic_userInfo];
    //[request setPostBody:postData];
    //[request setRequestMethod:@"POST"];
    //添加到ASINetworkQueue队列去下载
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
	[app.netWorkQueue addOperation:request];
    [arr_requests addObject:request];
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
    
    if ([str_operate isEqualToString:@"requestMagazineList"]) {
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
                NSArray *arr_download = [element_item elementsForName:@"Download"];
                NSString *str_download = [[arr_download objectAtIndex:0] stringValue];
                [dic_itemSaved setObject:str_download forKey:@"url"];
                NSArray *arr_summary = [element_item elementsForName:@"Summary"];
                NSString *str_summary = [[arr_summary objectAtIndex:0] stringValue];
                [dic_itemSaved setObject:str_summary forKey:@"summary"];
                NSArray *arr_image = [element_item elementsForName:@"Image"];
                NSString *str_image = [[arr_image objectAtIndex:0] stringValue];
                [dic_itemSaved setObject:str_image forKey:@"coverImgUrl"];
                NSArray *arr_update = [element_item elementsForName:@"Update"];
                NSString *str_update = [[arr_update objectAtIndex:0] stringValue];
                [dic_itemSaved setObject:str_update forKey:@"createTime"];
//                UIButton *btn_magazine = [UIButton buttonWithType:UIButtonTypeCustom];
//                int row = [arr_total count]/4;
//                int col = [arr_total count]%4;
//                btn_magazine.frame = CGRectMake(10+80*col, 10+93*row, 60, 40);
//                [btn_magazine setBackgroundImage:[UIImage imageNamed:@"bookcover.png"] forState:UIControlStateNormal];
//                [view_content addSubview:btn_magazine];
//                [dic_itemSaved setObject:btn_magazine forKey:@"button"];
//                [arr_total addObject:dic_itemSaved];
                
                int result = [[SqlManager sharedManager] saveMagazineItem:dic_itemSaved];
                
                NSMutableDictionary *dic_newInfo = [[NSMutableDictionary alloc] initWithDictionary:[[SqlManager sharedManager] getMagazineInfoWithID:str_id]];
                if (result == 102) {
                    for (int i = 0; i < [arr_magazine count]; i++) {
                        NSDictionary *dic_magazine = [arr_magazine objectAtIndex:i];
                        NSString *str_tempId = [dic_magazine objectForKey:@"id"];
                        if ([str_tempId isEqualToString:str_id] ) {
                            UIButton *btn_temp = [dic_magazine objectForKey:@"button"];
                            [dic_newInfo setObject:btn_temp forKey:@"button"];
                            [arr_magazine replaceObjectAtIndex:i withObject:dic_newInfo];
                            [self requestCover:dic_newInfo];
                            break;
                        }
                    }
                }
                else if(result == 103)
                {
                    NSDateFormatter *dateForm_time = [[NSDateFormatter alloc] init];
                    [dateForm_time setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
                    [dateForm_time setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                    UIButton *btn_magazine = [UIButton buttonWithType:UIButtonTypeCustom];
                    [btn_magazine addTarget:self action:@selector(turnToDetail:) forControlEvents:UIControlEventTouchUpInside];
                    [view_content addSubview:btn_magazine];
                    [dic_newInfo setObject:btn_magazine forKey:@"button"];
                    for (int i = 0; i < [arr_magazine count]; i++) {
                        NSDictionary *dic_topImg = [arr_magazine objectAtIndex:i];
                        NSString *str_tempCreateTime = [dic_topImg objectForKey:@"createTime"];
                        NSDate *date_temp = [dateForm_time dateFromString:str_tempCreateTime];
                        NSDate *date_current = [dateForm_time dateFromString:str_update];
                        if ([date_current compare:date_temp] == NSOrderedDescending) {
                            [arr_magazine insertObject:dic_newInfo atIndex:i];
                            break;
                        }
                        else if(i == [arr_magazine count] - 1) 
                        {
                            [arr_magazine addObject:dic_newInfo];
                            break;
                        }
                    }
                    if ([arr_magazine count] == 0) {
                        [arr_magazine addObject:dic_newInfo];
                    }
                }
                [self reloadViews];
            }
        }
        
//        [[SqlManager sharedManager] saveMagazineList:arr_total];
//        for (int i = 0; i < [arr_total count]; i++) {
//            NSDictionary *dic_temp = [arr_total objectAtIndex:i];
//            NSString *str_id = [dic_temp objectForKey:@"id"];
//            NSMutableDictionary *dic_tempInfo = [[NSMutableDictionary alloc] initWithDictionary:[[SqlManager sharedManager] getMagazineInfoWithID:str_id]];
//            UIButton *btn_magazine = (UIButton *)[dic_temp objectForKey:@"button"];
//            [dic_tempInfo setObject:btn_magazine forKey:@"button"];
//            [btn_magazine addTarget:self action:@selector(turnToDetail:) forControlEvents:UIControlEventTouchUpInside];
//            NSString *str_imgAddress= [dic_tempInfo objectForKey:@"coverImgAddress"];
//            if ([str_imgAddress length] == 0) {
//                [self requestCover:dic_tempInfo];
//            }
//            else {
//                UIImage *img;
//                if ([str_imgAddress length] > 0) {
//                    NSFileManager *fileManager = [NSFileManager defaultManager];
//                    NSData *data_img = [fileManager contentsAtPath:str_imgAddress];
//                    UIImage *image = [UIImage imageWithData:data_img];
//                    NSString *str_address = [dic_tempInfo objectForKey:@"address"];
//                    if ([str_address length] > 0) {
//                        img = image;
//                    }
//                    else {
//                        // Draw image1
//                        UIGraphicsBeginImageContext(image.size);
//                        //用当前的图形上下文的资源。
//                        [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height) blendMode:kCGBlendModeLuminosity alpha:0.6f]; 
//                        //CGContextRef context = UIGraphicsGetCurrentContext();
//                        CGImageRef image = CGBitmapContextCreateImage(UIGraphicsGetCurrentContext());
//                        img =  [UIImage imageWithCGImage:image];  
//                        UIGraphicsEndImageContext();
//                    }
//                }
//                [btn_magazine setBackgroundImage:img forState:UIControlStateNormal];
//            }
//            [arr_magazine addObject:dic_tempInfo];
//        }
    }
    else if ([str_operate isEqualToString:@"downloadImg"]) {
        UIImage *image = [[UIImage alloc] initWithData:request.responseData];
        NSString *str_id = [dic_userInfo objectForKey:@"id"];
        NSString *str_fileName = request.url.lastPathComponent;
        str_fileName = [NSString stringWithFormat:@"%@@2x%@",[str_fileName substringToIndex:[str_fileName length] -4],[str_fileName substringFromIndex:[str_fileName length]-4]];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *str_address = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/Caches/Magazine/%@",str_fileName]];
        if ([[SqlManager sharedManager] saveDoc:request.responseData address:str_address] == YES) {
            [[SqlManager sharedManager] saveMagezineCover:str_id imgAddress:str_address];
        }
        NSMutableDictionary *dic_newInfo = [[NSMutableDictionary alloc] initWithDictionary:[[SqlManager sharedManager] getMagazineInfoWithID:str_id]];
        for (int i = 0; i < [arr_magazine count]; i++) {
            NSDictionary *dic_temp = [arr_magazine objectAtIndex:i];
            NSString *str_tempID = [dic_temp objectForKey:@"id"];
            if ([str_id isEqualToString:str_tempID]) {
                UIButton *btn_magazine = [dic_temp objectForKey:@"button"];
                UIGraphicsBeginImageContext(image.size);
                [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height) blendMode:kCGBlendModeLuminosity alpha:0.6f]; 
                //CGContextRef context = UIGraphicsGetCurrentContext();
                CGImageRef imageRef = CGBitmapContextCreateImage(UIGraphicsGetCurrentContext());
                UIImage *img =  [UIImage imageWithCGImage:imageRef];  
                UIGraphicsEndImageContext();
                [btn_magazine setBackgroundImage:img forState:UIControlStateNormal];
                [dic_newInfo setObject:btn_magazine forKey:@"button"];
                [arr_magazine replaceObjectAtIndex:i withObject:dic_newInfo];
                break;
            }
        }
//        int index = [[dic_userInfo objectForKey:@"index"] intValue];
//        UIButton *btn_magzine = [arr_buttons objectAtIndex:index];
//        // Draw image1
//        UIGraphicsBeginImageContext(image.size);
//        //用当前的图形上下文的资源。
//        [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height) blendMode:kCGBlendModeLuminosity alpha:0.6f]; 
//        //CGContextRef context = UIGraphicsGetCurrentContext();
//        CGImageRef imageRef = CGBitmapContextCreateImage(UIGraphicsGetCurrentContext());
//        UIImage *img =  [UIImage imageWithCGImage:imageRef];  
//        UIGraphicsEndImageContext();
//        [[SqlManager sharedManager] saveDoc:UIImagePNGRepresentation(image) address:str_address];
//        [btn_magzine setBackgroundImage:img forState:UIControlStateNormal];
//        [btn_magzine addTarget:self action:@selector(turnToDetail:) forControlEvents:UIControlEventTouchUpInside];
//        NSMutableDictionary *dic_magezine = [[NSMutableDictionary alloc] initWithDictionary:[[SqlManager sharedManager] getMagazineInfoWithID:str_id]];
//        [dic_magezine setObject:btn_magzine forKey:@"button"];
//        [arr_magzine addObject:dic_magezine];
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

@end
