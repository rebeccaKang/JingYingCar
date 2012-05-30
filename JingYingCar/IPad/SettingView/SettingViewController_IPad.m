//
//  SettingViewController_IPad.m
//  JingYingCar
//
//  Created by JiaMing Yan on 12-4-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SettingViewController_IPad.h"
#import "AppDelegate_IPad.h"
#import "SettingAboutViewController_IPad.h"
#import "SettingTechSupportViewController_IPad.h"
#import "SettingBufferViewController_IPad.h"

@interface SettingViewController_IPad ()

@end

@implementation SettingViewController_IPad

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
    
    [self.navigationController setNavigationBarHidden:YES];
    
    self.view.frame = CGRectMake(99, 165, 570, 630);
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"settingBackground_ipad.png"]];
    UIView *view_nav = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 570, 45)];
    view_nav.backgroundColor = [UIColor clearColor];
    view_nav.layer.shadowOffset = CGSizeMake(0, 1);
    view_nav.layer.shadowOpacity = 1;
    view_nav.layer.shadowColor = [UIColor blackColor].CGColor;
    [self.view addSubview:view_nav];
    
    UIImageView *imgView_navBK = [[UIImageView alloc] initWithFrame:view_nav.bounds];
    imgView_navBK.image = [UIImage imageNamed:@"settingNav_ipad.png"];
    [view_nav addSubview:imgView_navBK];
    
//    UIButton *btn_back = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn_back.frame = CGRectMake(10, 10, 50, 25);
//    [btn_back setBackgroundImage:[UIImage imageNamed:@"leftBarItem.png"] forState:UIControlStateNormal];
//    [btn_back setTitle:@" 返回" forState:UIControlStateNormal];
//    [btn_back addTarget:self action:@selector(turnBack) forControlEvents:UIControlEventTouchUpInside];
//    [btn_back setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    btn_back.titleLabel.font = [UIFont boldSystemFontOfSize:14];
//    btn_back.titleLabel.textAlignment = UITextAlignmentRight;
//    [view_nav addSubview:btn_back];
    
    UIButton *btn_finish = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_finish.frame = CGRectMake(210, 8, 100, 30);
    [btn_finish setBackgroundImage:[UIImage imageNamed:@"settingFinish.png"] forState:UIControlStateNormal];
    //[btn_finish setTitle:@"完成" forState:UIControlStateNormal];
    [btn_finish addTarget:self action:@selector(turnBack) forControlEvents:UIControlEventTouchUpInside];
    [btn_finish setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn_finish.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    btn_finish.titleLabel.textAlignment = UITextAlignmentRight;
    [view_nav addSubview:btn_finish];
    
    UIView *view_content = [[UIView alloc] initWithFrame:CGRectMake(0, 45, 320, 415)];
    view_content.backgroundColor = [UIColor clearColor];
    [self.view addSubview:view_content];
    
    tbl_setting = [[UITableView alloc] initWithFrame:view_content.bounds style:UITableViewStyleGrouped];
    tbl_setting.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
    tbl_setting.delegate = self;
    tbl_setting.dataSource = self;
    [view_content addSubview:tbl_setting];
    
    UIButton *btn_attention = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn_attention setBackgroundImage:[UIImage imageNamed:@"download.png"] forState:UIControlStateNormal];
    [btn_attention setTitle:@"关注官方微博" forState:UIControlStateNormal];
    btn_attention.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    btn_attention.frame = CGRectMake(80, 325, 160, 30);
    [view_content addSubview:btn_attention];
    
    UILabel *lb_copyRight = [[UILabel alloc] initWithFrame:CGRectMake(30, 365, 260, 40)];
    lb_copyRight.font = [UIFont boldSystemFontOfSize:12];
    lb_copyRight.textAlignment = UITextAlignmentCenter;
    lb_copyRight.backgroundColor = [UIColor clearColor];
    lb_copyRight.lineBreakMode = UILineBreakModeCharacterWrap;
    lb_copyRight.numberOfLines = 2;
    lb_copyRight.textColor = [UIColor grayColor];
    lb_copyRight.text = @"Copyright © 2012 上海菁英广告传播有限公司. All Right Reserved";
    [view_content addSubview:lb_copyRight];
    
    arr_time = [NSArray arrayWithObjects:@"不缓存",@"一天",@"一周",@"一个月",@"永久", nil];
    
    SinaEngine = [[WBEngine alloc] initWithAppKey:kWBSDKDemoAppKey appSecret:kWBSDKDemoAppSecret];
    [SinaEngine setRootViewController:self];
    [SinaEngine setDelegate:self];
    [SinaEngine setRedirectURI:@"http://"];
    [SinaEngine setIsUserExclusive:NO];
    
    [self.view bringSubviewToFront:view_nav];
    
    [self show];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
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

