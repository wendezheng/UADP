//
//  CategoryViewController.m
//  UADP
//
//  Created by hello world on 14-12-8.
//  Copyright (c) 2014年 csu. All rights reserved.
//

#import "CategoryViewController.h"
#import "ListViewController.h"
#import "ShowMessageViewController.h"
#import "CSUAppDelegate.h"
#import "SBJson.h"
#import "SBJsonParser.h"
#import "ContentViewController.h"
@interface CategoryViewController ()
{
    UIScrollView *scrollView;
    UIActivityIndicatorView *activityView;
}

@end

@implementation CategoryViewController
//@synthesize scrollView = _scrollView;
//@synthesize listOfCategory = _listOfCategory;
//@synthesize listOfAllArticleID = _listOfAllArticleID;
@synthesize listOfCategoryName = _listOfCategoryName;
//@synthesize listOfAllArticleName = _listOfAllArticleName;
@synthesize statecode,appID,appName,appTheme;
@synthesize categorydata = _categorydata;
@synthesize listOfCategoryID = _listOfCategoryID;
-(NSMutableArray *)listOfCategoryID
{
    if (_listOfCategoryID) {
        _listOfCategoryID = [[NSMutableArray alloc]init];
    }
    return _listOfCategoryID;
}
-(NSMutableData *)categorydata
{
    if (!_categorydata) {
        _categorydata = [[NSMutableData alloc]init];
    }
    return _categorydata;
}
-(NSMutableArray *)listOfCategoryName
{
    if (!_listOfCategoryName) {
        _listOfCategoryName = [[NSMutableArray alloc]init];
    }
    return _listOfCategoryName;

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
    UIBarButtonItem *messageItem = [[UIBarButtonItem alloc]initWithTitle:@"查看消息" style:UIBarButtonItemStylePlain target:self action:@selector(checkMessage)];
    self.navigationItem.rightBarButtonItem =messageItem;
    NSLog(@"self.appID=%d",self.appID);
    [self getAllCategory:@"" appID:self.appID];
    self.navigationController.navigationBar.backgroundColor = [[UIColor alloc]initWithRed:129/255.0 green:210/255.0 blue:213/255.0 alpha:1];
    activityView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [activityView setCenter:self.view.center];
    [activityView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [activityView startAnimating];
    [self.view addSubview:activityView];

}

-(void)checkMessage
{

    
    ShowMessageViewController *ShowMessageView=[[ShowMessageViewController alloc]init];
    [ShowMessageView setTitle:[NSString stringWithFormat:@"关于%@的消息",self.appName]];
    ShowMessageView.appid = self.appID;
    [self.navigationController pushViewController:ShowMessageView animated:YES];
    
    
}

-(void)generateButtons2:(NSInteger)count
{
    int n = 6;
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,60,self.view.frame.size.width,/*[UIScreen mainScreen].applicationFrame.size.height*/self.view.frame.size.height-108)];
   // self.scrollView.frame =  CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height-108);
    [self.view addSubview:scrollView];
    int heit=scrollView.frame.size.height,widh=scrollView.frame.size.width;
    int heit2=self.view.frame.size.height;
    NSLog(@"%f",self.view.frame.size.height);
    if (self.appTheme==1) {
        [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width, (heit2/n*2+10)*((count+1)/2))];
        for (int i=1; i<=count; i++) {
            CGRect frame = CGRectMake(widh/2*((i-1)%2)+2.5, /*heit/((n+1)*2)+*/heit/(n/2)*((i-1)/2)+25, widh/2-5, heit/n*2-5/*+30*/);
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.backgroundColor =[[UIColor alloc]initWithRed:129/255.0 green:210/255.0 blue:213/255.0 alpha:1];
            button.titleLabel.font = [UIFont systemFontOfSize:40];
            [button setTitle:[_listOfCategoryName objectAtIndex:i-1] forState:UIControlStateNormal];
            button.titleLabel.numberOfLines =2;
            [button setTag:i-1];
            [button addTarget:self action:@selector(runButtonActions:) forControlEvents:UIControlEventTouchUpInside];
            button.frame = frame;
            
            [scrollView addSubview:button];
            
        }
    }
    
    if (self.appTheme==2) {
        [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width, (heit2/n*2+10)*((count+1)/2))];
        for (int i=1; i<=count; i++) {
            CGRect frame = CGRectMake(widh/3*((i-1)%2)+2.5, /*heit/((n+1)*2)+*/heit/(n/2)*((i-1)/2)+25, widh/2-5, heit/n*2-5/*+30*/);
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            if (i%5==0) {
                button.backgroundColor =[[UIColor alloc]initWithRed:141/255.0 green:118/255.0 blue:102/255.0 alpha:1];
            }
            if (i%5==1) {
                button.backgroundColor =[[UIColor alloc]initWithRed:54/255.0 green:57/255.0 blue:102/255.0 alpha:1];
            }
            if (i%5==2) {
                button.backgroundColor =[[UIColor alloc]initWithRed:40/255.0 green:94/255.0 blue:164/255.0 alpha:1];
            }
            if (i%5==3) {
                button.backgroundColor =[[UIColor alloc]initWithRed:107/255.0 green:144/255.0 blue:48/255.0 alpha:1];
            }
            if (i%5==4) {
                button.backgroundColor =[[UIColor alloc]initWithRed:200/255.0 green:81/255.0 blue:23/255.0 alpha:1];
            }
            button.titleLabel.font = [UIFont systemFontOfSize:40];
            [button setTitle:[_listOfCategoryName objectAtIndex:i-1] forState:UIControlStateNormal];
            button.titleLabel.numberOfLines =2;
            [button setTag:i-1];
            [button addTarget:self action:@selector(runButtonActions:) forControlEvents:UIControlEventTouchUpInside];
            button.frame = frame;
            [scrollView addSubview:button];
            
        }
    }
    if (self.appTheme==3) {
       [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width, (heit2/n+5)*count)];
        for (int i=1; i<=count; i++) {
            CGRect frame = CGRectMake(2.5, 15+heit/n*(i-1), widh-5, heit/n-5);
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.backgroundColor =[[UIColor alloc]initWithRed:129/255.0 green:210/255.0 blue:213/255.0 alpha:1];
            button.titleLabel.font = [UIFont systemFontOfSize:40];
            [button setTitle:[_listOfCategoryName objectAtIndex:i-1] forState:UIControlStateNormal];
            [button setTag:i-1];
            [button.layer setMasksToBounds:YES];
            [button.layer setBorderWidth:1.0];
            //[button.layer setCornerRadius:8.0f];
            [button addTarget:self action:@selector(runButtonActions:) forControlEvents:UIControlEventTouchUpInside];
            button.frame = frame;
            [scrollView addSubview:button];
            
        }
    }
    if (self.appTheme==4) {
        [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width, (heit2/n+5)*count)];
        for (int i=1; i<=count; i++) {
            CGRect frame = CGRectMake(2.5, 15+heit/n*(i-1), widh-5, heit/n-5);
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            if (i%5==0) {
                button.backgroundColor =[[UIColor alloc]initWithRed:141/255.0 green:118/255.0 blue:102/255.0 alpha:1];
            }
            if (i%5==1) {
                button.backgroundColor =[[UIColor alloc]initWithRed:54/255.0 green:57/255.0 blue:102/255.0 alpha:1];
            }
            if (i%5==2) {
                button.backgroundColor =[[UIColor alloc]initWithRed:40/255.0 green:94/255.0 blue:164/255.0 alpha:1];
            }
            if (i%5==3) {
                button.backgroundColor =[[UIColor alloc]initWithRed:107/255.0 green:144/255.0 blue:48/255.0 alpha:1];
            }
            if (i%5==4) {
                button.backgroundColor =[[UIColor alloc]initWithRed:200/255.0 green:81/255.0 blue:23/255.0 alpha:1];
            }
            [button setTitle:[_listOfCategoryName objectAtIndex:i-1] forState:UIControlStateNormal];
            [button setTag:i-1];
            button.titleLabel.font = [UIFont systemFontOfSize:40];
            [button.layer setMasksToBounds:YES];
            [button.layer setBorderWidth:1.0];
            //[button.layer setCornerRadius:8.0f];
            [button addTarget:self action:@selector(runButtonActions:) forControlEvents:UIControlEventTouchUpInside];
            button.frame = frame;
            [scrollView addSubview:button];
            
            
        }
    }

    
    
    
}



