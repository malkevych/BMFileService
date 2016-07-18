//
//  SIQLPreviewController.h
//  BoMalkevych
//
//  Created by Malkevych Bohdan Ihorovych on 16.03.16.
//  Copyright © 2016 Seductive. All rights reserved.
//

#import <UIKit/UIKit.h>
@import QuickLook;

typedef NS_ENUM(NSInteger, TypeShowing) {
    TypeShowingSave,
    TypeShowingJustDisplay
};

@protocol SIQLPreviewControllerUploadingDelegate <NSObject>

-(void)onTouchDoneWithUrl:(NSURL *)localeFileUrl;
-(void)onTouchCloseWithUrl:(NSURL *)localeFileUrl;

@end

@interface SIQLPreviewController : QLPreviewController

@property (nonatomic, strong) id<QLPreviewItem> item;
@property (nonatomic, assign) TypeShowing typeShowing;
@property (nonatomic, weak) id<SIQLPreviewControllerUploadingDelegate> delegateUpload;

@end
