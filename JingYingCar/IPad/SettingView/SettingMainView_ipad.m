//
//  SettingMainView_ipad.m
//  JingYingCar
//
//  Created by JiaMing Yan on 12-5-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SettingMainView_ipad.h"

@implementation SettingMainView_ipad

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.tag = settingViewTag;
        self.backgroundColor = [UIColor colorWithWhite:0.2f alpha:0.8f];
        
        CGRect rect = CGRectMake(99, 165, 570, 630);
        
        view_mainContentView = [[UIView alloc] initWithFrame:rect];
        view_mainContentView.backgroundColor = [UIColor clearColor];
        [self addSubview:view_mainContentView];
        
        view_main = [[UIView alloc] initWithFrame:view_mainContentView.bounds];
        view_main.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"settingBackground_ipad.png"]];
        [view_mainContentView addSubview:view_main];
        
        view_about = [[UIView alloc] initWithFrame:view_mainContentView.bounds];
        view_about.alpha = 0;
        [view_mainContentView addSubview:view_about];
        
        view_techSupport = [[UIView alloc] initWithFrame:view_mainContentView.bounds];
        view_techSupport.alpha = 0;
        [view_mainContentView addSubview:view_techSupport];
        
        view_bufferTime = [[UIView alloc] initWithFrame:view_mainContentView.bounds];
        view_bufferTime.alpha = 0;
        [view_mainContentView addSubview:view_bufferTime];
        
        UIView *view_nav = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 570, 45)];
        view_nav.backgroundColor = [UIColor clearColor];
