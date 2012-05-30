//
//  TopicDetailViewController_IPad.m
//  JingYingCar
//
//  Created by JiaMing Yan on 12-4-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TopicDetailViewController_IPad.h"

@interface TopicDetailViewController_IPad ()

@end

@implementation TopicDetailViewController_IPad

@synthesize str_id;
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
    UIView *view_nav = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 768, 45)];
    view_nav.backgroundColor = [UIColor clearColor];
    [self.view addSubview:view_nav];
    
    UIImageView *imgView_navBK = [[UIImageView alloc] initWithFrame:view_nav.bounds];
    imgView_navBK.image = [UIImage imageNamed:@"hostNav_ipad.png"];
    [view_nav addSubview:imgView_navBK];
    
    UIButton *btn_back = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_back.frame = CGRectMake(10, 7.5f, 50, 30);
    [btn_back setBackgroundImage:[UIImage imageNamed:@"back_ipad.png"] forState:UIControlStateNormal];
    //[btn_back setTitle:@" 返回" forState:UIControlStateNormal];
    [btn_back addTarget:self action:@selector(turnBack) forControlEvents:UIControlEventTouchUpInside];
    [btn_back setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn_back.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    btn_back.titleLabel.textAlignment = UITextAlignmentRight;
    [view_nav addSubview:btn_back];
    
    UIView *view_content = [[UIView alloc] initWithFrame:CGRectMake(0, 45, 768, 915)];
    view_content.backgroundColor = [UIColor clearColor];
    [self.view addSubview:view_content];
    
    UIView *view_bottom = [[UIView alloc] initWithFrame:CGRectMake(0, 960, 768, 45)];
    view_bottom.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"topicBottomNav_ipad.png"]];
    [self.view addSubview:view_bottom];
    
    UIButton *btn_share = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_share.frame = CGRectMake(200, 8, 28, 29);
    [btn_share setBackgroundImage:[UIImage imageNamed:@"share_ipad.png"] forState:UIControlStateNormal];
    //[btn_share setBackgroundImage:[UIImage imageNamed:@"shareHighlighted.png"] forState:UIControlStateHighlighted];
    [btn_share addTarget:self action:@selector(showShareList) forControlEvents:UIControlEventTouchUpInside];
    [view_bottom addSubview:btn_share];
    
    UIButton *btn_fontSmall = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_fontSmall.frame = CGRectMake(510, 8, 28, 29);
    [btn_fontSmall setBackgroundImage:[UIImage imageNamed:@"fontSmall_ipad.png"] forState:UIControlStateNormal];
    //[btn_fontSmall setBackgroundImage:[UIImage imageNamed:@"topicHighlighted.png"] forState:UIControlStateHighlighted];
    [btn_fontSmall addTarget:self action:@selector(fontSmaller) forControlEvents:UIControlEventTouchUpInside];
    [view_bottom addSubview:btn_fontSmall];
    
    UIButton *btn_fontLarge = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_fontLarge.frame = CGRectMake(560, 8, 28, 29);
    [btn_fontLarge setBackgroundImage:[UIImage imageNamed:@"fontLarge_ipad.png"] forState:UIControlStateNormal];
    //[btn_fontLarge setBackgroundImage:[UIImage imageNamed:@"topicHighlighted.png"] forState:UIControlStateHighlighted];
    [btn_fontLarge addTarget:self action:@selector(fontLarger) forControlEvents:UIControlEventTouchUpInside];
    [view_bottom addSubview:btn_fontLarge];
    
    UIButton *btn_collect = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_collect.frame = CGRectMake(723, 5, 35, 35);
    isCollected = [[SqlManager sharedManager] isCollected:str_id];
    if (isCollected == 0) {
        [btn_collect setBackgroundImage:[UIImage imageNamed:@"uncollected_ipad.png"] forState:UIControlStateNormal];
    }
    else if(isCollected == 1)
    {
        [btn_collect setBackgroundImage:[UIImage imageNamed:@"collected_ipad.png"] forState:UIControlStateNormal];
    }
    [btn_collect addTarget:self action:@selector(collect:) forControlEvents:UIControlEventTouchUpInside];
    [view_nav addSubview:btn_collect];
    
    NSDictionary *dic_info;
    NSLog(@"type:%d,str_id:%@",type,str_id);
    switch (type) {
        case 0:
        {
            dic_info = [[NSDictionary alloc] initWithDictionary:[[SqlManager sharedManager] getNewsDetail:str_id] copyItems:YES];
        }
            break;
        case 1:
        {
            dic_info = [[NSDictionary alloc] initWithDictionary:[[SqlManager sharedManager] getImageDetail:str_id] copyItems:YES];
        }
            break;
        case 2:
        {
            dic_info = [[NSDictionary alloc] initWithDictionary:[[SqlManager sharedManager] getTopicListWithID:str_id] copyItems:YES];
        }
            break;
        default:
            break;
    }
    //NSLog(@"detail:%@",dic_info);
    str_class = [dic_info objectForKey:@"class"];
    NSString *str_isReaded = [dic_info objectForKey:@"isReaded"];
    if ([str_class intValue] == 1) {
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"blackBackground_ipad.png"]];
        
        sclView_topic = [[UIScrollView alloc] initWithFrame:view_content.bounds];
        sclView_topic.backgroundColor = [UIColor clearColor];
        [view_content addSubview:sclView_topic];
        
        lb_title = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 728, 60)];
        lb_title.font = [UIFont boldSystemFontOfSize:28];
        lb_title.textAlignment = UITextAlignmentLeft;
        lb_title.backgroundColor = [UIColor clearColor];
        lb_title.textColor = [UIColor whiteColor];
        [sclView_topic addSubview:lb_title];
        
        tv_content = [[UITextView alloc] initWithFrame:CGRectMake(20, 460, 728, 450)];
        
        sclView_topic.contentSize = CGSizeMake(768, 60+400+tv_content.frame.size.height);
        
        tv_content.backgroundColor = [UIColor clearColor];
        tv_content.textColor = [UIColor whiteColor];
        tv_content.userInteractionEnabled = NO;
        [sclView_topic addSubview:tv_content];
        
        imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 60, 768, 400)];
        imgView.backgroundColor = [UIColor grayColor];
        [sclView_topic addSubview:imgView];
        
        btn_hideShare = [UIButton buttonWithType:UIButtonTypeCustom];
        btn_hideShare.backgroundColor = [UIColor clearColor];
        btn_hideShare.frame = CGRectMake(0, 0, 768, 915);
        [btn_hideShare addTarget:self action:@selector(hideShareList) forControlEvents:UIControlEventTouchUpInside];
        btn_hideShare.tag = 12;
        btn_hideShare.enabled = NO;
        [self.view addSubview:btn_hideShare];
        
        view_shareList = [[UIView alloc] initWithFrame:CGRectMake(50, 960, 332, 366)];
        view_shareList.backgroundColor = [UIColor clearColor];
        [self.view addSubview:view_shareList];
        
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideShareList)];
//        tap.numberOfTapsRequired = 1;
//        tap.numberOfTouchesRequired = 1;
//        tap.delegate = self;
//        [view_shareList addGestureRecognizer:tap];
        
        UIImageView *imgView_bk = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shareBackground_ipad.png"]];
        imgView_bk.frame = view_shareList.bounds;
        [view_shareList addSubview:imgView_bk];
        
        UIButton *btn_sinaShare = [UIButton buttonWithType:UIButtonTypeCustom];
        btn_sinaShare.frame = CGRectMake(17, 100, 298, 54);
        //[btn_sinaShare setTitle:@"分享到新浪微博" forState:UIControlStateNormal];
        [btn_sinaShare setBackgroundImage:[UIImage imageNamed:@"shareSina_ipad.png"] forState:UIControlStateNormal];
        [btn_sinaShare setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn_sinaShare addTarget:self action:@selector(showSinaShare) forControlEvents:UIControlEventTouchUpInside];
        [view_shareList addSubview:btn_sinaShare];
        
