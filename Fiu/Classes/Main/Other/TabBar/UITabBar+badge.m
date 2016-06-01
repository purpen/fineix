//
//  UITabBar+badge.m
//  badgeValue


#import "UITabBar+badge.h"
#import "Fiu.h"
#define tabBarItemNum 5
#define Constant 1000

@implementation UITabBar (badge)

- (void)showBadgeWithIndex:(long )index
{
    [self hideBadgeWithIndex:index];
    
    UIView *badgeView = [[UIView alloc] init];
    badgeView.tag = index + Constant;
    badgeView.layer.cornerRadius = 4;
    badgeView.backgroundColor = [UIColor colorWithHexString:fineixColor];
    int itemW = self.frame.size.width / tabBarItemNum;
    badgeView.frame = CGRectMake((int)((index + 0.68) * itemW)-10/667.0*SCREEN_HEIGHT +4, 3+3/667.0*SCREEN_HEIGHT, 8, 8);
    [self addSubview:badgeView];
}

- (void)hideBadgeWithIndex:(long )index
{
    if ([self viewWithTag:index + Constant])
    {
        [[self viewWithTag:index + Constant] removeFromSuperview];
    }
}

@end
