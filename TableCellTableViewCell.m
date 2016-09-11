//
//  TableCellTableViewCell.m
//  UADP
//
//  Created by hello world on 14-12-22.
//  Copyright (c) 2014年 csu. All rights reserved.
//

#import "TableCellTableViewCell.h"

@implementation TableCellTableViewCell
@synthesize contentLabel = _contentLabel;
@synthesize timeLabel = _timeLabel;
- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

@end