//        UIButton *btn_tecentShare = [UIButton buttonWithType:UIButtonTypeCustom];
//        btn_tecentShare.frame = CGRectMake(17, 134, 298, 54);
//        //[btn_emailShare setTitle:@"邮件分享此文章" forState:UIControlStateNormal];
//        [btn_tecentShare setBackgroundImage:[UIImage imageNamed:@"shareTecent_ipad.png"] forState:UIControlStateNormal];
//        [btn_tecentShare setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [btn_tecentShare addTarget:self action:@selector(showEmailShare) forControlEvents:UIControlEventTouchUpInside];
//        [view_shareList addSubview:btn_tecentShare];
//        
//        UIButton *btn_sohuShare = [UIButton buttonWithType:UIButtonTypeCustom];
//        btn_sohuShare.frame = CGRectMake(17, 208, 298, 54);
//        //[btn_emailShare setTitle:@"邮件分享此文章" forState:UIControlStateNormal];
//        [btn_sohuShare setBackgroundImage:[UIImage imageNamed:@"shareSohu_ipad.png"] forState:UIControlStateNormal];
//        [btn_sohuShare setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [btn_sohuShare addTarget:self action:@selector(showEmailShare) forControlEvents:UIControlEventTouchUpInside];
//        [view_shareList addSubview:btn_sohuShare];
//        
//        UIButton *btn_163Share = [UIButton buttonWithType:UIButtonTypeCustom];
//        btn_163Share.frame = CGRectMake(17, 282, 298, 54);
//        //[btn_emailShare setTitle:@"邮件分享此文章" forState:UIControlStateNormal];
//        [btn_163Share setBackgroundImage:[UIImage imageNamed:@"share163_ipad.png"] forState:UIControlStateNormal];
//        [btn_163Share setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [btn_163Share addTarget:self action:@selector(showEmailShare) forControlEvents:UIControlEventTouchUpInside];
//        [view_shareList addSubview:btn_163Share];
        
        UIButton *btn_emailShare = [UIButton buttonWithType:UIButtonTypeCustom];
        btn_emailShare.frame = CGRectMake(17, 200, 298, 54);
        //[btn_emailShare setTitle:@"邮件分享此文章" forState:UIControlStateNormal];
        [btn_emailShare setBackgroundImage:[UIImage imageNamed:@"shareEmail_ipad.png"] forState:UIControlStateNormal];
        [btn_emailShare setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn_emailShare addTarget:self action:@selector(showEmailShare) forControlEvents:UIControlEventTouchUpInside];
        [view_shareList addSubview:btn_emailShare];
        
