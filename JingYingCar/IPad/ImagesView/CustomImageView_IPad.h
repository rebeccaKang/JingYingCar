//
//  CustomImageView_IPad.h
//  JingYingCar
//
//  Created by JiaMing Yan on 12-5-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomImageView_IPad : UIView<UIGestureRecognizerDelegate>
{
    NSString *str_id;
    UIImageView *imgView;
    UIImage *img;
    UIActivityIndicatorView *indView;
}

@property (nonatomic,retain) NSString *str_id;
@property (nonatomic,retain) UIImage *img;

- (id)initWithFrame:(CGRect)frame withID:(NSString *)strID img:(UIImage *)image;

@end
