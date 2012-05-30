//
//  ImageDetailViewController_IPad.m
//  JingYingCar
//
//  Created by JiaMing Yan on 12-4-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ImageDetailViewController_IPad.h"
#import "CustomImageView_IPad.h"

@interface ImageDetailViewController_IPad ()

@end

@implementation ImageDetailViewController_IPad

@synthesize str_id;

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
    arr_imgList = [[NSMutableArray alloc] initWithArray:[[SqlManager sharedManager] getImagesSeriesWithID:str_id]];
    NSDictionary *dic_info = [[NSDictionary alloc] initWithDictionary:[[SqlManager sharedManager] getImageListWithID:str_id] copyItems:YES];
    
    UIView *view_nav = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 768, 45)];
    view_nav.backgroundColor = [UIColor clearColor];
    [self.view addSubview:view_nav];
    
    UIImageView *imgView_navBK = [[UIImageView alloc] initWithFrame:view_nav.bounds];
    imgView_navBK.image = [UIImage imageNamed:@"imagesNav_ipad.png"];
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
    
    sclView_item = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 45, 768, 915)];
    sclView_item.contentSize = sclView_item.frame.size;
    sclView_item.backgroundColor = [UIColor clearColor];
    sclView_item.directionalLockEnabled = YES;
    sclView_item.pagingEnabled = YES;
    sclView_item.delegate = self;
    sclView_item.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:sclView_item];
    
    view_imgList = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 768, 915)];
    view_imgList.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"blackBackground_ipad.png"]];
    [self.view addSubview:view_imgList];
    
    UIView *view_topBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 768, 45)];
    view_topBar.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"emptyNav_ipad.png"]];
    [view_imgList addSubview:view_topBar];
    
    sclView_imgList = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 45, 768, 915)];
    sclView_imgList.backgroundColor = [UIColor clearColor];
    sclView_imgList.delegate = self;
    sclView_imgList.directionalLockEnabled = YES;
    [view_imgList addSubview:sclView_imgList];
    
    UILabel *lb_topBarTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 45)];
    lb_topBarTitle.backgroundColor = [UIColor clearColor];
    lb_topBarTitle.textColor = [UIColor blackColor];
    lb_topBarTitle.textAlignment = UITextAlignmentLeft;
    lb_topBarTitle.text = [dic_info objectForKey:@"title"];
    lb_topBarTitle.font = [UIFont boldSystemFontOfSize:24];
    lb_topBarTitle.textAlignment = UITextAlignmentCenter;
    [view_topBar addSubview:lb_topBarTitle];
    
    UIButton *btn_topBarBack = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_topBarBack.frame = CGRectMake(5, 7, 50, 30);
    [btn_topBarBack setBackgroundImage:[UIImage imageNamed:@"back_ipad.png"] forState:UIControlStateNormal];
    //[btn_topBarBack setTitle:@"返回" forState:UIControlStateNormal];
    [btn_topBarBack setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn_topBarBack.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [btn_topBarBack addTarget:self action:@selector(hideImgListView) forControlEvents:UIControlEventTouchUpInside];
    [view_topBar addSubview:btn_topBarBack];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"blackBackground_ipad.png"]];
    
    [self hideImgList];
    
    for (int i = 0; i < [arr_imgList count]; i++) {
        NSMutableDictionary *dic_item = [[NSMutableDictionary alloc] initWithDictionary:[arr_imgList objectAtIndex:i]];
        NSString *str_imgID = [dic_item objectForKey:@"imgID"];
        UIView *view_content = [[UIView alloc] initWithFrame:CGRectMake(768*i, 0, 768, 915)];
        view_content.backgroundColor = [UIColor clearColor];
        [sclView_item addSubview:view_content];
        
        UIScrollView *sclView_topic = [[UIScrollView alloc] initWithFrame:view_content.bounds];
        sclView_topic.backgroundColor = [UIColor clearColor];
        sclView_topic.directionalLockEnabled = YES;
        [view_content addSubview:sclView_topic];
        
        UILabel *lb_title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 768, 60)];
        lb_title.font = [UIFont boldSystemFontOfSize:20];
        lb_title.textAlignment = UITextAlignmentLeft;
        lb_title.backgroundColor = [UIColor clearColor];
        lb_title.textColor = [UIColor whiteColor];
        [sclView_topic addSubview:lb_title];
        [dic_item setObject:lb_title forKey:@"lb_title"];
        
        UITextView *tv_content = [[UITextView alloc] initWithFrame:CGRectMake(0, 682, 768, 315)];
        
        sclView_topic.contentSize = CGSizeMake(768, 682+tv_content.frame.size.height);
        
        tv_content.backgroundColor = [UIColor clearColor];
        tv_content.textColor = [UIColor whiteColor];
        tv_content.userInteractionEnabled = NO;
        [sclView_topic addSubview:tv_content];
        [dic_item setObject:tv_content forKey:@"tv_content"];
        
        CustomImageView_IPad *imgView = [[CustomImageView_IPad alloc] initWithFrame:CGRectMake(0, 120, 768, 512) withID:str_imgID img:nil];
        //imgView.delegate = self;
        [sclView_topic addSubview:imgView];
        [dic_item setObject:imgView forKey:@"imgView"];
        [arr_imgList replaceObjectAtIndex:i withObject:dic_item];
    }
    UIView *view_bottom = [[UIView alloc] initWithFrame:CGRectMake(0, 960, 768, 45)];
    view_bottom.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"topicBottomNav_ipad.png"]];
    [self.view addSubview:view_bottom];
    
    UIButton *btn_share = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_share.frame = CGRectMake(170, 8, 28, 29);
    [btn_share setBackgroundImage:[UIImage imageNamed:@"share_ipad.png"] forState:UIControlStateNormal];
    //[btn_share setBackgroundImage:[UIImage imageNamed:@"shareHighlighted.png"] forState:UIControlStateHighlighted];
    [btn_share addTarget:self action:@selector(showShareList) forControlEvents:UIControlEventTouchUpInside];
    [view_bottom addSubview:btn_share];
    
    btn_lastImg = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_lastImg.frame = CGRectMake(320, 7.5f, 30, 30);
    [btn_lastImg setBackgroundImage:[UIImage imageNamed:@"lastImg_ipad.png"] forState:UIControlStateNormal];
    //[btn_lastImg setBackgroundImage:[UIImage imageNamed:@"lastImgHighlighted.png"] forState:UIControlStateHighlighted];
    [btn_lastImg addTarget:self action:@selector(lastImg) forControlEvents:UIControlEventTouchUpInside];
    btn_lastImg.enabled = NO;
    [view_bottom addSubview:btn_lastImg];
    
    btn_nextImg = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_nextImg.frame = CGRectMake(420,  7.5f, 30, 30);
    [btn_nextImg setBackgroundImage:[UIImage imageNamed:@"nextImg_ipad.png"] forState:UIControlStateNormal];
    //[btn_nextImg setBackgroundImage:[UIImage imageNamed:@"nextImgHighlighted.png"] forState:UIControlStateHighlighted];
    [btn_nextImg addTarget:self action:@selector(nextImg) forControlEvents:UIControlEventTouchUpInside];
    [view_bottom addSubview:btn_nextImg]; 
    
    UIButton *btn_imgDownload = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_imgDownload.frame = CGRectMake(568, 7, 30, 30);
    [btn_imgDownload setBackgroundImage:[UIImage imageNamed:@"imgDownload_ipad.png"] forState:UIControlStateNormal];
    //[btn_imgDownload setBackgroundImage:[UIImage imageNamed:@"nextImgHighlighted.png"] forState:UIControlStateHighlighted];
    [btn_imgDownload addTarget:self action:@selector(downloadToAlbum) forControlEvents:UIControlEventTouchUpInside];
    [view_bottom addSubview:btn_imgDownload]; 
    
    UIButton *btn_showTotal = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_showTotal.frame = CGRectMake(708, 7, 50, 30);
    [btn_showTotal setBackgroundImage:[UIImage imageNamed:@"imagesListBtn_ipad.png"] forState:UIControlStateNormal];
    [btn_showTotal addTarget:self action:@selector(showImgListView) forControlEvents:UIControlEventTouchUpInside];
    [view_nav addSubview:btn_showTotal];
    
    btn_hideShare = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_hideShare.backgroundColor = [UIColor clearColor];
    btn_hideShare.frame = CGRectMake(0, 0, 768, 915);
    [btn_hideShare addTarget:self action:@selector(hideShareList) forControlEvents:UIControlEventTouchUpInside];
    btn_hideShare.tag = 12;
    btn_hideShare.enabled = NO;
    [self.view addSubview:btn_hideShare];
    
    view_shareList = [[UIView alloc] initWithFrame:CGRectMake(20, 960, 332, 366)];
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
    
