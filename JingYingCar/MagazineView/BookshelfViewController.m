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
#import "MagazineUndownloadedViewController.h"

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
    
    //arr_magzine = [[NSMutableArray alloc] initWithArray:[[SqlManager sharedManager] getMagazineList]];
    
    arr_magzine = [[NSMutableArray alloc] init];
    [self requestMagzineList];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    UIView *view_nav = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 45)];
    view_nav.backgroundColor = [UIColor clearColor];
    [self.view addSubview:view_nav];
    
    UIImageView *imgView_navBK = [[UIImageView alloc] initWithFrame:view_nav.bounds];
    imgView_navBK.image = [UIImage imageNamed:@"magazineNav.png"];
    [view_nav addSubview:imgView_navBK];
    
    UIButton *btn_edit = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_edit.frame = CGRectMake(250, 7, 52, 30);
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
        [self requestMagzineList];
    }
    for (int i = 0; i < [arr_magzine count]; i++) {
        NSDictionary *dic_magazine = [arr_magzine objectAtIndex:i];
        NSString *str_id = [dic_magazine objectForKey:@"id"];
        UIButton *btn_magazine = [dic_magazine objectForKey:@"button"];
        NSMutableDictionary *dic_newInfo = [[[NSMutableDictionary alloc] initWithDictionary:[[SqlManager sharedManager] getMagazineInfoWithID:str_id]] mutableCopy];
        [dic_newInfo setObject:btn_magazine forKey:@"button"];
        [arr_magzine replaceObjectAtIndex:i withObject:dic_newInfo];
        UIImage *img;
        NSString *str_address = [dic_newInfo objectForKey:@"address"];
        if ([str_address length] > 0) {
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSString *str_imgAddress = [dic_newInfo objectForKey:@"coverImgAddress"];
            NSData *data_img = [fileManager contentsAtPath:str_imgAddress];
            img = [UIImage imageWithData:data_img];
        }
        else {
            UIImage *image = [UIImage imageNamed:@"bookcover.png"];
            UIGraphicsBeginImageContext(image.size);
            [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height) blendMode:kCGBlendModeLuminosity alpha:0.6f]; 
            //CGContextRef context = UIGraphicsGetCurrentContext();
            CGImageRef imageRef = CGBitmapContextCreateImage(UIGraphicsGetCurrentContext());
            img =  [UIImage imageWithCGImage:imageRef];  
            UIGraphicsEndImageContext();
        }
        [btn_magazine setBackgroundImage:img forState:UIControlStateNormal];
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

-(void)reloadViews
{
    
}

