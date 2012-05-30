//
//  ImageDetailViewController_IPad.h
//  JingYingCar
//
//  Created by JiaMing Yan on 12-4-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate_IPad.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "WBEngine.h"
#import "WBSendView.h"

@interface ImageDetailViewController_IPad : UIViewController<UIScrollViewDelegate,UIWebViewDelegate,MFMailComposeViewControllerDelegate,WBEngineDelegate,WBSendViewDelegate, UIGestureRecognizerDelegate>
{
    //NSMutableDictionary *dic_detail;
    //NSString *str_class;
    NSString *str_id;
    
    //UIScrollView *sclView_topic;
    
//    UILabel *lb_title;
//    UITextView *tv_content;
//    UIImageView *imgView;
    
    UIWebView *webView_detail;
    
    UIView *view_shareList;
    
    WBEngine *SinaEngine;//新浪微博
    
    UIActivityIndicatorView *indView;
    
    NSMutableArray *arr_imgList;
    
    UIScrollView *sclView_item;
    
    UIScrollView *sclView_imgList;
    UIView *view_imgList;
    
    NSMutableArray *arr_requests;
    
    UIButton *btn_hideShare;
    
    BOOL isShowShareList;
    
    UIButton *btn_lastImg;
    UIButton *btn_nextImg;
}

@property (nonatomic,retain) NSString *str_id;

@end
