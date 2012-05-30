//
//  SettingBufferViewController_IPad.m
//  JingYingCar
//
//  Created by JiaMing Yan on 12-5-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SettingBufferViewController_IPad.h"

@interface SettingBufferViewController_IPad ()

@end

@implementation SettingBufferViewController_IPad

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
    imgView_navBK.image = [UIImage imageNamed:@"settingNav.png"];
    [view_nav addSubview:imgView_navBK];
    
    UIButton *btn_back = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_back.frame = CGRectMake(10, 7.5f, 50, 30);
    [btn_back setBackgroundImage:[UIImage imageNamed:@"leftBarItem.png"] forState:UIControlStateNormal];
    [btn_back setTitle:@" 设定" forState:UIControlStateNormal];
    [btn_back addTarget:self action:@selector(turnBack) forControlEvents:UIControlEventTouchUpInside];
    [btn_back setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn_back.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    btn_back.titleLabel.textAlignment = UITextAlignmentRight;
    [view_nav addSubview:btn_back];
    
    UIView *view_content = [[UIView alloc] initWithFrame:CGRectMake(0, 45, 320, 415)];
    view_content.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
    [self.view addSubview:view_content];
    
    tbl_setting = [[UITableView alloc] initWithFrame:CGRectMake(10, 10, 300, 300) style:UITableViewStyleGrouped];
    tbl_setting.backgroundColor = [UIColor clearColor];
    tbl_setting.delegate = self;
    tbl_setting.dataSource = self;
    tbl_setting.scrollEnabled = NO;
    [view_content addSubview:tbl_setting];
    
    arr_time = [NSArray arrayWithObjects:@"不缓存",@"一天",@"一周",@"一个月",@"永久", nil];
    
    AppDelegate_IPad *app = (AppDelegate_IPad *)[UIApplication sharedApplication].delegate;
    NSDictionary *dic_configure = [[NSDictionary alloc] initWithDictionary:[[SqlManager sharedManager] readConfigure]];
    app.fontSize = [[dic_configure objectForKey:@"fontSize"] integerValue];
    app.bufferTime = [[dic_configure objectForKey:@"bufferTime"] integerValue];
    choice = app.bufferTime;
    NSLog(@"%@",dic_configure);
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
    AppDelegate_IPad *app = (AppDelegate_IPad *)[UIApplication sharedApplication].delegate;
    app.bufferTime = choice;
    NSMutableDictionary *dic_configure = [[NSMutableDictionary alloc] init];
    [dic_configure setObject:[NSString stringWithFormat:@"%d",app.fontSize] forKey:@"fontSize"];
    [dic_configure setObject:[NSString stringWithFormat:@"%d",app.bufferTime] forKey:@"bufferTime"];
    [[SqlManager sharedManager] saveConfigure:dic_configure];
    [self.navigationController popViewControllerAnimated:YES];
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
    return [arr_time count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
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
    choice = indexPath.row;
    [tableView reloadData];
    
    //[self.navigationController popViewControllerAnimated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



@end
