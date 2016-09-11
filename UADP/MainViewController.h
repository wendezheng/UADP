//
//  MainViewController.h
//  UADP
//
//  Created by hello world on 14-11-11.
//  Copyright (c) 2014年 csu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property(strong,nonatomic) NSMutableData *allData;
@property(nonatomic,strong) NSMutableArray *listOfApp;
@property(nonatomic,strong) NSMutableArray *listOfAppID;
@property(nonatomic,strong) NSMutableArray *listOfAppName;
@property(nonatomic,strong) NSMutableArray *listOfTheme;
@property(nonatomic,strong) NSMutableArray *listOfAppALogo;
@property(nonatomic) long statecode;
- (IBAction)cancel:(id)sender;
@end
