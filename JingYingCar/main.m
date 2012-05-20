//
//  main.m
//  JingYingCar
//
//  Created by JiaMing Yan on 12-4-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"
#import "AppDelegate_IPad.h"

int main(int argc, char *argv[])
{
    @autoreleasepool {
        if (IS_IPAD) {
            return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate_IPad class]));
        }
        else {
            return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
        }
    }
}
