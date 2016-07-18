//
//  ApplicationSheetButton.h
//  BoMalkevych
//
//  Created by Malkevych Bohdan Ihorovych on 11.03.16.
//  Copyright © 2016 Seductive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SIApplicationSheetButtonProtocol.h"

@interface SIApplicationSheetButton : NSObject <SIApplicationSheetButtonProtocol>

@property (nonatomic, strong) NSString * title;
@property (nonatomic, assign) SIButtonStyle style;

-(instancetype)initWithTitle:(NSString *)title style:(SIButtonStyle)style;

@end
