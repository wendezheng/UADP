//
//  CommentViewController.m
//  UADP
//
//  Created by hello world on 14-11-14.
//  Copyright (c) 2014年 csu. All rights reserved.
//

#import "CommentViewController.h"
#import "CSUAppDelegate.h"
#import "SBJson.h"
#import "SBJsonParser.h"
@interface CommentViewController ()<UITextFieldDelegate>
{
    UIActivityIndicatorView *activityView;
}
@end

@implementation CommentViewController
{
    long statecode;
    NSMutableData *reData;
    NSURLConnection *listcommentCon,*submitCom;
    NSMutableArray *listUseraccount;
    NSString *contentjsonstr;
}

//@synthesize deptcode,articleid;
@synthesize commentTView = _commentTView;
@synthesize scrollView = _scrollView;
@synthesize listOfComment = _listOfComment;
@synthesize keyboardIsShown =_keyboardIsShown;
@synthesize commentTextField = _commentTextField;
-(NSMutableArray *)listOfComment
{
    if (!_listOfComment) {
        _listOfComment = [[NSMutableArray alloc]init];
    }
    return _listOfComment;
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
    
    reData = [[NSMutableData alloc]init];
    listUseraccount = [[NSMutableArray alloc]init];
    self.keyboardIsShown = NO;
    self.scrollView.frame = CGRectMake(0, 0, 320, 460);
    self.commentTView.frame = CGRectMake(0, 0, 320, 420);
    
    [self.scrollView setContentSize:CGSizeMake(320, 460)];
    CGRect textFrame = CGRectMake(2,self.scrollView.frame.size.height-40,250,40);
    
    //UITextField *text
    self.commentTextField= [[UITextField alloc]init];
    [self.commentTextField setBorderStyle:UITextBorderStyleLine];
    [self.commentTextField setTag:1];
    [self.commentTextField setTextColor:[UIColor grayColor]];
    self.commentTextField.frame = textFrame;
    [self.commentTextField setPlaceholder:@"comment"];
    self.commentTextField.delegate =self;
    
    CGRect buttonFrame = CGRectMake(250,self.scrollView.frame.size.height-40,70,40);
    self.sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.sendButton.backgroundColor = [UIColor blueColor];
    [self.sendButton setTitle:@"send"forState:UIControlStateNormal];
    [self.sendButton setTag:2];
    //[button setBackgroundImage:[UIImage imageNamed:@"category-5"] forState:UIControlStateNormal];
    [self.sendButton addTarget:self action:@selector(sendComment:) forControlEvents:UIControlEventTouchUpInside];
    //NSLog(@"%f---%f", self.view.frame.size.height, self.view.frame.origin.y);
    self.sendButton.frame = buttonFrame;
 
    [self.scrollView addSubview:self.sendButton];
    [self.scrollView addSubview:self.commentTextField];
    //[self.scrollView addSubview:self.commentText];
    [self.scrollView addSubview:self.commentTView];

    NSLog(@"%@-+++-",self.listOfComment);
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
    
    
    NSString *jsons =[NSString stringWithFormat:@"{\"tagid\":%d,\"state\":\"2\"}",self.articleid];
    [self getListData:[NSString stringWithFormat:@"%@%@",[[self getListIP]objectForKey:@"serverip"],[[self getListIP]objectForKey:@"getcommentIP"]] connection:listcommentCon jsons:jsons];
    NSLog(@"%@",[NSString stringWithFormat:@"%@%@",[[self getListIP]objectForKey:@"serverip"],[[self getListIP]objectForKey:@"getcommentIP"]]);
    activityView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0,30, 30)];
    [activityView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [activityView setCenter:self.view.center];
    [activityView startAnimating];
    [self.view addSubview:activityView];
}

-(void)viewTapped:(UITapGestureRecognizer*)tapGr
{
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    CGRect rect = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
    self.view.frame = rect;
    [UIView commitAnimations];
    //[textField resignFirstResponder];
    [self.commentTextField resignFirstResponder];
    //[self.content resignFirstResponder];
    
}




-(void)viewWillAppear:(BOOL)animated
{
    
    //—-registers the notifications for keyboard—-
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(keyboardDidShow:)
     name:UIKeyboardDidShowNotification
     object:self.view.window];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(keyboardDidHide:)
     name:UIKeyboardDidHideNotification
     object:nil];
    //[super viewWillAppear:animated];
    
}

//—-when a TextField view begins editing—-
-(void) textFieldDidBeginEditing:(UITextField *)textFieldView {

    self.commentTextField = textFieldView;
}

//—-when the user taps on the return key on the keyboard—-
/*
-(BOOL)textFieldShouldReturn:(UITextField *) textFieldView {
    NSLog(@"return");
    [self.commentTextField resignFirstResponder];
    return YES;
}
*/
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    CGRect rect = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
    self.view.frame = rect;
    [UIView commitAnimations];
    [textField resignFirstResponder];
    return YES;
}
//—-when a TextField view is done editing—-
-(void) textFieldDidEndEditing:(UITextField *) textFieldView {
     //self.commentTextField = nil;
}


