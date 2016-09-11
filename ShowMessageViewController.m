//
//  ShowMessageViewController.m
//  UADP
//
//  Created by hello world on 14-12-17.
//  Copyright (c) 2014年 csu. All rights reserved.
//

#import "ShowMessageViewController.h"
#import "CSUAppDelegate.h"
#import "SBJson.h"
#import "SBJsonParser.h"
//#import "TableCellTableViewCell.h"
@interface ShowMessageViewController ()

@end

@implementation ShowMessageViewController
@synthesize showMessageTableView = _showMessageTableView;
@synthesize listOfMessgae = _listOfMessgae;
@synthesize listOfMessageId = _listOfMessageId;
@synthesize messageData = _messageData;
@synthesize isreadMuti = _isreadMuti;
@synthesize listOfSendtime = _listOfSendtime;
@synthesize appid;
@synthesize statedcode;
-(NSMutableArray*)listOfSendtime
{
    if (!_listOfSendtime) {
        _listOfSendtime = [[NSMutableArray alloc]init];
    }
    return _listOfSendtime;
}
-(NSMutableArray *)isreadMuti
{
    if (_isreadMuti) {
        _isreadMuti= [[NSMutableArray alloc]init];
    }
    return _isreadMuti;
}
-(NSMutableArray *)listOfMessageId
{
    if (!_listOfMessageId) {
        _listOfMessageId= [[NSMutableArray alloc]init];
    }
    return  _listOfMessageId;
}
-(NSMutableArray *)listOfMessgae
{
    if (!_listOfMessgae) {
        _listOfMessgae= [[NSMutableArray alloc]init];
    }
    return _listOfMessgae;
}

-(NSMutableData *)messageData
{
    if (!_messageData) {
        _messageData = [[NSMutableData alloc]init];
    }
    return _messageData;
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
    
    CSUAppDelegate *csuappd = [[UIApplication sharedApplication]delegate];

    
    
    
   // [self getMessageFromServer:csuappd.uid appid:self.appid];
    NSLog(@"%d--%d--%d",csuappd.uid,csuappd.appid,self.appid);
    
    
    
    // Do any additional setup after loading the view from its nib.
  // CSUAppDelegate *adelegate = [[UIApplication sharedApplication]delegate];
   // NSString *sql = @"insert or replace into message(userid,appid,content,isread,sendtime,sender,msgstate)values(22,7,'yyyyyyyyyyyyyyyyyyÿyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyÿyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy',0,'2014-12-22 09:00:33','liyuanyuan','e');";
    //[adelegate.dboperate updateDB:sql];
    //[UIApplication sharedApplication].applicationIconBadgeNumber=1;
    if ([UIApplication sharedApplication].applicationIconBadgeNumber!=0) {
        //[self getMessageFromServer:48 appid:7];
        [self getMessageFromServer:csuappd.uid appid:self.appid];

        
    }
    else
    {
        //调用查本地数据库方法显示消息
        [self searchDB];
    }
    //[self getMessageFromServer:csuappd.uid appid:self.appid];
    
}

-(void)searchDB
{
    CSUAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    //DBOperation *dboperate = [[DBOperation alloc]init];
    NSLog(@"---%@",appDelegate.username);
    // order by scheduledate desc,scheduletime desc
    NSString *sql = [NSString stringWithFormat:@"select * from message where userid=%d and appid=%d order by sendtime desc;",appDelegate.uid,self.appid];
    NSLog(@"%d,%@",[appDelegate.dboperate getCount:sql],sql);
    [self.listOfMessgae removeAllObjects];
    [self.listOfMessageId removeAllObjects];
    [self.listOfSendtime removeAllObjects];
    NSMutableArray *temp=[[NSMutableArray alloc]init];
    temp =[appDelegate.dboperate getMessage:sql];
    
    for (int i=0; i<[temp count]; i++) {
        [self.listOfMessageId addObject:[[temp objectAtIndex:i]objectForKey:@"msgid"]];
        [self.listOfMessgae addObject:[[temp objectAtIndex:i] objectForKey:@"content"]];
        [self.isreadMuti addObject:[[temp objectAtIndex:i] objectForKey:@"isread"]];
        [self.listOfSendtime addObject:[[temp objectAtIndex:i] objectForKey:@"sendtime"]];
       // [self.dateAndtime addObject:[NSString stringWithFormat:@"%@ %@",[[temp objectAtIndex:i] objectForKey:@"scheduledate"],[[temp objectAtIndex:i] objectForKey:@"scheduletime"]]];
    }

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *cellValue = [_listOfMessgae objectAtIndex:indexPath.row];
    //[_listOfMessgae objectAtIndex:indexPath.row];
    float heigt = cellValue.length*13/320*20;
    NSLog(@"string75%F",heigt);
    return heigt>65?heigt:65;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"string75");
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
        