//    UIButton *btn_tecentShare = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn_tecentShare.frame = CGRectMake(17, 134, 298, 54);
//    //[btn_emailShare setTitle:@"邮件分享此文章" forState:UIControlStateNormal];
//    [btn_tecentShare setBackgroundImage:[UIImage imageNamed:@"shareTecent_ipad.png"] forState:UIControlStateNormal];
//    [btn_tecentShare setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [btn_tecentShare addTarget:self action:@selector(showEmailShare) forControlEvents:UIControlEventTouchUpInside];
//    [view_shareList addSubview:btn_tecentShare];
//    
//    UIButton *btn_sohuShare = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn_sohuShare.frame = CGRectMake(17, 208, 298, 54);
//    //[btn_emailShare setTitle:@"邮件分享此文章" forState:UIControlStateNormal];
//    [btn_sohuShare setBackgroundImage:[UIImage imageNamed:@"shareSohu_ipad.png"] forState:UIControlStateNormal];
//    [btn_sohuShare setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [btn_sohuShare addTarget:self action:@selector(showEmailShare) forControlEvents:UIControlEventTouchUpInside];
//    [view_shareList addSubview:btn_sohuShare];
//    
//    UIButton *btn_163Share = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn_163Share.frame = CGRectMake(17, 282, 298, 54);
//    //[btn_emailShare setTitle:@"邮件分享此文章" forState:UIControlStateNormal];
//    [btn_163Share setBackgroundImage:[UIImage imageNamed:@"share163_ipad.png"] forState:UIControlStateNormal];
//    [btn_163Share setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [btn_163Share addTarget:self action:@selector(showEmailShare) forControlEvents:UIControlEventTouchUpInside];
//    [view_shareList addSubview:btn_163Share];
    
    UIButton *btn_emailShare = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_emailShare.frame = CGRectMake(17, 200, 298, 54);
    //[btn_emailShare setTitle:@"邮件分享此文章" forState:UIControlStateNormal];
    [btn_emailShare setBackgroundImage:[UIImage imageNamed:@"shareEmail_ipad.png"] forState:UIControlStateNormal];
    [btn_emailShare setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn_emailShare addTarget:self action:@selector(showEmailShare) forControlEvents:UIControlEventTouchUpInside];
    [view_shareList addSubview:btn_emailShare];
    
