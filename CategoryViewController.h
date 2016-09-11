//
//  CategoryViewController.h
//  UADP
//
//  Created by hello world on 14-12-8.
//  Copyright (c) 2014年 csu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryViewController : UIViewController
//@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
//@property(nonatomic,strong) NSMutableArray *listOfCategory;
//@property(nonatomic,strong) NSMutableArray *listOfAllArticleID;
//@property(nonatomic,strong) NSMutableArray *listOfAllArticleName;

@property(nonatomic,strong) NSMutableArray *listOfCategoryName;
@property(nonatomic,strong) NSMutableArray *listOfCategoryID;
@property(nonatomic) int appID,appTheme;
@property(nonatomic,strong) NSString *appName;
@property(nonatomic) long statecode;
@property(nonatomic,strong) NSMutableData *categorydata;
@end
