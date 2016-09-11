//
//  LoginViewController.h
//  UADP
//
//  Created by hello world on 14-11-11.
//  Copyright (c) 2014年 csu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CommonCrypto/CommonDigest.h>
@interface LoginViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *account;
@property (strong, nonatomic) IBOutlet UITextField *password;

@property(strong,nonatomic) UIActivityIndicatorView *activityView;

@property(strong,nonatomic) NSMutableData *recieveData;
@property(nonatomic) long statecode;

- (IBAction)Register:(id)sender;

- (IBAction)Login:(id)sender;

@end
