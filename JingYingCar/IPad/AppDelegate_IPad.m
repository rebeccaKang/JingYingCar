//
//  AppDelegate_IPad.m
//  JingYingCar
//
//  Created by JiaMing Yan on 12-4-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate_IPad.h"
#import "HostViewController_IPad.h"
#import "ImagesViewController_IPad.h"
#import "BookshelfViewController_IPad.h"
#import "SettingViewController_IPad.h"
#import "TopicViewController_IPad.h"
#import "MoreViewController_IPad.h"
#import "SearchViewController_IPad.h"

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


@implementation AppDelegate_IPad

@synthesize window = _window;
@synthesize netWorkQueue;
@synthesize fontSize;
@synthesize bufferTime;
@synthesize navCon_main;
@synthesize arr_shouldRequest;
@synthesize isShowSetting;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    netWorkQueue  = [[ASINetworkQueue alloc] init];
	[netWorkQueue reset];
	[netWorkQueue setShowAccurateProgress:YES];
	[netWorkQueue go];
    
    arr_requests = [[NSMutableArray alloc] init];
    
    [self getClassTotal];
    
    NSDictionary *dic_configure = [[NSDictionary alloc] initWithDictionary:[[SqlManager sharedManager] readConfigure]];
    fontSize = [[dic_configure objectForKey:@"fontSize"] integerValue];
    bufferTime = [[dic_configure objectForKey:@"bufferTime"] integerValue];
    
//    HostViewController *con_hostView = [[HostViewController alloc] init];
//    UINavigationController *nav_hostView = [[UINavigationController alloc] initWithRootViewController:con_hostView];
//    nav_hostView.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"首页" image:[UIImage imageNamed:@"host2.png"] tag:0];
//    
//    ImagesViewController *con_images = [[ImagesViewController alloc] init];
//    UINavigationController *nav_imgsView = [[UINavigationController alloc] initWithRootViewController:con_images];
//    nav_imgsView.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"图库" image:[UIImage imageNamed:@"images1.png"] tag:1];
//    
//    TopicViewController *con_topic = [[TopicViewController alloc] init];
//    UINavigationController *nav_topic = [[UINavigationController alloc] initWithRootViewController:con_topic];
//    nav_topic.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"文章" image:[UIImage imageNamed:@"topic1.png"] tag:2];
//    
//    BookshelfViewController *con_bookshelf = [[BookshelfViewController alloc] init];
//    UINavigationController *nav_bookshelf = [[UINavigationController alloc] initWithRootViewController:con_bookshelf];
//    nav_bookshelf.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"杂志" image:[UIImage imageNamed:@"magazine1.png"] tag:3];
//    
//    MoreViewController *con_more = [[MoreViewController alloc] init];
//    con_more.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"更多" image:[UIImage imageNamed:@"more1.png"] tag:4];
//    tabCon_main = [[UITabBarController alloc] init];
//    tabCon_main.delegate = self;
//    NSArray *arr_controllers = [NSArray arrayWithObjects:nav_hostView,nav_imgsView,nav_topic,nav_bookshelf,con_more, nil];
//    tabCon_main.viewControllers = arr_controllers;
//    
//    [self.window setRootViewController:tabCon_main];
    
    HostViewController_IPad *con_hostView = [[HostViewController_IPad alloc] init];
    con_hostView.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"首页" image:[UIImage imageNamed:@"host_ipad.png"] tag:0];
    
    ImagesViewController_IPad *con_images = [[ImagesViewController_IPad alloc] init];
    con_images.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"图库" image:[UIImage imageNamed:@"images_ipad.png"] tag:1];
    
    TopicViewController_IPad *con_topic = [[TopicViewController_IPad alloc] init];
    con_topic.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"文章" image:[UIImage imageNamed:@"topic_ipad.png"] tag:2];
    
    BookshelfViewController_IPad *con_bookshelf = [[BookshelfViewController_IPad alloc] init];
    con_bookshelf.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"杂志" image:[UIImage imageNamed:@"magazine_ipad.png"] tag:3];
    
    MoreViewController_IPad *con_more = [[MoreViewController_IPad alloc] init];
    con_more.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"更多" image:[UIImage imageNamed:@"more_ipad.png"] tag:4];
    
    tabCon_main = [[UITabBarController alloc] init];
    tabCon_main.delegate = self;
    NSArray *arr_controllers = [NSArray arrayWithObjects:con_hostView,con_images,con_topic,con_bookshelf,con_more, nil];
    tabCon_main.viewControllers = arr_controllers;
    
    nav_main = [[UINavigationController alloc] initWithRootViewController:tabCon_main];
    nav_main.navigationBarHidden = YES;
    
    [self.window setRootViewController:nav_main];
    
