//
//  BookshelfViewController.h
//  JingYingCar
//
//  Created by JiaMing Yan on 12-4-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "MagazineUndownloadedViewController.h"

@interface BookshelfViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,MagazineEditDelegate>
{
    UITableView *tbl_bookshelf;
    
    NSMutableArray *arr_magazine;
    
    NSMutableArray *arr_buttons;
    
    UIView *view_content;
}

@end
