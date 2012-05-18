//
//  CustomImageView.m
//  JingYingCar
//
//  Created by JiaMing Yan on 12-5-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CustomImageView.h"

@implementation CustomImageView

@synthesize str_id;
@synthesize img;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame withID:(NSString *)strID img:(UIImage *)image
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.userInteractionEnabled = YES;
        str_id = strID;
        imgView = [[UIImageView alloc] initWithFrame:self.bounds];
        imgView.backgroundColor = [UIColor grayColor];
        indView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [indView setCenter:imgView.center];
        if (image != nil) {
            imgView.image = image;
        }
        else {
            [indView startAnimating];
        }
        [imgView addSubview:indView];
        [self addSubview:imgView];
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

-(void)setImg:(UIImage *)newImg
{
    img = newImg;
    imgView.image = newImg;
    if ([indView isAnimating] == YES) {
        [indView stopAnimating];
    }
    [self setNeedsDisplay];
}


@end
