//
//  CommentViewController.h
//  UADP
//
//  Created by hello world on 14-11-14.
//  Copyright (c) 2014年 csu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIAlertViewDelegate>
{
    
}

//@property (strong, nonatomic) IBOutlet UITextField *commentText;
//- (IBAction)sendComment:(id)sender;

@property (strong, nonatomic) IBOutlet UITableView *commentTView;
@property  BOOL keyboardIsShown;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property(strong,nonatomic)UITextField *commentTextField;
@property(strong,nonatomic)UIButton * sendButton;
@property(strong,nonatomic)NSMutableArray *listOfComment;
@property(nonatomic) int articleid;
@property(nonatomic,strong)NSString* deptcode;
@end