-(void)generateButtons:(NSInteger)count
{
    NSLog(@"--------------------------------------------------------------%d",count);
    int defaultheight = 80,distance = 2.5;
    CSUAppDelegate *csuad = [UIApplication sharedApplication].delegate;
    NSDictionary *themes=csuad.themeDictionary;
    NSArray *themeAyyay= [themes objectForKey:@"theme"];
    NSDictionary *mytheme;
    if (self.appTheme>[themeAyyay count]&&[themeAyyay count]>0) {
         mytheme = [themeAyyay objectAtIndex:0];
    }
    else
        mytheme = [themeAyyay objectAtIndex:self.appTheme-1];
    
    int cols = [[mytheme objectForKey:@"cols"]integerValue];
    
    NSArray *colorArray = [mytheme objectForKey:@"color"];
    NSArray *imgArray = [mytheme objectForKey:@"img"];
    
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,70,self.view.frame.size.width,[UIScreen mainScreen].applicationFrame.size.height)];
    [self.view addSubview:scrollView];
    int heit=scrollView.frame.size.height,widh=scrollView.frame.size.width;
     NSLog(@"--------------------------------------------------------------%d",defaultheight*count);
    if (cols==1) {
        [scrollView setContentSize:CGSizeMake(widh,defaultheight*count)];
        for (int i=1; i<=count; i++) {
            CGRect frame;
            if ([imgArray count]>0)
            frame = CGRectMake(widh/cols*((i-1)%cols)+distance, distance+((i-1)/cols)*(defaultheight), widh/cols-distance*2, defaultheight-distance*2-15);
            else
                 frame = CGRectMake(widh/cols*((i-1)%cols)+distance, distance+((i-1)/cols)*(defaultheight), widh/cols-distance*2, defaultheight-distance*2);
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            //button.backgroundColor =[[UIColor alloc]initWithRed:129/255.0 green:210/255.0 blue:213/255.0 alpha:1];
            button.backgroundColor=[self colorWithHexString:[colorArray objectAtIndex:((i-1)%[colorArray count])]];
//            button.titleLabel.font = [UIFont systemFontOfSize:40];
//            [button setTitle:[_listOfCategoryName objectAtIndex:i-1] forState:UIControlStateNormal];
//            button.titleLabel.numberOfLines =2;
            [button setTag:i-1];
            [button.layer setMasksToBounds:YES];
            [button.layer setBorderWidth:1.0];
            [button.layer setCornerRadius:8.0f];
            
           // NSURL *url= [NSURL URLWithString:@"http://192.168.1.33:8080/UADigitalPublish/resrcs/images/test/iphone-tests-icon.png"];
            if ([imgArray count]>0)
            {
                //[NSString stringWithFormat:@"%@%@",[[self getListIP]objectForKey:@"serverip"],[[self getListIP]objectForKey:@"imagesip"]]
                NSURL *url= [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",[[self getListIP]objectForKey:@"serverip"],[[self getListIP]objectForKey:@"imagesip"],[imgArray objectAtIndex:((i-1)%[imgArray count])]]];
                NSData *data= [NSData dataWithContentsOfURL:url];
                NSLog(@"++%@",data);
                UIImage *image =[UIImage imageWithData:data];
                [button setBackgroundImage:image forState:UIControlStateNormal];
                
            }

            
            [button addTarget:self action:@selector(runButtonActions:) forControlEvents:UIControlEventTouchUpInside];
            button.frame = frame;
            
            [scrollView addSubview:button];
            
            
            
            if ([imgArray count]>0) {
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(button.frame.origin.x, button.frame.origin.y+button.frame.size.height+2, button.frame.size.width, 15)];
                //label.backgroundColor= [UIColor blackColor];
                NSLog(@"++++++++++++++++++++++++++++++++++%f",label.frame.origin.y);
                label.text = [_listOfCategoryName objectAtIndex:i-1];
                label.textAlignment = NSTextAlignmentCenter;
                label.font = [UIFont systemFontOfSize:12];
                label.numberOfLines=2;
                [scrollView addSubview:label];
            }
            else
            {
                button.titleLabel.font = [UIFont systemFontOfSize:40];
                [button setTitle:[_listOfCategoryName objectAtIndex:i-1] forState:UIControlStateNormal];
                button.titleLabel.numberOfLines =2;
            }

        }

    }
    else
    {
        [scrollView setContentSize:CGSizeMake(widh,widh/cols*((count+cols-1)/cols))];
        for (int i=1; i<=count; i++) {
            CGRect frame = CGRectMake(widh/cols*((i-1)%cols)+distance, distance+((i-1)/cols)*(widh/cols), widh/cols-distance*2-10, widh/cols-distance*2-15);
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            //button.backgroundColor =[[UIColor alloc]initWithRed:129/255.0 green:210/255.0 blue:213/255.0 alpha:1];
            button.backgroundColor=[self colorWithHexString:[colorArray objectAtIndex:((i-1)%[colorArray count])]];
            
            [button setTag:i-1];
            
            //NSString *urlstr = [NSString stringWithFormat:@"http://192.168.1.33:8080/UADigitalPublish/resrcs/images/test/%@",[imgArray objectAtIndex:((i-1)%[colorArray count])]];
           // NSURL *url= [NSURL URLWithString:@"http://192.168.1.33:8080/UADigitalPublish/resrcs/images/test/iphone-tests-icon.png"];
            if ([imgArray count]>0)
            {
               NSURL *url= [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",[[self getListIP]objectForKey:@"serverip"],[[self getListIP]objectForKey:@"imagesip"],[imgArray objectAtIndex:((i-1)%[imgArray count])]]];
                NSData *data= [NSData dataWithContentsOfURL:url];
                NSLog(@"++%@",data);
                UIImage *image =[UIImage imageWithData:data];
                [button setBackgroundImage:image forState:UIControlStateNormal];
                
                
                
            }
            
            [button addTarget:self action:@selector(runButtonActions:) forControlEvents:UIControlEventTouchUpInside];
            button.frame = frame;
            
            [scrollView addSubview:button];
            
            
            
            if ([imgArray count]>0) {
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(button.frame.origin.x, button.frame.origin.y+button.frame.size.height+2, button.frame.size.width, 15)];
                //label.backgroundColor= [UIColor blackColor];
                NSLog(@"++++++++++++++++++++++++++++++++++%f",label.frame.origin.y);
                label.text = [_listOfCategoryName objectAtIndex:i-1];
                label.textAlignment = NSTextAlignmentCenter;
                label.font = [UIFont systemFontOfSize:12];
                label.numberOfLines=2;
                [scrollView addSubview:label];
            }
            else
            {
                button.titleLabel.font = [UIFont systemFontOfSize:button.frame.size.width/3];
                [button setTitle:[_listOfCategoryName objectAtIndex:i-1] forState:UIControlStateNormal];
                button.titleLabel.numberOfLines =2;
            }
            
        }
        

    }
    
    
    
    
}





