//
//  ListViewController.m
//  UADP
//
//  Created by hello world on 14-11-11.
//  Copyright (c) 2014年 csu. All rights reserved.
//

#import "ListViewController.h"
#import "ContentViewController.h"
#import "CSUAppDelegate.h"
#import "SBJson.h"
#import "SBJsonParser.h"
@interface ListViewController ()
{
    UIActivityIndicatorView *activityView;
}

@end

@implementation ListViewController

@synthesize listOfTitle=_listOfTitle;
@synthesize strCategoryName = _strCategoryName;
@synthesize listTable = _listTable;
@synthesize listOfID = _listOfID;
@synthesize appID,statecode;
@synthesize articleData= _articleData;
@synthesize listOfLogo = _listOfLogo;
@synthesize listOfPath = _listOfPath;
@synthesize listOfDeptcode=_listOfDeptcode;
-(NSMutableArray *)listOfID
{
    if (!_listOfID) {
        _listOfID = [[NSMutableArray alloc]init];
    }
    return _listOfID;
}
-(NSMutableArray *)listOfTitle
{
    if (!_listOfTitle) {
        _listOfTitle = [[NSMutableArray alloc]init];
    }
    return _listOfTitle;
}
-(NSMutableArray *)listOfLogo
{
    if (!_listOfLogo) {
        _listOfLogo = [[NSMutableArray alloc]init];
    }
    return _listOfLogo;
}
-(NSMutableArray *)listOfPath
{
    if (!_listOfPath) {
        _listOfPath = [[NSMutableArray alloc]init];
    }
    return _listOfPath;
}
-(NSMutableData *)articleData
{
    if (!_articleData) {
        _articleData = [[NSMutableData alloc]init];
    }
    return  _articleData;
}
-(NSMutableArray *)listOfDeptcode
{
    if (!_listOfDeptcode) {
        _listOfDeptcode = [[NSMutableArray alloc]init];
    }
    return  _listOfDeptcode;
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
    //self.articleData = [[NSMutableData alloc]init];
    
    [self getArticle:@"" appID:self.appID category:self.strCategoryName];
    //NSLog(@"tt%@",_listOfTitle);
    activityView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [activityView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [activityView setCenter:self.view.center];
    [activityView startAnimating];
    [self.view addSubview:activityView];
    
    
    //set background
    //tableView
    //UIImageView *tableBackground = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tablebg"]];
    //[_listTable setBackgroundView:tableBackground];
    
    
  //  [_listTable setBackgroundColor:[UIColor brownColor]];
    //[_listTable setSeparatorColor:[UIColor redColor]];
    

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    NSString *cellValue = [_listOfTitle objectAtIndex:indexPath.row];
    cell.textLabel.text = cellValue;
    NSURL *url= [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[[self getListIP]objectForKey:@"serverip"],[self.listOfLogo objectAtIndex:indexPath.row]]];
    NSData *data= [NSData dataWithContentsOfURL:url];
    UIImage *image =[UIImage imageWithData:data];
    cell.imageView.image = image;
    
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [_listOfTitle count];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"tt%@",_listOfPath);
    NSString *titleSelected = [_listOfID objectAtIndex:indexPath.row];
    ContentViewController *cvc=[[ContentViewController alloc]init];
    cvc.articleID = titleSelected;
    cvc.deptcode = [_listOfDeptcode objectAtIndex:indexPath.row];
    [cvc setTitle:[_listOfTitle objectAtIndex:[indexPath row]]];
    cvc.aPath = [_listOfPath objectAtIndex:[indexPath row]];
    [self.navigationController pushViewController:cvc animated:YES];
    NSLog(@"tt%@",_listOfID);
    
}

//set background
//tableViewCell
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //cell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cellbg"]];
    //cell.backgroundColor =[[UIColor alloc]initWithRed:129/255.0 green:210/255.0 blue:213/255.0 alpha:1];// [UIColor clearColor];
    cell.backgroundColor =[UIColor clearColor];
}





