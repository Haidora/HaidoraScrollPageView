//
//  ViewController.m
//  HaidoraScrollPageView
//
//  Created by DaiLingchi on 14-10-31.
//  Copyright (c) 2014年 Haidora. All rights reserved.
//

#import "ViewController.h"
#import "HDScrollPageView.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet HDScrollPageView *testScrollview;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSMutableArray *test = [NSMutableArray array];
    for (int i = 0; i < 2; i++)
    {
        UIView *view = [UIView new];
        if (i % 2 == 0)
        {
            view.backgroundColor = [UIColor redColor];
        }
        else
        {
            view.backgroundColor = [UIColor yellowColor];
        }
        [test addObject:view];
    }

    [_testScrollview setViewsArray:test];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
