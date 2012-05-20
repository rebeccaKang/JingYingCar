//
//  MoreViewController_IPad.m
//  JingYingCar
//
//  Created by JiaMing Yan on 12-4-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MoreViewController_IPad.h"

@interface MoreViewController_IPad ()

@end

@implementation MoreViewController_IPad

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
    
    UIView *view_nav = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 45)];
    view_nav.backgroundColor = [UIColor clearColor];
    view_nav.layer.shadowOffset = CGSizeMake(0, 1);
    view_nav.layer.shadowOpacity = 0.8;
    view_nav.layer.shadowColor = [UIColor blackColor].CGColor;
    [self.view addSubview:view_nav];
    
    UIImageView *imgView_navBK = [[UIImageView alloc] initWithFrame:view_nav.bounds];
    imgView_navBK.image = [UIImage imageNamed:@"moreNav.png"];
    [view_nav addSubview:imgView_navBK];
    
    UIView *view_content = [[UIView alloc] initWithFrame:CGRectMake(0, 45, 320, 415)];
    view_content.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
    [self.view addSubview:view_content];
    
    arr_list = [[NSMutableArray alloc] init];
    arr_listID = [[NSArray alloc] initWithArray:[[SqlManager sharedManager] getCollectionList] copyItems:YES];
    for (int i = 0; i < [arr_listID count]; i++) {
        NSDictionary *dic_collectionID = [arr_listID objectAtIndex:i];
        NSString *str_fatherID = [dic_collectionID objectForKey:@"fatherID"];
        NSString *str_childeID = [dic_collectionID objectForKey:@"childID"];
        NSDictionary *dic_collection;
        switch ([str_fatherID intValue]) {
            case 0:
            {
                dic_collection = [[NSDictionary alloc] initWithDictionary:[[SqlManager sharedManager] getNewsListWithID:str_childeID]];
            }
                break;
            case 1:
            {
                dic_collection = [[NSDictionary alloc] initWithDictionary:[[SqlManager sharedManager] getImageListWithID:str_childeID]];
            }
                break;
            case 2:
            {
                dic_collection = [[NSDictionary alloc] initWithDictionary:[[SqlManager sharedManager] getTopicListWithID:str_childeID]];
            }
                break;
            default:
                break;
        }
        [arr_list addObject:dic_collection];
    }
    
    tbl_list = [[UITableView alloc] initWithFrame:view_content.bounds style:UITableViewStylePlain];
    tbl_list.separatorStyle = UITableViewCellSeparatorStyleNone;
    tbl_list.backgroundColor = [UIColor clearColor];
    tbl_list.delegate = self;
    tbl_list.dataSource = self;
    [view_content addSubview:tbl_list];
    
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

-(void)viewWillAppear:(BOOL)animated
{
    if (tbl_list != nil) {
        [self reload];
    }
}

-(void)reload
{
    [arr_list removeAllObjects];
    arr_listID = [[[SqlManager sharedManager] getCollectionList] mutableCopy];
    for (int i = 0; i < [arr_listID count]; i++) {
        NSDictionary *dic_collectionID = [arr_listID objectAtIndex:i];
        NSString *str_fatherID = [dic_collectionID objectForKey:@"fatherID"];
        NSString *str_childeID = [dic_collectionID objectForKey:@"childID"];
        NSDictionary *dic_collection;
        switch ([str_fatherID intValue]) {
            case 0:
            {
                dic_collection = [[NSDictionary alloc] initWithDictionary:[[SqlManager sharedManager] getNewsListWithID:str_childeID]];
            }
                break;
            case 1:
            {
                dic_collection = [[NSDictionary alloc] initWithDictionary:[[SqlManager sharedManager] getImageListWithID:str_childeID]];
            }
                break;
            case 2:
            {
                dic_collection = [[NSDictionary alloc] initWithDictionary:[[SqlManager sharedManager] getTopicListWithID:str_childeID]];
            }
                break;
            default:
                break;
        }
        [arr_list addObject:dic_collection];
    }
    [tbl_list reloadData];
}

