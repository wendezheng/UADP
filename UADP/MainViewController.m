//
//  MainViewController.m
//  UADP
//
//  Created by hello world on 14-11-11.
//  Copyright (c) 2014年 csu. All rights reserved.
//

#import "MainViewController.h"
#import "CategoryViewController.h"
#import "SBJson.h"
#import "SBJsonParser.h"
#import "CSUAppDelegate.h"
#import "ShowMessageViewController.h"
@interface MainViewController ()
{
    //NSURLConnection *c;
    UIActivityIndicatorView *activityView;
}

@end

@implementation MainViewController
@synthesize listOfApp = _listOfApp;
@synthesize scrollView =_scrollView;
@synthesize allData = _allData;
@synthesize listOfAppID = _listOfAppID;
@synthesize listOfAppName = _listOfAppName;
@synthesize listOfTheme = _listOfTheme;
@synthesize listOfAppALogo = _listOfAppALogo;
-(NSMutableArray *)listOfTheme
{
    if (!_listOfTheme) {
        _listOfTheme = [[NSMutableArray alloc]init];
    }
    return _listOfTheme;
}
-(NSMutableArray *)listOfAppName
{
    if (!_listOfAppName) {
        _listOfAppName = [[NSMutableArray alloc]init];
    }
    return _listOfAppName;
}
-(NSMutableArray *)listOfAppALogo
{
    if (!_listOfAppALogo) {
        _listOfAppALogo = [[NSMutableArray alloc]init];
    }
    return _listOfAppALogo;
}

-(NSMutableArray *)listOfAppID
{
    if (!_listOfAppID) {
        _listOfAppID = [[NSMutableArray alloc]init];
    }
    return _listOfAppID;
}