//        UIButton *btn_cancelShare = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//        btn_cancelShare.frame = CGRectMake(10, 120, 300, 40);
//        [btn_cancelShare setTitle:@"取消" forState:UIControlStateNormal];
//        [btn_cancelShare setBackgroundImage:[UIImage imageNamed:@"shareBtn.png"] forState:UIControlStateNormal];
//        [btn_cancelShare setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [btn_cancelShare addTarget:self action:@selector(hideShareList) forControlEvents:UIControlEventTouchUpInside];
//        [view_share addSubview:btn_cancelShare];
    }
    else if([str_class intValue] == 2)
    {
        webView_detail = [[UIWebView alloc] initWithFrame:view_content.bounds];
        webView_detail.backgroundColor = [UIColor clearColor];
        webView_detail.userInteractionEnabled = true;
        webView_detail.scalesPageToFit = YES;
        [webView_detail setDelegate:self];
        [view_content addSubview:webView_detail];
        
    }
    
    SinaEngine = [[WBEngine alloc] initWithAppKey:kWBSDKDemoAppKey appSecret:kWBSDKDemoAppSecret];
    [SinaEngine setRootViewController:self];
    [SinaEngine setDelegate:self];
    [SinaEngine setRedirectURI:@"http://"];
    [SinaEngine setIsUserExclusive:NO];
    
    indView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indView.center = self.view.center;
    [self.view addSubview:indView];
    [self.view bringSubviewToFront:indView];
    
    if ([str_isReaded isEqualToString:@"0"]) {
        imgView.frame = CGRectMake(0, 0, 0, 0);
        tv_content.frame = CGRectMake(0, 60, 768, 850);
        [self requestDetail];
    }
    else {
        if ([str_class intValue] == 1 || type == 1) {
            NSString *str_title = [dic_info objectForKey:@"contentTitle"];
            NSString *str_content = [dic_info objectForKey:@"contentDetail"];
            lb_title.text = str_title;
            
            tv_content.text = str_content;
            
            UIImage *img;
            NSString *str_imgAddress = [dic_info objectForKey:@"contentImgAddress"];
            if ([str_imgAddress length] > 0) {
                NSFileManager *fileManager = [NSFileManager defaultManager];
                NSData *data_img = [fileManager contentsAtPath:str_imgAddress];
                img = [UIImage imageWithData:data_img];
                imgView.image = img;
            }
            
            [self refreshView];
        }
        else if([str_class intValue] == 2)
        {
            NSString *str_url = [dic_info objectForKey:@"contentUrl"];
            NSURL *url = [[NSURL alloc] initWithString:str_url];
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
            [webView_detail loadRequest:request];
        }
    }
    [self.view bringSubviewToFront:view_bottom];
    
    isShowShareList = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"精英车主";
    
    dic_detail = [[NSMutableDictionary alloc] init];
    
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

