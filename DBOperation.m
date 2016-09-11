//
//  DBOperation.m
//  CSUMsgPush
//
//  Created by hello world on 14-4-24.
//  Copyright (c) 2014年 hello world. All rights reserved.
//

#import "DBOperation.h"
#import "CSUAppDelegate.h"
@interface DBOperation ()

@end

@implementation DBOperation

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
}

-(void)openSQLiteDB:(sqlite3 **)database
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* dbFileName = @"uadp.db";
    NSString *dataFilePath = [documentsDirectory stringByAppendingPathComponent:dbFileName];
    NSLog(@"%@",dataFilePath);
    if (sqlite3_open([dataFilePath UTF8String], database) != SQLITE_OK)
    {
        sqlite3_close(*database);
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"打开数据库文件失败"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles: nil];
        [alert show];
    }
}

- (void)initDB:(sqlite3 **)database
{
    char *errorMsg;
    NSString *sql1 =@"CREATE TABLE IF NOT EXISTS user(userid integer primary key,account text,password text,username text,deptid integer,sort integer,gender text,tel text,mail text);";
    
    NSString *sql =@"CREATE TABLE IF NOT EXISTS message(msgid integer primary key,userid integer,appid integer,content text,isread integer,sendtime text,sender text,msgstate text);";

    NSString *sql2 =@"create table IF NOT EXISTS app(appid integer primary key,appname text,appdata text,appsubmitter text,appsubmittime text,applogo text,appowner text,applastediter text,applastedittime text,applabel text,appexplain text,appstate text,deptcode text);";
    
     NSString *sql3 =@"create table IF NOT EXISTS category(modelid integer primary key,modelname text,appid integer,state text);";
    
     NSString *sql4 =@"create table IF NOT EXISTS apparticle(apaid integer,appid integer,modelname text,articleid integer,state text,primary key(appid,modelname,articleid));";

//     NSString *sql4 =@"create table IF NOT EXISTS apparticle(apaid integer primary key,appid integer,modelname text,articleid integer,state text);";
    
    NSString *sql5 =@"create table IF NOT EXISTS article(aid integer primary key,userid text,apath text,alabel text,atitle text,asubmitter text,asubmittime text,alastediter text,alastedittime text,aexplain text,atype text,alogo text,aowner text);";
    if (sqlite3_exec(*database, [sql UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK || sqlite3_exec(*database, [sql1 UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK ||sqlite3_exec(*database, [sql2 UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK ||sqlite3_exec(*database, [sql3 UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK ||sqlite3_exec(*database, [sql4 UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK || sqlite3_exec(*database, [sql5 UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK)
    {
        sqlite3_close(*database);
    }
}

-(NSMutableArray *)getArticle:(NSString *)rsql
{
    NSMutableArray *tempArray=[[NSMutableArray alloc]init];
    CSUAppDelegate *appDelegate=[[UIApplication sharedApplication]delegate];
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(appDelegate->database, [rsql UTF8String], -1, &statement, NULL) != SQLITE_OK)
    {
        NSLog(@"Error: failed to prepare statement with message:get channels.");
    }
    //查询结 果集中一条一条的遍历所有的记录，这里的数字对应的是列值。
    while (sqlite3_step(statement) == SQLITE_ROW)
    {//(aid integer primary key,userid text,apath text,alabel text,atitle text,asubmitter text,asubmittime text,alastediter text,alastedittime text,aexplain text,atype text,alogo text,aowner text)
        int aid =(int)sqlite3_column_int(statement, 0);
        int uid = (int)sqlite3_column_int(statement, 1);
        char *apath= (char *)sqlite3_column_text(statement,2);
        char *alabel = (char *)sqlite3_column_text(statement, 3);
        char* atitle = (char*)sqlite3_column_text(statement, 4);
        char* asubmitter = (char*)sqlite3_column_text(statement, 5);
        char* asubmittime = (char*)sqlite3_column_text(statement, 6);
        char* alastediter = (char*)sqlite3_column_text(statement, 7);
        char *alastedittime = (char *)sqlite3_column_text(statement, 8);
        char* aexplain = (char*)sqlite3_column_text(statement, 9);
        char* atype = (char*)sqlite3_column_text(statement, 10);
        char* alogo = (char*)sqlite3_column_text(statement, 11);
        char* aowner = (char*)sqlite3_column_text(statement, 12);
        
        NSString* apathStr= [NSString stringWithUTF8String:apath];
        NSString* alabelStr = [NSString stringWithUTF8String:alabel];
        NSString *atitleStr=[NSString stringWithUTF8String:atitle];
        NSString *gasubmitterStr=[NSString stringWithUTF8String:asubmitter];
        NSString *asubmittimeStr=[NSString stringWithUTF8String:asubmittime];
        NSString *alastediterStr=[NSString stringWithUTF8String:alastediter];
        NSString* alastedittimeStr = [NSString stringWithUTF8String:alastedittime];
        NSString *aexplainStr=[NSString stringWithUTF8String:aexplain];
        NSString *atypeStr=[NSString stringWithUTF8String:atype];
        NSString *alogoStr=[NSString stringWithUTF8String:alogo];
        NSString *aownerStr=[NSString stringWithUTF8String:aowner];

        
        NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:aid] ,@"aid",[NSNumber numberWithInteger:uid],@"uid",apathStr,@"apath",alabelStr,@"alabel",atitleStr,@"atitle",gasubmitterStr,@"asubmitter",asubmittimeStr,@"asubmittime",alastediterStr,@"alastediter",alastedittimeStr,@"alastedittime",aexplainStr,@"aexplain",atypeStr,@"atype",alogoStr,@"alogo",aownerStr,@"aowner",nil];
        [tempArray addObject:dic];
        
    }
    
    
    NSLog(@"%@",tempArray);
    return tempArray;
}







-(NSMutableArray *)getCategory:(NSString *)rsql
{
    NSMutableArray *tempArray=[[NSMutableArray alloc]init];
    CSUAppDelegate *appDelegate=[[UIApplication sharedApplication]delegate];
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(appDelegate->database, [rsql UTF8String], -1, &statement, NULL) != SQLITE_OK)
    {
        NSLog(@"Error: failed to prepare statement with message:get channels.");
    }
    //查询结 果集中一条一条的遍历所有的记录，这里的数字对应的是列值。
    while (sqlite3_step(statement) == SQLITE_ROW)
    {//(modelid integer primary key,modelname text,appid integer,state text)
        int modelid =(int)sqlite3_column_int(statement, 0);
        char* modelname = (char*)sqlite3_column_text(statement, 1);
        int appid = (int)sqlite3_column_int(statement, 2);
        char* state = (char*)sqlite3_column_text(statement, 3);
        
        
        NSString* modelnameStr= [NSString stringWithUTF8String:modelname];
        NSString* stateStr = [NSString stringWithUTF8String:state];
        
        NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:modelid] , @"modelid",modelnameStr,@"modelname",[NSNumber numberWithInteger:appid] , @"appid",stateStr,@"state",nil];
        [tempArray addObject:dic];
        
    }
    
    
    NSLog(@"%@",tempArray);
    return tempArray;
}


-(NSMutableArray *)getappArticle:(NSString *)rsql
{
    NSMutableArray *tempArray=[[NSMutableArray alloc]init];
    CSUAppDelegate *appDelegate=[[UIApplication sharedApplication]delegate];
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(appDelegate->database, [rsql UTF8String], -1, &statement, NULL) != SQLITE_OK)
    {
        NSLog(@"Error: failed to prepare statement with message:get channels.");
    }
    //查询结 果集中一条一条的遍历所有的记录，这里的数字对应的是列值。
    while (sqlite3_step(statement) == SQLITE_ROW)
    {//(apaid integer primary key,appid integer,modelname text,articleid integer,state text
        int apaid =(int)sqlite3_column_int(statement, 0);
        int appid =(int)sqlite3_column_int(statement, 1);
        char* modelname = (char*)sqlite3_column_text(statement, 2);
        int articleid =(int)sqlite3_column_int(statement, 3);
        char* state = (char*)sqlite3_column_text(statement, 4);
        
        
        
        NSString* modelanameStr= [NSString stringWithUTF8String:modelname];
        NSString* stateStr = [NSString stringWithUTF8String:state];
;
        
        NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:apaid] , @"apaid",[NSNumber numberWithInteger:appid],@"appid",[NSNumber numberWithInt:articleid],@"articleid",modelanameStr,@"modelname",stateStr,@"state",nil];
        [tempArray addObject:dic];
        
    }
    
    
    NSLog(@"%@",tempArray);
    return tempArray;
}







-(NSMutableArray *)getUserMsg:(NSString *)rsql
{
    NSMutableArray *tempArray=[[NSMutableArray alloc]init];
        CSUAppDelegate *appDelegate=[[UIApplication sharedApplication]delegate];
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(appDelegate->database, [rsql UTF8String], -1, &statement, NULL) != SQLITE_OK)
    {
        NSLog(@"Error: failed to prepare statement with message:get channels.");
    }
    //查询结 果集中一条一条的遍历所有的记录，这里的数字对应的是列值。
    while (sqlite3_step(statement) == SQLITE_ROW)
    {//(userid integer primary key,account text,password text,username text,deptid integer,sort integer,gender text,tel text,mail text)
        int userid =(int)sqlite3_column_int(statement, 0);
        char *account= (char *)sqlite3_column_text(statement,1);
        char *password = (char *)sqlite3_column_text(statement, 2);
        char* userName = (char*)sqlite3_column_text(statement, 3);
        int deptid = (int)sqlite3_column_int(statement, 4);
        int sort =(int)sqlite3_column_int(statement, 5);
        char* gender = (char*)sqlite3_column_text(statement, 6);
        char* tel = (char*)sqlite3_column_text(statement, 7);
        char* mail = (char*)sqlite3_column_text(statement, 8);
        
    
        NSString* userNameStr= [NSString stringWithUTF8String:userName];
        NSString* accoountStr = [NSString stringWithUTF8String:account];
        NSString *passwordStr=[NSString stringWithUTF8String:password];
        NSString *genderStr=[NSString stringWithUTF8String:gender];
        NSString *telStr=[NSString stringWithUTF8String:tel];
        NSString *mailStr=[NSString stringWithUTF8String:mail];
        
        NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:userid] , @"userid",accoountStr,@"account",userNameStr,@"username", passwordStr,@"password",[NSNumber numberWithInteger:deptid] , @"deptid",[NSNumber numberWithInt:sort],@"sort",genderStr,@"gender",telStr,@"tel",mailStr,@"mail",nil];
        [tempArray addObject:dic];
        
    }

    
    NSLog(@"%@",tempArray);
    return tempArray;
}




