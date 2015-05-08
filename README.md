# Encore

[![Version](https://img.shields.io/cocoapods/v/KSEncore.svg?style=flat)](http://cocoapods.org/pods/KSEncore)
[![License](https://img.shields.io/cocoapods/l/KSEncore.svg?style=flat)](http://cocoapods.org/pods/KSEncore)
[![Platform](https://img.shields.io/cocoapods/p/KSEncore.svg?style=flat)](http://cocoapods.org/pods/KSEncore)

## Usage

Encore is for queueing callbacks. It ensures that a single executor runs a block while other callbacks block.

```objc
+ (void)process:(void(^)(NSError *error))callback
{
    static KSEncore *encore;
    static dispatch_once_t token;
    dispatch_once(&token, ^{ encore = [KSEncore new]; });
  
    [encore queue:callback block:^{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // ...
            dispatch_async(dispatch_get_main_queue(), ^{
                [encore flush:^(void (^callback)(NSError *error)) {
                    callback(error);
                }];
            });
        });
    }];
}
```

## Installation

Encore is available through [CocoaPods](http://cocoapods.org). To install it add the following line to your Podfile:

```ruby
pod "KSEncore"
```

## Author

Kevin Sylvestre, kevin@ksylvest.com

## License

Encore is available under the MIT license. See the LICENSE file for more info.