- (void)getArticle:(NSString *)rusername appID:(int)appid category:(NSString *)categoryname
{
    // Establish the request
    NSString *jsons = [NSString stringWithFormat:@"{\"appid\":%d,\"modelname\":\"%@\",\"state\":\"%@\"}",appid,categoryname,@"2"];
    //jsons = @"jsons={\"id\":75}";
    NSString *body = [NSString stringWithFormat:@"jsons=%@",jsons];
    NSLog(@"%@",body);
    
    NSString *baseurl=[NSString stringWithFormat:@"%@%@?",[[self getListIP] objectForKey:@"serverip"],[[self getListIP] objectForKey:@"articleIP"]];
    //NSString *baseurl = [NSString stringWithFormat:@"%@?",[self getArticleIP]];  //chuliapp地址
    NSLog(@"baseurl = %@", baseurl);
    
    
    NSURL *url = [NSURL URLWithString:baseurl];
	NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    //[urlRequest addValue:bodyLength forHTTPHeaderField:@"Content-Length"];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"urlrequest = %@", urlRequest);
    NSURLConnection *getArticleConnetion= [[NSURLConnection alloc] initWithRequest: urlRequest delegate: self];
    
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.articleData appendData:data];
    NSLog(@"%@",data);
	NSString *rsp = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	NSLog(@"connection    2  Received data = %@  ", rsp);
    
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	NSHTTPURLResponse *resp = (NSHTTPURLResponse *)response;
	NSLog(@"Response statusCode:    %lu", (long)resp.statusCode);
    self.statecode = (long)resp.statusCode;
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [activityView stopAnimating];
    NSLog(@"----------connection done!");
    /*if (self.statecode == 404 || self.statecode == 500) {
        [self searchDB];
        return;
    }
*/
    if (self.statecode ==200) {
        NSString *rsp = [[NSString alloc] initWithData:self.articleData encoding:NSUTF8StringEncoding];
        NSArray *dataArray = [[NSArray alloc]init];
        dataArray=[rsp JSONValue];
        NSArray * articleArray= [[NSArray alloc]init];
        articleArray = [dataArray lastObject];
        NSLog(@"%@",articleArray);
        int count = [articleArray count];
        NSLog(@"count=%d",count);
        for (int i=0; i<count; i++) {
            NSDictionary *result = [articleArray objectAtIndex:i];
            int articleid = [[result objectForKey:@"id"]integerValue];
            int userid = [[result objectForKey:@"userid"]integerValue];
            NSString *titie=[result objectForKey:@"title"];
            NSString *logo = [result objectForKey:@"logo"];
            NSString *submitter=[result objectForKey:@"submitter"];
            NSString *label = [result objectForKey:@"label"];
            NSString *type=[result objectForKey:@"type"];
            NSString *lastediter = [result objectForKey:@"lastediter"];
            NSString *submittime=[result objectForKey:@"submittime"];
            NSString *lastedittime = [result objectForKey:@"lastedittime"];
            NSString *owner=[result objectForKey:@"owner"];
            NSString *path = [result objectForKey:@"path"];
            NSString *explain = [result objectForKey:@"explain"];
           // NSString *deptcode = [result objectForKey:@"deptcode"];
            int state = [[result objectForKey:@"state"]integerValue];
            NSLog(@"--------");
            //[self.listOfDeptcode addObject:deptcode];
              NSLog(@"--------");
            [self.listOfTitle addObject:titie];
              NSLog(@"--------");
            [self.listOfID addObject:[NSNumber numberWithInt: articleid]];
              NSLog(@"--------");
            [self.listOfLogo addObject:logo];
              NSLog(@"--------");
            [self.listOfPath addObject:path];
              NSLog(@"--------");
            NSString *sql=[NSString stringWithFormat:@"insert or replace into apparticle(appid,modelname,articleid,state)values(%d,'%@',%d,'%d');",self.appID,self.strCategoryName,articleid,state];
            NSLog(@"%@",sql);
            NSString *sql2=[NSString stringWithFormat:@"insert or replace into article(aid,userid,apath,alabel,atitle,asubmitter,asubmittime,alastediter,alastedittime,aexplain,atype,alogo,aowner)values(%d,'%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@');",articleid,[NSString stringWithFormat:@"%d",userid],path,label,titie,submitter,submittime,lastediter,lastedittime,explain,type,logo,owner];
            NSLog(@"%@",sql2);
            CSUAppDelegate *csuapp = [[UIApplication sharedApplication]delegate];
            [csuapp.dboperate updateDB:sql];
            [csuapp.dboperate updateDB:sql2];
            
            //APP---LOGO   TODO
            
            
            
        }
        
        [[self listTable]reloadData];
    }
    
    
    [self.articleData setLength:0];
    
    
    
}

-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [activityView stopAnimating];
    NSLog(@"connection error!");
    [self searchDB];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"无法连接到服务器"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
    
}


-(void)searchDB
{
    CSUAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;

    NSString *sql = [NSString stringWithFormat:@"select * from apparticle where appid=%d and modelname='%@';",self.appID,self.strCategoryName];
    NSLog(@"%@",sql);
    NSMutableArray *temp=[[NSMutableArray alloc]init];
    temp =[appDelegate.dboperate getappArticle:sql];
    
    for (int i=0; i<[temp count]; i++) {
        NSLog(@"---");

        NSString *intaid=[[temp objectAtIndex:i]objectForKey:@"articleid"];
        [self.listOfID addObject:intaid];
        NSString *sql2 =[NSString stringWithFormat:@"select * from article where aid=%d;",[intaid integerValue]];
        NSMutableArray *temp2=[[NSMutableArray alloc]init];
        temp2 =[appDelegate.dboperate getArticle:sql2];
        for (int k=0;k<[temp2 count]; k++) {
            [self.listOfTitle addObject:[[temp2 objectAtIndex:k]objectForKey:@"atitle"]];
            [self.listOfLogo addObject:[[temp2 objectAtIndex:k]objectForKey:@"alogo"]];
            [self.listOfPath addObject:[[temp2 objectAtIndex:k]objectForKey:@"apath"]];
        }
        
      
    }
    NSLog(@"%@",sql);
    [[self listTable]reloadData];
    
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
/*
-(NSString*)getArticleIP
{
    NSString *articleIP=nil,*serverIp=nil;
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
            if ([category isEqualToString:@"articleIP"])
                articleIP=[dict valueForKey:category];
            
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
            if ([category isEqualToString:@"articleIP"])
            {articleIP=[dict valueForKey:category];
                NSLog(@"--+-+--%@",[dict valueForKey:category]);
            }
        }
        
    }
    //return articleIP;
    return [NSString stringWithFormat:@"%@%@",serverIp,articleIP];
}


*/




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