//    UIButton *btn_cancelShare = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    btn_cancelShare.frame = CGRectMake(10, 120, 300, 40);
//    [btn_cancelShare setTitle:@"取消" forState:UIControlStateNormal];
//    [btn_cancelShare setBackgroundImage:[UIImage imageNamed:@"shareBtn.png"] forState:UIControlStateNormal];
//    [btn_cancelShare setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [btn_cancelShare addTarget:self action:@selector(hideShareList) forControlEvents:UIControlEventTouchUpInside];
//    [view_shareList addSubview:btn_cancelShare];
    
    SinaEngine = [[WBEngine alloc] initWithAppKey:kWBSDKDemoAppKey appSecret:kWBSDKDemoAppSecret];
    [SinaEngine setRootViewController:self];
    [SinaEngine setDelegate:self];
    [SinaEngine setRedirectURI:@"http://"];
    [SinaEngine setIsUserExclusive:NO];
    
//    indView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
//    indView.center = CGPointMake(160, 80);
//    [imgView addSubview:indView];
    
    //str_class = [dic_info objectForKey:@"class"];
    NSString *str_isReaded = [dic_info objectForKey:@"isReaded"];
    
    if ([str_isReaded isEqualToString:@"0"]) {
        [self requestDetail];
    }
    else {
        [self refreshView];
    }
    
    [self.view bringSubviewToFront:sclView_imgList];
    [self.view bringSubviewToFront:view_bottom];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"精英车主";
    
    //dic_detail = [[NSMutableDictionary alloc] init];
    
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

