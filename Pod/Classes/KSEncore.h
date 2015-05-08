//
//  KSEncore.h
//  KSEncore
//
//  Created by Kevin Sylvestre on 2015-05-07.
//  Copyright (c) 2015 SURKUS Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^KSEncoreBlock)(void);
typedef void (^KSEncoreFlush)(id callback);

@interface KSEncore : NSObject

- (void)queue:(id)callback block:(KSEncoreBlock)block;
- (void)flush:(KSEncoreFlush)flush;

@end
