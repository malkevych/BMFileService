//
//  SFFileCell.m
//  BoMalkevych
//
//  Created by Malkevych Bohdan Ihorovych on 15.03.16.
//  Copyright © 2016 Seductive. All rights reserved.
//

#import "SFFileCell.h"

@implementation SFFileCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)prepareForReuse {
    [super prepareForReuse];
    self.accessoryType = UITableViewCellAccessoryNone;
}

@end
