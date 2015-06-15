//
//  HDScrollPageView.m
//  HaidoraScrollPageView
//
//  Created by DaiLingchi on 14-10-31.
//  Copyright (c) 2014年 Haidora. All rights reserved.
//

#import "HDScrollPageView.h"

@interface HDScrollPageView ()

@property (nonatomic, strong, readwrite) UIScrollView *scrollView;
@property (nonatomic, strong, readwrite) UIPageControl *pageControl;

@property (nonatomic, strong) UITapGestureRecognizer *tap;

@property (nonatomic, strong) UIView *firstView;
@property (nonatomic, strong) UIView *middleView;
@property (nonatomic, strong) UIView *lastView;
@property (nonatomic, assign) BOOL shouldAutoStart;
@property (nonatomic, strong) NSTimer *autoScrollTimer;

@end

@implementation HDScrollPageView

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self)
    {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    _autoScrollDelayTime = 5;
    _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];

    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollView.autoresizingMask =
        UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.scrollEnabled = NO;
    _scrollView.pagingEnabled = YES;
    [_scrollView addGestureRecognizer:_tap];
    [self addSubview:_scrollView];

    _pageControl = [[UIPageControl alloc] init];
    _pageControl.userInteractionEnabled = NO;
    [self addSubview:_pageControl];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect rect = self.bounds;
    rect.origin.y = rect.size.height - 30;
    rect.size.height = 30;
    _pageControl.frame = rect;

    [self reloadData];
}

- (void)reloadData
{
    [_firstView removeFromSuperview];
    [_middleView removeFromSuperview];
    [_lastView removeFromSuperview];

    if (_viewsArray.count > 0)
    {
        if (_currentPage == 0)
        {
            _firstView = [_viewsArray lastObject];
            _middleView = [_viewsArray objectAtIndex:_currentPage];
            if ([_viewsArray count] > 1)
            {
                _lastView = [_viewsArray objectAtIndex:_currentPage + 1];
            }
        }
        else if (_currentPage == [_viewsArray count] - 1)
        {
            _firstView = [_viewsArray objectAtIndex:_currentPage - 1];
            _middleView = [_viewsArray objectAtIndex:_currentPage];
            _lastView = [_viewsArray objectAtIndex:0];
        }
        else
        {
            _firstView = [_viewsArray objectAtIndex:_currentPage - 1];
            _middleView = [_viewsArray objectAtIndex:_currentPage];
            _lastView = [_viewsArray objectAtIndex:_currentPage + 1];
        }
        [_pageControl setCurrentPage:_currentPage];

        CGSize scrollSize = self.bounds.size;
        [_firstView setFrame:CGRectMake(0, 0, scrollSize.width, scrollSize.height)];
        [_middleView setFrame:CGRectMake(scrollSize.width, 0, scrollSize.width, scrollSize.height)];
        [_lastView
            setFrame:CGRectMake(scrollSize.width * 2, 0, scrollSize.width, scrollSize.height)];
        [_scrollView addSubview:_firstView];
        [_scrollView addSubview:_middleView];
        [_scrollView addSubview:_lastView];
        _scrollView.contentSize = CGSizeMake(self.bounds.size.width * 3, self.bounds.size.height);
        [_scrollView setContentOffset:CGPointMake(self.bounds.size.width, 0) animated:NO];
    }
}

#pragma mark ScrollView Delegate
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    //自动timer滑行后自动替换，不再动画
    [self reloadData];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (_shouldAutoStart)
    {
        [_autoScrollTimer invalidate];
        _autoScrollTimer = nil;
        _autoScrollTimer = [NSTimer scheduledTimerWithTimeInterval:_autoScrollDelayTime
                                                            target:self
                                                          selector:@selector(autoShowNext)
                                                          userInfo:nil
                                                           repeats:YES];
    }
    int x = scrollView.contentOffset.x;
    //往下翻一张
    if (x >= (2 * self.frame.size.width))
    {
        if (_currentPage + 1 == [_viewsArray count])
        {
            _currentPage = 0;
        }
        else
        {
            _currentPage++;
        }
        if (_didScrollBlock)
        {
            _didScrollBlock(self, _currentPage);
        }
    }

    //往上翻
    if (x <= 0)
    {
        if (_currentPage - 1 < 0)
        {
            _currentPage = [_viewsArray count] - 1;
        }
        else
        {
            _currentPage--;
        }
        if (_didScrollBlock)
        {
            _didScrollBlock(self, _currentPage);
        }
    }

    [self reloadData];
}

#pragma mark
#pragma mark Setter

- (void)setViewsArray:(NSMutableArray *)viewsArray
{
    _viewsArray = viewsArray;
    _currentPage = 0;

    _pageControl.numberOfPages = [viewsArray count];
    [_pageControl setCurrentPage:_currentPage];

    if (viewsArray && viewsArray.count > 1)
    {
        self.scrollView.scrollEnabled = YES;
    }
    else
    {
        self.scrollView.scrollEnabled = NO;
    }
    [self reloadData];
}

#pragma mark
#pragma mark Action

- (void)autoShowNext
{
    if (_currentPage + 1 >= [_viewsArray count])
    {
        _currentPage = 0;
    }
    else
    {
        _currentPage++;
    }
    [_scrollView setContentOffset:CGPointMake(self.bounds.size.width * 2, 0) animated:YES];
}

- (void)handleTap:(UITapGestureRecognizer *)tap
{
    if (_didClickBlock)
    {
        _didClickBlock(self, _currentPage);
    }
}

- (void)shouldAutoShow:(BOOL)shouldStart
{
    _shouldAutoStart = shouldStart;
    if (shouldStart)
    {
        if ([_autoScrollTimer isValid])
        {
        }
        else
            _autoScrollTimer = [NSTimer scheduledTimerWithTimeInterval:_autoScrollDelayTime
                                                                target:self
                                                              selector:@selector(autoShowNext)
                                                              userInfo:nil
                                                               repeats:YES];
    }
    else
    {
        if ([_autoScrollTimer isValid])
        {
            [_autoScrollTimer invalidate];
            _autoScrollTimer = nil;
        }
    }
}

@end