-(void)keyboardDidShow:(NSNotification *)notification
{
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_3_2
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
#endif
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_3_2
        NSValue *keyboardBoundsValue = [[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
#else
        NSValue *keyboardBoundsValue = [[notification userInfo] objectForKey:UIKeyboardBoundsUserInfoKey];
#endif
        CGRect keyboardBounds;
        [keyboardBoundsValue getValue:&keyboardBounds];
        NSInteger offset =self.view.frame.size.height-keyboardBounds.origin.y;
        CGRect listFrame = CGRectMake(0, -offset, self.view.frame.size.width,self.view.frame.size.height);
        NSLog(@"offset is %ld",(long)offset);
        [UIView beginAnimations:@"anim" context:NULL];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.3];
        //处理移动事件，将各视图设置最终要达到的状态
        
        self.view.frame=listFrame;
        
        [UIView commitAnimations];
        
    }
}

/*
//—-when the keyboard appears—-
-(void) keyboardDidShow:(NSNotification *) notification {
    [self.scrollView setContentSize:CGSizeMake(320, 460)];
    if (self.keyboardIsShown) return;
    
    NSDictionary* info = [notification userInfo];
    
    //—-obtain the size of the keyboard—-
    NSValue *aValue =
    [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect =
    [self.view convertRect:[aValue CGRectValue] fromView:nil];
    
    NSLog(@"%f", keyboardRect.size.height);
    
    //—-resize the scroll view (with keyboard)—-
    CGRect viewFrame = [self.scrollView frame];
    viewFrame.size.height -= (keyboardRect.size.height);
    self.scrollView.frame = viewFrame;
    
    //—-scroll to the current text field—-
    CGRect textFieldRect = [self.commentTextField frame];
    CGRect buttonRect = [self.sendButton frame];
    [self.scrollView scrollRectToVisible:textFieldRect animated:YES];
    [self.scrollView scrollRectToVisible:buttonRect animated:YES];
    [self.scrollView scrollRectToVisible:self.commentTView.frame animated:YES];
    self.keyboardIsShown = YES;
}
*/
//—-when the keyboard disappears—-
-(void) keyboardDidHide:(NSNotification *) notification {
    NSDictionary* info = [notification userInfo];
    
    //—-obtain the size of the keyboard—-
    NSValue* aValue =
    [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect =
    [self.view convertRect:[aValue CGRectValue] fromView:nil];
    
    //—-resize the scroll view back to the original size
    // (without keyboard)—-
    CGRect viewFrame = [self.scrollView frame];
    viewFrame.size.height += (keyboardRect.size.height/*+self.commentTextField.frame.size.height*/);
    self.scrollView.frame = viewFrame;
    
    self.keyboardIsShown = NO;
}

//—-before the View window disappear—-
-(void) viewWillDisappear:(BOOL)animated {
    //—-removes the notifications for keyboard—-
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:UIKeyboardDidShowNotification
     object:nil];
    
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:UIKeyboardDidHideNotification
     object:nil];
    [super viewWillDisappear:animated];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *cellValue = [_listOfComment objectAtIndex:indexPath.row];[_listOfComment objectAtIndex:indexPath.row];
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
    }
    
    NSString *cellValue = [NSString stringWithFormat:@"%@: %@",[listUseraccount objectAtIndex:indexPath.row],[_listOfComment objectAtIndex:indexPath.row]];
    
    //UITextView *textView = [[UITextView alloc]init];
   // textView.text = cellValue;
   // textView.textAlignment=UITextAlignmentLeft;
    //[cell.contentView addSubview:textView];
    [cell.textLabel setFont:[UIFont systemFontOfSize:13]];
    cell.textLabel.numberOfLines=cellValue.length*13/200;
    cell.textLabel.text = cellValue;
    //int index = arc4random()%4+1;
    //UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"category-%d",index]];
    //cell.imageView.image = image;
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [_listOfComment count];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)sendComment:(id)sender
{
    CSUAppDelegate *csud = [[UIApplication sharedApplication]delegate];
    if (self.commentTextField.text.length==0) {
        UIAlertView *alert =
        [[UIAlertView alloc]initWithTitle:@"评论内容不能为空！"
                                  message:@"请输入评论内容"
                                delegate:self
                        cancelButtonTitle:@"OK"
                        otherButtonTitles:nil];
        [alert show];
        
        return;
    }
    
    //[self.listOfComment addObject:[NSString stringWithFormat:@"%@: %@",csud.username,self.commentTextField.text]];
   // [listUseraccount addObject:csud.account];
    
    NSDictionary *sendvalue = [[NSMutableDictionary alloc]init];
    [sendvalue setValue:self.commentTextField.text forKey:@"content"];
    [sendvalue setValue:[NSNumber numberWithInt:self.articleid]forKey:@"tagid"];
    [sendvalue setValue:csud.account forKey:@"account"];
    [sendvalue setValue:csud.deptcode forKey:@"deptcode"];
    NSDate *nowatime = [[NSDate alloc]init];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSString *dateAndtime = [dateFormatter stringFromDate:nowatime];
    [sendvalue setValue:dateAndtime forKey:@"time"];
    [sendvalue setValue:csud.username forKey:@"username"];
    SBJsonWriter *sbjsonwriter = [[SBJsonWriter alloc]init];
    
    NSString *jsons = [sbjsonwriter stringWithObject:sendvalue];
    NSLog(@"jsons=%@-------%@",jsons,[sbjsonwriter stringWithObject:[[NSDictionary alloc]initWithObjectsAndKeys:self.commentTextField.text,@"content", nil ]]);
    
    //[self getListData:[NSString stringWithFormat:@"%@%@",[[self getListIP]objectForKey:@"serverip"],[[self getListIP]objectForKey:@"subcommentIP"]] connection:listcommentCon jsons:jsons];
    [self getListData:[NSString stringWithFormat:@"%@%@",[[self getListIP]objectForKey:@"serverip"],[[self getListIP]objectForKey:@"enhancedDFA"]] connection:listcommentCon jsons:[sbjsonwriter stringWithObject:[[NSDictionary alloc]initWithObjectsAndKeys:self.commentTextField.text,@"content", nil ]]];
    contentjsonstr = jsons;
    //[self.commentTextField setText:@""];
    //[self.commentTView reloadData];
    [activityView startAnimating];
}

