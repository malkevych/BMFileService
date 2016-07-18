//
//  UINavigationController+Rotated.m
//  BoMalkevych
//
//  Created by Malkevych Bohdan Ihorovych on 18.03.16.
//  Copyright © 2016 Seductive. All rights reserved.
//

#import "UINavigationController+Rotated.h"
#import "SIRotatedNC.h"

@implementation UINavigationController (Rotated)

-(BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if ([self isKindOfClass:[SIRotatedNC class]]) {
        return UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight | UIInterfaceOrientationMaskPortrait;
    }
    return UIInterfaceOrientationMaskPortrait;
}

@end
