//
//  MagazineUndownloadedViewController.h
//  JingYingCar
//
//  Created by JiaMing Yan on 12-5-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@protocol MagazineEditDelegate <NSObject>

-(void)commitEditing:(NSString *)str_id;

@end

@interface MagazineUndownloadedViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,ASIHTTPRequestDelegate>
{
    NSMutableArray *arr_magazineList;
    UITableView *tbl_magazineList;
    
    NSMutableArray *arr_magazineData;
    
    BOOL isDeleteMode;
    
    id<MagazineEditDelegate>delegate;
}

@property (nonatomic,retain) id<MagazineEditDelegate>delegate;

@end