-(void)collect:(UIButton *)sender
{
    if (isCollected == 0) {
        NSLog(@"%d",type);
        BOOL result = [[SqlManager sharedManager] addMyCollectionWithFatherID:[NSString stringWithFormat:@"%d",type] childID:str_id];
        if (result == 0) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"收藏成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
            [sender setBackgroundImage:[UIImage imageNamed:@"collect.png"] forState:UIControlStateNormal];
            isCollected = 1;
        }
        else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"收藏失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
        }
    }
    else {
        int result = [[SqlManager sharedManager] deleteCollection:str_id];
        if (result == 0) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"已取消收藏" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
            [sender setBackgroundImage:[UIImage imageNamed:@"uncollected.png"] forState:UIControlStateNormal];
            isCollected = 0;
        }
        else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"取消收藏失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
        }
    }
}

-(void)fontLarger
{
    AppDelegate_IPad *app = (AppDelegate_IPad *)[UIApplication sharedApplication].delegate;
    if (app.fontSize < 2) {
        app.fontSize ++;
    }
    NSMutableDictionary *dic_configure = [[NSMutableDictionary alloc] init];
    [dic_configure setObject:[NSString stringWithFormat:@"%d",app.fontSize] forKey:@"fontSize"];
    [dic_configure setObject:[NSString stringWithFormat:@"%d",app.bufferTime] forKey:@"bufferTime"];
    [[SqlManager sharedManager] saveConfigure:dic_configure];
    [self refreshView];
}

-(void)fontSmaller
{
    AppDelegate_IPad *app = (AppDelegate_IPad *)[UIApplication sharedApplication].delegate;
    if (app.fontSize > 0) {
        app.fontSize --;
    }
    NSMutableDictionary *dic_configure = [[NSMutableDictionary alloc] init];
    [dic_configure setObject:[NSString stringWithFormat:@"%d",app.fontSize] forKey:@"fontSize"];
    [dic_configure setObject:[NSString stringWithFormat:@"%d",app.bufferTime] forKey:@"bufferTime"];
    [[SqlManager sharedManager] saveConfigure:dic_configure];
    [self refreshView];
}

-(void)refreshView
{
    AppDelegate_IPad *app = (AppDelegate_IPad *)[UIApplication sharedApplication].delegate;
    UIFont *font;
    switch (app.fontSize) {
        case 0:
            font = [UIFont systemFontOfSize:20];
            break;
        case 1:
            font = [UIFont systemFontOfSize:24];
            break;
        case 2:
            font = [UIFont systemFontOfSize:28];
            break;
        default:
            break;
    }
    tv_content.font = font;
    [tv_content sizeToFit];
    if (imgView.image == nil) {
        imgView.frame = CGRectMake(0, 0, 0, 0);
        tv_content.frame = CGRectMake(20, 60, 728, tv_content.contentSize.height);
        sclView_topic.contentSize = CGSizeMake(768, tv_content.frame.size.height + 60);
    }
    else {
        imgView.frame = CGRectMake(0, 60, 768, 400);
        tv_content.frame = CGRectMake(20, 460, 728, tv_content.contentSize.height);
        sclView_topic.contentSize = CGSizeMake(768, tv_content.frame.size.height + 400 + 60);
    }
}

-(void)showShareList
{
    if (isShowShareList == NO) {
        btn_hideShare.enabled = YES;
        CGRect originRect = view_shareList.frame;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.4f];
        [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:view_shareList cache:NO];
        view_shareList.frame = CGRectMake(originRect.origin.x, 589, originRect.size.width, originRect.size.height);
        [UIView commitAnimations];
        isShowShareList = YES;
    }
    else {
        [self hideShareList];
    }
}

-(void)hideShareList
{
    isShowShareList = NO;
    btn_hideShare.enabled = NO;
    CGRect originRect = view_shareList.frame;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.4f];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:view_shareList cache:NO];
    view_shareList.frame = CGRectMake(originRect.origin.x, 960, originRect.size.width, originRect.size.height);
    [UIView commitAnimations];
}

