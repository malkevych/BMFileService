//
//  SIApplicationSheetService.m
//  BoMalkevych
//
//  Created by Malkevych Bohdan Ihorovych on 11.03.16.
//  Copyright © 2016 Seductive. All rights reserved.
//

#import "SIApplicationSheetService.h"

@implementation SIApplicationSheetService

-(instancetype)initWithTitle:(NSString *)title image:(UIImage *)image tag:(NSInteger)tag {
    self = [super init];
    if (self) {
        self.title = title;
        self.image = image;
        self.tag = tag;
    }
    return self;
}

-(instancetype)initWithTitle:(NSString *)title imageName:(NSString *)imageName tag:(NSInteger)tag {
    self = [super init];
    if (self) {
        self.title = title;
        self.imageName = imageName;
        self.tag = tag;
    }
    return self;
}

@end
