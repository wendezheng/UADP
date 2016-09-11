//
//  ContentViewController.h
//  UADP
//
//  Created by hello world on 14-11-11.
//  Copyright (c) 2014年 csu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContentViewController : UIViewController<UIWebViewDelegate,UITabBarDelegate,UIScrollViewDelegate,UIImagePickerControllerDelegate>
@property (strong, nonatomic) IBOutlet UIWebView *webViewContent;
@property(nonatomic,strong) NSString *articleID,*deptcode;
@property(strong,nonatomic) NSMutableData *articleData;

@property (strong, nonatomic) IBOutlet UITabBar *commentTabBar;

@property int numLove;
@property(nonatomic,strong) NSString *aPath;


@end
