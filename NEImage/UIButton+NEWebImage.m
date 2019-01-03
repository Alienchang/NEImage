//
//  UIButton+NEWebImage.m
//  NESocialClient
//
//  Created by Chang Liu on 10/23/17.
//  Copyright © 2017 Chang Liu. All rights reserved.
//

#import "UIButton+NEWebImage.h"
#import "UIView+NEWebImage.h"
#import <SDWebImage/UIButton+WebCache.h>

@implementation UIButton (NEWebImage)
- (void)ne_setImageWithURL:(NSString *)url forState:(UIControlState)state {
    [self ne_setImageWithURL:url forState:state placeholderImage:nil];
}
- (void)ne_setImageWithURL:(NSString *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder {
    __weak typeof(self)weakSelf = self;
    [self ne_internalSetImageWithURL:url
                    placeholderImage:placeholder
                            cacheURL:nil
                           imageType:NEImageSizeOriginal
                             options:NEWebImageRetryFailed
                        operationKey:nil
                       setImageBlock:^(UIImage * _Nullable image, NSData * _Nullable imageData) {
                           [weakSelf setImage:image forState:state];
    } progress:nil completed:nil];
}

- (void)ne_setBackgroundImageWithURL:(NSString *)url forState:(UIControlState)state {
    [self ne_setBackgroundImageWithURL:url forState:state placeholderImage:nil];
}

- (void)ne_setBackgroundImageWithURL:(NSString *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder {
    __weak typeof(self)weakSelf = self;
    [self ne_internalSetImageWithURL:url
                    placeholderImage:placeholder
                            cacheURL:nil
                           imageType:NEImageSizeOriginal
                             options:NEWebImageRetryFailed
                        operationKey:nil
                       setImageBlock:^(UIImage * _Nullable image, NSData * _Nullable imageData) {
        [weakSelf setBackgroundImage:image forState:state];
    } progress:nil completed:nil];
}
@end
