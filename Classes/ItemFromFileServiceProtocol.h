//
//  ItemFromFileServiceProtocol.h
//  BoMalkevych
//
//  Created by Malkevych Bohdan Ihorovych on 15.03.16.
//  Copyright © 2016 Seductive. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, FSFileType) {
    FSFileTypeFolder,
    FSFileTypePdf,
    FSFileTypeDoc,
    FSFileTypeDocx,
    FSFileTypeOther
};

@protocol ItemFromFileServiceProtocol <NSObject>

@property (nonatomic, strong) NSString * title;
@property (nonatomic, assign) FSFileType fileType;
@property (nonatomic, strong) NSString * identifier;
@property (nonatomic, strong) NSString * mimeType;
@property (nonatomic, strong) NSString * extention;
@property (nonatomic, strong) NSString * serverPath;

-(BOOL)isFolder;
-(BOOL)isTrashed;

@end