- (IBAction)cancel:(id)sender {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[[self getListIP]objectForKey:@"serverip"],[[self getListIP]objectForKey:@"logoutIP"]]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    NSString *str = @"type=focus-c";
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *str1 = [[NSString alloc]initWithData:received encoding:NSUTF8StringEncoding];
    NSLog(@"%@",str1);
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(NSMutableArray *)listOfApp
{
    if (!_listOfApp) {
        _listOfApp = [[NSMutableArray alloc]init];
    }
    return _listOfApp;
}
-(NSMutableData *)allData
{
    if (!_allData) {
        _allData = [[NSMutableData alloc]init];
    }
    return _allData;
}
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
    
    // Do any additional setup after loading the view.
    
   // NSString *plpath = [[NSBundle mainBundle]pathForResource:@"theme-phone-cfg-comments" ofType:@"json"];
   // NSData *jdata = [[NSData alloc]initWithContentsOfFile:plpath];
   // NSLog(@"%@+++++++-----",[jdata JSONValue]);
    
    
    
     CSUAppDelegate *csuapp = [[UIApplication sharedApplication] delegate];
    //@"http://192.168.1.33:8080/UADigitalPublish/resrcs/json/theme-phone-cfg.json"
    NSURL *url= [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[[self getListIP]objectForKey:@"serverip"],[[self getListIP]objectForKey:@"resrcsip"]]];
    NSData *data= [NSData dataWithContentsOfURL:url];
    NSString *jsonstring = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *tt = [jsonstring JSONValue];
    NSLog(@"++tt=%@%@",jsonstring,tt);
    csuapp.themeDictionary = tt;

   
    NSLog(@"%@",[NSString stringWithFormat:@"%@拥有的APP",csuapp.username]);
    //[self getAllApp:[NSString stringWithFormat:@"%d",csuapp.deptid]];
    [self setTitle:[NSString stringWithFormat:@"%@",csuapp.username]];
    [self getAllApp:csuapp.deptcode];
    activityView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [activityView setCenter:self.view.center];
    [activityView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [activityView startAnimating];
    [self.view addSubview:activityView];
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)generateButtons:(NSInteger)count
{
    //int count =arc4random()%50+4;
    
    self.scrollView.frame = CGRectMake(0, 0, 320, 560);
    [self.scrollView setContentSize:CGSizeMake(320, self.view.frame.size.height/8*count)];
     NSLog(@"%d",count);
    
    int n = 16;
    int heit=self.scrollView.frame.size.height,widh=self.scrollView.frame.size.width;
    NSLog(@"%f",self.view.frame.size.height);
    for (int i=1; i<=count; i++) {

        //CGRect frame = CGRectMake(widh/2*((i+1)%2)+2.5, /*heit/((n+1)*2)+*/heit/(n/2)*((i-1)/2)+20, widh/2-5,heit/n*2-5/*+30*/);
        CGRect frame = CGRectMake(widh/4*((i-1)%4)+2.5,heit/(n/3)*((i-1)/4)+10,60,60);
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = frame;
        button.backgroundColor =[[UIColor alloc]initWithRed:129/255.0 green:210/255.0 blue:213/255.0 alpha:1];
        [button.layer setMasksToBounds:YES];
        [button.layer setBorderWidth:1.0];
        [button.layer setCornerRadius:6.0f];
        //[button setTitle:[_listOfAppName objectAtIndex:i-1]/*[NSString stringWithFormat:@"app--%d",i]*/ forState:UIControlStateNormal];
        [button setTag:i-1];
        
        
        //@"http://175.6.1.99:9090"
        NSURL *logourl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[[self getListIP] objectForKey:@"rootip"],[self.listOfAppALogo objectAtIndex:i-1]]];
        NSData *logodata = [NSData dataWithContentsOfURL:logourl];
        UIImage *logoimage = [UIImage imageWithData:logodata];
        [button setBackgroundImage:logoimage forState:UIControlStateNormal];
        
        
        
        [button addTarget:self action:@selector(runButtonActions:) forControlEvents:UIControlEventTouchUpInside];
        //NSLog(@"%f---%f", self.view.frame.size.height, self.view.frame.origin.y);
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(button.frame.origin.x, button.frame.origin.y+button.frame.size.height+2, button.frame.size.width, 20)];
        //label.backgroundColor= [UIColor grayColor];
        label.text = [_listOfAppName objectAtIndex:i-1];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:12];
        //label.numberOfLines=2;
        [self.scrollView addSubview:label];
        
        //[self.view addSubview:button];
        [self.scrollView addSubview:button];
        
        //消息数字
        if ([UIApplication sharedApplication].applicationIconBadgeNumber!=0&&((CSUAppDelegate*)[UIApplication sharedApplication].delegate).appid==[self.listOfAppID objectAtIndex:i-1]) {
            UILabel *msgcount = [[UILabel alloc]initWithFrame:CGRectMake(button.frame.size.width+button.frame.origin.x-10, button.frame.origin.y-5, 15, 15)];
            msgcount.text = [NSString stringWithFormat:@"%d",[UIApplication sharedApplication].applicationIconBadgeNumber];
            //msgcount.textColor = [UIColor redColor];
            msgcount.textAlignment = NSTextAlignmentCenter;
            msgcount.font = [UIFont systemFontOfSize:12];
            msgcount.layer.masksToBounds=YES;
            msgcount.layer.cornerRadius = 6.0f;
            msgcount.backgroundColor = [UIColor redColor];
            [self.scrollView addSubview:msgcount];
        }

        
    }


}

- (void)runButtonActions:(id)sender
{
    // Configure new view & push it with custom |pushViewController:| method
    CategoryViewController *CategoryVC= [[CategoryViewController alloc]init];
     [CategoryVC setTitle:[_listOfAppName objectAtIndex:[sender tag]]];
    CategoryVC.appID = [[_listOfAppID objectAtIndex:[sender tag]] integerValue];
    CategoryVC.appName = [_listOfAppName objectAtIndex:[sender tag]];
    CategoryVC.appTheme = [[_listOfTheme objectAtIndex:[sender tag]]integerValue];
    //CategoryVC.listOfCategory = [self.listOfApp objectAtIndex:[sender tag]];
    
//    for (int i=0; i<[CategoryVC.listOfCategory count]; i++) {
//        NSDictionary *category=[CategoryVC.listOfCategory objectAtIndex:i];
//        NSString *modelName = [category objectForKey:@"modelName"];
//        [CategoryVC.listOfCategoryName addObject:modelName];
//        
//        NSArray *articleid = [category objectForKey:@"articleId"];
//        NSArray *articleName = [category objectForKey:@"articleName"];
//        if ([articleid count]>0 && [articleName count]>0) {
//            [CategoryVC.listOfAllArticleID addObject:articleid];
//            [CategoryVC.listOfAllArticleName addObject:articleName];
//        }
//        
//    }
    
    
    
    [self.navigationController pushViewController:CategoryVC animated:YES];
    
}






