//
//  CQDMModuleModel.m
//  CJBaseUtilDemo
//
//  Created by ciyouzen on 2016/11/23.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import "CQDMModuleModel.h"

@implementation CQDMModuleModel

- (NSBundle *)xibBundle {
    NSBundle *xibBundle = _xibBundle;
    if (xibBundle == nil && _xibBundleName != nil) {
        Class classEntry = self.classEntry;
        //NSString *clsString = NSStringFromClass(classEntry);
        NSBundle *bundle = [NSBundle bundleForClass:classEntry];
        NSString *bundleName = self.xibBundleName;
        NSURL *url = [bundle URLForResource:bundleName withExtension:@"bundle"];
        xibBundle = [NSBundle bundleWithURL:url];
    }
    return xibBundle;
}

- (void)updateContent:(NSString *)content {
    NSString *lastContentString = self.content;
    
    NSArray<NSString *> *components = [self.content componentsSeparatedByString:@"\n"];
    if (components.count > self.contentLines) {
        NSArray *firstTwoComponents = [components subarrayWithRange:NSMakeRange(0, self.contentLines)];
        lastContentString = [firstTwoComponents componentsJoinedByString:@"\n"];
    }
    
    self.content = content;
    
}

@end
