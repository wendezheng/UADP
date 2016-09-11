//
//  ContentViewController.m
//  UADP
//
//  Created by hello world on 14-11-11.
//  Copyright (c) 2014年 csu. All rights reserved.
//

#import "ContentViewController.h"
#import "CommentViewController.h"
#import "AdvertismentViewController.h"
#import "SBJson.h"
#import "SBJsonParser.h"

#include "CSUAppDelegate.h"
@interface ContentViewController ()
{
     NSTimer *articletimer;
    NSMutableData *trcacedata;
    long statuscode;
}
@end

@implementation ContentViewController

@synthesize articleID = _articleID;
@synthesize webViewContent = _webViewContent;
@synthesize commentTabBar = _commentTabBar;
@synthesize deptcode = _deptcode;
@synthesize articleData = _articleData;
@synthesize aPath;


-(NSMutableData *)articleData
{
    if (!_articleData) {
        _articleData = [[NSMutableData alloc]init];
    }
    return _articleData;
}
 static int second = 0;

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


   
    self.articleData = (NSMutableData*)[self.aPath dataUsingEncoding:NSUTF8StringEncoding];
    [self viewinit];
    
    
}
-(void)searchDB:(int)articleid
{
    
    [self viewinit];
}

-(void)viewinit
{
    
    trcacedata = [[NSMutableData alloc]init];
    
    NSMutableData *advdata = (NSMutableData *)[[NSString stringWithFormat:@"<html><head><style type=\"text/css\">                                               .comments-family {                                                   font-family: add;                                                   font-size: 28px;                                               }           @font-face{                                                   font-family: add;                                               src:url(%@assets/fonts/add.ttf);                                              }                                               </style> </head><body><div></div>",[[self getListIP] objectForKey:@"serverIP"]] dataUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"%@+-+",advdata);

    [advdata appendData:_articleData];
    NSLog(@"%@+-+",advdata);
    NSData *taildata = [@"</body></html>" dataUsingEncoding:NSUTF8StringEncoding];
    [advdata appendData:taildata];
    /////////////////////////////////
    NSArray *paths= NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docdir=[paths objectAtIndex:0];
    NSURL *baseurl = [NSURL fileURLWithPath:docdir];
    [_webViewContent loadData:advdata MIMEType:@"text/html" textEncodingName:@"utf-8" baseURL:baseurl];
    [_webViewContent setOpaque:NO];


    
    
    
    [_commentTabBar setDelegate:self];
    

    second = 0;
    NSLog(@"ViewDidLoad");
    self.numLove=0;
    
    NSLog(@"ViewDidLoad--%f",self.navigationController.navigationBar.frame.origin.y);
    

    
    self.webViewContent= [[UIWebView alloc]initWithFrame:CGRectMake(0,142,320,377)];
    


}

//网页上的链接用safari打开
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (navigationType==UIWebViewNavigationTypeLinkClicked) {
        NSURL *url = [request URL];
        if ([[UIApplication sharedApplication]canOpenURL:url]) {
            [[UIApplication sharedApplication]openURL:url];
             NSLog(@"O");
        }
         NSLog(@"NO");
        return  NO;
       
    }
     NSLog(@"y");
    return YES;
}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidStartLoad");
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidFinishLoad");
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"didFailLoadWithError");
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    switch (item.tag) {
        case 0:
            NSLog(@"item%ld",(long)item.tag);
            break;
        case 1:
            NSLog(@"item%ld",(long)item.tag);
            break;
        case 2:
            NSLog(@"item%ld",(long)item.tag);
            break;
        default:
            break;
    }
    if (item.tag==1) {
        CommentViewController * commentPage = [[CommentViewController alloc]init];
        commentPage.articleid=[self.articleID integerValue];
        commentPage.deptcode = self.deptcode;
        [self.navigationController pushViewController:commentPage animated:YES];
    }
    if (item.tag==0) {
        [item setTitle:[NSString stringWithFormat:@"%d",++self.numLove]];
    }
    NSLog(@"string");
    
}


