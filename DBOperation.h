//
//  DBOperation.h
//  CSUMsgPush
//
//  Created by hello world on 14-4-24.
//  Copyright (c) 2014年 hello world. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "sqlite3.h"

@interface DBOperation : UIViewController
{
    //sqlite3* database;
}
- (void)initDB:(sqlite3 **)database;
-(void)openSQLiteDB:(sqlite3 **)database;
-(void)updateDB:(NSString*)rsql;
-(NSInteger)getCount:(NSString *)rsql;
-(NSMutableArray *)getArticle:(NSString *)rsql;
-(NSMutableArray *)getAllapp:(NSString*)rsql;
-(NSMutableArray *)getUserMsg:(NSString *)rsql;
-(NSMutableArray *)getMessage:(NSString*)rsql;
-(NSMutableArray *)getappArticle:(NSString *)rsql;
-(NSMutableArray *)getCategory:(NSString *)rsql;
@end