- (void)getListData:(NSString *)detailurl connection:(NSURLConnection *)connection jsons:(NSString*)jsons
{
    // Establish the post request
    NSString *body = [NSString stringWithFormat:@"jsons=%@",jsons];
    NSURL *url = [NSURL URLWithString:detailurl];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    //[urlRequest addValue:bodyLength forHTTPHeaderField:@"Content-Length"];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
    connection= [[NSURLConnection alloc] initWithRequest: urlRequest delegate: self];
    
    
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [reData appendData:data];
    NSString *rsp = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"getAllDataConnetion  Received data = %@  ", rsp);
    
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse *resp = (NSHTTPURLResponse *)response;
    NSLog(@"Response statusCode:    %lu", (long)resp.statusCode);
    statecode = (long)resp.statusCode;
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [activityView stopAnimating];
    NSLog(@"----------connection done!");
    NSString *rsp = [[NSString alloc] initWithData:reData encoding:NSUTF8StringEncoding];
    //[self.activityView stopAnimating];
    //[activityView setHidesWhenStopped:YES];
    NSLog(@"%@,%@",reData,rsp);
    if (statecode ==200) {
        if ([connection.currentRequest.URL.absoluteString isEqualToString:[NSString stringWithFormat:@"%@%@",[[self getListIP]objectForKey:@"serverip"],[[self getListIP]objectForKey:@"getcommentIP"]]]) {
            NSArray *dataArray = [[NSArray alloc]init];
            dataArray = [rsp JSONValue];
            int count = [dataArray count];
            NSLog(@"count=%d",count);
            [listUseraccount removeAllObjects];
            [self.listOfComment removeAllObjects];
            for (int i=0; i<count; i++) {
                
                [listUseraccount addObject:[[dataArray objectAtIndex:i]objectForKey:@"user_account"]];
                [self.listOfComment addObject:[[dataArray objectAtIndex:i]objectForKey:@"content"]];
                
            }
            [self.commentTView reloadData];
        }
        else
        {
            if ([connection.currentRequest.URL.absoluteString isEqualToString:[NSString stringWithFormat:@"%@%@",[[self getListIP]objectForKey:@"serverip"],[[self getListIP]objectForKey:@"enhancedDFA"]]]) {
                if ([[[rsp JSONValue]objectForKey:@"result"]isEqualToString:@"true"]) {
                    [self getListData:[NSString stringWithFormat:@"%@%@",[[self getListIP]objectForKey:@"serverip"],[[self getListIP]objectForKey:@"subcommentIP"]] connection:listcommentCon jsons:contentjsonstr];
                    contentjsonstr=@"";
                    
                }
                else{
                    UIAlertView * alerword = [[UIAlertView alloc]initWithTitle:@"注意" message:@"你评论的内容含有敏感词" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                    [alerword show];
                }
            }
            else
            {
                if ([rsp isEqualToString:@"{\"result\":\"true\"}"]) {
                    UIAlertView * alerword = [[UIAlertView alloc]initWithTitle:@"" message:@"你的评论审核中" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                    [alerword show];
                    [self.commentTextField setText:@""];
                }
                
                NSString *jsons =[NSString stringWithFormat:@"{\"tagid\":%d,\"state\":\"2\"}",self.articleid];
                [self getListData:[NSString stringWithFormat:@"%@%@",[[self getListIP]objectForKey:@"serverip"],[[self getListIP]objectForKey:@"getcommentIP"]] connection:listcommentCon jsons:jsons];
            }
        }
        
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"服务器出现错误"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
   
    [reData setLength:0];
    
    
         
    
    
}

-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [activityView stopAnimating];
    NSLog(@"connection error!");
    //[self.activityView stopAnimating];
    //[activityView setHidesWhenStopped:YES];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                        message:@"网络连接错误"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
    
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









@end
