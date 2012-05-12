//
//  SettingTechSupportViewController.m
//  JingYingCar
//
//  Created by JiaMing Yan on 12-5-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SettingTechSupportViewController.h"

@interface SettingTechSupportViewController ()

@end

@implementation SettingTechSupportViewController

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
    // If you create your views manually, you MUST override this method and use it to create your views.
    // If you use Interface Builder to create your views, then you must NOT override this method.
    [super loadView];
    UIView *view_nav = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 45)];
    view_nav.backgroundColor = [UIColor clearColor];
    [self.view addSubview:view_nav];
    
    UIImageView *imgView_navBK = [[UIImageView alloc] initWithFrame:view_nav.bounds];
    imgView_navBK.image = [UIImage imageNamed:@"navDefault.png"];
    [view_nav addSubview:imgView_navBK];
    
    UIButton *btn_back = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_back.frame = CGRectMake(10, 7, 50, 30);
    [btn_back setBackgroundImage:[UIImage imageNamed:@"leftBarItem.png"] forState:UIControlStateNormal];
    [btn_back setTitle:@" 设定" forState:UIControlStateNormal];
    [btn_back addTarget:self action:@selector(turnBack) forControlEvents:UIControlEventTouchUpInside];
    [btn_back setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn_back.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    btn_back.titleLabel.textAlignment = UITextAlignmentRight;
    [view_nav addSubview:btn_back];
    
    UIView *view_content = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
    view_content.backgroundColor = [UIColor clearColor];
    [self.view addSubview:view_content];
    
    UIImageView *imgView_bk = [[UIImageView alloc] initWithFrame:view_content.bounds];
    imgView_bk.image = [UIImage imageNamed:@"techSupport.png"];
    [view_content addSubview:imgView_bk];
    
    [self.view bringSubviewToFront:view_nav];
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

#pragma mark -
#pragma mark buttonFunction
-(void)turnBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