#pragma mark - Table view data source
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view_header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    UIImageView *imgView_bk = [[UIImageView alloc] initWithFrame:view_header.bounds];
    imgView_bk.image = [UIImage imageNamed:@"collectionTableview.png"];
    [view_header addSubview:imgView_bk];
    
    UIImageView *imgView_collect = [[UIImageView alloc] initWithFrame:CGRectMake(10, 8, 25, 25)];
    imgView_collect.image = [UIImage imageNamed:@"collect.png"];
    [view_header addSubview:imgView_collect];
    
    UILabel *lb_title = [[UILabel alloc] initWithFrame:CGRectMake(45, 5, 80, 30)];
    lb_title.textColor = [UIColor blackColor];
    lb_title.backgroundColor = [UIColor clearColor];
    lb_title.text = @"我的收藏";
    [view_header addSubview:lb_title];
    return view_header;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [arr_list count];
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
        
        UIView *view_bk = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
        view_bk.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"magazineTableview.png"]];
        view_bk.tag = 0;
        [cell addSubview:view_bk];
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 5, 80, 50)];
        imgView.tag = 1;
        [cell addSubview:imgView];
        
        UILabel *lb_title = [[UILabel alloc] initWithFrame:CGRectMake(110, 0, 180, 20)];
        lb_title.textColor = [UIColor grayColor];
        lb_title.font = [UIFont systemFontOfSize:12];
        lb_title.backgroundColor = [UIColor clearColor];
        lb_title.tag = 2;
        [cell addSubview:lb_title];
        
        UILabel *lb_summary = [[UILabel alloc] initWithFrame:CGRectMake(110, 20, 180, 20)];
        lb_summary.textColor = [UIColor blackColor];
        lb_summary.font = [UIFont systemFontOfSize:14];
        lb_summary.backgroundColor = [UIColor clearColor];
        lb_summary.tag = 3;
        [cell addSubview:lb_summary];
        
        UILabel *lb_update = [[UILabel alloc] initWithFrame:CGRectMake(110, 40, 180, 20)];
        lb_update.textColor = [UIColor colorWithRed:0.384 green:0.286 blue:0.224 alpha:1];
        lb_update.font = [UIFont systemFontOfSize:12];
        lb_update.backgroundColor = [UIColor clearColor];
        lb_update.tag = 4;
        [cell addSubview:lb_update];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    if (arr_list.count > indexPath.row) {
        NSDictionary *dic_news = [arr_list objectAtIndex:indexPath.row];
        
        UIView *view_bk = [cell viewWithTag:0];
        
        UIImageView *imgView = (UIImageView *)[view_bk viewWithTag:1];
        UIImage *img;
        NSString *str_imgAddress = [dic_news objectForKey:@"smallImgAddress"];
        if ([str_imgAddress length] > 0) {
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSData *data_img = [fileManager contentsAtPath:str_imgAddress];
            img = [UIImage imageWithData:data_img];
        }
        else {
            imgView.backgroundColor = [UIColor grayColor];
        }
        imgView.image = img;
        
        UILabel *lb_title = (UILabel *)[view_bk viewWithTag:2];
        lb_title.text = [dic_news objectForKey:@"title"];
        
        UILabel *lb_summary = (UILabel *)[view_bk viewWithTag:3];
        lb_summary.text = [dic_news objectForKey:@"summary"];
        
        UILabel *lb_update = (UILabel *)[view_bk viewWithTag:4];
        lb_update.text = [dic_news objectForKey:@"createTime"];
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
    
    TopicDetailViewController_IPad *con_detail = [[TopicDetailViewController_IPad alloc] init];
    
    NSDictionary *dic_news = [arr_listID objectAtIndex:indexPath.row];
    NSString *str_fatherID = [dic_news objectForKey:@"fatherID"];
    con_detail.str_id = [dic_news objectForKey:@"childID"];
    con_detail.type = [str_fatherID intValue];
    
    [self.navigationController pushViewController:con_detail animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 
    if (editingStyle == UITableViewCellEditingStyleDelete) {
    // Delete the row from the data source.
        NSDictionary *dic_news = [arr_listID objectAtIndex:indexPath.row];
        NSString *str_id = [dic_news objectForKey:@"childID"];
        [[SqlManager sharedManager] deleteCollection:str_id];
        [arr_list removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        //[self reload];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
 }
 


@end
