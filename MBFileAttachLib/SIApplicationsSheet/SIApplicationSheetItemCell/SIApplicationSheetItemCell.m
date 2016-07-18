//
//  SIApplicationSheetItemCell.m
//  BoMalkevych
//
//  Created by Malkevych Bohdan Ihorovych on 11.03.16.
//  Copyright © 2016 Seductive. All rights reserved.
//

#import "SIApplicationSheetItemCell.h"

@interface SIApplicationSheetItemCell()

@property (weak, nonatomic) IBOutlet UIImageView *imgLogo;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@end

@implementation SIApplicationSheetItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.imgLogo.layer.cornerRadius = 15;
    self.imgLogo.layer.masksToBounds = YES;
}

-(void)fillWithService:(id<SIApplicationSheetServiceProtocol>)service {
    [self setImageForService:service];
    self.lblTitle.text = service.title;
}

-(void)setImageForService:(id<SIApplicationSheetServiceProtocol>)service {
    __weak typeof(self) weakSelf = self;
    if (service.image) {
        [self.imgLogo setImage:service.image];
    } else {
        __block UIImage * img = nil;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            img = [UIImage imageNamed:service.imageName];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.imgLogo setImage:img];
            });
        });
    }
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    if (selected) {
        [self animateSelection];
    } else {
        [self animateDeselection];
    }
}

-(void) animateSelection {
#warning  TO DO
}

-(void) animateDeselection {
#warning  TO DO
}

@end
