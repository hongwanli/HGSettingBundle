//
//  BBTSettingInformation.m
//  HGSettingBundle
//
//  Created by XiaoDou on 3/29/16.
//  Copyright © 2016 北京嗨购电子商务有限公司. All rights reserved.
//

#import "BBTSettingInformation.h"
#import "BBTSettingInformationDefine.h"

@interface BBTSettingInformation () {
    BOOL _testModeDidChanged;
}

@end

@implementation BBTSettingInformation

#pragma mark ########################## Public ##########################

+ (BBTSettingInformation *)shareInstance {
    static BBTSettingInformation *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[BBTSettingInformation alloc] init];
    });
    
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _testModeEnabled = NO;
        _testModeDidChanged = NO;
    }
    
    return self;
}

- (void)resetSettingInfoIfNeeded:(BSRestSettingInfoBlock)block {
    [self loadSettingInfomationFromUserDefaults];
    if (_testModeDidChanged) {
        block();
    }
}

#pragma mark ########################## Private ##########################

- (void)loadSettingInfomationFromUserDefaults {
    [self loadSettingInfomationFromSettingBundle];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    _testModeEnabled = [userDefaults boolForKey:kPerferenceTestModeEnabledKey];
    BOOL lastTestModeEnabled = [userDefaults boolForKey:kPerferenceLastTestModeEnabled];
    
    if (lastTestModeEnabled != _testModeEnabled) {
        [userDefaults setBool:_testModeEnabled forKey:kPerferenceLastTestModeEnabled];
        _testModeDidChanged = YES;
    }
}

- (void)loadSettingInfomationFromSettingBundle {
    NSString *settingBundle = [[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"bundle"];
    
    if (!settingBundle) {
        NSLog(@"Settings.bundle 不存在!");
        return;
    }
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *settingsPlist = [[NSDictionary alloc] initWithContentsOfFile:[settingBundle stringByAppendingPathComponent:@"Root.plist"]];
    NSArray *perferenceSpecifiers = [settingsPlist objectForKey:@"PreferenceSpecifiers"];
    
    NSMutableDictionary *defaultsToRegister = [[NSMutableDictionary alloc] initWithCapacity:[perferenceSpecifiers count]];
    
    for (NSDictionary *prefSpecification in perferenceSpecifiers) {
        NSString *key = [prefSpecification objectForKey:@"Key"];
        
        if (key) {
            id currentObject = [prefSpecification objectForKey:key];
            if (currentObject == nil) {
                id objectToSet = [prefSpecification objectForKey:@"DefaultValue"];
                [defaultsToRegister setObject:objectToSet forKey:key];
                NSLog(@"Setting object %@ for key %@", objectToSet, key);
            } else {
                NSLog(@"Key %@ is readable (value: %@), nothing written to defaults.", key, currentObject);
            }
        }
    }

    [userDefaults registerDefaults:defaultsToRegister];
    [userDefaults synchronize];
}

@end