-(void)showEmailShare
{
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
    
    NSDictionary *dic_info;
    if (type == 0) {
        dic_info = [[SqlManager sharedManager] getNewsDetail:str_id];
    }
    else if (type == 2) {
        dic_info = [[SqlManager sharedManager] getTopicListWithID:str_id];
    }
    NSString *str_contentImgAddress = [dic_info objectForKey:@"contentImgAddress"];
    NSData *data_img = [NSData dataWithContentsOfFile:str_contentImgAddress];
    [picker addAttachmentData:data_img mimeType:@"image/png" fileName:str_contentImgAddress.lastPathComponent];
	
    NSString *str_title = lb_title.text;
	[picker setSubject:[NSString stringWithFormat:@"来自菁英车主:%@的分享",str_title]];
    
	// Set up recipients
//	NSArray *toRecipients = [NSArray arrayWithObject:@"first@example.com"]; 
//	NSArray *ccRecipients = [NSArray arrayWithObjects:@"second@example.com", @"third@example.com", nil]; 
//	NSArray *bccRecipients = [NSArray arrayWithObject:@"fourth@example.com"]; 
	
//	[picker setToRecipients:toRecipients];
//	[picker setCcRecipients:ccRecipients];	
//	[picker setBccRecipients:bccRecipients];
	
	// Attach an image to the email
//	NSString *path = [[NSBundle mainBundle] pathForResource:@"rainy" ofType:@"jpg"];
//	NSData *myData = [NSData dataWithContentsOfFile:path];
//	[picker addAttachmentData:myData mimeType:@"image/jpeg" fileName:@"rainy"];
	
	// Fill out the email body text
	NSString *emailBody = tv_content.text;
	[picker setMessageBody:emailBody isHTML:NO];
	
	[self presentModalViewController:picker animated:YES];
    
    [self hideShareList];
}

-(void)showSinaShare
{
    if ([SinaEngine isLoggedIn] && ![SinaEngine isAuthorizeExpired])
    {
        WBSendView *sendView = [[WBSendView alloc] initWithAppKey:kWBSDKDemoAppKey appSecret:kWBSDKDemoAppSecret text:tv_content.text image:imgView.image];
        [sendView setDelegate:self];
        
        [sendView show:YES];
    }
    else {
        [SinaEngine logIn];
    }
}

#pragma mark - WBEngineDelegate Methods

#pragma mark Authorize

- (void)engineAlreadyLoggedIn:(WBEngine *)engine
{
    //[indicatorView stopAnimating];
    if ([engine isUserExclusive])
    {
        UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil 
                                                           message:@"请先登出！" 
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定" 
                                                 otherButtonTitles:nil];
        [alertView show];
    }
}

- (void)engineDidLogIn:(WBEngine *)engine
{
    //[indicatorView stopAnimating];
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil 
													   message:@"登录成功！" 
													  delegate:self
											 cancelButtonTitle:@"确定" 
											 otherButtonTitles:nil];
    [alertView setTag:kWBAlertViewLogInTag];
	[alertView show];
}

- (void)engine:(WBEngine *)engine didFailToLogInWithError:(NSError *)error
{
    //[indicatorView stopAnimating];
    NSLog(@"didFailToLogInWithError: %@", error);
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil 
													   message:@"登录失败！" 
													  delegate:nil
											 cancelButtonTitle:@"确定" 
											 otherButtonTitles:nil];
	[alertView show];
}

- (void)engineDidLogOut:(WBEngine *)engine
{
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil 
													   message:@"登出成功！" 
													  delegate:self
											 cancelButtonTitle:@"确定" 
											 otherButtonTitles:nil];
    [alertView setTag:kWBAlertViewLogOutTag];
	[alertView show];
}

- (void)engineNotAuthorized:(WBEngine *)engine
{
    
}

- (void)engineAuthorizeExpired:(WBEngine *)engine
{
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil 
													   message:@"请重新登录！" 
													  delegate:nil
											 cancelButtonTitle:@"确定" 
											 otherButtonTitles:nil];
	[alertView show];
}

#pragma mark - UIAlertViewDelegate Methods

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == kWBAlertViewLogInTag)
    {
        WBSendView *sendView = [[WBSendView alloc] initWithAppKey:kWBSDKDemoAppKey appSecret:kWBSDKDemoAppSecret text:tv_content.text image:imgView.image];
        [sendView setDelegate:self];
        
        [sendView show:YES];
    }
    else if (alertView.tag == kWBAlertViewLogOutTag)
    {
        
    }
}

