//
//  customTableViewCell.m
//  HowToEat
//
//  Created by FangZ on 16/6/22.
//  Copyright © 2016年 FangZ. All rights reserved.
//

#import "customTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "juheDataModel.h"

@interface customTableViewCell()

@property (strong, nonatomic) IBOutlet UIImageView *headerImageView;

@property (strong, nonatomic) IBOutlet UILabel *headerTitle;

@property (strong, nonatomic) IBOutlet UILabel *detailTitle;

@end

@implementation customTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)showUIWithModel:(juheDataModel *)model{
    NSLog(@"%@", model.albums[0]);
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:model.albums[0]]];
    self.headerTitle.text = model.Title;
//    [self.headerTitle setTextColor:[UIColor redColor]];
    self.detailTitle.text = model.imtro;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
