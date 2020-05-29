//
//  UIScrollView+BottomRefreshControl.h
//  mvvm-architect
//
//  Created by Nguyen Duc Huy B on 5/29/20.
//  Copyright © 2020 sun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (BottomRefreshControl)

@property (nullable, nonatomic) UIRefreshControl *bottomRefreshControl;

@end


@interface UIRefreshControl (BottomRefreshControl)

@property (nonatomic) CGFloat triggerVerticalOffset;

@end
