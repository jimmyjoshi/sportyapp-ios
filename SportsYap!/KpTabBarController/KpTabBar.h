//
//  KpTabBar.h
//  KpCustomTabbar
//
//  Created by Ketan on 4/20/16.
//  Copyright © 2016 kETAN pATEL. All rights reserved.
//

#import <UIKit/UIKit.h>


@class KpTabBar, KpTabBarItem;

@protocol KpTabBarDelegate <NSObject>

@optional
- (void)tabBar:(KpTabBar *)tabBarView didSelectedItemFrom:(NSInteger)from to:(NSInteger)to;
@end



@interface KpTabBar : UIView

@property (nonatomic, strong) UIColor *itemTitleColor;
@property (nonatomic, strong) UIColor *selectedItemTitleColor;
@property (nonatomic, strong) UIFont *itemTitleFont;
@property (nonatomic, strong) UIFont *badgeTitleFont;
@property (nonatomic, assign) CGFloat itemImageRatio;
@property (nonatomic, assign) NSInteger tabBarItemCount;
@property (nonatomic, strong) KpTabBarItem *selectedItem;
@property (nonatomic, strong) NSMutableArray *tabBarItems;
@property (nonatomic, strong) UIColor *bgColor;

@property (nonatomic, weak) id<KpTabBarDelegate> delegate;

- (void)addTabBarItem:(UITabBarItem *)item;

@end
