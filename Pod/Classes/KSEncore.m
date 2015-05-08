//
//  KSEncore.m
//  KSEncore
//
//  Created by Kevin Sylvestre on 2015-05-07.
//  Copyright (c) 2015 SURKUS Inc. All rights reserved.
//

#import "KSEncore.h"

@interface KSEncore ()

@property (nonatomic, strong) NSMutableSet *callbacks;

@end

@implementation KSEncore

////////////////////////////////////////////////////////////////////////////////

#pragma mark - Workers

- (void)queue:(id)callback block:(KSEncoreBlock)block
{
    BOOL executor;
    
    @synchronized(self)
    {
        executor = !self.callbacks;
        
        if (self.callbacks) [self.callbacks addObject:callback];
        else self.callbacks = [NSMutableSet setWithObject:callback];
    }
    
    if (executor) block();
}

- (void)flush:(KSEncoreFlush)flush
{
    @synchronized(self)
    {
        for (id callback in self.callbacks) flush(callback);
        self.callbacks = NULL;
    }
}

@end