-(void)collect
{
    BOOL result = [[SqlManager sharedManager] addMyCollectionWithFatherID:@"1" childID:str_id];
    if (result == YES) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"收藏成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }
    else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该收藏已存在" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }
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
    for (int i = 0; i < [arr_imgList count]; i++) {
        NSDictionary *dic_item = [[NSMutableDictionary alloc] initWithDictionary:[arr_imgList objectAtIndex:i]];
        //NSLog(@"dic_item:%@",dic_item);
        
        NSString *str_tempId = [dic_item objectForKey:@"imgID"];
        UILabel *lb_title = [dic_item objectForKey:@"lb_title"];
        lb_title.text = [dic_item objectForKey:@"contentTitle"];
        
        UITextView *tv_content = [dic_item objectForKey:@"tv_content"];
        tv_content.text = [dic_item objectForKey:@"contentDetail"];
        tv_content.font = font;
        [tv_content sizeToFit];
        tv_content.frame = CGRectMake(0, 682, 768, tv_content.contentSize.height);
        
        UIScrollView *sclView_topic = (UIScrollView *)tv_content.superview;
        sclView_topic.contentSize = CGSizeMake(768, tv_content.frame.size.height + 682);
        
        UIView *view_content = sclView_topic.superview;
        view_content.frame = CGRectMake(768*i, 0, 768, 915);
        
        CustomImageView_IPad *imgView = [dic_item objectForKey:@"imgView"];
        UIImage *img;
        NSString *str_imgAddress = [dic_item objectForKey:@"largeImgAddress"];
        if ([str_imgAddress length] > 0) {
            img = [UIImage imageWithContentsOfFile:str_imgAddress];
            imgView.img = img;
        }
    }
    sclView_item.contentSize = CGSizeMake(768*[arr_imgList count], 915);
}

-(void)loadAllTopImage
{
    for (int i = 0; i < [arr_imgList count]; i++) {
        NSDictionary *dic_item = [[NSMutableDictionary alloc] initWithDictionary:[arr_imgList objectAtIndex:i]];
        NSString *str_imgAddress = [dic_item objectForKey:@"largeImgAddress"];
        if ([str_imgAddress length] == 0) {
            [self requestImage:dic_item imgType:@"0"];
        }
    }
}

