//
//  KpTabBarController.m
//  KpCustomTabbar
//
//  Created by Ketan on 4/20/16.
//  Copyright © 2016 kETAN pATEL. All rights reserved.
//

#import "KpTabBarController.h"
#import "KpTabBar.h"
#import "KpTabBarCONST.h"
#import "KpTabBarItem.h"

@interface KpTabBarController () <KpTabBarDelegate>

@property (nonatomic, strong) KpTabBar *kpTabBar;

@end

@implementation KpTabBarController

#pragma mark -

- (UIColor *)itemTitleColor {
    
    if (!_itemTitleColor) {
        
        _itemTitleColor = [UIColor darkGrayColor];
    }
    return _itemTitleColor;
}

- (UIColor *)selectedItemTitleColor {
    
    if (!_selectedItemTitleColor) {
        
        _selectedItemTitleColor = [UIColor blackColor];
    }
    return _selectedItemTitleColor;
}

- (UIFont *)itemTitleFont {
    
    if (!_itemTitleFont) {
        
        _itemTitleFont = [UIFont systemFontOfSize:10.0f];
    }
    return _itemTitleFont;
}

- (UIFont *)badgeTitleFont {
    
    if (!_badgeTitleFont) {
        
        _badgeTitleFont = [UIFont systemFontOfSize:11.0f];
    }
    return _badgeTitleFont;
}

#pragma mark -

- (void)loadView {
    
    [super loadView];
    
    self.itemImageRatio = 0.70f;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];

    [self.tabBar addSubview:({
        
        KpTabBar *tabBar = [[KpTabBar alloc] init];
        tabBar.frame     = self.tabBar.bounds;
        tabBar.delegate  = self;
        
        self.kpTabBar = tabBar;
    })];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self createCustomButton];
    
    [self removeOriginControls];
}



- (void) createCustomButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    /*[button addTarget:self
               action:@selector(aMethod:)
     forControlEvents:UIControlEventTouchUpInside];*/
    [button setTitle:@"Show View" forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor redColor]];
   
    button.frame = CGRectMake(80.0, 210.0, 160.0, 40.0);
    //[self.view addSubview:button];
}

- (void) addingCustomButton:(UIButton *)btn {
    [self.view addSubview:btn];
}
- (void)removeOriginControls {
    
    [self.tabBar.subviews enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        if ([obj isKindOfClass:[UIControl class]]) {
            
            [obj removeFromSuperview];
        }
    }];
}

- (void)setViewControllers:(NSArray *)viewControllers {
    
    self.kpTabBar.badgeTitleFont = self.badgeTitleFont;
    self.kpTabBar.itemTitleFont = self.itemTitleFont;
    self.kpTabBar.itemImageRatio = self.itemImageRatio;
    self.kpTabBar.itemTitleColor = self.itemTitleColor;
    self.kpTabBar.selectedItemTitleColor = self.selectedItemTitleColor;
    self.kpTabBar.bgColor = self.bgColor;
    
    self.kpTabBar.tabBarItemCount = viewControllers.count;
    
    [viewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        UIViewController *VC = (UIViewController *)obj;
        
        UIImage *selectedImage = VC.tabBarItem.selectedImage;
        VC.tabBarItem.selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        [self addChildViewController:VC];
        
        [self.kpTabBar addTabBarItem:VC.tabBarItem];
    }];
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    
    [super setSelectedIndex:selectedIndex];
    
    self.kpTabBar.selectedItem.selected = NO;
    self.kpTabBar.selectedItem = self.kpTabBar.tabBarItems[selectedIndex];
    self.kpTabBar.selectedItem.selected = YES;
}

#pragma mark - XXTabBarDelegate Method

- (void)tabBar:(KpTabBar *)tabBarView didSelectedItemFrom:(NSInteger)from to:(NSInteger)to {
    
    self.selectedIndex = to;
}

@end
