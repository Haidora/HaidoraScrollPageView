//
//  HDScrollPageView.h
//  HaidoraScrollPageView
//
//  Created by DaiLingchi on 14-10-31.
//  Copyright (c) 2014年 Haidora. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HDScrollPageView : UIView <UIScrollViewDelegate>

@property (nonatomic, strong, readonly) UIScrollView *scrollView;
@property (nonatomic, strong, readonly) UIPageControl *pageControl;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSTimeInterval autoScrollDelayTime;
@property (nonatomic, strong) NSMutableArray *viewsArray;

@property (nonatomic, copy) void (^didClickBlock)(HDScrollPageView *view, NSInteger index);

- (void)shouldAutoShow:(BOOL)shouldStart;

@end