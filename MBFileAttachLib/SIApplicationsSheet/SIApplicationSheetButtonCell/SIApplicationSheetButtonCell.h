//
//  SIApplicationSheetButtonCell.h
//  BoMalkevych
//
//  Created by Malkevych Bohdan Ihorovych on 11.03.16.
//  Copyright © 2016 Seductive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SIApplicationSheetButtonProtocol.h"

@interface SIApplicationSheetButtonCell : UITableViewCell

-(void)fillWithButton:(id<SIApplicationSheetButtonProtocol>)button;


@end
