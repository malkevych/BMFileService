//
//  SIApplicationSheetButton.h
//  BoMalkevych
//
//  Created by Malkevych Bohdan Ihorovych on 11.03.16.
//  Copyright © 2016 Seductive. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM (NSInteger, SIButtonStyle) {
    SIApplicationSheetButtonTypeDefault,
    SIApplicationSheetButtonTypeRed // unimplemented
};

@protocol SIApplicationSheetButtonProtocol <NSObject>

@property (nonatomic, strong) NSString * title;
@property (nonatomic, assign) SIButtonStyle style;

@end
