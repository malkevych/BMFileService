//
//  FileServiceProtocol.h
//  BoMalkevych
//
//  Created by Malkevych Bohdan Ihorovych on 10.03.16.
//  Copyright © 2016 Seductive. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^LoginHandlerHandler) (BOOL isSuccess, NSError * error);

@protocol FileServiceProtocol <NSObject>

@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSDictionary * keys;
@property (nonatomic, copy) LoginHandlerHandler loginHandler;

+(instancetype)service;
-(BOOL)isLogined;
-(void)logout;
-(void)loginWithVC:(UIViewController *)viewController;
-(id)currentSession;

@end