-(void)viewWillAppear:(BOOL)animated
{
    [tbl_setting reloadData];
}

-(void)show
{
    [self.view setAlpha:0];
    CGAffineTransform transform = CGAffineTransformIdentity;
    [self.view setTransform:CGAffineTransformScale(transform, 0.3, 0.3)];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(bounceOutAnimationStopped)];
    [self.view setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6f]];
    [self.view setAlpha:0.5];
    [self.view setTransform:CGAffineTransformScale(transform,1.6, 1.6)];
    [UIView commitAnimations];
}

#pragma mark Animations

- (void)bounceOutAnimationStopped
{
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.13];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(bounceInAnimationStopped)];
    [self.view setAlpha:0.8];
	[self.view setTransform:CGAffineTransformScale(CGAffineTransformIdentity, 1.5,1.5)];
	[UIView commitAnimations];
}

- (void)bounceInAnimationStopped
{
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.13];
    [UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(bounceNormalAnimationStopped)];
    [self.view setAlpha:1.0];
	[self.view setTransform:CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0)];
	[UIView commitAnimations];
}

- (void)bounceNormalAnimationStopped
{
    [self allAnimationsStopped];
}

- (void)allAnimationsStopped
{
    //[self.view setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6f]];
}

#pragma mark -
#pragma mark buttonFunction
-(void)turnBack
{
//    [self.navigationController popViewControllerAnimated:YES];
//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationDuration:0.2f];
//    [UIView setAnimationTransition:UIViewAnimationOptionTransitionFlipFromBottom forView:self.view cache:NO];
//    [UIView commitAnimations];
    //[delegate hideSetting:self.view];
//    CATransition *transition = [CATransition animation];
//    transition.duration = 0.8f;
//    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
//    transition.type = kCATransitionMoveIn;
//    transition.subtype = kCATransitionFromTop;
//    transition.delegate = self;
//    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    AppDelegate_IPad *app = (AppDelegate_IPad *)[UIApplication sharedApplication].delegate;
    //[[SqlManager sharedManager] emptyBuffer:app.bufferTime];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)createSinaFriend 
{
    NSMutableDictionary *dic_params = [[NSMutableDictionary alloc] init];
    [dic_params setObject:@"" forKey:@"uId"];
    [dic_params setObject:@"" forKey:@"screen_name"];
    [SinaEngine loadRequestWithMethodName:@"friendships/create" httpMethod:@"POST" params:dic_params postDataType:kWBRequestPostDataTypeNormal httpHeaderFields:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        switch (indexPath.section) {
            case 0:
            {
                if (indexPath.row == 0) {
                    NSArray *arr_segments = [NSArray arrayWithObjects:@"小",@"中",@"大",nil];
                    UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:arr_segments];
                    segment.frame = CGRectMake(120, 10, 180, 30);
                    [segment addTarget:self action:@selector(changeFontSize:) forControlEvents:UIControlEventValueChanged];
                    [cell addSubview:segment];
                    AppDelegate_IPad *app = (AppDelegate_IPad *)[UIApplication sharedApplication].delegate;
                    segment.selectedSegmentIndex = app.fontSize;
                    
                    UIImageView *imgView_icon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 30, 30)];
                    imgView_icon.image = [UIImage imageNamed:@"changeFont.png"];
                    [cell addSubview:imgView_icon];
                    
                    UILabel *lb_title = [[UILabel alloc] initWithFrame:CGRectMake(40, 10, 80, 30)];
                    lb_title.backgroundColor = [UIColor clearColor];
                    lb_title.text = @"字体设置";
                    lb_title.font = [UIFont boldSystemFontOfSize:17];
                    lb_title.textColor = [UIColor blackColor];
                    [cell addSubview:lb_title];
                    
//                    cell.textLabel.text = @"字体设置";
//                    cell.imageView.image = [UIImage imageNamed:@"changeFont.png"];
                }
                else if (indexPath.row == 1) {
                    UIImageView *imgView_icon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 30, 30)];
                    imgView_icon.image = [UIImage imageNamed:@"changeBufferTime.png"];
                    [cell addSubview:imgView_icon];
                    
                    UILabel *lb_title = [[UILabel alloc] initWithFrame:CGRectMake(40, 10, 80, 30)];
                    lb_title.backgroundColor = [UIColor clearColor];
                    lb_title.text = @"缓存时间";
                    lb_title.font = [UIFont boldSystemFontOfSize:17];
                    lb_title.textColor = [UIColor blackColor];
                    [cell addSubview:lb_title];
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    //cell.imageView.image = [UIImage imageNamed:@"changeBufferTime.png"];
                }
            }
                break;
            case 1:
            {
                if (indexPath.row == 0) {
                    cell.textLabel.text = @"关于精英车主";
                }
                else if (indexPath.row == 1) {
                    cell.textLabel.text = @"技术支持说明";
                }
            }
                break;
            default:
                break;
        }
    }
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row == 0) {
            }
            else if (indexPath.row == 1) {
                AppDelegate_IPad *app = (AppDelegate_IPad *)[UIApplication sharedApplication].delegate;
                cell.detailTextLabel.text = [arr_time objectAtIndex:app.bufferTime];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
        }
            break;
        case 1:
        {
            if (indexPath.row == 0) {
            }
            else if (indexPath.row == 1) {
            }
        }
            break;
        default:
            break;
    }
    
    
    return cell;
}

