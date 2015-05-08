//
//  KSEncoreTests.m
//  KSEncoreTests
//
//  Created by Kevin Sylvestre on 05/07/2015.
//  Copyright (c) 2014 Kevin Sylvestre. All rights reserved.
//

#import <KSEncore/KSEncore.h>

SpecBegin(KSEncoreSpec)

describe(@"KSEncoreSpec", ^{
    describe(@"#queue:block:", ^{
        it(@"handles a single queue by executing the callback", ^{
            __block KSEncore *encore = [KSEncore new];
            __block NSDate *result;
            
            void (^callback)(NSDate *) = ^(NSDate *date){
                result = date;
            };

            waitUntil(^(DoneCallback done) {
                [encore queue:callback block:^{
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            __block NSDate *date = [NSDate date];
                            [encore flush:^(void (^foo)(NSDate *)) {
                                foo(date);
                            }];
                            
                            done();
                        });
                    });
                }];
            });
            
            expect(result).to.beKindOf([NSDate class]);
        });
        
        it(@"handles multiple queues by executing the callback", ^{
            __block KSEncore *encore = [KSEncore new];

            __block const NSUInteger count = 512;
            __block NSUInteger callbacks = 0;
            __block NSUInteger executions = 0;
            
            waitUntil(^(DoneCallback done) {
                for (NSUInteger index = 0; index < count; index++)
                {
                    void (^callback)(void) = ^(void) {
                        callbacks++;
                    };
                    
                    [encore queue:callback block:^{
                        executions++;
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [encore flush:^(void (^callback)(void)) {
                                    callback();
                                }];
                                
                                done();
                            });
                        });
                    }];
                }
            });
            
            expect(callbacks).to.beLessThanOrEqualTo(count);
            expect(callbacks).to.equal(count);
        });

    });
});

SpecEnd
