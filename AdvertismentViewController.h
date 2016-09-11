//
//  AdvertismentViewController.h
//  UADP
//
//  Created by hello world on 14-12-3.
//  Copyright (c) 2014年 csu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdvertismentViewController : UIViewController<UIWebViewDelegate>
@property(nonatomic,strong)NSString *advURL;

@property (strong, nonatomic) IBOutlet UIWebView *advWebView;

@end