- (void)getAllApp:(NSString *)deptcode
{
    // Establish the request
//    NSString *body = [NSString stringWithFormat:@"username=%@",rusername];
    NSLog(@"++++++++++++%@",deptcode);
  //  NSString *jsons = [NSString stringWithFormat:@"{\"id\":\"22\"}"];
    NSString *jsons = [NSString stringWithFormat:@"{\"deptcode\":\"%@\",\"state\":\"%@\"}",deptcode,@"2"];
    NSString *body = [NSString stringWithFormat:@"jsons=%@",jsons];
    
     NSString *baseurl=[NSString stringWithFormat:@"%@%@?",[[self getListIP] objectForKey:@"serverip"],[[self getListIP] objectForKey:@"allAppIP"]];
    
   // NSString *baseurl = [NSString stringWithFormat:@"%@?",[self getAllAppIP]];  //chuliapp地址
    NSLog(@"baseurl = %@", baseurl);
    
	NSURL *url = [NSURL URLWithString:baseurl];
	NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    //[urlRequest addValue:bodyLength forHTTPHeaderField:@"Content-Length"];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"urlrequest = %@", urlRequest);
    NSURLConnection *getAppConnetion= [[NSURLConnection alloc] initWithRequest: urlRequest delegate: self];
    
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.allData appendData:data];
    
    
	NSString *rsp = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	NSLog(@"connection    2  Received data = %@  ", rsp);
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	NSHTTPURLResponse *resp = (NSHTTPURLResponse *)response;
    self.statecode =(long)resp.statusCode;
	NSLog(@"Response statusCode:    %lu", (long)resp.statusCode);
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [activityView stopAnimating];
    NSLog(@"connection done!");
    NSString *rsp = [[NSString alloc] initWithBytes:[self.allData mutableBytes] length:[self.allData length] encoding: NSUTF8StringEncoding];

    if (self.statecode ==200)
    {
        CSUAppDelegate *csuapp = [[UIApplication sharedApplication]delegate];
        NSLog(@"connection------%@",connection.currentRequest.URL.absoluteString);
        if ([connection.currentRequest.URL.absoluteString isEqualToString:[NSString stringWithFormat:@"%@%@?",[[self getListIP] objectForKey:@"serverip"],[[self getListIP] objectForKey:@"allAppIP"]]])
        {
            NSLog(@"triiriranldaldf");
            NSMutableArray *jsonsappid = [[NSMutableArray alloc]init];
            NSArray * dataArray= [[NSArray alloc]init];
            
            dataArray = [rsp JSONValue];
            int count = [dataArray count];
            NSLog(@"count=%d",count);
            for (int i=0; i<count; i++) {
                NSDictionary *result = [dataArray objectAtIndex:i];
                NSString * appName = [result objectForKey:@"name"];
                NSLog(@"connection    2  Received data = %@  ", appName);
                [self.listOfAppName addObject:appName];
                int appID = [[result objectForKey:@"id"] integerValue];
                NSLog(@"connection    23333333  Received data = %d  ", appID);
                [self.listOfAppID addObject:[NSNumber numberWithInt:appID]];
                NSString * appdata = [result objectForKey:@"data"];
                [self.listOfTheme addObject:appdata];
                NSLog(@"connection    2  Received data = %@  ", appdata);
                [self.listOfApp addObject:appdata];
                
                NSString *sbumitter = [result objectForKey:@"submitter"];
                NSString *sbumittime = [result objectForKey:@"submittime"];
                NSString *aplogo = [result objectForKey:@"logo"];
                [self.listOfAppALogo addObject:aplogo];
                NSString *apowner = [result objectForKey:@"owner"];
                
                NSString *deptcode = [result objectForKey:@"deptcode"];
                
                NSString *lastediter = [result objectForKey:@"lastediter"];
                NSString *lastedittime = [result objectForKey:@"lastedittime"];
                NSString *aplabel = [result objectForKey:@"label"];
                NSString *apexplain = [result objectForKey:@"explain"];
                NSString *apstate = [result objectForKey:@"state"];
                
                NSString *sql=[NSString stringWithFormat:@"insert or replace into app(appid,appname,appdata,appsubmitter,appsubmittime,applogo,appowner,applastediter,applastedittime,applabel,appexplain,appstate,deptcode)values(%d,'%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@');",appID,appName,appdata,sbumitter,sbumittime,aplogo,apowner,lastediter,lastedittime,aplabel,apexplain,apstate,deptcode];
                NSLog(@"%@",sql);
                [csuapp.dboperate updateDB:sql];
                
                //APP---LOGO   TODO
                
                
                NSDictionary *dictionary =[[NSMutableDictionary alloc]init];
                [dictionary setValue:[NSNumber numberWithInt:appID] forKey:@"appid"];
                [jsonsappid addObject:dictionary];
                
            }
            
            
            
            [self.allData setLength:0];
            
            
            [self generateButtons:count];
            
            
            NSDictionary *root=[[NSMutableDictionary alloc]init];
            [root setValue:jsonsappid forKey:@"jsonsappid"];
            NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
            [root setValue:/*@"e0f67e4c26dcb54bf050029475058cc5d31f2321fcc8b070f8015ff3f747b432"*/[userDefaults objectForKey:@"DeviceTokenStringKEY"] forKey:@"devicetoken"];
            [root setValue:[NSNumber numberWithInt:csuapp.uid] forKey:@"userid"];
            
            SBJsonWriter *sendconfirm = [[SBJsonWriter alloc] init];
            NSString *sendvalue = [sendconfirm stringWithObject:root];
            
            NSLog(@"json---------------%@",sendvalue);
            
            [self sendDevicetoken:sendvalue];

            
        }
    }
    
    else
    {
        [self.allData setLength:0];
         NSLog(@"<<<<<<<<<<<<<<<<<<<<<<<<<");
    }
    
    
    /*
    
    if ([rsp isEqualToString:@"{\"result\":true}"]) {
        return;
    }
    if (self.statecode==404 || self.statecode==500) {
        NSLog(@"<<<<<<<<<<<<<<<<<<<<<<<<<");
        //查本地数据库显示
        if ([rsp isEqualToString:@"{\"result\":true}"]) {
            return;
        }
        
        
        
        
        //[self searchDB];
        
        return;
    }
     */
   /*
	NSLog(@"connection    2  Received data = %@  ", rsp);
    CSUAppDelegate *csuapp = [[UIApplication sharedApplication]delegate];
    
//    NSString *deleteSql = @"delete from app;";
//    [csuapp.dboperate updateDB:deleteSql];
    NSMutableArray *jsonsappid = [[NSMutableArray alloc]init];
    NSArray * dataArray= [[NSArray alloc]init];
    
    dataArray = [rsp JSONValue];
    int count = [dataArray count];
    NSLog(@"count=%d",count);
    for (int i=0; i<count; i++) {
        NSDictionary *result = [dataArray objectAtIndex:i];
        NSString * appName = [result objectForKey:@"name"];
        NSLog(@"connection    2  Received data = %@  ", appName);
        [self.listOfAppName addObject:appName];
        int appID = [[result objectForKey:@"id"] integerValue];
        NSLog(@"connection    23333333  Received data = %d  ", appID);
        [self.listOfAppID addObject:[NSNumber numberWithInt:appID]];
        NSString * appdata = [result objectForKey:@"data"];
        [self.listOfTheme addObject:appdata];
        NSLog(@"connection    2  Received data = %@  ", appdata);
        [self.listOfApp addObject:appdata];
        
        NSString *sbumitter = [result objectForKey:@"submitter"];
        NSString *sbumittime = [result objectForKey:@"submittime"];
        NSString *aplogo = [result objectForKey:@"logo"];
        NSString *apowner = [result objectForKey:@"owner"];
        
        NSString *deptcode = [result objectForKey:@"deptcode"];
        
        NSString *lastediter = [result objectForKey:@"lastediter"];
        NSString *lastedittime = [result objectForKey:@"lastedittime"];
        NSString *aplabel = [result objectForKey:@"label"];
        NSString *apexplain = [result objectForKey:@"explain"];
        NSString *apstate = [result objectForKey:@"state"];
        
        NSString *sql=[NSString stringWithFormat:@"insert or replace into app(appid,appname,appdata,appsubmitter,appsubmittime,applogo,appowner,applastediter,applastedittime,applabel,appexplain,appstate,deptcode)values(%d,'%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@');",appID,appName,appdata,sbumitter,sbumittime,aplogo,apowner,lastediter,lastedittime,aplabel,apexplain,apstate,deptcode];
        NSLog(@"%@",sql);
        [csuapp.dboperate updateDB:sql];
        
        //APP---LOGO   TODO
        
        
        NSDictionary *dictionary =[[NSMutableDictionary alloc]init];
        [dictionary setValue:[NSNumber numberWithInt:appID] forKey:@"appid"];
        [jsonsappid addObject:dictionary];
        
    }
    
    
    
    [self.allData setLength:0];

    
    [self generateButtons:count];
    
    
    NSDictionary *root=[[NSMutableDictionary alloc]init];
    [root setValue:jsonsappid forKey:@"jsonsappid"];
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    [root setValue:/@"e0f67e4c26dcb54bf050029475058cc5d31f2321fcc8b070f8015ff3f747b432"/[userDefaults objectForKey:@"DeviceTokenStringKEY"] forKey:@"devicetoken"];
    [root setValue:[NSNumber numberWithInt:csuapp.uid] forKey:@"userid"];
    
    SBJsonWriter *sendconfirm = [[SBJsonWriter alloc] init];
    NSString *sendvalue = [sendconfirm stringWithObject:root];
    
    NSLog(@"json---------------%@",sendvalue);
    
    [self sendDevicetoken:sendvalue];
    */

    
}

