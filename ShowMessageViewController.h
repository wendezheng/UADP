//
//  ShowMessageViewController.h
//  UADP
//
//  Created by hello world on 14-12-17.
//  Copyright (c) 2014年 csu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowMessageViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *showMessageTableView;
@property(strong,nonatomic)NSMutableArray *listOfMessgae;
@property(strong,nonatomic)NSMutableArray *listOfMessageId;
@property(strong, nonatomic)NSMutableData *messageData;
@property(nonatomic)int appid;
@property(nonatomic,strong)NSMutableArray *isreadMuti;
@property(nonatomic,strong)NSMutableArray *listOfSendtime;
@property(nonatomic)long statedcode;
@end