//        view_nav.layer.shadowOffset = CGSizeMake(0, 1);
//        view_nav.layer.shadowOpacity = 1;
//        view_nav.layer.shadowColor = [UIColor blackColor].CGColor;
        [view_main addSubview:view_nav];
        
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
        btn_finish.frame = CGRectMake(440, 8, 120, 30);
        [btn_finish setBackgroundImage:[UIImage imageNamed:@"settingFinish_ipad.png"] forState:UIControlStateNormal];
        //[btn_finish setTitle:@"完成" forState:UIControlStateNormal];
        [btn_finish addTarget:self action:@selector(hide:) forControlEvents:UIControlEventTouchUpInside];
        [btn_finish setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn_finish.titleLabel.font = [UIFont boldSystemFontOfSize:17];
        btn_finish.titleLabel.textAlignment = UITextAlignmentRight;
        [view_nav addSubview:btn_finish];
        
        UIView *view_content = [[UIView alloc] initWithFrame:CGRectMake(0, 45, 570, 585)];
        view_content.backgroundColor = [UIColor clearColor];
        [view_main addSubview:view_content];
        
        tbl_setting = [[UITableView alloc] initWithFrame:view_content.bounds style:UITableViewStyleGrouped];
        tbl_setting.backgroundColor = [UIColor clearColor];
        tbl_setting.delegate = self;
        tbl_setting.dataSource = self;
        [view_content addSubview:tbl_setting];
        
//        UIButton *btn_attention = [UIButton buttonWithType:UIButtonTypeCustom];
//        [btn_attention setBackgroundImage:[UIImage imageNamed:@"download.png"] forState:UIControlStateNormal];
//        [btn_attention setTitle:@"关注官方微博" forState:UIControlStateNormal];
//        btn_attention.titleLabel.font = [UIFont boldSystemFontOfSize:12];
//        btn_attention.frame = CGRectMake(80, 325, 160, 30);
//        [view_content addSubview:btn_attention];
        
        UILabel *lb_copyRight = [[UILabel alloc] initWithFrame:CGRectMake(155, 540, 260, 40)];
        lb_copyRight.font = [UIFont boldSystemFontOfSize:12];
        lb_copyRight.textAlignment = UITextAlignmentCenter;
        lb_copyRight.backgroundColor = [UIColor clearColor];
        lb_copyRight.lineBreakMode = UILineBreakModeCharacterWrap;
        lb_copyRight.numberOfLines = 2;
        lb_copyRight.textColor = [UIColor grayColor];
        lb_copyRight.text = @"Copyright © 2012 上海菁英广告传播有限公司. All Right Reserved";
        [view_content addSubview:lb_copyRight];
        
        arr_time = [NSArray arrayWithObjects:@"不缓存",@"一天",@"一周",@"一个月",@"永久", nil];
        
        [view_main bringSubviewToFront:view_nav];
        
        UIView *view_nav_techSupport = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 570, 45)];
        view_nav_techSupport.backgroundColor = [UIColor clearColor];
        //        view_nav.layer.shadowOffset = CGSizeMake(0, 1);
        //        view_nav.layer.shadowOpacity = 1;
        //        view_nav.layer.shadowColor = [UIColor blackColor].CGColor;
        [view_techSupport addSubview:view_nav_techSupport];
        
        UIImageView *imgView_techSupportNavBK = [[UIImageView alloc] initWithFrame:view_nav.bounds];
        imgView_techSupportNavBK.image = [UIImage imageNamed:@"settingNav_ipad.png"];
        [view_nav_techSupport addSubview:imgView_techSupportNavBK];
        
        UIButton *btn_back = [UIButton buttonWithType:UIButtonTypeCustom];
        btn_back.frame = CGRectMake(10, 7.5f, 50, 30);
        [btn_back setBackgroundImage:[UIImage imageNamed:@"back_ipad.png"] forState:UIControlStateNormal];
        //[btn_back setTitle:@" 设定" forState:UIControlStateNormal];
        [btn_back addTarget:self action:@selector(techSupportTurnBack) forControlEvents:UIControlEventTouchUpInside];
        [btn_back setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn_back.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        btn_back.titleLabel.textAlignment = UITextAlignmentRight;
        [view_nav_techSupport addSubview:btn_back];
        
        UIView *view_techSupportContent = [[UIView alloc] initWithFrame:CGRectMake(0, 45, 570, 585)];
        view_techSupportContent.backgroundColor = [UIColor clearColor];
        [view_techSupport addSubview:view_techSupportContent];
        
        UIImageView *imgView_techSupportBK = [[UIImageView alloc] initWithFrame:view_techSupportContent.bounds];
        imgView_techSupportBK.image = [UIImage imageNamed:@"techSupport_ipad.png"];
        [view_techSupportContent addSubview:imgView_techSupportBK];
        
        UIView *view_nav_about = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 570, 45)];
        view_nav_about.backgroundColor = [UIColor clearColor];
        //        view_nav.layer.shadowOffset = CGSizeMake(0, 1);
        //        view_nav.layer.shadowOpacity = 1;
        //        view_nav.layer.shadowColor = [UIColor blackColor].CGColor;
        [view_about addSubview:view_nav_about];
        
        UIImageView *imgView_aboutNavBK = [[UIImageView alloc] initWithFrame:view_nav.bounds];
        imgView_aboutNavBK.image = [UIImage imageNamed:@"settingNav_ipad.png"];
        [view_nav_about addSubview:imgView_aboutNavBK];
        
        UIButton *btn_back2 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn_back2.frame = CGRectMake(10, 7.5f, 50, 30);
        [btn_back2 setBackgroundImage:[UIImage imageNamed:@"back_ipad.png"] forState:UIControlStateNormal];
        //[btn_back setTitle:@" 设定" forState:UIControlStateNormal];
        [btn_back2 addTarget:self action:@selector(aboutTurnBack) forControlEvents:UIControlEventTouchUpInside];
        [btn_back2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn_back2.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        btn_back2.titleLabel.textAlignment = UITextAlignmentRight;
        [view_nav_about addSubview:btn_back2];
        
        UIView *view_aboutContent = [[UIView alloc] initWithFrame:CGRectMake(0, 45, 570, 585)];
        view_aboutContent.backgroundColor = [UIColor clearColor];
        [view_about addSubview:view_aboutContent];
        
        UIImageView *imgView_aboutBK = [[UIImageView alloc] initWithFrame:view_techSupportContent.bounds];
        imgView_aboutBK.image = [UIImage imageNamed:@"about_ipad.png"];
        [view_aboutContent addSubview:imgView_aboutBK];
        
        UIView *view_nav_bufferTime = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 570, 45)];
        view_nav_bufferTime.backgroundColor = [UIColor clearColor];
        //        view_nav.layer.shadowOffset = CGSizeMake(0, 1);
        //        view_nav.layer.shadowOpacity = 1;
        //        view_nav.layer.shadowColor = [UIColor blackColor].CGColor;
        [view_bufferTime addSubview:view_nav_bufferTime];
        
        UIImageView *imgView_bufferTimeNavBK = [[UIImageView alloc] initWithFrame:view_nav.bounds];
        imgView_bufferTimeNavBK.image = [UIImage imageNamed:@"settingNav_ipad.png"];
        [view_nav_bufferTime addSubview:imgView_bufferTimeNavBK];
        
        UIButton *btn_backBufferTime = [UIButton buttonWithType:UIButtonTypeCustom];
        btn_backBufferTime.frame = CGRectMake(10, 7.5f, 50, 30);
        [btn_backBufferTime setBackgroundImage:[UIImage imageNamed:@"back_ipad.png"] forState:UIControlStateNormal];
        //[btn_back setTitle:@" 设定" forState:UIControlStateNormal];
        [btn_backBufferTime addTarget:self action:@selector(techSupportTurnBack) forControlEvents:UIControlEventTouchUpInside];
        [btn_backBufferTime setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn_backBufferTime.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        btn_backBufferTime.titleLabel.textAlignment = UITextAlignmentRight;
        [view_nav_bufferTime addSubview:btn_backBufferTime];
        
        UIView *view_bufferTimeContent = [[UIView alloc] initWithFrame:CGRectMake(0, 45, 570, 585)];
        view_bufferTimeContent.backgroundColor = [UIColor clearColor];
        [view_bufferTime addSubview:view_bufferTimeContent];
        
        UIImageView *imgView_bufferTimeBK = [[UIImageView alloc] initWithFrame:view_techSupportContent.bounds];
        imgView_bufferTimeBK.image = [UIImage imageNamed:@"settingBackground_ipad.png"];
        [view_bufferTimeContent addSubview:imgView_bufferTimeBK];
        
        tbl_bufferTime = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 570, 585) style:UITableViewStyleGrouped];
        tbl_bufferTime.backgroundColor = [UIColor clearColor];
        tbl_bufferTime.delegate = self;
        tbl_bufferTime.dataSource = self;
        tbl_bufferTime.scrollEnabled = NO;
        [view_bufferTimeContent addSubview:tbl_bufferTime];
        
        AppDelegate_IPad *app = (AppDelegate_IPad *)[UIApplication sharedApplication].delegate;
        NSDictionary *dic_configure = [[NSDictionary alloc] initWithDictionary:[[SqlManager sharedManager] readConfigure]];
        app.fontSize = [[dic_configure objectForKey:@"fontSize"] integerValue];
        app.bufferTime = [[dic_configure objectForKey:@"bufferTime"] integerValue];
        choice = app.bufferTime;
        NSLog(@"%@",dic_configure);
        
        [view_mainContentView bringSubviewToFront:view_main];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)show:(BOOL)animated
{
    AppDelegate_IPad *app = (AppDelegate_IPad *)[UIApplication sharedApplication].delegate;
    if (app.isShowSetting == YES) {
        return;
    }
    app.isShowSetting = YES;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
	if (!window)
    {
		window = [[UIApplication sharedApplication].windows objectAtIndex:0];
	}
  	[window addSubview:self];
    if (animated)
    {
        [self setAlpha:0];
        CGAffineTransform transform = CGAffineTransformIdentity;
        [self setTransform:CGAffineTransformScale(transform, 0.3, 0.3)];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.2];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(bounceOutAnimationStopped)];
        [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6f]];
        [self setAlpha:0.5];
        [self setTransform:CGAffineTransformScale(transform, 1.1, 1.1)];
        [UIView commitAnimations];
    }
    else
    {
        [self allAnimationsStopped];
    }
}