#pragma mark -
#pragma mark Dismiss Mail/SMS view controller

// Dismisses the email composition interface when users tap Cancel or Send. Proceeds to update the 
// message field with the result of the operation.
- (void)mailComposeController:(MFMailComposeViewController*)controller 
          didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
	
    NSString *str_hint = @"";
	// Notifies users about errors associated with the interface
	switch (result)
	{
		case MFMailComposeResultCancelled:
			str_hint = @"邮件已取消";
			break;
		case MFMailComposeResultSaved:
			str_hint = @"邮件已保存";
			break;
		case MFMailComposeResultSent:
			str_hint = @"邮件已发送";
			break;
		case MFMailComposeResultFailed:
			str_hint = @"邮件发送失败";
			break;
		default:
			str_hint = @"邮件未发送";
			break;
	}
    UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"" message:str_hint delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alerView show];
	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark connection
-(void)requestDetail
{
    if (([indView isAnimating] == NO)) {
        [indView startAnimating];
    }
    NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@",DEFAULT_URL]];
    //设置
	ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:url];
	//设置ASIHTTPRequest代理
	request.delegate = self;
    //设置是是否支持断点下载
	[request setAllowResumeForFileDownloads:NO];
	//设置基本信息
    NSString *httpBodyString = [self detailRequestBody];
	NSLog(@"request total  httpBodyString :%@",httpBodyString);
	
    NSData *postData = [httpBodyString dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *dic_userInfo = [[NSMutableDictionary alloc] init];
    [dic_userInfo setObject:@"requestDetail" forKey:@"operate"];
    [request setUserInfo:dic_userInfo];
    [request setPostBody:postData];
    [request setRequestMethod:@"POST"];
    //添加到ASINetworkQueue队列去下载
    AppDelegate_IPad *app = (AppDelegate_IPad *)[UIApplication sharedApplication].delegate;
	[app.netWorkQueue addOperation:request];
    [arr_requests addObject:request];
}

-(NSString *)detailRequestBody
{
    DDXMLNode *node_operate;
    if (type == 0) {
        node_operate = [DDXMLNode elementWithName:@"Operate" stringValue:@"GetTopicDetail"];
    }
    else if(type == 1)
    {
        node_operate = [DDXMLNode elementWithName:@"Operate" stringValue:@"GetImageDetail"];
    }
    else if(type == 2)
    {
        node_operate = [DDXMLNode elementWithName:@"Operate" stringValue:@"GetTopicDetail"];
    }
    //NSString *str_id = [dic_detail objectForKey:@"id"];
    DDXMLNode *node_device = [DDXMLNode elementWithName:@"Device" stringValue:@"ipad"];
    DDXMLNode *node_id = [DDXMLNode elementWithName:@"ID" stringValue:str_id];
    NSArray *arr_request = [[NSArray alloc] initWithObjects:node_operate,node_device,node_id,nil];
    DDXMLElement *element_request = [[DDXMLElement alloc] initWithName: @"Request"];
    [element_request setChildren:arr_request];
    return [element_request XMLString];
}

