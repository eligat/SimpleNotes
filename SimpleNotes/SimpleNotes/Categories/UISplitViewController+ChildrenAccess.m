//
//  UISplitViewController+ChildrenAccess.m
//  SimpleNotes
//
//  Created by eligat on 3/27/16.
//  Copyright © 2016 Oleg Sannikov. All rights reserved.
//

#import "UISplitViewController+ChildrenAccess.h"

@implementation UISplitViewController (ChildrenAccess)

#pragma mark - Accessors
- (UIViewController *)masterVC {
    return self.viewControllers.firstObject;
}

- (UIViewController *)detailVC {
    if (self.viewControllers.count > 1) {
        return (UIViewController *)self.viewControllers[1];
    }
    
    return nil;
}

@end