//        
//        NSArray * array = [[NSBundle mainBundle]loadNibNamed:@"TableCellTableViewCell" owner:nil options:nil];
//        cell = [array objectAtIndex:0];
    }
    //todo时间加颜色
    NSString *cellValue = [NSString stringWithFormat:@"%@------>%@",[_listOfSendtime objectAtIndex:indexPath.row],[_listOfMessgae objectAtIndex:indexPath.row]];
    
    [cell.textLabel setFont:[UIFont systemFontOfSize:13]];
    cell.textLabel.numberOfLines=cellValue.length*13/200;
    cell.textLabel.text = cellValue;
    
    
//    cell.detailTextLabel.text = [_listOfSendtime objectAtIndex:indexPath.row];
//    NSLog(@"%@",cell.detailTextLabel.text);
    
//    float heigt = cellValue.length*13/320*20;
//    //CGRect contentFrame = CGRectMake(0, CGFloat y, <#CGFloat width#>, <#CGFloat height#>)
//    CGSize contentSize = CGSizeMake(320, heigt);
//    //cell.contentLabel.frame
//    [cell.contentLabel setFont:[UIFont systemFontOfSize:13]];
//    cell.contentLabel.numberOfLines=cellValue.length*13/200;
//    cell.contentLabel.text = cellValue;
//    
//    cell.timeLabel.text = [_listOfSendtime objectAtIndex:indexPath.row];
//    NSLog(@"%@",cell.timeLabel.text);
    //int index = arc4random()%4+1;
    //UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"category-%d",index]];
    //cell.imageView.image = image;
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [_listOfMessgae count];
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        CSUAppDelegate *adelegete = [[UIApplication sharedApplication]delegate];
        NSString *sql = [NSString stringWithFormat:@"delete from message where msgid=%d;",[[self.listOfMessageId objectAtIndex:indexPath.row]intValue]];
        [adelegete.dboperate updateDB:sql];
        [self.listOfMessgae removeObjectAtIndex:indexPath.row];
        [self.listOfMessageId removeObjectAtIndex:indexPath.row];
        [self.showMessageTableView reloadData];
        
        
        
    }
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cellbg"]];
    cell.backgroundColor = [UIColor clearColor];
}

////////////////////////////////////////////////////////////////////////////
//
- (void)getMessageFromServer:(int)userid appid:(int)rappid
{
    NSDictionary *dictionary =[[NSMutableDictionary alloc]init];
    [dictionary setValue:[NSNumber numberWithInt:userid]forKey:@"userid"];
    [dictionary setValue:[NSNumber numberWithInt:rappid] forKey:@"appid"];
    SBJsonWriter *sendvalue = [[SBJsonWriter alloc] init];
    NSString *jsons = [sendvalue stringWithObject:dictionary];

    NSLog(@"%@",jsons);
    //NSString *jsons = [NSString stringWithFormat:@"{\"appid\":\"7\"}"];
    NSString *body = [NSString stringWithFormat:@"jsons=%@",jsons];
    
     NSString *baseurl=[NSString stringWithFormat:@"%@%@?",[[self getListIP] objectForKey:@"serverip"],[[self getListIP] objectForKey:@"MessageIP"]];
   // NSString *baseurl = [NSString stringWithFormat:@"%@?",[self getMessageIP]];  //chuliapp地址
    NSLog(@"baseurl = %@", baseurl);
    
	NSURL *url = [NSURL URLWithString:baseurl];
	NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    //[urlRequest addValue:bodyLength forHTTPHeaderField:@"Content-Length"];
    [urlRequest setHTTPMethod:@"POST"];
    
    [urlRequest setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"urlrequest = %@", urlRequest);
    NSURLConnection *getmsgConnetion= [[NSURLConnection alloc] initWithRequest: urlRequest delegate: self];
    
}


- (void)resetBadgeNumberOnProviderWithDeviceToken: (NSString *)deviceTokenString usernameR:(NSString*)rusername confirm:(NSString *)confirm
{
    
    //NSString *jsons = [NSString stringWithFormat:@"username=%@&token=%@&confirm=%@",rusername,deviceTokenString,confirm];
    // NSString *jsons = [NSString stringWithFormat:@"{\"id\":\"7\"}"];
    NSString *body = [NSString stringWithFormat:@"jsons=%@",confirm];
    NSString *baseurl=[NSString stringWithFormat:@"%@%@?",[[self getListIP] objectForKey:@"serverip"],[[self getListIP] objectForKey:@"ResetIP"]];
    //NSString *baseurl = [NSString stringWithFormat:@"%@?",[self getResetIP]];  //chuliapp地址
    NSLog(@"baseurl = %@", baseurl);
    
	NSURL *url = [NSURL URLWithString:baseurl];
	NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    //[urlRequest addValue:bodyLength forHTTPHeaderField:@"Content-Length"];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"urlrequest = %@", urlRequest);
    NSURLConnection *resetConnetion= [[NSURLConnection alloc] initWithRequest: urlRequest delegate: self];
    
    
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.messageData appendData:data];
    
    
	NSString *rsp = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	NSLog(@"connection    2  Received data = %@  ", rsp);
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	NSHTTPURLResponse *resp = (NSHTTPURLResponse *)response;
    self.statedcode = (long)resp.statusCode;
	NSLog(@"Response statusCode:    %lu", (long)resp.statusCode);
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"connection done!");
    NSString *rsp = [[NSString alloc] initWithBytes:[self.messageData mutableBytes] length:[self.messageData length] encoding: NSUTF8StringEncoding];
