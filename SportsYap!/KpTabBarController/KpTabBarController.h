//
//  KpTabBarController.h
//  KpCustomTabbar
//
//  Created by Ketan on 4/20/16.
//  Copyright © 2016 kETAN pATEL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KpTabBarController : UITabBarController

@property (nonatomic, strong) UIColor *itemTitleColor;
@property (nonatomic, strong) UIColor *selectedItemTitleColor;
@property (nonatomic, strong) UIFont *itemTitleFont;
@property (nonatomic, strong) UIFont *badgeTitleFont;
@property (nonatomic, assign) CGFloat itemImageRatio;
@property (nonatomic, strong) UIColor *bgColor;

- (void)removeOriginControls;
- (void)createCustomButton;
- (void)addingCustomButton:(UIButton*)btn;
@end
