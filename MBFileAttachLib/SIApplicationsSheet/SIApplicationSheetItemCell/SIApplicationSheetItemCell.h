//
//  SIApplicationSheetItemCell.h
//  BoMalkevych
//
//  Created by Malkevych Bohdan Ihorovych on 11.03.16.
//  Copyright © 2016 Seductive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SIApplicationSheetServiceProtocol.h"

@interface SIApplicationSheetItemCell : UICollectionViewCell

-(void)fillWithService:(id<SIApplicationSheetServiceProtocol>)service;

@end