/*
    if (self.statedcode==404 || self.statedcode == 500 || [rsp isEqualToString:@"{\"result\":true}"]||[rsp isEqualToString:@"{\"result\":false}"]) {
        if ([rsp isEqualToString:@"{\"result\":true}"]) {
            [UIApplication sharedApplication].applicationIconBadgeNumber=0;
        }
        NSLog(@"<<<<<<<<<<<<<<<<<<<<<<<<<");
        return;
    }
    */
    if (self.statedcode == 200) {
        if ([connection.currentRequest.URL.absoluteString isEqualToString:[NSString stringWithFormat:@"%@%@?",[[self getListIP] objectForKey:@"serverip"],[[self getListIP] objectForKey:@"MessageIP"]]]) {
            CSUAppDelegate *adelegate = [[UIApplication sharedApplication]delegate];
            NSMutableArray *confirmvalue = [[NSMutableArray alloc]init];
            NSLog(@"connection    2  Received data = %@  ", rsp);
            NSArray * dataArray= [[NSArray alloc]init];
            dataArray = [rsp JSONValue];
            int count = [dataArray count];
            NSLog(@"count=%d",count);
            for (int i=0; i<count; i++) {
                NSDictionary *result = [dataArray objectAtIndex:i];
                int msgid = [[result objectForKey:@"id"]integerValue];
                int appid= [[result objectForKey:@"appid"]integerValue];
                NSString *content = [result objectForKey:@"content"];
                NSString *submittime = [result objectForKey:@"submittime"];
                NSString * summiter = [result objectForKey:@"submitter"];
                NSString * msgstate = [result objectForKey:@"state"];
                int userid = [[result objectForKey:@"userid"]integerValue];
                
                NSDictionary *dictionary =[[NSMutableDictionary alloc]init];
                [dictionary setValue:[NSNumber numberWithInt: msgid] forKey:@"msgid"];
                [confirmvalue addObject:dictionary];
                
                NSString *sql = [NSString stringWithFormat:@"insert or replace into message(msgid,userid,appid,content,isread,sendtime,sender,msgstate)values(%d,%d,%d,'%@',%d,'%@','%@','%@');",msgid,userid,appid,content,1,submittime,summiter,msgstate];
                [adelegate.dboperate updateDB:sql];
                
                
            }
            
            NSDictionary *root=[[NSMutableDictionary alloc]init];
            [root setValue:confirmvalue forKey:@"confirm"];
            NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
            [root setValue:/*@"e0f67e4c26dcb54bf050029475058cc5d31f2321fcc8b070f8015ff3f747b432"*/[userDefaults objectForKey:@"DeviceTokenStringKEY"] forKey:@"devicetoken"];
            [root setValue:[NSNumber numberWithInt:adelegate.uid] forKey:@"userid"];
            
            SBJsonWriter *sendconfirm = [[SBJsonWriter alloc] init];
            NSString *sendvalue = [sendconfirm stringWithObject:root];
            
            NSLog(@"json---------------%@",sendvalue);
            
            [UIApplication sharedApplication].applicationIconBadgeNumber=0;
            [self resetBadgeNumberOnProviderWithDeviceToken:@" " usernameR:@"" confirm:sendvalue];
            //[UIApplication sharedApplication].applicationIconBadgeNumber=0;
            
            
            //调用查本地数据库方法显示消息
            [self searchDB];
            [self.showMessageTableView reloadData];
        }
        else
        {
            if ([rsp isEqualToString:@"{\"result\":true}"]) {
            [UIApplication sharedApplication].applicationIconBadgeNumber=0;
        }
            
        }
        
    }
    
    [self.messageData setLength:0];
    
}

-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"connection error!");
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"无法连接到服务器"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
    [self searchDB];
    
}


-(NSString*)getMessageIP
{
    NSString *MessageIP=nil,*serverIp=nil;
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
            if ([category isEqualToString:@"MessageIP"])
                MessageIP=[dict valueForKey:category];
            
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
            if ([category isEqualToString:@"MessageIP"])
            {MessageIP=[dict valueForKey:category];
                NSLog(@"--+-+--%@",[dict valueForKey:category]);
            }
        }
        
    }
    
     return [NSString stringWithFormat:@"%@%@",serverIp,MessageIP];
}
/*
-(NSString*)getResetIP
{
    NSString *ResetIP=nil,*serverIp=nil;
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
            if ([category isEqualToString:@"ResetIP"])
                ResetIP=[dict valueForKey:category];
            
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
            if ([category isEqualToString:@"ResetIP"])
            {ResetIP=[dict valueForKey:category];
                NSLog(@"--+-+--%@",[dict valueForKey:category]);
            }
        }
        
    }
    
     return [NSString stringWithFormat:@"%@%@",serverIp,ResetIP];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
