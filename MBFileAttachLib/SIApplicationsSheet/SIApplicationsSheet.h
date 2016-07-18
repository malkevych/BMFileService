//
//  SIApplicationsSheet.h
//  BoMalkevych
//
//  Created by Malkevych Bohdan Ihorovych on 11.03.16.
//  Copyright © 2016 Seductive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SIApplicationSheetButtonProtocol.h"
#import "SIApplicationSheetServiceProtocol.h"
#import "SIApplicationSheetButton.h"
#import "SIApplicationSheetService.h"

@protocol SIApplicationsSheetDelegate <NSObject>
@optional
-(void)onTouchedButtonIndex:(NSNumber *)index;
-(void)onTouchedServiceWithTag:(NSNumber *)index;

@end

@interface SIApplicationsSheet : UIView

@property (nonatomic, strong) NSArray <SIApplicationSheetButtonProtocol>* buttons;
@property (nonatomic, strong) NSArray <SIApplicationSheetServiceProtocol>* services;
@property (nonatomic, weak) id<SIApplicationsSheetDelegate> delegate;

+(void)showWithButtons:(NSArray <SIApplicationSheetButtonProtocol>*)buttons services:(NSArray <SIApplicationSheetServiceProtocol>*)services delegate:(id<SIApplicationsSheetDelegate>)delegate;
-(void)show;

@end
