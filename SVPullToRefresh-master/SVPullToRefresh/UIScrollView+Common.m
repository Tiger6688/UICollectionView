//
//  UIScrollView+Common.m
//  SVPullToRefreshDemo
//
//  Created by apple on 15/3/23.
//  Copyright (c) 2015年 Home. All rights reserved.
//

#import "UIScrollView+Common.h"
#import <objc/runtime.h>


static float topNavigationBarHeightValue;

@implementation UIScrollView(UIScrollView_Common)

- (float)topNavigationBarHeight
{
    return topNavigationBarHeightValue;
}

- (void)setTopNavigationBarHeight:(float)barHeight
{
    topNavigationBarHeightValue = barHeight;
}

@end