-(void)loadAllListImage
{
    for (int i = 0; i < [arr_imgList count]; i++) {
        NSDictionary *dic_item = [[NSMutableDictionary alloc] initWithDictionary:[arr_imgList objectAtIndex:i]];
        NSString *str_imgAddress = [dic_item objectForKey:@"smallImgAddress"];
        if ([str_imgAddress length] == 0) {
            [self requestImage:dic_item imgType:@"1"];
        }
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
	
    int index = fabs(sclView_item.contentOffset.x) / sclView_item.frame.size.width;
    
    NSDictionary *dic_info = [arr_imgList objectAtIndex:index];
    NSString *str_contentImgAddress = [dic_info objectForKey:@"largeImgAddress"];
    NSData *data_img = [NSData dataWithContentsOfFile:str_contentImgAddress];
    [picker addAttachmentData:data_img mimeType:@"image/png" fileName:str_contentImgAddress.lastPathComponent];
    
    NSString *str_title = [dic_info objectForKey:@"title"];
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
	NSString *emailBody = [dic_info objectForKey:@"contentDetail"];
    if ([emailBody length] > 140) {
        emailBody = [emailBody substringToIndex:140];
    }
	[picker setMessageBody:emailBody isHTML:NO];
	
	[self presentModalViewController:picker animated:YES];
    
    [self hideShareList];
}

-(void)showSinaShare
{
    int index = fabs(sclView_item.contentOffset.x) / sclView_item.frame.size.width;
    
    NSDictionary *dic_info = [arr_imgList objectAtIndex:index];
    
    NSString *str_content = [dic_info objectForKey:@"contentDetail"];
    
    NSString *str_contentImgAddress = [dic_info objectForKey:@"largeImgAddress"];
    UIImage *img = [UIImage imageWithContentsOfFile:str_contentImgAddress];
    
    if ([SinaEngine isLoggedIn] && ![SinaEngine isAuthorizeExpired])
    {
        WBSendView *sendView = [[WBSendView alloc] initWithAppKey:kWBSDKDemoAppKey appSecret:kWBSDKDemoAppSecret text:str_content image:img];
        [sendView setDelegate:self];
        
        [sendView show:YES];
    }
    else {
        [SinaEngine logIn];
    }
}

-(void)nextImg
{
    int index = fabs(sclView_item.contentOffset.x) / sclView_item.frame.size.width;
    if (index < [arr_imgList count] -1) {
        [sclView_item scrollRectToVisible:CGRectMake(768*(index+1), 0, sclView_item.frame.size.width, sclView_item.frame.size.height) animated:YES];
        if (btn_lastImg.enabled == NO) {
            btn_lastImg.enabled = YES;
        }
        if (index +1 == [arr_imgList count] -1) {
            btn_nextImg.enabled = NO;
        }
    }
}

-(void)lastImg
{
    int index = fabs(sclView_item.contentOffset.x) / sclView_item.frame.size.width;
    if (index > 0) {
        [sclView_item scrollRectToVisible:CGRectMake(768*(index - 1), 0, sclView_item.frame.size.width, sclView_item.frame.size.height) animated:YES];
        if (btn_nextImg.enabled == NO) {
            btn_nextImg.enabled = YES;
        }
        if (index == 1) {
            btn_lastImg.enabled = NO;
        }
    }
}

-(void)showImgListView
{
    [self loadAllListImage];
    [self refreshImgListView];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.6f];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:view_imgList cache:NO];
    [self showImgList];
    [UIView commitAnimations];
}

-(void)hideImgListView
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.6f];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:view_imgList cache:NO];
    [self hideImgList];
    [UIView commitAnimations];
}

-(void)hideImgList
{
    view_imgList.hidden = YES;
    sclView_imgList.hidden = YES;
    NSArray *arr_views = [sclView_imgList subviews];
    for (UIView *view in arr_views) {
        view.hidden = YES;
    }
}

-(void)showImgList
{
    view_imgList.hidden = NO;
    sclView_imgList.hidden = NO;
    NSArray *arr_views = [sclView_imgList subviews];
    for (UIView *view in arr_views) {
        view.hidden = NO;
    }
}

-(void)refreshImgListView
{
    for (int i = 0; i < [arr_imgList count]; i++) {
        NSMutableDictionary *dic_item = [arr_imgList objectAtIndex:i];
        CustomImageView_IPad *imgView = (CustomImageView_IPad *)[dic_item objectForKey:@"smallImgView"];
        if (imgView == nil) {
            int row = i/2;
            int col = i%2;
            imgView = [[CustomImageView_IPad alloc] initWithFrame:CGRectMake(16+col*376, 16+row*216, 360, 200) withID:[NSString stringWithFormat:@"%d",i] img:nil];
            //imgView.delegate = self;
            [sclView_imgList addSubview:imgView];
            [dic_item setObject:imgView forKey:@"smallImgView"];
            [arr_imgList replaceObjectAtIndex:i withObject:dic_item];
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSmallImg:)];
            tapGesture.numberOfTapsRequired = 1;
            tapGesture.numberOfTouchesRequired = 1;
            [imgView addGestureRecognizer:tapGesture];
        }
        NSString *str_imgAddress = [dic_item objectForKey:@"smallImgAddress"];
        if ([str_imgAddress length] > 0) {
            UIImage *img = [UIImage imageWithContentsOfFile:str_imgAddress];
            imgView.img = img;
        }
    }
    
    int rows = [arr_imgList count]/2 +1;
    sclView_imgList.contentSize = CGSizeMake(768, 16+216*rows);
}