- (void)hide:(BOOL)animated
{
    AppDelegate_IPad *app = (AppDelegate_IPad *)[UIApplication sharedApplication].delegate;
    if (app.isShowSetting == NO) {
        return;
    }
    app.isShowSetting = NO;
    animated = YES;
	if (animated)
    {
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.3];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(hideAndCleanUp)];
		self.alpha = 0;
		[UIView commitAnimations];
	} else {
		
		[self hideAndCleanUp];
	}
}

- (void)hideAndCleanUp
{
	[self removeFromSuperview];	
}

#pragma mark Animations

- (void)bounceOutAnimationStopped
{
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.13];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(bounceInAnimationStopped)];
    //[self setAlpha:0.8];
	[self setTransform:CGAffineTransformScale(CGAffineTransformIdentity, 0.9,0.9)];
	[UIView commitAnimations];
}

- (void)bounceInAnimationStopped
{
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.13];
    [UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(bounceNormalAnimationStopped)];
    [self setAlpha:1.0];
	[self setTransform:CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0)];
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

-(void)showTechSupportView
{
    view_main.alpha = 0;
    view_about.alpha = 0;
    view_techSupport.alpha = 1.0;
    view_bufferTime.alpha = 0;
    [view_mainContentView bringSubviewToFront:view_techSupport];
}

