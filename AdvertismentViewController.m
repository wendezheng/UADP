//
//  AdvertismentViewController.m
//  UADP
//
//  Created by hello world on 14-12-3.
//  Copyright (c) 2014年 csu. All rights reserved.
//

#import "AdvertismentViewController.h"

@interface AdvertismentViewController ()

@end

@implementation AdvertismentViewController
@synthesize advURL = _advURL;
@synthesize advWebView = _advWebView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    NSURL *url= [NSURL URLWithString:_advURL];
    NSLog(@"%@",url);
    NSURLRequest *req=[NSURLRequest requestWithURL:url];
    [_advWebView loadRequest:req];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
