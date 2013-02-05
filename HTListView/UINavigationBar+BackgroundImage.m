//
//  UINavigationBar+BackgroundImage.m
//  UICustomization
//
//  Created by Nikita Leonov on 4/19/11.
//  Copyright 2011 leonov.co. All rights reserved.
//

#import "UINavigationBar+BackgroundImage.h"
#import <QuartzCore/QuartzCore.h>

@implementation UINavigationBar (BackgroundImage)
- (void)setBackgroundImage:(UIImage*)backgroundImage {
    self.layer.contents = (id)backgroundImage.CGImage;
}
@end