-(void)showAboutView
{
    view_main.alpha = 0;
    view_about.alpha = 1.0;
    view_techSupport.alpha = 0;
    view_bufferTime.alpha = 0;
    [view_mainContentView bringSubviewToFront:view_about];
}

-(void)showMainView
{
    view_main.alpha = 1.0;
    view_about.alpha = 0;
    view_techSupport.alpha = 0;
    view_bufferTime.alpha = 0;
    [view_mainContentView bringSubviewToFront:view_main];
}

-(void)showBufferTimeView
{
    view_main.alpha = 0;
    view_about.alpha = 0;
    view_techSupport.alpha = 0;
    view_bufferTime.alpha = 1.0;
    [view_mainContentView bringSubviewToFront:view_bufferTime];
}

#pragma mark - buttonFunction
-(void)aboutTurnBack
{
    view_main.alpha = 0;
    view_about.alpha = 1.0;
    view_techSupport.alpha = 0;
    view_bufferTime = 0;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5f];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(showMainView)];
    view_main.alpha = 0.5f;
    view_about.alpha = 0.5f;
    view_techSupport.alpha = 0;
    view_bufferTime.alpha = 0;
    [self bringSubviewToFront:view_main];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:view_mainContentView cache:NO];
    [UIView commitAnimations];
}

-(void)techSupportTurnBack
{
    view_main.alpha = 0;
    view_about.alpha = 0;
    view_techSupport.alpha = 1.0;
    view_bufferTime = 0;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5f];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(showMainView)];
    view_main.alpha = 0.5f;
    view_about.alpha = 0;
    view_techSupport.alpha = 0.5f;
    view_bufferTime.alpha = 0;
    [self bringSubviewToFront:view_main];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:view_mainContentView cache:NO];
    [UIView commitAnimations];
}

