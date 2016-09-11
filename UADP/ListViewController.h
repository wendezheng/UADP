//
//  ListViewController.h
//  UADP
//
//  Created by hello world on 14-11-11.
//  Copyright (c) 2014年 csu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong) NSMutableArray *listOfTitle;
@property(nonatomic,strong) NSMutableArray *listOfID;
@property(nonatomic,strong) NSMutableArray *listOfLogo;
@property(nonatomic,strong) NSMutableArray *listOfPath;
@property(nonatomic,strong) NSMutableArray *listOfDeptcode;
@property(nonatomic,strong) NSMutableData  *articleData;
@property(nonatomic,strong) NSString *strCategoryName;
@property(nonatomic,strong) IBOutlet UITableView *listTable;
@property(nonatomic) int appID;
@property(nonatomic) long statecode;
@end