-(void)downloadToAlbum
{
    int index = fabs(sclView_item.contentOffset.x) / sclView_item.frame.size.width;
    NSDictionary *dic_item = [arr_imgList objectAtIndex:index];
    CustomImageView_IPad *imgView = (CustomImageView_IPad *)[dic_item objectForKey:@"imgView"];
    if (imgView != nil) {
        if (imgView.img != nil) {
            UIImageWriteToSavedPhotosAlbum(imgView.img, self, @selector(completeDownloadToAlbumImage:didFinishSavingWithError:contextInfo:), nil);
        }
    }
}

- (void)completeDownloadToAlbumImage: (UIImage *) image
    didFinishSavingWithError: (NSError *) error
                 contextInfo: (void *) contextInfo;
{
    if (error == nil) {
        UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil 
                                                           message:@"已保存至相册" 
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定" 
                                                 otherButtonTitles:nil];
        [alertView show];
    }
}

#pragma mark -tapGestureDelegate
-(void)tapSmallImg:(UITapGestureRecognizer *)sender
{
    [self hideImgListView];
    CustomImageView_IPad *view = (CustomImageView_IPad *)sender.view;
    int index = [view.str_id intValue];
    NSLog(@"index:%d",index);
    [sclView_item scrollRectToVisible:CGRectMake(768*index, 0, sclView_item.frame.size.width, sclView_item.frame.size.height) animated:NO];
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
        int index = fabs(sclView_item.contentOffset.x) / sclView_item.frame.size.width;
        
        NSDictionary *dic_info = [arr_imgList objectAtIndex:index];
        
        NSString *str_content = [dic_info objectForKey:@"contentDetail"];
        
        NSString *str_contentImgAddress = [dic_info objectForKey:@"contentImgAddress"];
        UIImage *img = [UIImage imageWithContentsOfFile:str_contentImgAddress];
        
        WBSendView *sendView = [[WBSendView alloc] initWithAppKey:kWBSDKDemoAppKey appSecret:kWBSDKDemoAppSecret text:str_content image:img];
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
    if ([indView isAnimating] == NO) {
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
    DDXMLNode *node_operate = [DDXMLNode elementWithName:@"Operate" stringValue:@"GetImageDetail"];
    DDXMLNode *node_device = [DDXMLNode elementWithName:@"Device" stringValue:@"ipad"];
    //NSString *str_id = [dic_detail objectForKey:@"id"];
    DDXMLNode *node_id = [DDXMLNode elementWithName:@"ID" stringValue:str_id];
    NSArray *arr_request = [[NSArray alloc] initWithObjects:node_operate,node_device,node_id,nil];
    DDXMLElement *element_request = [[DDXMLElement alloc] initWithName: @"Request"];
    [element_request setChildren:arr_request];
    return [element_request XMLString];
}

-(void)requestImage:(NSDictionary *)dic_info imgType:(NSString *)str_type
{
    NSString *str_url = @"";
    if ([str_type isEqualToString:@"0"]) {
        str_url = [dic_info objectForKey:@"largeImgUrl"];
    }
    else {
        str_url = [dic_info objectForKey:@"smallImgUrl"];
    }
    if ([str_url length] == 0) {
        return;
    }
    NSURL *_url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@/%@",BASIC_URL,str_url]];
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
    [dic_userInfo setObject:str_type forKey:@"imgType"];
    
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
            NSString *str_tempId = [[arr_id objectAtIndex:0] stringValue];
            //[dic_detail setObject:str_tempId forKey:@"id"];
            
            NSArray *arr_items =[element_response elementsForName:@"Item"];
            for (DDXMLElement *element_item in arr_items) {
                NSMutableDictionary *dic_item = [[NSMutableDictionary alloc] init];
                NSArray *arr_title = [element_item elementsForName:@"Title"];
                NSString *str_title = [[arr_title objectAtIndex:0] stringValue];
                [dic_item setObject:str_title forKey:@"contentTitle"];
                NSArray *arr_smallImgUrl = [element_item elementsForName:@"SmallImage"];
                NSString *str_smallImgUrl = [[arr_smallImgUrl objectAtIndex:0] stringValue];
                [dic_item setObject:str_smallImgUrl forKey:@"smallImgUrl"];
                NSArray *arr_largeImgUrl = [element_item elementsForName:@"LargeImage"];
                NSString *str_largeImgUrl = [[arr_largeImgUrl objectAtIndex:0] stringValue];
                [dic_item setObject:str_largeImgUrl forKey:@"largeImgUrl"];
                NSArray *arr_content = [element_item elementsForName:@"Content"];
                NSString *str_content = [[arr_content objectAtIndex:0] stringValue];
                [dic_item setObject:str_content forKey:@"contentDetail"];
                NSArray *arr_imgID = [element_item elementsForName:@"ID"];
                NSString *str_imgID = [[arr_imgID objectAtIndex:0] stringValue];
                [dic_item setObject:str_imgID forKey:@"imgID"];
                
                //[arr_imgList addObject:dic_item];
                
                int result = [[SqlManager sharedManager] saveImageSeries:dic_item ID:str_tempId];
                NSMutableDictionary *dic_newInfo = [[NSMutableDictionary alloc] initWithDictionary:[[SqlManager sharedManager] getImagesSeriesWithID:str_tempId imgID:str_imgID]];
                
                if (result == 102) {
                    for (int i = 0; i < [arr_imgList count]; i++) {
                        NSDictionary *dic_oldInfo = [arr_imgList objectAtIndex:i];
                        NSString *str_oldImgID = [dic_oldInfo objectForKey:@"imgID"];
                        if ([str_oldImgID isEqualToString:str_imgID]) {
                            UILabel *lb_title = (UILabel *)[dic_oldInfo objectForKey:@"lb_title"];
                            UITextView *tv_content = (UITextView *)[dic_oldInfo objectForKey:@"tv_content"];
                            CustomImageView_IPad *imgView = (CustomImageView_IPad *)[dic_oldInfo objectForKey:@"imgView"];
                            [dic_newInfo setObject:lb_title forKey:@"lb_title"];
                            [dic_newInfo setObject:tv_content forKey:@"tv_content"];
                            [dic_newInfo setObject:imgView forKey:@"imgView"];
                        }
                    }
                }
                else if(result == 103) {
                    UIView *view_content = [[UIView alloc] initWithFrame:CGRectMake(768*[arr_imgList count], 45, 768, 915)];
                    view_content.backgroundColor = [UIColor clearColor];
                    [sclView_item addSubview:view_content];
                    
                    UIScrollView *sclView_topic = [[UIScrollView alloc] initWithFrame:view_content.bounds];
                    sclView_topic.backgroundColor = [UIColor clearColor];
                    sclView_topic.directionalLockEnabled = YES;
                    [view_content addSubview:sclView_topic];
                    
                    UILabel *lb_title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 768, 60)];
                    lb_title.font = [UIFont boldSystemFontOfSize:20];
                    lb_title.textAlignment = UITextAlignmentLeft;
                    lb_title.backgroundColor = [UIColor clearColor];
                    lb_title.textColor = [UIColor whiteColor];
                    [sclView_topic addSubview:lb_title];
                    [dic_newInfo setObject:lb_title forKey:@"lb_title"];
                    
                    UITextView *tv_content = [[UITextView alloc] initWithFrame:CGRectMake(0, 682, 768, 328)];
                    
                    sclView_topic.contentSize = CGSizeMake(768, 682+tv_content.frame.size.height);
                    
                    tv_content.backgroundColor = [UIColor clearColor];
                    tv_content.textColor = [UIColor whiteColor];
                    tv_content.userInteractionEnabled = NO;
                    [sclView_topic addSubview:tv_content];
                    [dic_newInfo setObject:tv_content forKey:@"tv_content"];
                    
                    CustomImageView_IPad *imgView = [[CustomImageView_IPad alloc] initWithFrame:CGRectMake(0, 120, 768, 512) withID:@"" img:nil];
                    //imgView.delegate = self;
                    [sclView_topic addSubview:imgView];
                    [dic_newInfo setObject:imgView forKey:@"imgView"];
                    [arr_imgList addObject:dic_newInfo];
                    //[self requestImage:dic_newInfo imgType:@"0"];
                }
                //NSLog(@"arr_imgList:%@",arr_imgList);
                [self refreshView];
            }
            [self loadAllTopImage];
