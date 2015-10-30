//
//  main.m
//  SecurityTransformsLeaks
//
//  Created by Konstantin Pavlikhin on 30.10.15.
//  Copyright © 2015 Konstantin Pavlikhin. All rights reserved.
//

#import <Foundation/Foundation.h>

@import Security;

int main(int argc, const char* argv[])
{
  @autoreleasepool
  {
    NSData* const inputData = [@"DummyString" dataUsingEncoding: NSUTF8StringEncoding];

    const CFDataRef inputDataRef = CFBridgingRetain(inputData);

    // * * *.

    for(NSUInteger i = 0; i < 100000; i++)
    {
      @autoreleasepool
      {
        CFErrorRef internalError = NULL;

        const SecTransformRef digestTransform = SecDigestTransformCreate(kSecDigestSHA1, 0, &internalError);

        if(digestTransform)
        {
          if(SecTransformSetAttribute(digestTransform, kSecTransformInputAttributeName, inputDataRef, &internalError))
          {
            const CFDataRef hashData = SecTransformExecute(digestTransform, &internalError); // Leaks 😡.

            CFRelease(hashData);
          }
          else
          {
            NSError* const error = CFBridgingRelease(internalError);

            NSLog(@"%@", error);
          }

          CFRelease(digestTransform);
        }
        else
        {
          NSError* const error = CFBridgingRelease(internalError);

          NSLog(@"%@", error);
        }
      }
    }

    CFRelease(inputDataRef);
  }

  return 0;
}