-(NSMutableArray *)getAllapp:(NSString*)rsql
{
    NSMutableArray *tempArray=[[NSMutableArray alloc]init];
    CSUAppDelegate *appDelegate=[[UIApplication sharedApplication]delegate];
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(appDelegate->database, [rsql UTF8String], -1, &statement, NULL) != SQLITE_OK)
    {
        NSLog(@"Error: failed to prepare statement with message:get channels.");
    }
    //查询结 果集中一条一条的遍历所有的记录，这里的数字对应的是列值。
    while (sqlite3_step(statement) == SQLITE_ROW)
    {
        
        
        int appid =(int)sqlite3_column_int(statement, 0);
        char* appname = (char*)sqlite3_column_text(statement, 1);
        char* appdata = (char*)sqlite3_column_text(statement, 2);
        char *appsubter= (char*)sqlite3_column_text(statement, 3);
        char *appsubtime =(char*)sqlite3_column_text(statement, 4);
        char* applogo = (char*)sqlite3_column_text(statement, 5);
         char* appowner = (char*)sqlite3_column_text(statement, 6);
        //int appowner =(int)sqlite3_column_int(statement, 6);
        char *applastediter= (char*)sqlite3_column_text(statement, 7);
        char* applastedittime = (char*)sqlite3_column_text(statement, 8);
        char* applabel = (char*)sqlite3_column_text(statement, 9);
        char* appexplain = (char*)sqlite3_column_text(statement, 10);
        char *appstate= (char*)sqlite3_column_text(statement, 11);
        char * deptcode = (char*)sqlite3_column_text(statement, 12);
        
        NSString* appownerStr= [NSString stringWithUTF8String:appowner];
        NSString* appnameStr= [NSString stringWithUTF8String:appname];
        NSString* appdataStr = [NSString stringWithUTF8String:appdata];
        NSString *appsubmitterStr=[NSString stringWithUTF8String:appsubter];
        NSString* appsubtimeStr= [NSString stringWithUTF8String:appsubtime];
        NSString* applogoStr= [NSString stringWithUTF8String:applogo];
        NSString* applastediterStr = [NSString stringWithUTF8String:applastediter];
        NSString* applastedittimeStr= [NSString stringWithUTF8String:applastedittime];
        NSString* applabelStr= [NSString stringWithUTF8String:applabel];
        NSString* appexplainStr = [NSString stringWithUTF8String:appexplain];
        NSString *appstateStr=[NSString stringWithUTF8String:appstate];
        NSString *deptcodeStr = [NSString stringWithUTF8String:deptcode];
        NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:appid],@"appid",appnameStr,@"appname",appdataStr, @"appdata",appsubmitterStr,@"appsubmitter",appsubtimeStr,@"appsubmittime",applogoStr,@"applogo",/*[NSNumber numberWithInteger:appowner]*/appownerStr, @"appowner",applastediterStr,@"applastediter",applastedittimeStr,@"applastedittime",applabelStr,@"applabel",appexplainStr,@"appexplain",appstateStr,@"appstate",deptcodeStr,@"deptcode",nil];
        [tempArray addObject:dic];
    }
    
    NSLog(@"%@",tempArray);
    return tempArray;

}


