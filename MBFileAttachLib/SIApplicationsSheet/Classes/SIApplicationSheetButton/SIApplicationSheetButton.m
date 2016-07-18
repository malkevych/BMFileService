//
//  ApplicationSheetButton.m
//  BoMalkevych
//
//  Created by Malkevych Bohdan Ihorovych on 11.03.16.
//  Copyright © 2016 Seductive. All rights reserved.
//

#import "SIApplicationSheetButton.h"

@implementation SIApplicationSheetButton

-(instancetype)initWithTitle:(NSString *)title style:(SIButtonStyle)style {
    self = [super init];
    if (self) {
        self.title = title;
        self.style = style;
    }
    return self;
}

@end
