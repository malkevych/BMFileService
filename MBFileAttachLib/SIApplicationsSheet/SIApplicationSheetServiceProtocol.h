//
//  SIApplicationSheetService.h
//  BoMalkevych
//
//  Created by Malkevych Bohdan Ihorovych on 11.03.16.
//  Copyright © 2016 Seductive. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SIApplicationSheetServiceProtocol <NSObject>

@property (nonatomic, strong) NSString * title;
@property (nonatomic, assign) NSInteger tag;

@optional
@property (nonatomic, strong) UIImage * image;
@property (nonatomic, strong) NSString * imageName;

@end