-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [activityView stopAnimating];
    NSLog(@"connection error!");
    //查本地数据库显示
    [self searchDB];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"无法连接到服务器"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
    
}

/*
-(NSString*)getAllAppIP
{
    NSString *AllAppIP=nil,*serverIp=nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    
    NSString *serverioPlist = [[paths objectAtIndex:0]stringByAppendingPathComponent:@"serverIP.plist"];
    if ([[NSFileManager defaultManager]fileExistsAtPath:serverioPlist]) {
        NSDictionary *dict = [[NSDictionary alloc]initWithContentsOfFile:serverioPlist];
        for (NSString *category in dict)
        {
            NSLog(@"%@",category);
            NSLog(@"--++---%@",[dict valueForKey:category]);
            if ([category isEqualToString:@"serverip"])
                serverIp=[dict valueForKey:category];
            if ([category isEqualToString:@"allAppIP"])
                AllAppIP=[dict valueForKey:category];
            
        }
    }
    else
    {
        NSString *plpath = [[NSBundle mainBundle]pathForResource:@"serverIP" ofType:@"plist"];
        NSDictionary *dict = [[NSDictionary alloc]initWithContentsOfFile:plpath];
        for (NSString *category in dict)
        {
            NSLog(@"%@",category);
            if ([category isEqualToString:@"serverip"])
                serverIp=[dict valueForKey:category];
            if ([category isEqualToString:@"allAppIP"])
            {AllAppIP=[dict valueForKey:category];
                NSLog(@"--+-+--%@",[dict valueForKey:category]);
            }
        }
        
    }
    //return AllAppIP;
    return [NSString stringWithFormat:@"%@%@",serverIp,AllAppIP];
}
*/
-(void)searchDB
{
    CSUAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    //DBOperation *dboperate = [[DBOperation alloc]init];
    NSLog(@"---%@",appDelegate.username);
    // order by scheduledate desc,scheduletime desc
   // NSString *sql = [NSString stringWithFormat:@"select * from app where appowner=%d and appstate=0;",appDelegate.deptid];
    //根据当前用户查询所拥有的app还没加条件
    NSString *sql = [NSString stringWithFormat:@"select * from app where appowner =%@ and state='2';",appDelegate.deptcode];
    NSLog(@"55555555+++++++++++++++++++++%@",sql );
    

    NSLog(@"%ld",(long)[appDelegate.dboperate getCount:sql]);
    
    NSMutableArray *jsonsappid=[[NSMutableArray alloc]init];
    
    NSMutableArray *temp=[[NSMutableArray alloc]init];
    temp =[appDelegate.dboperate getAllapp:sql];
    
    for (int i=0; i<[temp count]; i++) {
        [self.listOfAppALogo addObject:[[temp objectAtIndex:i]objectForKey:@"aplogo"]];
        [self.listOfAppID addObject:[[temp objectAtIndex:i]objectForKey:@"appid"]];
        [self.listOfAppName addObject:[[temp objectAtIndex:i] objectForKey:@"appname"]];
        [self.listOfTheme addObject:[[temp objectAtIndex:i] objectForKey:@"appdata"]];
        //[self.isreadMuti addObject:[[temp objectAtIndex:i] objectForKey:@"isread"]];
        // [self.dateAndtime addObject:[NSString stringWithFormat:@"%@ %@",[[temp objectAtIndex:i] objectForKey:@"scheduledate"],[[temp objectAtIndex:i] objectForKey:@"scheduletime"]]];
        NSDictionary *dictionary =[[NSMutableDictionary alloc]init];
        [dictionary setValue:[[temp objectAtIndex:i]objectForKey:@"appid"] forKey:@"appid"];
        [jsonsappid addObject:dictionary];
    }
    
    
    [self generateButtons:[self.listOfAppName count]];
    
    NSDictionary *root=[[NSMutableDictionary alloc]init];
    [root setValue:jsonsappid forKey:@"jsonsappid"];
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    [root setValue:/*@"e0f67e4c26dcb54bf050029475058cc5d31f2321fcc8b070f8015ff3f747b432"*/[userDefaults objectForKey:@"DeviceTokenStringKEY"] forKey:@"devicetoken"];
    [root setValue:[NSNumber numberWithInt:appDelegate.uid] forKey:@"userid"];
    
    SBJsonWriter *sendconfirm = [[SBJsonWriter alloc] init];
    NSString *sendvalue = [sendconfirm stringWithObject:root];
    
    NSLog(@"json---------------%@",sendvalue);
    
    [self sendDevicetoken:sendvalue];
    
    
    
}

