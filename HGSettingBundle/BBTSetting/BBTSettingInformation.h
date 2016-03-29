//
//  BBTSettingInformation.h
//  HGSettingBundle
//
//  Created by XiaoDou on 3/29/16.
//  Copyright © 2016 北京嗨购电子商务有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^BSRestSettingInfoBlock)();

@interface BBTSettingInformation : NSObject
@property (nonatomic, assign) BOOL testModeEnabled;

+ (BBTSettingInformation *)shareInstance;
- (void)resetSettingInfoIfNeeded:(BSRestSettingInfoBlock)block;

@end