//            if ([str_class intValue] == 1) {
                
                //[self.view setNeedsDisplay];
//            }
//            else if([str_class intValue] == 2) 
//            {
//                NSArray *arr_url = [element_response elementsForName:@"Url"];
//                NSString *str_url = [[arr_url objectAtIndex:0] stringValue];
//                [dic_detail setObject:str_url forKey:@"url"];
//                
//                NSURL *url = [[NSURL alloc] initWithString:str_url];
//                NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
//                [webView_detail loadRequest:request];
//            }
        }
    }
    else if ([str_operate isEqualToString:@"downloadImg"]) {
        UIImage *img = [[UIImage alloc] initWithData:request.responseData];
        NSString *str_fileName = request.url.lastPathComponent;
        str_fileName = [NSString stringWithFormat:@"%@@2x%@",[str_fileName substringToIndex:[str_fileName length] -4],[str_fileName substringFromIndex:[str_fileName length]-4]];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *str_address = @"";
        NSString *str_imgID = [dic_info objectForKey:@"imgID"];
        NSString *str_imgType = [dic_info objectForKey:@"imgType"];
        NSLog(@"str_imgID:%@,%@",str_imgID,str_imgType);

        str_address = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/Caches/Image/%@",str_fileName]];

        //[dic_detail setObject:str_address forKey:@"contentImgAddress"];
        if ([[SqlManager sharedManager] saveDoc:request.responseData address:str_address] == YES) {
            [[SqlManager sharedManager] saveImagesSeriesImg:str_id imgAddress:str_address imgType:[str_imgType intValue] imgID:str_imgID];
        }
        
        NSMutableDictionary *dic_newInfo = [[NSMutableDictionary alloc] initWithDictionary:[[SqlManager sharedManager] getImagesSeriesWithID:str_id imgID:str_imgID]];

        for (int i = 0; i < [arr_imgList count]; i++) {
            NSDictionary *dic_oldInfo = [arr_imgList objectAtIndex:i];
            NSString *str_oldImgID = [dic_oldInfo objectForKey:@"imgID"];
            if ([str_oldImgID isEqualToString:str_imgID]) {
                UILabel *lb_title = (UILabel *)[dic_oldInfo objectForKey:@"lb_title"];
                UITextView *tv_content = (UITextView *)[dic_oldInfo objectForKey:@"tv_content"];
                CustomImageView_IPad *imgView = (CustomImageView_IPad *)[dic_oldInfo objectForKey:@"imgView"];
                CustomImageView_IPad *imgView_small = (CustomImageView_IPad *)[dic_oldInfo objectForKey:@"smallImgView"];
                [dic_newInfo setObject:lb_title forKey:@"lb_title"];
                [dic_newInfo setObject:tv_content forKey:@"tv_content"];
                [dic_newInfo setObject:imgView forKey:@"imgView"];
                if (imgView_small != nil) {
                    [dic_newInfo setObject:imgView_small forKey:@"smallImgView"];
                }
                [arr_imgList replaceObjectAtIndex:i withObject:dic_newInfo];
                break;
            }
        }
        
        if ([str_imgType isEqualToString:@"0"]) {
            [self refreshView];
        }
        else if ([str_imgType isEqualToString:@"1"]) {
            [self refreshImgListView];
        }
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
    if ([indView isAnimating] == YES) {
        [indView stopAnimating];
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
