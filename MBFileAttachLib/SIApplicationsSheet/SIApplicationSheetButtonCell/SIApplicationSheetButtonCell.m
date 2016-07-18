//
//  SIApplicationSheetButtonCell.m
//  BoMalkevych
//
//  Created by Malkevych Bohdan Ihorovych on 11.03.16.
//  Copyright © 2016 Seductive. All rights reserved.
//

#import "SIApplicationSheetButtonCell.h"

@interface SIApplicationSheetButtonCell()
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@end

@implementation SIApplicationSheetButtonCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)fillWithButton:(id<SIApplicationSheetButtonProtocol>)button {
    self.lblTitle.text = button.title;
#pragma mark TO DO Style
}

@end
