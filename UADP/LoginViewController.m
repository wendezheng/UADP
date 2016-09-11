//
//  LoginViewController.m
//  UADP
//
//  Created by hello world on 14-11-11.
//  Copyright (c) 2014年 csu. All rights reserved.
//

#import "LoginViewController.h"
#import "CSUAppDelegate.h"
#import "SBJson.h"
#import "SBJsonParser.h"
#import "RegisterViewController.h"
@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize account = _account;
@synthesize password = _password;
@synthesize activityView;
@synthesize recieveData = _recieveData;
@synthesize statecode;
-(NSMutableData *)recieveData
{
    if (!_recieveData) {
        _recieveData = [[NSMutableData alloc]init];
    }
    return _recieveData;
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
    // Do any additional setup after loading the view from its nib.
    //self.title = @"UADP";
    NSUserDefaults *usersdefault = [NSUserDefaults standardUserDefaults];
    [[self account]setText:[usersdefault objectForKey:@"account"]];
    [[self password]setText:[usersdefault objectForKey:@"password"]];
    NSLog(@"%@",[usersdefault objectForKey:@"account"]);
    //隐藏键盘
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewTapped:(UITapGestureRecognizer*)tapGr
{
    [self.account resignFirstResponder];
    [self.password resignFirstResponder];
    
}

- (IBAction)Register:(id)sender
{
    NSLog(@"re%@",self.navigationController);
    RegisterViewController *rvc = [[RegisterViewController alloc]init];
    [self.navigationController pushViewController:rvc animated:YES];
    //[self presentModalViewController:rvc animated:YES];
}
- (IBAction)Login:(id)sender
{
    
    CSUAppDelegate *csudelegate =[[UIApplication sharedApplication] delegate];
    NSString *accountStr = [[self account]text];
    NSString *passwordStr = [[self password]text];
    
    
    if(accountStr.length==0||passwordStr.length==0){
        UIAlertView *alert= [[UIAlertView alloc] initWithTitle:@"无效输入" message:@"用户名或密码为空" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    
    
    
    csudelegate.account = accountStr;
    csudelegate.password = passwordStr;
    
    self.activityView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [self.activityView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [activityView setCenter:self.view.center];
    [self.activityView startAnimating];
    [self.view addSubview:self.activityView];
    
    NSString * deviceTokenString =@"e0f67e4c26dcb54bf050029475058cc5d31f2321fcc8b070f8015ff3f747b432";
   // deviceTokenString = [[NSUserDefaults standardUserDefaults] objectForKey:@"DeviceTokenStringKEY"];
    [self validate:accountStr password:passwordStr deviceToken:deviceTokenString];
    
    
    

    
//    UIStoryboard *mainBoard = [UIStoryboard storyboardWithName:@"MainBoard" bundle:nil];
//    [self presentModalViewController:[mainBoard instantiateInitialViewController] animated:YES];
    
    
    
}




- (void)validate:(NSString *)raccount password:(NSString *)rpassword deviceToken:(NSString *)deviceTokenString
{
    //md5加密密码
    const char *original_str = [rpassword UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
    NSString * md5password = [NSString stringWithString:[hash lowercaseString]];
    NSLog(@"---md5---%@", [hash lowercaseString]);
    
    // Establish the request
    NSDictionary *loginjson = [[NSMutableDictionary alloc]init];
    [loginjson setValue:raccount forKey:@"account"];
    [loginjson setValue:rpassword forKey:@"password"];
    SBJsonWriter *jsonwriter = [[SBJsonWriter alloc] init];
    NSString *sendloginjson = [jsonwriter stringWithObject:loginjson];
    NSString *body = [NSString stringWithFormat:@"jsons=%@",sendloginjson];
    
   NSString *baseurl=[NSString stringWithFormat:@"%@%@?",[[self getListIP] objectForKey:@"serverip"],[[self getListIP] objectForKey:@"loginIP"]];
    
   // NSString *baseurl = [NSString stringWithFormat:@"%@?",[self getServerIP]];
    
    NSLog(@"send provider device token = %@", baseurl);
    NSURL *url = [NSURL URLWithString:baseurl];
	NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    //[urlRequest addValue:bodyLength forHTTPHeaderField:@"Content-Length"];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
    [urlRequest setValue:@"123456" forHTTPHeaderField:@"username"];
    //[urlRequest setValue:@"234567" forKey:@"account"];
    NSLog(@"urlrequest = %@", urlRequest);
    NSURLConnection *loginConnetion= [[NSURLConnection alloc] initWithRequest: urlRequest delegate: self];
    
}




- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	NSHTTPURLResponse *resp = (NSHTTPURLResponse *)response;
	NSLog(@"Response statusCode:    %lu", (long)resp.statusCode);
    self.statecode = (long)resp.statusCode;
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
    NSDictionary* headers = [httpResponse allHeaderFields];
    NSLog(@"headers: %@", headers);

}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.recieveData appendData:data];
	   
}



-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //[conn release];
    NSLog(@"connection done!");
    /*if (self.statecode == 404 || self.statecode == 500) {
        [self.activityView stopAnimating];
        [activityView setHidesWhenStopped:YES];
        NSLog(@"connection error!");
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                            message:@"服务器出现问题！"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];

        return;
    }*/
    NSString *rsp = [[NSString alloc] initWithBytes:[self.recieveData mutableBytes] length:[self.recieveData length] encoding: NSUTF8StringEncoding];
	NSLog(@"connection    2  Received data = %@  ", rsp);
    if (self.statecode == 200 )
    {
        NSDictionary * root = [[NSDictionary alloc]init];
        root = [rsp JSONValue];
        Boolean result=[[root objectForKey:@"result"]boolValue];;
        NSLog(@"dengluchenggopng%@",root);
        ///////+++@"{\"result\":true}"
        if(result) {
            
            int usort = [[root objectForKey:@"USort"]integerValue];
            int uid = [[root objectForKey:@"UId"] integerValue];
            NSString * account = [root objectForKey:@"UAccount"];
            NSString * password = [root objectForKey:@"UPassword"];
            
            NSDictionary *dept = [[NSDictionary alloc]init];
            dept = [root objectForKey:@"dept"];
            int deptid = [[dept objectForKey:@"deptId"]integerValue];
            NSString *deptname = [dept objectForKey:@"deptName"];
            NSString *deptcode = [dept objectForKey:@"deptCode"];
            NSDictionary * usermsg = [[NSDictionary alloc] init];
            usermsg = [root objectForKey:@"userMsg"];
            NSString * username = [usermsg objectForKey:@"UName"];
            NSString * ugender = [usermsg objectForKey:@"UGender"];
            NSString * utel = [usermsg objectForKey:@"UTel"];
            NSString * umail = [usermsg objectForKey:@"UMail"];
            
            CSUAppDelegate *csuappdelegate = [[UIApplication sharedApplication]delegate];
            csuappdelegate.uid = uid;
            csuappdelegate.deptid = deptid;
            csuappdelegate.deptname = deptname;
            csuappdelegate.username = username;
            csuappdelegate.deptcode = deptcode;
            NSString * sql = [NSString stringWithFormat:@"insert or replace into user(userid ,account,password,username,deptid,sort,gender,tel,mail)values(%d,'%@','%@','%@',%d,%d,'%@','%@','%@');",uid,account,password,username,deptid,usort,ugender,utel,umail];
            NSLog(@"%@",sql);
            NSString * sql2 = @"select * from user";
            [csuappdelegate.dboperate updateDB:sql];
            [csuappdelegate.dboperate getUserMsg:sql2];
            [self.activityView stopAnimating];
            [activityView setHidesWhenStopped:YES];
          //  CSUAppDelegate *csudeglate = [[UIApplication sharedApplication]delegate];
            NSUserDefaults *usersdefault = [NSUserDefaults standardUserDefaults];
            [usersdefault setValue:csuappdelegate.account forKey:@"account"];
            [usersdefault setValue:csuappdelegate.password forKey:@"password"];
            [usersdefault synchronize];
            NSLog(@"--%@",[usersdefault objectForKey:@"account"]);
            UIStoryboard *mainBoard = [UIStoryboard storyboardWithName:@"MainBoard" bundle:nil];
            [self presentModalViewController:[mainBoard instantiateInitialViewController] animated:YES];
        }
        else
        {
            // NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            //[userDefaults setObject:NO forKey:self.username.text];
            
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"用户名或密码错误！" message:@"忘记密码？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            
            
        }
        

    }
    else
    {
        UIAlertView *alertview = [[UIAlertView alloc]initWithTitle:@"" message:@"服务器出错" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertview show];
    }
    [self.view endEditing:YES];
    [self.activityView stopAnimating];
    [activityView setHidesWhenStopped:YES];
    
  /*  NSDictionary * root = [[NSDictionary alloc]init];
    root = [rsp JSONValue];
    Boolean result=[[root objectForKey:@"result"]boolValue];;
     NSLog(@"dengluchenggopng%@",root);
    ///////+++@"{\"result\":true}"
    if(result) {
        
        int usort = [[root objectForKey:@"USort"]integerValue];
        int uid = [[root objectForKey:@"UId"] integerValue];
        NSString * account = [root objectForKey:@"UAccount"];
        NSString * password = [root objectForKey:@"UPassword"];
        
        NSDictionary *dept = [[NSDictionary alloc]init];
        dept = [root objectForKey:@"dept"];
        int deptid = [[dept objectForKey:@"deptId"]integerValue];
        NSString *deptname = [dept objectForKey:@"deptName"];
        NSString *deptcode = [dept objectForKey:@"deptCode"];
        NSDictionary * usermsg = [[NSDictionary alloc] init];
        usermsg = [root objectForKey:@"userMsg"];
        NSString * username = [usermsg objectForKey:@"UName"];
        NSString * ugender = [usermsg objectForKey:@"UGender"];
        NSString * utel = [usermsg objectForKey:@"UTel"];
        NSString * umail = [usermsg objectForKey:@"UMail"];
        
        CSUAppDelegate *csuappdelegate = [[UIApplication sharedApplication]delegate];
        csuappdelegate.uid = uid;
        csuappdelegate.deptid = deptid;
        csuappdelegate.deptname = deptname;
        csuappdelegate.username = username;
        csuappdelegate.deptcode = deptcode;
        NSString * sql = [NSString stringWithFormat:@"insert or replace into user(userid ,account,password,username,deptid,sort,gender,tel,mail)values(%d,'%@','%@','%@',%d,%d,'%@','%@','%@');",uid,account,password,username,deptid,usort,ugender,utel,umail];
        NSLog(@"%@",sql);
        NSString * sql2 = @"select * from user";
        [csuappdelegate.dboperate updateDB:sql];
        [csuappdelegate.dboperate getUserMsg:sql2];
                [self.activityView stopAnimating];
        [activityView setHidesWhenStopped:YES];
        CSUAppDelegate *csudeglate = [[UIApplication sharedApplication]delegate];
        NSUserDefaults *usersdefault = [NSUserDefaults standardUserDefaults];
        [usersdefault setValue:csudeglate.account forKey:@"account"];
        [usersdefault setValue:csudeglate.password forKey:@"password"];
        [usersdefault synchronize];
        NSLog(@"--%@",[usersdefault objectForKey:@"account"]);
        UIStoryboard *mainBoard = [UIStoryboard storyboardWithName:@"MainBoard" bundle:nil];
        [self presentModalViewController:[mainBoard instantiateInitialViewController] animated:YES];
    }
    else
    {
        // NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        //[userDefaults setObject:NO forKey:self.username.text];
        
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"用户名或密码错误！" message:@"忘记密码？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        
        [self.view endEditing:YES];
        [self.activityView stopAnimating];
        [activityView setHidesWhenStopped:YES];
    }
  */
    
    
    //if the string from provider is "true", means the devicetoken is stored in the provider server
    //so the app won't send the devicetoken next time.
	/*if (isNotificationSetBadge == NO) {
     
     NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
     if([rsp isEqualToString:@"true"])
     {
     NSLog(@"connection    2.2  Received data = %@  ", rsp);
     [userDefaults setBool:YES forKey:self.username.text];//@"DeviceTokenRegisteredKEY"];
     }
     
     }else{//isNotificationSetBadge == YES;
     NSLog(@"connection    2  reset");
     isNotificationSetBadge = NO;
     }
     */

   // NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
   // [userDefaults removeObjectForKey:self.username.text];
    
    
       [self.recieveData setLength:0];
    
}

-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    
    [self.activityView stopAnimating];
    [activityView setHidesWhenStopped:YES];
    NSLog(@"connection error2!");
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"无法连接到服务器"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
    
    //NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //[userDefaults removeObjectForKey:self.username.text];
    
}


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





//-(void)viewWillAppear:(BOOL)animated
//{
//    NSUserDefaults *usersdefault = [NSUserDefaults standardUserDefaults];
//    
//    [[self username]setText:[usersdefault objectForKey:@"username"]];
//    [[self password]setText:[usersdefault objectForKey:@"password"]];
//    NSLog(@"%@",[usersdefault objectForKey:@"username"]);
//
//
//}
//
//-(void)viewDidDisappear:(BOOL)animated
//{
//    NSUserDefaults *usersdefault = [NSUserDefaults standardUserDefaults];
//    
//    [[self username]setText:[usersdefault objectForKey:@"username"]];
//    [[self password]setText:[usersdefault objectForKey:@"password"]];
//    NSLog(@"%@",[usersdefault objectForKey:@"username"]);
//}










@end
