//
//  SIPreviewItem.h
//  BoMalkevych
//
//  Created by Malkevych Bohdan Ihorovych on 16.03.16.
//  Copyright © 2016 Seductive. All rights reserved.
//

#import <Foundation/Foundation.h>
@import QuickLook;

@interface SIPreviewItem : NSObject <QLPreviewItem>

@property(nonatomic, strong) NSURL * previewItemURL;
@property(nonatomic, strong) NSString * previewItemTitle;

-(instancetype)initWithPath:(NSString *)path title:(NSString *)title;
-(instancetype)initWithUrl:(NSURL *)url title:(NSString *)title;

@end