#pragma mark -
#pragma mark buttonFunction
-(void)turnToDetail:(UIButton *)sender
{
    for (int i = 0; i < [arr_magzine count]; i++) {
        NSDictionary *dic_temp = [arr_magzine objectAtIndex:i];
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
    MagazineDownloadedViewController *con_magazineInfo = [[MagazineDownloadedViewController alloc] init];
    [self.navigationController pushViewController:con_magazineInfo animated:YES];
}

#pragma mark -
#pragma mark connection
-(void)requestMagzineList
{
    NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@",DEFAULT_URL]];
    //设置
	ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:url];
	//设置ASIHTTPRequest代理
	request.delegate = self;
    //设置是是否支持断点下载
	[request setAllowResumeForFileDownloads:NO];
	//设置基本信息
    NSString *httpBodyString = [self magzineListRequestBody];
	NSLog(@"request topiclist  httpBodyString :%@",httpBodyString);
	
    NSData *postData = [httpBodyString dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *dic_userInfo = [[NSMutableDictionary alloc] init];
    [dic_userInfo setObject:@"requestMagzineList" forKey:@"operate"];
    [request setUserInfo:dic_userInfo];
    [request setPostBody:postData];
    [request setRequestMethod:@"POST"];
    //添加到ASINetworkQueue队列去下载
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
	[app.netWorkQueue addOperation:request];
}

-(NSString *)magzineListRequestBody
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
    
    if ([str_operate isEqualToString:@"requestMagzineList"]) {
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
                UIButton *btn_magzine = [UIButton buttonWithType:UIButtonTypeCustom];
                int row = [arr_total count]/4;
                int col = [arr_total count]%4;
                btn_magzine.frame = CGRectMake(10+80*col, 10+93*row, 60, 60);
                [btn_magzine setBackgroundImage:[UIImage imageNamed:@"bookcover.png"] forState:UIControlStateNormal];
                [view_content addSubview:btn_magzine];
                [dic_itemSaved setObject:btn_magzine forKey:@"button"];
                [arr_total addObject:dic_itemSaved];
            }
        }
        
        [[SqlManager sharedManager] saveMagazineList:arr_total];
        for (int i = 0; i < [arr_total count]; i++) {
            NSDictionary *dic_temp = [arr_total objectAtIndex:i];
            NSString *str_id = [dic_temp objectForKey:@"id"];
            NSMutableDictionary *dic_tempInfo = [[NSMutableDictionary alloc] initWithDictionary:[[SqlManager sharedManager] getMagazineInfoWithID:str_id]];
            UIButton *btn_magazine = (UIButton *)[dic_temp objectForKey:@"button"];
            [dic_tempInfo setObject:btn_magazine forKey:@"button"];
            [btn_magazine addTarget:self action:@selector(turnToDetail:) forControlEvents:UIControlEventTouchUpInside];
            NSString *str_imgAddress= [dic_tempInfo objectForKey:@"coverImgAddress"];
            if ([str_imgAddress length] == 0) {
                [self requestCover:dic_tempInfo];
            }
            else {
                UIImage *img;
                if ([str_imgAddress length] > 0) {
                    NSFileManager *fileManager = [NSFileManager defaultManager];
                    NSData *data_img = [fileManager contentsAtPath:str_imgAddress];
                    UIImage *image = [UIImage imageWithData:data_img];
                    NSString *str_address = [dic_tempInfo objectForKey:@"address"];
                    if ([str_address length] > 0) {
                        img = image;
                    }
                    else {
                        // Draw image1
                        UIGraphicsBeginImageContext(image.size);
                        //用当前的图形上下文的资源。
                        [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height) blendMode:kCGBlendModeLuminosity alpha:0.6f]; 
                        //CGContextRef context = UIGraphicsGetCurrentContext();
                        CGImageRef image = CGBitmapContextCreateImage(UIGraphicsGetCurrentContext());
                        img =  [UIImage imageWithCGImage:image];  
                        UIGraphicsEndImageContext();
                    }
                }
                [btn_magazine setBackgroundImage:img forState:UIControlStateNormal];
            }
            [arr_magzine addObject:dic_tempInfo];
        }
    }
    else if ([str_operate isEqualToString:@"downloadImg"]) {
        UIImage *image = [[UIImage alloc] initWithData:request.responseData];
        NSString *str_id = [dic_userInfo objectForKey:@"id"];
        NSString *str_fileName = request.url.lastPathComponent;
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *str_address = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/Caches/Magazine/%@",str_fileName]];
        if ([[SqlManager sharedManager] saveDoc:request.responseData address:str_address] == YES) {
            [[SqlManager sharedManager] saveMagezineCover:str_id imgAddress:str_address];
        }
        for (int i = 0; i < [arr_magzine count]; i++) {
            NSDictionary *dic_temp = [arr_magzine objectAtIndex:i];
            NSString *str_tempID = [dic_temp objectForKey:@"id"];
            if ([str_id isEqualToString:str_tempID]) {
                UIButton *btn_magzine = [dic_temp objectForKey:@"button"];
                UIGraphicsBeginImageContext(image.size);
                [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height) blendMode:kCGBlendModeLuminosity alpha:0.6f]; 
                //CGContextRef context = UIGraphicsGetCurrentContext();
                CGImageRef imageRef = CGBitmapContextCreateImage(UIGraphicsGetCurrentContext());
                UIImage *img =  [UIImage imageWithCGImage:imageRef];  
                UIGraphicsEndImageContext();
                [[SqlManager sharedManager] saveDoc:UIImagePNGRepresentation(image) address:str_address];
                [btn_magzine setBackgroundImage:img forState:UIControlStateNormal];
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
