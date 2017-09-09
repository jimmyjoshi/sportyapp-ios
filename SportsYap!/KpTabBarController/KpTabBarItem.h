//
//  KpTabBarItem.h
//  KpCustomTabbar
//
//  Created by Ketan on 4/20/16.
//  Copyright © 2016 kETAN pATEL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KpTabBarItem : UIButton

@property (nonatomic, strong) UITabBarItem *tabBarItem;
@property (nonatomic, assign) NSInteger tabBarItemCount;
@property (nonatomic, strong) UIColor *itemTitleColor;
@property (nonatomic, strong) UIColor *selectedItemTitleColor;
@property (nonatomic, strong) UIFont *itemTitleFont;
@property (nonatomic, strong) UIFont *badgeTitleFont;
@property (nonatomic, assign) CGFloat itemImageRatio;

- (instancetype)initWithItemImageRatio:(CGFloat)itemImageRatio BgColor:(UIColor *)bgColor;

@end