-(void)requestImage:(NSString *)url
{
    NSURL *_url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@/%@",BASIC_URL,url]];
    if ([url length] == 0) {
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
    NSMutableDictionary *dic_userInfo = [[NSMutableDictionary alloc] init];
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
    NSDictionary *dic_info = request.userInfo;
    NSString *str_operate = [dic_info objectForKey:@"operate"];
    NSLog(@"str_operate:%@",str_operate);
    
    NSData *_data = request.responseData;
    NSString *responseString = [[NSString alloc] initWithData:_data encoding:NSUTF8StringEncoding];
    NSLog(@"responseString4:%@",responseString);
    
    if ([str_operate isEqualToString:@"requestDetail"]) {
        NSError *error = nil;
        DDXMLDocument* xmlDoc = [[DDXMLDocument alloc] initWithXMLString:responseString options:0 error:&error];
        if (error) {
            NSLog(@"%@",[error localizedDescription]);
        }
        NSArray *arr_response = [xmlDoc nodesForXPath:@"//Response" error:&error];
        for (DDXMLElement *element_response in arr_response) {
            NSArray *arr_code = [element_response elementsForName:@"Code"];
            NSString *str_code = [[arr_code objectAtIndex:0] stringValue];
            //NSMutableDictionary *dic_itemSaved = [[NSMutableDictionary alloc] init];
            NSArray *arr_id = [element_response elementsForName:@"ID"];
            NSString *str_id = [[arr_id objectAtIndex:0] stringValue];
            [dic_detail setObject:str_id forKey:@"id"];
            
            if ([str_class intValue] == 1) {
                NSArray *arr_title = [element_response elementsForName:@"Title"];
                NSString *str_title = [[arr_title objectAtIndex:0] stringValue];
                [dic_detail setObject:str_title forKey:@"contentTitle"];
                NSArray *arr_image = [element_response elementsForName:@"Image"];
                NSString *str_image = [[arr_image objectAtIndex:0] stringValue];
                [dic_detail setObject:str_image forKey:@"contentImgUrl"];
                NSArray *arr_content = [element_response elementsForName:@"Content"];
                NSString *str_content = [[arr_content objectAtIndex:0] stringValue];
                [dic_detail setObject:str_content forKey:@"contentDetail"];
                
                [self requestImage:str_image];
                
                lb_title.text = str_title;
                
                tv_content.text = str_content;
                [self refreshView];
                
                //[self.view setNeedsDisplay];
            }
            else if([str_class intValue] == 2) 
            {
                NSArray *arr_url = [element_response elementsForName:@"Url"];
                NSString *str_url = [[arr_url objectAtIndex:0] stringValue];
                [dic_detail setObject:str_url forKey:@"url"];
                
                NSURL *url = [[NSURL alloc] initWithString:str_url];
                NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
                [webView_detail loadRequest:request];
            }
        }
    }
    else if ([str_operate isEqualToString:@"downloadImg"]) {
        if (([indView isAnimating] == YES)) {
            [indView stopAnimating];
        }
        UIImage *img = [[UIImage alloc] initWithData:request.responseData];
        NSString *str_fileName = request.url.lastPathComponent;
        str_fileName = [NSString stringWithFormat:@"%@@2x%@",[str_fileName substringToIndex:[str_fileName length] -4],[str_fileName substringFromIndex:[str_fileName length]-4]];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *str_address = @"";
        switch (type) {
            case 0:
            {
                str_address = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/Caches/Host/%@",str_fileName]];
            }
                break;
            case 1:
            {
                str_address = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/Caches/Image/%@",str_fileName]];
            }
                break;
            case 2:
            {
                str_address = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/Caches/Topic/%@",str_fileName]];
            }
                break;
            default:
                break;
        }
        [dic_detail setObject:str_address forKey:@"contentImgAddress"];
        if ([[SqlManager sharedManager] saveDoc:request.responseData address:str_address] == YES) {
            switch (type) {
                case 0:
                {
                    [[SqlManager sharedManager] saveHotNewsDetail:dic_detail];
                }
                    break;
                case 1:
                {
                    [[SqlManager sharedManager] saveImageDetail:dic_detail];
                }
                    break;
                case 2:
                {
                    [[SqlManager sharedManager] saveTopicDetail:dic_detail];
                }
                    break;
                default:
                    break;
            }
        }
        tv_content.frame = CGRectMake(0, 460, 768, 450);
        imgView.frame = CGRectMake(0, 60, 768, 400);
        imgView.image = img;
        
        [self refreshView];
        //[self.view setNeedsDisplay];
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
    if (([indView isAnimating] == NO)) {
        [indView startAnimating];
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

#pragma mark - WBSendViewDelegate Methods

- (void)sendViewDidFinishSending:(WBSendView *)view
{
    [view hide:YES];
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil 
													   message:@"微博发送成功！" 
													  delegate:nil
											 cancelButtonTitle:@"确定" 
											 otherButtonTitles:nil];
	[alertView show];
}

- (void)sendView:(WBSendView *)view didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    [view hide:YES];
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil 
													   message:@"微博发送失败！" 
													  delegate:nil
											 cancelButtonTitle:@"确定" 
											 otherButtonTitles:nil];
	[alertView show];
}

- (void)sendViewNotAuthorized:(WBSendView *)view
{
    [view hide:YES];
    
    [self dismissModalViewControllerAnimated:YES];
}

- (void)sendViewAuthorizeExpired:(WBSendView *)view
{
    [view hide:YES];
    
    [self dismissModalViewControllerAnimated:YES];
}


@end