- (void)runButtonActions:(id)sender
{
   // NSLog(@"-%D-------%@------------%@-------",[sender tag],self.listOfAllArticleID,self.listOfAllArticleName);

    ListViewController *lvc = [[ListViewController alloc]init];
    lvc.strCategoryName = [self.listOfCategoryName objectAtIndex:[sender tag]];
    lvc.appID = self.appID;
    [lvc setTitle:[self.listOfCategoryName objectAtIndex:[sender tag]]];
    NSLog(@"--------%@------------%@-------",lvc.listOfID,lvc.listOfTitle );
    [self.navigationController pushViewController:lvc animated:YES];

}


- (void)getAllCategory:(NSString *)rusername appID:(int)appid
{
    // Establish the request
    NSString *jsons = [NSString stringWithFormat:@"{\"appid\":%d,\"state\":\"%@\"}",appid,@"2"];
    NSString *body = [NSString stringWithFormat:@"jsons=%@",jsons];
    NSLog(@"%@",body);
    
    NSString *baseurl=[NSString stringWithFormat:@"%@%@?",[[self getListIP] objectForKey:@"serverip"],[[self getListIP] objectForKey:@"categoryIP"]];
    //NSString *baseurl = [NSString stringWithFormat:@"%@?",[self getAllCategoryIP]];  //chuliapp地址
    NSLog(@"baseurl = %@", baseurl);
    
	NSURL *url = [NSURL URLWithString:baseurl];
	NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    //[urlRequest addValue:bodyLength forHTTPHeaderField:@"Content-Length"];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"urlrequest = %@", urlRequest);
    NSURLConnection *getCategoryConnetion= [[NSURLConnection alloc] initWithRequest: urlRequest delegate: self];
    
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.categorydata appendData:data];
	NSString *rsp = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	NSLog(@"connection    2  Received data = %@  ", rsp);
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    
	NSHTTPURLResponse *resp = (NSHTTPURLResponse *)response;
	NSLog(@"Response statusCode:    %lu", (long)resp.statusCode);
    self.statecode =(long)resp.statusCode;
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [activityView stopAnimating];
     NSLog(@"connection done!");
    if (self.statecode == 200) {
        NSString *rsp = [[NSString alloc] initWithBytes:[self.categorydata mutableBytes] length:[self.categorydata length] encoding: NSUTF8StringEncoding];
        NSLog(@"connection    2  Received data = %@  ", rsp);
        CSUAppDelegate *csuapp = [[UIApplication sharedApplication]delegate];
        
        
        //    NSString *deleteSql = @"delete from category;";
        //    [csuapp.dboperate updateDB:deleteSql];
        
        NSArray * dataArray= [[NSArray alloc]init];
        
        dataArray = [rsp JSONValue];
        int count = [dataArray count];
        NSLog(@"count=%d",count);
        for (int i=0; i<count; i++) {
            NSDictionary *result = [dataArray objectAtIndex:i];
            int categoryid = [[result objectForKey:@"id"]integerValue];
            NSString *categoryname=[result objectForKey:@"modelname"];
            int appid = [[result objectForKey:@"appid"] integerValue];
            NSString *state = [result objectForKey:@"state"];
            [self.listOfCategoryName addObject:categoryname];
            [self.listOfCategoryID addObject:[NSNumber numberWithInt: categoryid]];
            NSLog(@"categoryname = %@  ", categoryname);
            NSString *sql=[NSString stringWithFormat:@"insert or replace into category(modelid,modelname,appid,state)values(%d,'%@',%d,'%@');",categoryid,categoryname,appid,state];
            NSLog(@"%@",sql);
            [csuapp.dboperate updateDB:sql];
            
            //APP---LOGO   TODO
            
        }
        
        [self generateButtons:[self.listOfCategoryName count]];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"服务器出错"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
  /*  NSString *rsp = [[NSString alloc] initWithBytes:[self.categorydata mutableBytes] length:[self.categorydata length] encoding: NSUTF8StringEncoding];
    NSLog(@"connection    2  Received data = %@  ", rsp);
    CSUAppDelegate *csuapp = [[UIApplication sharedApplication]delegate];
    
    
//    NSString *deleteSql = @"delete from category;";
//    [csuapp.dboperate updateDB:deleteSql];
    
    NSArray * dataArray= [[NSArray alloc]init];
    
    dataArray = [rsp JSONValue];
    int count = [dataArray count];
    NSLog(@"count=%d",count);
    for (int i=0; i<count; i++) {
        NSDictionary *result = [dataArray objectAtIndex:i];
        int categoryid = [[result objectForKey:@"id"]integerValue];
         NSString *categoryname=[result objectForKey:@"modelname"];
        int appid = [[result objectForKey:@"appid"] integerValue];
        NSString *state = [result objectForKey:@"state"];
        [self.listOfCategoryName addObject:categoryname];
        [self.listOfCategoryID addObject:[NSNumber numberWithInt: categoryid]];
        NSLog(@"categoryname = %@  ", categoryname);
        NSString *sql=[NSString stringWithFormat:@"insert or replace into category(modelid,modelname,appid,state)values(%d,'%@',%d,'%@');",categoryid,categoryname,appid,state];
        NSLog(@"%@",sql);
        [csuapp.dboperate updateDB:sql];
        
        //APP---LOGO   TODO
        
    }
    */
    [self.categorydata setLength:0];

    //[self generateButtons:[self.listOfCategoryName count]];

    
    
    
}

