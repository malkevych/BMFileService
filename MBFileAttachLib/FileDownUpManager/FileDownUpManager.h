//
//  FileDownUpManager.h
//  BoMalkevych
//
//  Created by Malkevych Bohdan Ihorovych on 16.03.16.
//  Copyright © 2016 Seductive. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileDownUpManager : NSObject

+(NSURL *)prepareLocalStorePathForStoreCV;
+(NSURL *)applicationDocumentsDirectory;
+(void)cleanAllChachedCVs;
+(NSURL *)CVsDirectory;

+(BOOL)saveData:(NSData *)file toUrl:(NSURL *)url;

@end