//    NSString *str_version = [UIDevice currentDevice].systemVersion;
//    if ([str_version intValue] > 4) {
//        [nav_main.navigationBar setBackgroundImage:[UIImage imageNamed:@"navHotNews.png"] forBarMetrics:UIBarMetricsDefault];
//    }
//    else {
//        [nav_main.navigationBar setImage:@"navHotNews.png"];
//    }
    
    //tabCon_main.title = @"精英车主";
    
//    UILabel *lb_title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 55)];
//    lb_title.backgroundColor = [UIColor clearColor];
//    lb_title.font = [UIFont boldSystemFontOfSize:24];
//    lb_title.textAlignment = UITextAlignmentCenter;
//    lb_title.text = @"精英车主";
//    lb_title.tag = 100;
//    [nav_main.navigationBar addSubview:lb_title];
//   
    
    UIButton *btn_left = [UIButton buttonWithType:UIButtonTypeCustom];
	btn_left.frame = CGRectMake(15, 15, 25, 25);
    [btn_left setBackgroundImage:[UIImage imageNamed:@"search.png"] forState:UIControlStateNormal];	
    [btn_left addTarget:self action:@selector(turnToSearch:) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *barBtn_left = [[UIBarButtonItem alloc] initWithCustomView:btn_left];
    tabCon_main.navigationItem.leftBarButtonItem = barBtn_left;
    
    UIButton *btn_right = [UIButton buttonWithType:UIButtonTypeCustom];
	btn_right.frame = CGRectMake(15, 15, 25, 25);
    [btn_right setBackgroundImage:[UIImage imageNamed:@"setting.png"] forState:UIControlStateNormal];	
	UIBarButtonItem *barBtn_right = [[UIBarButtonItem alloc] initWithCustomView:btn_right];
    tabCon_main.navigationItem.rightBarButtonItem = barBtn_right;
    
    arr_shouldRequest = [[NSMutableArray alloc] initWithObjects:@"1",@"1",@"1",@"1", nil];
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    NSDate *time = [NSDate date];
    NSDateFormatter *dateForm_time = [[NSDateFormatter alloc] init];
    [dateForm_time setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
    [dateForm_time setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *strTime = [dateForm_time stringFromDate:time];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:strTime forKey:@"lastLogOutTime"];
    
    [[SqlManager sharedManager] emptyBuffer:bufferTime];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [self getClassTotal];
    for (int i = 0; i < [arr_shouldRequest count]; i++) {
        [arr_shouldRequest replaceObjectAtIndex:i withObject:@"0"];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[SqlManager sharedManager] emptyBuffer:bufferTime];
    [self cancelAllRequests];
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
#pragma mark buttonFunction
-(void)turnToSearch:(UIButton *)sender
{
    SearchViewController_IPad *con_seach = [[SearchViewController_IPad alloc] init];
    [nav_main pushViewController:con_seach animated:YES];
}

#pragma mark -
#pragma mark connection
-(void)sendDeviceToken:(NSString *)deviceToken
{
    NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@/SendDeviceToken.ashx",BASIC_URL]];
    //设置
	ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:url];
	//设置ASIHTTPRequest代理
	request.delegate = self;
    //设置是是否支持断点下载
	[request setAllowResumeForFileDownloads:NO];
	//设置基本信息
    NSString *httpBodyString = [self setSendDeviceTokenRequestBody:deviceToken];
	NSLog(@"request deviceToken  httpBodyString :%@",httpBodyString);
	
    NSData *postData = [httpBodyString dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *dic_userInfo = [[NSMutableDictionary alloc] init];
    [dic_userInfo setObject:@"sendDeviceToken" forKey:@"operate"];
    [request setUserInfo:dic_userInfo];
    [request setPostBody:postData];
    [request setRequestMethod:@"POST"];
    //添加到ASINetworkQueue队列去下载
	[netWorkQueue addOperation:request];
    [arr_requests addObject:request];
}

-(void)getClassTotal
{
    //设置
    NSURL *url = [[NSURL alloc] initWithString:DEFAULT_URL];
	ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:url];
	//设置ASIHTTPRequest代理
	request.delegate = self;
    //设置是是否支持断点下载
	[request setAllowResumeForFileDownloads:NO];
	//设置基本信息
    NSString *httpBodyString = [self setGetTotalRequestBody];
	NSLog(@"request total  httpBodyString :%@",httpBodyString);
	
    NSData *postData = [httpBodyString dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *dic_userInfo = [[NSMutableDictionary alloc] init];
    [dic_userInfo setObject:@"GetTotal" forKey:@"operate"];
    [request setUserInfo:dic_userInfo];
    [request setPostBody:postData];
    [request setRequestMethod:@"POST"];
    //添加到ASINetworkQueue队列去下载
	[netWorkQueue addOperation:request];
    [arr_requests addObject:request];
}

-(NSString *)setGetTotalRequestBody
{
    DDXMLNode *node_operate = [DDXMLNode elementWithName:@"Operate" stringValue:@"GetTotal"];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *str_time = [userDefault objectForKey:@"lastLogOutTime"];
    if ([str_time length] == 0) {
        str_time = @"1900-00-00 00:00:00";
    }
    DDXMLNode *node_update = [DDXMLNode elementWithName:@"Update" stringValue:str_time];
    NSArray *arr_request = [[NSArray alloc] initWithObjects:node_operate,node_update,nil];
    DDXMLElement *element_request = [[DDXMLElement alloc] initWithName: @"Request"];
    [element_request setChildren:arr_request];
    return [element_request XMLString];
}

-(NSString *)setSendDeviceTokenRequestBody:(NSString *)deviceToken
{
    DDXMLNode *node_operate = [DDXMLNode elementWithName:@"Operate" stringValue:@"SendDeviceToken"];
    DDXMLNode *node_deviceToken = [DDXMLNode elementWithName:@"DeviceToken" stringValue:[deviceToken substringWithRange:NSMakeRange(1, deviceToken.length - 2)]];
    NSArray *arr_request = [[NSArray alloc] initWithObjects:node_operate,node_deviceToken,nil];
    DDXMLElement *element_request = [[DDXMLElement alloc] initWithName: @"Request"];
    [element_request setChildren:arr_request];
    return [element_request XMLString];
}

#pragma mark -
#pragma mark TabbarDelegate
-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    if (isShowSetting == YES) {
        SettingMainView_ipad *view_setting = (SettingMainView_ipad *)[self.window viewWithTag:settingViewTag];
        [view_setting hide:YES];
        isShowSetting = NO;
    }
    switch (tabBarController.selectedIndex) {
        case 0:
        {
            NSLog(@"0");
        }
            break;
        case 1:
        {
            NSLog(@"1");
            viewController.tabBarItem.badgeValue = 0;
            //tabCon_main.title = @"精英图库";
        }
            break;
        case 2:
        {
            NSLog(@"2");
            viewController.tabBarItem.badgeValue = 0;
            //tabCon_main.title = @"文章";
        }
            break;
        case 3:
        {
            NSLog(@"3");
            //tabCon_main.title = @"精英杂志期刊";
        }
            break;
        case 4:
        {
            NSLog(@"4");
            //tabCon_main.title = @"更多";
        }
            break;
        default:
            break;
    }
}

#pragma mark -
#pragma mark ASIHttpRequestDelegate
//ASIHTTPRequestDelegate,下载之前获取信息的方法,主要获取下载内容的大小
- (void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders
{
}
//ASIHTTPRequestDelegate,下载完成时,执行的方法
- (void)requestFinished:(ASIHTTPRequest *)request {
    NSDictionary *dic_info = request.userInfo;
    NSString *str_operate = [dic_info objectForKey:@"operate"];
    //NSLog(@"str_operate:%@",str_operate);
    
    NSData *_data = request.responseData;
    NSString *responseString = [[NSString alloc] initWithData:_data encoding:NSUTF8StringEncoding];
    NSLog(@"responseString1:%@",responseString);
    
    if ([str_operate isEqualToString:@"GetTotal"]) {
        NSError *error = nil;
        DDXMLDocument* xmlDoc = [[DDXMLDocument alloc] initWithXMLString:responseString options:0 error:&error];
        if (error) {
            NSLog(@"%@",[error localizedDescription]);
        }
        NSArray *arr_reponse = [xmlDoc nodesForXPath:@"//Response" error:&error];
        for (DDXMLElement *element_reponse in arr_reponse) {
            NSArray *arr_code = [element_reponse elementsForName:@"Code"];
            NSString *str_code = [[arr_code objectAtIndex:0] stringValue];
            
            NSArray *arr_HotNewsInfo = [element_reponse elementsForName:@"HotNews"];
            DDXMLElement *element_hotNewsInfo = [arr_HotNewsInfo objectAtIndex:0];
            NSArray *arr_hotNewsRefresh = [element_hotNewsInfo elementsForName:@"Refresh"];
            NSString *str_hotNewsRefresh = [[arr_hotNewsRefresh objectAtIndex:0] stringValue];
            NSArray *arr_hotNewsDelete = [element_hotNewsInfo elementsForName:@"Delete"];
            NSString *str_hotNewsDelete = [[arr_hotNewsDelete objectAtIndex:0] stringValue];
            NSArray *arr_hotNewsDeleteIDs = [str_hotNewsDelete componentsSeparatedByString:@","];
            for (int i = 0; i < [arr_hotNewsDeleteIDs count]; i++) {
                [[SqlManager sharedManager] deleteHotNews:[arr_hotNewsDeleteIDs objectAtIndex:i]];
            }
            
            NSArray *arr_topicInfo = [element_reponse elementsForName:@"Topic"];
            //NSInteger oldTopicNum = [[SqlManager sharedManager] getTopicsUnreadedNumber];
            DDXMLElement *element_topicInfo = [arr_topicInfo objectAtIndex:0];
            NSArray *arr_topicRefresh = [element_topicInfo elementsForName:@"Refresh"];
            NSString *str_topicRefresh = [[arr_topicRefresh objectAtIndex:0] stringValue];
            NSArray *arr_topicDelete = [element_topicInfo elementsForName:@"Delete"];
            NSString *str_topicDelete = [[arr_topicDelete objectAtIndex:0] stringValue];
            NSArray *arr_topicDeleteIDs = [str_topicDelete componentsSeparatedByString:@","];
            for (int i = 0; i < [arr_topicDeleteIDs count]; i++) {
                [[SqlManager sharedManager] deleteHotNews:[arr_topicDeleteIDs objectAtIndex:i]];
            }
            
            NSArray *arr_imagesInfo = [element_reponse elementsForName:@"Images"];
            //NSInteger oldImageNum = [[SqlManager sharedManager] getImagesUnreadedNumber];
            DDXMLElement *element_imagesInfo = [arr_imagesInfo objectAtIndex:0];
            NSArray *arr_imagesRefresh = [element_imagesInfo elementsForName:@"Refresh"];
            NSString *str_imagesRefresh = [[arr_imagesRefresh objectAtIndex:0] stringValue];
            NSArray *arr_imagesDelete = [element_imagesInfo elementsForName:@"Delete"];
            NSString *str_imagesDelete = [[arr_imagesDelete objectAtIndex:0] stringValue];
            NSArray *arr_imagesDeleteIDs = [str_imagesDelete componentsSeparatedByString:@","];
            for (int i = 0; i < [arr_imagesDeleteIDs count]; i++) {
                [[SqlManager sharedManager] deleteHotNews:[arr_imagesDeleteIDs objectAtIndex:i]];
            }
            
            NSArray *arr_magazineInfo = [element_reponse elementsForName:@"Magazine"];
            DDXMLElement *element_magazineInfo = [arr_magazineInfo objectAtIndex:0];
            NSArray *arr_magazineRefresh = [element_magazineInfo elementsForName:@"Refresh"];
            NSString *str_magazineRefresh = [[arr_magazineRefresh objectAtIndex:0] stringValue];
            NSArray *arr_magazineDelete = [element_magazineInfo elementsForName:@"Delete"];
            NSString *str_magazineDelete = [[arr_magazineDelete objectAtIndex:0] stringValue];
            NSArray *arr_magazineDeleteIDs = [str_magazineDelete componentsSeparatedByString:@","];
            for (int i = 0; i < [arr_magazineDeleteIDs count]; i++) {
                [[SqlManager sharedManager] deleteHotNews:[arr_magazineDeleteIDs objectAtIndex:i]];
            }
            
            for (UIViewController *controller in tabCon_main.viewControllers) {
                if (controller.tabBarItem.tag == 1) {
                    if ([str_imagesRefresh intValue] > 0) {
                        controller.tabBarItem.badgeValue = str_imagesRefresh;
                    }
                }
                else if(controller.tabBarItem.tag == 2)
                {
                    if ([str_topicRefresh intValue] > 0) {
                        controller.tabBarItem.badgeValue = str_topicRefresh;
                    }
                }
            }
        }
    }
}


//ASIHTTPRequestDelegate,下载失败
- (void)requestFailed:(ASIHTTPRequest *)request {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" 
                                                        message:@"下载失败，请检查网络状况"
                                                       delegate:self 
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
    
    [alertView show];
}

#pragma mark -
#pragma mark Push

- (void) launchNotification: (NSNotification *) notification
{
	[self performSelector:@selector(showString:) withObject:[[notification userInfo] description] afterDelay:1.0f];
}

- (void) showString: (NSString *) aString
{
	NSLog(aString);
}

//NSString *pushStatus ()
//{
//	return [[UIApplication sharedApplication] enabledRemoteNotificationTypes] ?
//	@"Notifications were active for this application" :
//	@"Remote notifications were not active for this application";
//}

// Little hack work-around to catch the end when the confirmation dialog goes away
- (void) confirmationWasHidden: (NSNotification *) notification
{
	// A secondary registration helps work through early 3.0 beta woes. It costs nothing and has no
	// ill side effects, so can be used without worry.
	[[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
}

// Retrieve the device token
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
	//NSUInteger rntypes = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
	//	NSString *results = [NSString stringWithFormat:@"Badge: %@, Alert:%@, Sound: %@",
	//						 (rntypes & UIRemoteNotificationTypeBadge) ? @"Yes" : @"No", 
	//						 (rntypes & UIRemoteNotificationTypeAlert) ? @"Yes" : @"No",
	//						 (rntypes & UIRemoteNotificationTypeSound) ? @"Yes" : @"No"];
	//	
	//	NSString *status = [NSString stringWithFormat:@"%@\nRegistration succeeded.\n\nDevice Token: %@\n%@", pushStatus(), deviceToken, results];
	//	[self showString:status];
	NSUserDefaults *ud_temp = [NSUserDefaults standardUserDefaults];
	NSString *str_deviceToken = [deviceToken description];
	[ud_temp setObject:str_deviceToken forKey:@"deviceToken"];
	NSLog(@"deviceToken: %@,%@", [ud_temp objectForKey:@"deviceToken"],deviceToken); 
    [self sendDeviceToken:str_deviceToken];
} 

// Provide a user explanation for when the registration fails
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error 
{
	//NSString *status = [NSString stringWithFormat:@"%@\nRegistration failed.\n\nError: %@", pushStatus(), [error localizedDescription]];
	//	[self showString:status];
    NSLog(@"Error in registration. Error: %@", error); 
} 

// Handle an actual notification
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
	//NSString *status = [NSString stringWithFormat:@"Notification received:\n%@",[userInfo description]];
	//	[self showString:status];
	//	CFShow([userInfo description]);
//	SoundEffect *soundAlert = [[SoundEffect alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Done" ofType:@"aiff"]];
//	[soundAlert play];
	NSLog(@"收到推送消息 ： %@",[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]);
    //	[dataSyncVc getDocumentData];
	//    if ([[userInfo objectForKey:@"aps"] objectForKey:@"alert"]!=NULL) {
	//        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"推送通知"
	//                                                        message:[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]
	//                                                       delegate:self
	//                                              cancelButtonTitle:@"关闭"
	//                                              otherButtonTitles:@"更新状态",nil];
	//        [alert show];
	//        [alert release];
	//	}
    //	[dataSync release];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(NSDictionary *)userInfo
{
	//NSString *status = [NSString stringWithFormat:@"Notification received:\n%@",[userInfo description]];
	//	[self showString:status];
	//	CFShow([userInfo description]);
	NSLog(@"收到推送消息 ： %@",[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]);
	//    if ([[userInfo objectForKey:@"aps"] objectForKey:@"alert"]!=NULL) {
	//        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"推送通知"
	//                                                        message:[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]
	//                                                       delegate:self
	//                                              cancelButtonTitle:@"关闭"
	//                                              otherButtonTitles:@"更新状态",nil];
	//        [alert show];
	//        [alert release];
	//	}
}

@end