-(void)sendDevicetoken:(NSString *)json
{
    NSString *body = [NSString stringWithFormat:@"jsons=%@",json];
    
     NSString *baseurl=[NSString stringWithFormat:@"%@%@?",[[self getListIP] objectForKey:@"serverip"],[[self getListIP] objectForKey:@"saveTokenIP"]];
    //NSString *baseurl = [NSString stringWithFormat:@"%@?",[self getSaveTokenIP]];  //chuliapp地址
    NSLog(@"baseurl = %@", baseurl);
    
	NSURL *url = [NSURL URLWithString:baseurl];
	NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    //[urlRequest addValue:bodyLength forHTTPHeaderField:@"Content-Length"];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"urlrequest = %@", urlRequest);
    NSURLConnection *sendDevicetokenConnetion= [[NSURLConnection alloc] initWithRequest: urlRequest delegate: self];
}

/*
-(NSString*)getSaveTokenIP
{
    NSString *SaveTokenIP=nil,*serverIp=nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    
    NSString *serverioPlist = [[paths objectAtIndex:0]stringByAppendingPathComponent:@"serverIP.plist"];
    if ([[NSFileManager defaultManager]fileExistsAtPath:serverioPlist]) {
        NSDictionary *dict = [[NSDictionary alloc]initWithContentsOfFile:serverioPlist];
        for (NSString *category in dict)
        {
            NSLog(@"%@",category);
            NSLog(@"--++---%@",[dict valueForKey:category]);
            if ([category isEqualToString:@"serverip"])
                serverIp=[dict valueForKey:category];
            if ([category isEqualToString:@"saveTokenIP"])
                SaveTokenIP=[dict valueForKey:category];
            
        }
    }
    else
    {
        NSString *plpath = [[NSBundle mainBundle]pathForResource:@"serverIP" ofType:@"plist"];
        NSDictionary *dict = [[NSDictionary alloc]initWithContentsOfFile:plpath];
        for (NSString *category in dict)
        {
            NSLog(@"%@",category);
            if ([category isEqualToString:@"serverip"])
                serverIp=[dict valueForKey:category];
            if ([category isEqualToString:@"saveTokenIP"])
            {SaveTokenIP=[dict valueForKey:category];
                NSLog(@"--+-+--%@",[dict valueForKey:category]);
            }
        }
        
    }
    //return SaveTokenIP;
    
    return [NSString stringWithFormat:@"%@%@",serverIp,SaveTokenIP];
    
}
*/
-(NSDictionary*)getListIP
{
    NSDictionary *dict;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *serverioPlist = [[paths objectAtIndex:0]stringByAppendingPathComponent:@"serverIP.plist"];
    if ([[NSFileManager defaultManager]fileExistsAtPath:serverioPlist])
    {
        dict = [[NSDictionary alloc]initWithContentsOfFile:serverioPlist];
        
    }
    else
    {
        NSString *plpath = [[NSBundle mainBundle]pathForResource:@"serverIP" ofType:@"plist"];
        dict = [[NSDictionary alloc]initWithContentsOfFile:plpath];
        
        
    }
    return dict;
}


@end