-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [activityView stopAnimating];
    NSLog(@"connection error!");
     //查本地数据
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
    //DBOperation *dboperate = [[DBOperation alloc]init];
    NSLog(@"---%@",appDelegate.username);
    // order by scheduledate desc,scheduletime desc
    // NSString *sql = [NSString stringWithFormat:@"select * from app where appowner=%d and appstate=0;",appDelegate.deptid];
    NSString *sql = @"select * from category where state='2';";
    NSMutableArray *temp=[[NSMutableArray alloc]init];
    temp =[appDelegate.dboperate getCategory:sql];
    
    for (int i=0; i<[temp count]; i++) {
        [self.listOfCategoryID addObject:[[temp objectAtIndex:i]objectForKey:@"modelid"]];
        [self.listOfCategoryName addObject:[[temp objectAtIndex:i] objectForKey:@"modelname"]];
        //[self.isreadMuti addObject:[[temp objectAtIndex:i] objectForKey:@"isread"]];
        // [self.dateAndtime addObject:[NSString stringWithFormat:@"%@ %@",[[temp objectAtIndex:i] objectForKey:@"scheduledate"],[[temp objectAtIndex:i] objectForKey:@"scheduletime"]]];
    }
                                                                                                              

        [self generateButtons:[self.listOfCategoryName count]];
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

-(NSString*)getAllCategoryIP
{
    NSString *AllCategoryIP=nil,*serverIp=nil;
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
            if ([category isEqualToString:@"categoryIP"])
                AllCategoryIP=[dict valueForKey:category];
            
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
            if ([category isEqualToString:@"categoryIP"])
            {AllCategoryIP=[dict valueForKey:category];
                NSLog(@"--+-+--%@",[dict valueForKey:category]);
            }
        }
        
    }
    //return AllCategoryIP;
    return [NSString stringWithFormat:@"%@%@",serverIp,AllCategoryIP];
}
*/
#pragma mark - 颜色转换 IOS中十六进制的颜色转换为UIColor
- (UIColor *) colorWithHexString: (NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
