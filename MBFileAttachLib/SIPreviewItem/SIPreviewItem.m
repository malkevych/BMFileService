//
//  SIPreviewItem.m
//  BoMalkevych
//
//  Created by Malkevych Bohdan Ihorovych on 16.03.16.
//  Copyright © 2016 Seductive. All rights reserved.
//

#import "SIPreviewItem.h"

@implementation SIPreviewItem

-(instancetype)initWithPath:(NSString *)path title:(NSString *)title {
    self = [super init];
    if (self) {
        self.previewItemURL = [NSURL fileURLWithPath:path];
        self.previewItemTitle = title;
    }
    return self;
}

-(instancetype)initWithUrl:(NSURL *)url title:(NSString *)title {
    self = [super init];
    if (self) {
        self.previewItemURL = url;
        self.previewItemTitle = title;
    }
    return self;
}

@end
