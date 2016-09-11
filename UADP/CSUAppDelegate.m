//
//  CSUAppDelegate.m
//  UADP
//
//  Created by hello world on 14-11-11.
//  Copyright (c) 2014年 csu. All rights reserved.
//

#import "CSUAppDelegate.h"
#import "LoginViewController.h"
#import "ShowMessageViewController.h"
#import "SBJson.h"
#import "SBJsonParser.h"
@implementation CSUAppDelegate
@synthesize username = _username;
@synthesize password = _password;
@synthesize dboperate = _dboperate;
@synthesize account;
@synthesize uid;
@synthesize deptid,appid,deptcode;
@synthesize deptname = _deptname;
@synthesize themeDictionary;
@synthesize inavigationController = _inavigationController;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    CSUAppDelegate *adelegate =[[UIApplication sharedApplication] delegate];
    
    /*NSURL *url= [NSURL URLWithString:@"http://192.168.1.33:8080/UADigitalPublish/resrcs/json/theme-phone-cfg2.json"];
    NSData *data= [NSData dataWithContentsOfURL:url];
    NSString *jsonstring = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *tt = [jsonstring JSONValue];
    NSLog(@"++tt=%@%@",jsonstring,tt);
    adelegate.themeDictionary = tt;
    */
    //数据可初始化
    self.dboperate = [[DBOperation alloc]init];
    [_dboperate openSQLiteDB:&database];
    [_dboperate initDB:&database];
    
    adelegate->dboperate =[[DBOperation alloc]init];
    adelegate->database=database;
    NSLog(@"+++%@",adelegate.username);
    
    
    NSString *rsql=@"SELECT * FROM MESSAGE;";
    NSMutableArray *t=[_dboperate getMessage:rsql];
    NSLog(@"+++%@",adelegate.username);
    NSLog(@"%@try----",t);

    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    //使用Storyboard初始化根界面
    //    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    //    self.window.rootViewController = [storyBoard instantiateInitialViewController];
    
    //启动后首先进入登陆界面
    LoginViewController *loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    self.inavigationController = [[UINavigationController alloc]initWithRootViewController:loginViewController];
    
    self.window.rootViewController = self.inavigationController;//loginViewController;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    

    if (launchOptions != nil)
    {
        NSDictionary* dictionary = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        application.applicationIconBadgeNumber =[[[dictionary objectForKey:@"aps"] objectForKey:@"badge"]integerValue];
        adelegate.appid = [[[dictionary objectForKey:@"aps"] objectForKey:@"appid"]integerValue];
    }
    
    return YES;
    

}



#ifdef __IPHONE_8_0
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [application registerForRemoteNotifications];
}
#endif




////////////////////////////////////////////////////////////////////////////////////
///注册消息推送
-(void)registerForRemoteNotificationToGetToken
{

    
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (![userDefaults boolForKey:@"DeviceTokenStringKEY"])
    {
        NSLog(@"no register!");
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{ /*[[UIApplication sharedApplication]registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];*/
            #ifdef __IPHONE_8_0 //这里主要是针对iOS 8.0,相应的8.1,8.2等版本各程序员可自行发挥，如果苹果以后推出更高版本还不会使用这个注册方式就不得而知了
                if([[UIApplication sharedApplication]respondsToSelector:@selector(registerUserNotificationSettings:)]){
                    UIUserNotificationSettings*settings=[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert categories:nil];
                    [[UIApplication sharedApplication]registerUserNotificationSettings:settings];
                }else{
                    UIRemoteNotificationType myTypes=UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound;
                    [[UIApplication sharedApplication]registerForRemoteNotificationTypes:myTypes];
                }
            #else
                UIRemoteNotificationType myTypes=UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound;
            
                [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
            #endif
        });
        
    }
    
    
}


//消息注册成功得到devicetoken
-(void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *tokenStr = [deviceToken description];
    NSString *deviceTokenStr = [[[tokenStr
                                  stringByReplacingOccurrencesOfString:@"<" withString:@""]
                                 stringByReplacingOccurrencesOfString:@">" withString:@""]
                                stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"%@",deviceTokenStr);
    /////////5.4
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //保存 device token 令牌,并且去掉空格
	[userDefaults setObject:[deviceTokenStr stringByReplacingOccurrencesOfString:@" " withString:@""] forKey:@"DeviceTokenStringKEY"];
    [userDefaults synchronize];
    
}


//注册消息失败
-(void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSString *str = [NSString stringWithFormat:@"Error:%@",error];
    NSLog(@"%@",str);
    
     NSLog(@"ttttt%@",self);
}


//app运行时接受推送消息
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"---Received notification: %@", userInfo);
    //[self addMessageFromRemoteNotification:userInfo updateUI:YES];
    for (id key in userInfo) {
        NSLog(@"keya:%@,value:%@",key,[userInfo objectForKey:key]);
    }
    
    
    
    NSDictionary *aps = [[NSDictionary alloc]init];
    aps = [userInfo objectForKey:@"aps"];
    CSUAppDelegate *csuade= [[UIApplication sharedApplication]delegate];
    csuade.appid = [[aps objectForKey:@"appid"]integerValue];
    NSLog(@"appid--%d",csuade.appid);
    
    
    ////////5.4
    NSLog(@"received badge number ---%@ ----",[[userInfo objectForKey:@"aps"] objectForKey:@"badge"]);
    
    for (id key in userInfo) {
        NSLog(@"key: %@, value: %@", key, [userInfo objectForKey:key]);
    }
	
    NSLog(@"the badge number is  %lu",  (long)[[UIApplication sharedApplication] applicationIconBadgeNumber]);
    NSLog(@"the application  badge number is  %lu",  (long)application.applicationIconBadgeNumber);
    application.applicationIconBadgeNumber =[[[userInfo objectForKey:@"aps"] objectForKey:@"badge"]integerValue];
    
    
    // We can determine whether an application is launched as a result of the user tapping the action
    // button or whether the notification was delivered to the already-running application by examining
    // the application state.
	
    //当用户打开程序时候收到远程通知后执行
	if (application.applicationState == UIApplicationStateActive) {
        // Nothing to do if applicationState is Inactive, the iOS already displayed an alert view.
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示"
															message:[NSString stringWithFormat:@"\n%@",
																	 [[userInfo objectForKey:@"aps"] objectForKey:@"alert"]]
														   delegate:self
												  cancelButtonTitle:@"关闭"
												  otherButtonTitles:@"查看",nil];
        
        
		[alertView show];
        
        
        
	}

}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        ShowMessageViewController *showMessageView = [[ShowMessageViewController alloc]init];
        CSUAppDelegate *csuappdelegate = [UIApplication sharedApplication].delegate;
        
        showMessageView.appid =csuappdelegate.appid;
        NSLog(@"appid--%d",showMessageView.appid );
        [((UINavigationController *)csuappdelegate.window.rootViewController.presentedViewController).topViewController.navigationController pushViewController:showMessageView animated:YES];
        
    }
}



////////////////////////////////////////////////////////////////////////////////////
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    //每次醒来判断是否得到devicetoken
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(registerForRemoteNotificationToGetToken) userInfo:nil repeats:NO];
    
    if ([UIApplication sharedApplication].applicationIconBadgeNumber!=0) {
        //[self getMessageFromServer:appd.username password:appd.password];
    }
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