#pragma mark - Table view delegate
//- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (indexPath.section == 0 && indexPath.row == 0) {
//        return nil;
//    }
//    return indexPath;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
            {
                UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                cell.userInteractionEnabled = NO;
            }
                break;
            case 1:
            {
                SettingBufferViewController_IPad *con_buffer = [[SettingBufferViewController_IPad alloc] init];
                [self.navigationController pushViewController:con_buffer animated:YES];
            }
                break; 
            default:
                break;
        }
    }
    else if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:
            {
                SettingAboutViewController_IPad *con_about = [[SettingAboutViewController_IPad alloc] init];
                [self.navigationController pushViewController:con_about animated:YES];
            }
                break;
            case 1:
            {
                SettingTechSupportViewController_IPad *con_support = [[SettingTechSupportViewController_IPad alloc] init];
                [self.navigationController pushViewController:con_support animated:YES];
            }
                break; 
            default:
                break;
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark uisegmentControl
-(void)changeFontSize:(UISegmentedControl *)sender
{
    AppDelegate_IPad *app = (AppDelegate_IPad *)[UIApplication sharedApplication].delegate;
    app.fontSize = sender.selectedSegmentIndex;
    NSMutableDictionary *dic_configure = [[NSMutableDictionary alloc] init];
    [dic_configure setObject:[NSString stringWithFormat:@"%d",app.fontSize] forKey:@"fontSize"];
    [dic_configure setObject:[NSString stringWithFormat:@"%d",app.bufferTime] forKey:@"bufferTime"];
    [[SqlManager sharedManager] saveConfigure:dic_configure];
    
}

@end
