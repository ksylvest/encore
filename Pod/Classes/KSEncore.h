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

/**
 Encore enables queueing of callbacks and single execution of methods. For example:
 
 Suppose an application allows for retries of HTTP requests when you get a `401` or `403` response code. The application
 exposes authentication through a shared authentication helper:
 
 ```
 + (void)authenticate:(KSSessionAuthenticateCallback)callback
 {
    // Authenticate...
    callback();
 }
 ```
 
 Suppose also that the app hits a few different APIs simultaneously  - all that need to retry if a `401` or `403`. This
 triggers multiple calls to authenticate - when only one is required. To fix:
 
 ```
 + (void)authenticate:(void (^)(NSError *error))callback
 {
    static KSEncore *encore;
    static dispatch_once_t token;
    dispatch_once(&token, ^{ encore = [KSEncore new]; });
    
    [encore queue:callback block:^{
        // Authenticate...
        [encore flush:^(void (^callback)(NSError *error)) {
            callback(error);
        }];
    }];
 }
 ```
 
 Callback will automatically be queued and only the initial call will execute the block.
 */
@interface KSEncore : NSObject

/**
 Call with each operation to queue up callbacks and ensure the block is only executed by the initial caller.
 @param callback The callback that is queued.
 @param block A block to be executed only by the initial caller.
 */
- (void)queue:(id)callback block:(KSEncoreBlock)block;

/**
 Call when the work has been completed to loop through all queued callbacks.
 @param flush A block that includes the callback (will be iterated over).
 */
- (void)flush:(KSEncoreFlush)flush;

@end
