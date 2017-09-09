//
//  KpTabBarBadge.h
//  KpCustomTabbar
//
//  Created by Ketan on 4/20/16.
//  Copyright © 2016 kETAN pATEL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KpTabBarBadge : UIButton

@property (nonatomic, copy) NSString *badgeValue;
@property (nonatomic, assign) NSInteger tabBarItemCount;
@property (nonatomic, strong) UIFont *badgeTitleFont;

@end
