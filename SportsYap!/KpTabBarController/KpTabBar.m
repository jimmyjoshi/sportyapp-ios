//
//  KpTabBar.m
//  KpCustomTabbar
//
//  Created by Ketan on 4/20/16.
//  Copyright © 2016 kETAN pATEL. All rights reserved.
//

#import "KpTabBar.h"
#import "KpTabBarItem.h"
#import "SportsYap_-Swift.h"

@interface KpTabBar () {
    KpTabBarItem *lastSelected;
}

@end

@implementation KpTabBar

- (NSMutableArray *)tabBarItems {
    
    if (_tabBarItems == nil) {
        
        _tabBarItems = [[NSMutableArray alloc] init];
    }
    return _tabBarItems;
}

- (void)addTabBarItem:(UITabBarItem *)item {
    
    KpTabBarItem *tabBarItem = [[KpTabBarItem alloc] initWithItemImageRatio:self.itemImageRatio BgColor:self.bgColor];
    
    tabBarItem.badgeTitleFont         = self.badgeTitleFont;
    tabBarItem.itemTitleFont          = self.itemTitleFont;
    tabBarItem.itemTitleColor         = self.itemTitleColor;
    tabBarItem.selectedItemTitleColor = self.selectedItemTitleColor;
    
    tabBarItem.tabBarItemCount = self.tabBarItemCount;
    
    tabBarItem.tabBarItem = item;
    
    [tabBarItem addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchDown];
    
    [self addSubview:tabBarItem];
    
    [self.tabBarItems addObject:tabBarItem];
    
    if (self.tabBarItems.count == 1) {
        [self buttonClick:tabBarItem];
    }
    
    
    if(tabBarItem.tag == 2) {
        tabBarItem.frame = CGRectMake(tabBarItem.frame.origin.x, tabBarItem.frame.origin.y-14, tabBarItem.frame.size.width, tabBarItem.frame.size.height+14);
    }
    
}

- (void)buttonClick:(KpTabBarItem *)tabBarItem {
    
    if ([self.delegate respondsToSelector:@selector(tabBar:didSelectedItemFrom:to:)] && tabBarItem.tag < 4) {
        
        if(lastSelected != nil) {
            UILabel *temp = [lastSelected viewWithTag:1414];
            temp.textColor = [UIColor lightGrayColor];
        }
        
        lastSelected = tabBarItem;
        
        UILabel *temp = [tabBarItem viewWithTag:1414];
        temp.textColor = [UIColor blackColor];
        
        [self.delegate tabBar:self didSelectedItemFrom:self.selectedItem.tabBarItem.tag to:tabBarItem.tag];
        
        self.selectedItem.selected = NO;
        self.selectedItem = tabBarItem;
        self.selectedItem.selected = YES;
    }
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    CGFloat w = self.frame.size.width;
    CGFloat h = self.frame.size.height;
    
    int count = (int)self.tabBarItems.count;
    CGFloat itemY = 0;
    CGFloat itemW = w / self.subviews.count;
    CGFloat itemH = h;
    
    for (int index = 0; index < count; index++) {
        
        KpTabBarItem *tabBarItem = self.tabBarItems[index];
        tabBarItem.tag = index;
        CGFloat itemX = index * itemW;
        tabBarItem.frame = CGRectMake(itemX, itemY, itemW, itemH);
        
        UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, tabBarItem.frame.size.height-15, tabBarItem.frame.size.width-20, 10)];
        lblTitle.textAlignment = NSTextAlignmentCenter;
        lblTitle.font = [UIFont systemFontOfSize:10];
        lblTitle.textColor = [UIColor lightGrayColor];
        lblTitle.tag = 1414;
        
        if(index == 0) {
            lblTitle.text = @"Home";
            lblTitle.textColor = [UIColor blackColor];
        }
        else if(index == 1) {
            lblTitle.text = @"Discover";
        }
        else if(index == 2) {
            lblTitle.text = @"Me";
        }
        else {
            lblTitle.text = @"";
        }
        
        [tabBarItem addSubview:lblTitle];
    }
}

@end