-(void)StartTimer
{
  articletimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAdvanced:) userInfo:nil repeats:YES];

    NSLog(@"st");
   
}


-(void)timerAdvanced:(NSTimer*)timer
{


    second++;
    NSLog(@"%d",second);

    
}
-(void)dealloc
{
    NSLog(@"back");
    CSUAppDelegate *csuad = [[UIApplication sharedApplication]delegate];
    NSString *jsons;
    NSDictionary *sendValue = [[NSMutableDictionary alloc]init];
    [sendValue setValue:self.articleID forKey:@"articleid" ];
    [sendValue setValue:[NSString stringWithFormat:@"%d",second] forKey:@"viewtime"];
    NSDate *nowatime = [[NSDate alloc]init];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSString *dateAndtime = [dateFormatter stringFromDate:nowatime];
    [sendValue setValue:nowatime forKey:@"lastviewtime"];
    [sendValue setValue:csuad.account forKey:@"account"];
    SBJsonWriter *sendjsons=[[SBJsonWriter alloc]init];
    NSString *jsons2 = [sendjsons stringWithObject:sendValue];
    
    
    
    jsons = [NSString stringWithFormat:@"{\"account\":\"%@\",\"articleid\":\"%@\",\"viewtime\":\"%d\",\"lastviewtime\":\"%@\"}",csuad.account,self.articleID,second,dateAndtime];
    NSLog(@"%@%@",jsons2,sendValue);
    
    [self sendTrace:jsons];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    NSLog(@"%@maxReadedTime---%d",_articleID,[[[NSUserDefaults standardUserDefaults]objectForKey:_articleID]intValue]);

    [articletimer invalidate];
    
    NSLog(@"%@maxReadedTime---%@",_articleID,[[NSUserDefaults standardUserDefaults]objectForKey:_articleID]);
}




-(void)viewWillAppear:(BOOL)animated
{
    NSLog(@"viewWillAppear---");
    [self StartTimer];
}
-(void)viewDidAppear:(BOOL)animated
{
     NSLog(@"viewDidAppear---");
    
    
}




- (void)sendTrace:(NSString *)jsons
{

    NSString *body = [NSString stringWithFormat:@"jsons=%@",jsons];
    NSLog(@"%@",body);
    
    
    NSString *baseurl=[NSString stringWithFormat:@"%@%@?",[[self getListIP] objectForKey:@"serverip"],[[self getListIP] objectForKey:@"traceIP"]];
   // NSString *baseurl = [NSString stringWithFormat:@"%@?",[self getArticleContentIP]];  //chuliapp地址
    NSLog(@"baseurl = %@", baseurl);
    
	NSURL *url = [NSURL URLWithString:baseurl];
	NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    //[urlRequest addValue:bodyLength forHTTPHeaderField:@"Content-Length"];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"urlrequest = %@", urlRequest);
    NSURLConnection *getContentConnetion= [[NSURLConnection alloc] initWithRequest: urlRequest delegate: nil];
    
}


//- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
//{
//    
//    [trcacedata appendData:data];
//    
//}
//-(void)connectionDidFinishLoading:(NSURLConnection *)connection
//{
//     NSLog(@"connection done!");
//    NSString *rsp = [[NSString alloc] initWithBytes:[self.articleData mutableBytes]length:[self.articleData length] encoding:NSUTF8StringEncoding];
//    NSLog(@"%@",rsp);
//    if (statuscode !=200 ) {
//        NSLog(@"<<<<<<<<<<<<<<<<<<<<<<<<<");
//        return;
//    }
//    
//    
//
//}
//- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
//{
//	NSHTTPURLResponse *resp = (NSHTTPURLResponse *)response;
//	NSLog(@"Response statusCode:    %lu", (long)resp.statusCode);
//    //[self.articleData setLength:0];
//    statuscode =(long)resp.statusCode;
//}
//
//
//
//-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
//{
//    NSLog(@"connection error!");
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示"
//                                                        message:@"连接错误"
//                                                       delegate:self
//                                              cancelButtonTitle:@"OK"
//                                              otherButtonTitles:nil];
//    [alertView show];
//    
//}

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
