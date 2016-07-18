//
//  SIApplicationSheetService.h
//  BoMalkevych
//
//  Created by Malkevych Bohdan Ihorovych on 11.03.16.
//  Copyright © 2016 Seductive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SIApplicationSheetServiceProtocol.h"

@interface SIApplicationSheetService : NSObject <SIApplicationSheetServiceProtocol>

@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) UIImage * image;
@property (nonatomic, strong) NSString * imageName;
@property (nonatomic, assign) NSInteger tag;

-(instancetype)initWithTitle:(NSString *)title image:(UIImage *)image tag:(NSInteger)tag;
-(instancetype)initWithTitle:(NSString *)title imageName:(NSString *)imageName tag:(NSInteger)tag;

@end
