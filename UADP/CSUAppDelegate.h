//
//  CSUAppDelegate.h
//  UADP
//
//  Created by hello world on 14-11-11.
//  Copyright (c) 2014年 csu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBOperation.h"
#import "sqlite3.h"
@interface CSUAppDelegate : UIResponder <UIApplicationDelegate,UIAlertViewDelegate>
{
@public
    sqlite3 *database;
    DBOperation *dboperate;
    NSDictionary *themeDictionary;
}
@property (strong, nonatomic) UIWindow *window;
@property(strong,nonatomic)UINavigationController *inavigationController;
@property(strong,nonatomic) NSString *username;
@property(strong,nonatomic) NSString *password;
@property(strong,nonatomic) NSString *account;
@property(nonatomic) int uid;
@property(nonatomic) int deptid;
@property(nonatomic) int appid;
@property(strong,nonatomic) NSString *deptname,*deptcode;
@property(strong,nonatomic) NSDictionary *themeDictionary;
@property(nonatomic,strong) DBOperation *dboperate;
@end
