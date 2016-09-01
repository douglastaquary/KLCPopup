//
//  UIResponder+KLCPopup.m
//  KLCPopup
//
//  Created by Adriano on 8/31/16.
//  Copyright © 2016 Kullect. All rights reserved.
//

#import "UIResponder+KLCPopup.h"
#import <objc/runtime.h>

NSString *const KLCPopupFirstResponderDidChangeNotification = @"KLCPopupFirstResponderDidChangeNotification";

@implementation UIResponder (KLCPopup)

+ (void)load
{
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		[self swizzleSelector:@selector(becomeFirstResponder) toSelector:@selector(st_becomeFirstResponder)];
	});
}

+ (void)swizzleSelector:(SEL)originalSelector toSelector:(SEL)swizzledSelector
{
	Class class = [self class];
	
	Method originalMethod = class_getInstanceMethod(class, originalSelector);
	Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
	method_exchangeImplementations(originalMethod, swizzledMethod);
}

- (BOOL)st_becomeFirstResponder
{
	BOOL accepted = [self st_becomeFirstResponder];
	if (accepted) {
		[[NSNotificationCenter defaultCenter]
		 postNotificationName:KLCPopupFirstResponderDidChangeNotification
		 object:self];
	}
	return accepted;
}

@end