-(NSMutableArray *)getMessage:(NSString*)rsql
{
    NSMutableArray *tempArray=[[NSMutableArray alloc]init];
    CSUAppDelegate *appDelegate=[[UIApplication sharedApplication]delegate];
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(appDelegate->database, [rsql UTF8String], -1, &statement, NULL) != SQLITE_OK)
    {
        NSLog(@"Error: failed to prepare statement with message:get channels.");
    }
    //查询结 果集中一条一条的遍历所有的记录，这里的数字对应的是列值。
    while (sqlite3_step(statement) == SQLITE_ROW)
    {//(msgid integer primary key,userid integer,appid integer,content text,isread integer,sendtime text,sender text,msgstate text);";
        
        int msgid = (int)sqlite3_column_int(statement, 0);
        int userid =(int)sqlite3_column_int(statement, 1);
        int appid = (int)sqlite3_column_int(statement, 2);
        char* content = (char*)sqlite3_column_text(statement, 3);
        int isread= (int)sqlite3_column_int(statement, 4);
        char *sendtime = (char *)sqlite3_column_text(statement, 5);
        char *sender = (char *)sqlite3_column_text(statement, 6);
        char *messagestate = (char *) sqlite3_column_text(statement, 7);
        
        NSString* contentStr= [NSString stringWithUTF8String:content];
        NSString* sendtimeStr= [NSString stringWithUTF8String:sendtime];
        NSString* senderStr = [NSString stringWithUTF8String:sender];
        NSString *messageStr=[NSString stringWithUTF8String:messagestate];
        NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:msgid], @"msgid",[NSNumber numberWithInt:userid],@"userid",[NSNumber numberWithInteger:appid], @"appid",contentStr,@"content",[NSNumber numberWithInt:isread],@"isread",sendtimeStr, @"sendtime",senderStr,@"sender",messageStr,@"msgstate",nil];
        [tempArray addObject:dic];
    }
    
    NSLog(@"%@",tempArray);
    return tempArray;
    
}



-(NSInteger)getCount:(NSString *)rsql
{
    CSUAppDelegate *appDelegate=[[UIApplication sharedApplication]delegate];
    sqlite3_stmt *statement;
    NSInteger count = 0;
    if (sqlite3_prepare_v2(appDelegate->database,[rsql UTF8String], -1, &statement, NULL) != SQLITE_OK)
    {
        NSLog(@"Error: failed to prepare statement with message:get channels.");
    }
    if (sqlite3_step(statement)==SQLITE_ROW) {
        count = sqlite3_column_int(statement, 0);
    }
    return count;
}





-(void)updateDB:(NSString*)rsql
{
    CSUAppDelegate *appDelegate=[[UIApplication sharedApplication]delegate];
    sqlite3_stmt *statement;
   // NSLog(@"%@",rsql);
    if (sqlite3_prepare_v2(appDelegate->database,[rsql UTF8String], -1, &statement, NULL) != SQLITE_OK)
    {
        NSLog(@"Error: failed to prepare statement with message:get channels.");
    }
    if (sqlite3_step(statement) != SQLITE_DONE)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"执行数据库操作失败"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles: nil];
        [alert show];
    }


}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