-(void)bufferTimeTurnBack
{
    view_main.alpha = 0;
    view_about.alpha = 0;
    view_techSupport.alpha = 0;
    view_bufferTime.alpha = 1.0;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5f];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(showMainView)];
    view_main.alpha = 0.5f;
    view_about.alpha = 0;
    view_techSupport.alpha = 0;
    view_bufferTime.alpha = 0.5f;
    [self bringSubviewToFront:view_main];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:view_mainContentView cache:NO];
    [UIView commitAnimations];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if (tableView == tbl_setting) {
        return 2;
    }
    else if (tableView == tbl_bufferTime)
    {
        return 1;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (tableView == tbl_setting) {
        if (section == 0) {
            return 3;
        }
        else {
            return 2;
        }
    }
    else if (tableView == tbl_bufferTime) {
        return [arr_time count];
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier;
    if (tableView == tbl_setting) {
        CellIdentifier = @"Cell";
    }
    else {
        CellIdentifier = @"bufferTime";
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // Configure the cell...
    if (tableView == tbl_setting) {
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            switch (indexPath.section) {
                case 0:
                {
                    if (indexPath.row == 0) {
                        NSArray *arr_segments = [NSArray arrayWithObjects:@"小",@"中",@"大",nil];
                        UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:arr_segments];
                        segment.frame = CGRectMake(340, 10, 180, 30);
                        [segment addTarget:self action:@selector(changeFontSize:) forControlEvents:UIControlEventValueChanged];
                        [cell addSubview:segment];
                        AppDelegate_IPad *app = (AppDelegate_IPad *)[UIApplication sharedApplication].delegate;
                        segment.selectedSegmentIndex = app.fontSize;
                        
                        //                    UIImageView *imgView_icon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 30, 30)];
                        //                    imgView_icon.image = [UIImage imageNamed:@"changeFont.png"];
                        //                    [cell addSubview:imgView_icon];
                        
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
                        //                    UIImageView *imgView_icon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 30, 30)];
                        //                    imgView_icon.image = [UIImage imageNamed:@"changeBufferTime.png"];
                        //                    [cell addSubview:imgView_icon];
                        
                        UILabel *lb_title = [[UILabel alloc] initWithFrame:CGRectMake(40, 10, 80, 30)];
                        lb_title.backgroundColor = [UIColor clearColor];
                        lb_title.text = @"缓存时间";
                        lb_title.font = [UIFont boldSystemFontOfSize:17];
                        lb_title.textColor = [UIColor blackColor];
                        [cell addSubview:lb_title];
                        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                        //cell.imageView.image = [UIImage imageNamed:@"changeBufferTime.png"];
                    }
                    else if(indexPath.row == 2){
                        UILabel *lb_title = [[UILabel alloc] initWithFrame:CGRectMake(40, 10, 80, 30)];
                        lb_title.backgroundColor = [UIColor clearColor];
                        lb_title.text = @"清空缓存";
                        lb_title.font = [UIFont boldSystemFontOfSize:17];
                        lb_title.textColor = [UIColor blackColor];
                        [cell addSubview:lb_title];
                        cell.accessoryType = UITableViewCellAccessoryNone;
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
    }
    else if (tableView == tbl_bufferTime)
    {
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
            cell.textLabel.text = [arr_time objectAtIndex:indexPath.row];
            
        }
        
        if (choice == indexPath.row) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
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
    if (tableView == tbl_setting) {
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
                    //                SettingBufferViewController_IPad *con_buffer = [[SettingBufferViewController_IPad alloc] init];
                    //                [self.navigationController pushViewController:con_buffer animated:YES];
                    view_main.alpha = 0;
                    view_about.alpha = 0;
                    view_techSupport.alpha = 0;
                    view_bufferTime.alpha = 0;
                    [UIView beginAnimations:nil context:nil];
                    [UIView setAnimationDuration:0.5f];
                    [UIView setAnimationDelegate:self];
                    [UIView setAnimationDidStopSelector:@selector(showBufferTimeView)];
                    view_main.alpha = 0.5f;
                    view_about.alpha = 0;
                    view_techSupport.alpha = 0;
                    view_bufferTime.alpha = 0.5f;
                    [self bringSubviewToFront:view_bufferTime];
                    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:view_mainContentView cache:NO];
                    [UIView commitAnimations];
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
                    //                SettingAboutViewController_IPad *con_about = [[SettingAboutViewController_IPad alloc] init];
                    //                [self.navigationController pushViewController:con_about animated:YES];
                    view_main.alpha = 0;
                    view_about.alpha = 0;
                    view_techSupport.alpha = 0;
                    view_bufferTime.alpha = 0;
                    [UIView beginAnimations:nil context:nil];
                    [UIView setAnimationDuration:0.5f];
                    [UIView setAnimationDelegate:self];
                    [UIView setAnimationDidStopSelector:@selector(showAboutView)];
                    view_main.alpha = 0.5f;
                    view_about.alpha = 0.5f;
                    view_techSupport.alpha = 0;
                    view_bufferTime.alpha = 0;
                    [self bringSubviewToFront:view_about];
                    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:view_mainContentView cache:NO];
                    [UIView commitAnimations];
                }
                    break;
                case 1:
                {
                    //                SettingTechSupportViewController_IPad *con_support = [[SettingTechSupportViewController_IPad alloc] init];
                    //                [self.navigationController pushViewController:con_support animated:YES];
                    view_main.alpha = 0;
                    view_about.alpha = 0;
                    view_techSupport.alpha = 0;
                    view_bufferTime.alpha = 0;
                    [UIView beginAnimations:nil context:nil];
                    [UIView setAnimationDuration:0.5f];
                    [UIView setAnimationDelegate:self];
                    [UIView setAnimationDidStopSelector:@selector(showTechSupportView)];
                    view_main.alpha = 0.5f;
                    view_about.alpha = 0;
                    view_techSupport.alpha = 0.5f;
                    view_bufferTime.alpha = 0;
                    [self bringSubviewToFront:view_techSupport];
                    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:view_mainContentView cache:NO];
                    [UIView commitAnimations];
                }
                    break; 
                default:
                    break;
            }
        }
    }
    else if (tableView == tbl_bufferTime) {
        choice = indexPath.row;
        [tableView reloadData];
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
