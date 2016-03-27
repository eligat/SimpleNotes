//
//  UISplitViewController+ChildrenAccess.h
//  SimpleNotes
//
//  Created by eligat on 3/27/16.
//  Copyright © 2016 Oleg Sannikov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UISplitViewController (ChildrenAccess)
@property (nonatomic, readonly) UIViewController *masterVC;
@property (nonatomic, readonly) UIViewController *detailVC;

@end
