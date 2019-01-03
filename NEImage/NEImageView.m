//
//  NEImageView.m
//  NESocialClient
//
//  Created by Chang Liu on 10/20/17.
//  Copyright © 2017 Chang Liu. All rights reserved.
//

#import "NEImageView.h"
#import <SDWebImage/UIView+WebCache.h>
#import <SDWebImage/UIView+WebCacheOperation.h>
#import <SDWebImage/NSData+ImageContentType.h>
#import "UIImage+NEExtension.h"
#import "UIImage+NEAnimated.h"

@interface NEImageView()<CAAnimationDelegate>

@end

@implementation NEImageView
- (void)ne_setImageWithURL:(NSString *_Nullable)url
               placeholder:(UIImage *_Nullable)placeholder
                    circle:(BOOL)circle {
    [self ne_setImageWithURL:url placeholder:placeholder progress:nil completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {

    }];
}

- (void)ne_setImageWithURL:(NSString *_Nullable)url
               placeholder:(UIImage *_Nullable)placeholder {
    [self ne_setImageWithURL:url placeholder:placeholder options:NEWebImageRetryFailed progress:nil completed:nil];
}
- (void)ne_setImageWithURL:(NSString *_Nullable)url
               placeholder:(UIImage *_Nullable)placeholder
                   options:(NEWebImageOptions)options
                  progress:(nullable NEWebImageDownloaderProgressBlock)progressBlock
                 completed:(nullable NEExternalCompletionBlock)completedBlock {
    [self ne_setImageWithURL:url placeholder:placeholder imageType:NEImageSizeOriginal imageAnimatedType:NEImageAnimatedNone options:options cacheURL:nil progress:progressBlock completed:completedBlock];
}

- (void)ne_setImageWithURL:(NSString *_Nullable)url
               placeholder:(UIImage *_Nullable)placeholder
                  progress:(nullable NEWebImageDownloaderProgressBlock)progressBlock
                 completed:(nullable NEExternalCompletionBlock)completedBlock {
    [self ne_setImageWithURL:url
                 placeholder:placeholder
                     options:NEWebImageRetryFailed
                    progress:progressBlock
                   completed:completedBlock];
}

- (void)ne_setImageWithURL:(NSString *_Nullable)url
               placeholder:(UIImage *_Nullable)placeholder
                 imageType:(NEImageType)imageType {
    [self ne_setImageWithURL:url placeholder:placeholder imageType:imageType imageAnimatedType:NEImageAnimatedNone options:NEWebImageRetryFailed cacheURL:nil progress:nil completed:nil];
}

- (void)ne_setImageWithURL:(NSString *_Nullable)url
               placeholder:(UIImage *_Nullable)placeholder
                  cacheURL:(NSString *_Nullable)cacheURL {
    [self ne_setImageWithURL:url placeholder:placeholder imageType:NEImageSizeOriginal imageAnimatedType:NEImageAnimatedNone options:NEWebImageRetryFailed cacheURL:cacheURL progress:nil completed:nil];
}

- (void)ne_setImageWithURL:(NSString *_Nullable)url
               placeholder:(UIImage *_Nullable)placeholder
                 imageType:(NEImageType)imageType
                  cacheURL:(NSString *_Nullable)cacheURL {
    [self ne_setImageWithURL:url placeholder:placeholder imageType:imageType imageAnimatedType:NEImageAnimatedNone options:NEWebImageRetryFailed cacheURL:cacheURL progress:nil completed:nil];
}

- (void)ne_setImageWithURL:(NSString *_Nullable)url
               placeholder:(UIImage *_Nullable)placeholder
                 imageType:(NEImageType)imageType
         imageAnimatedType:(NEImageAnimatedType)imageAnimatedType
                   options:(NEWebImageOptions)options
                  cacheURL:(NSString *_Nullable)cacheURL
                  progress:(nullable NEWebImageDownloaderProgressBlock)progressBlock
                 completed:(nullable NEExternalCompletionBlock)completedBlock {
    // 先移除所有动画
    [self.layer removeAllAnimations];
    
    if (imageType != NEImageAnimatedNone) {
        self.imageAnimatedType = imageAnimatedType;
    }
    
    __weak typeof(self)weakSelf = self;
    [self ne_internalSetImageWithURL:url placeholderImage:placeholder cacheURL:cacheURL imageType:imageType options:options operationKey:nil setImageBlock:^(UIImage * _Nullable image, NSData * _Nullable imageData) {
        SDImageFormat imageFormat = [NSData sd_imageFormatForImageData:imageData];
        switch (weakSelf.imageAnimatedType) {
            case NEImageAnimatedNone:
            {
                [weakSelf setImageWithImageData:imageData image:image imageFormat:imageFormat];
            }
                break;
            case NEImageAnimatedFadeIn:
            {
                UIImageView *tempImageView = [[UIImageView alloc] initWithImage:image];
                [tempImageView setAlpha:0];
                [tempImageView setFrame:weakSelf.bounds];
                [tempImageView setContentMode:weakSelf.contentMode];
                [weakSelf addSubview:tempImageView];
                
                [UIView animateWithDuration:.3 animations:^{
                    [tempImageView setAlpha:1];
                } completion:^(BOOL finished) {
                    [tempImageView removeFromSuperview];
                    [weakSelf setImageWithImageData:imageData image:image imageFormat:imageFormat];
                }];
            }
                break;
            case NEImageAnimatedFlipIn:
            {
                [UIView transitionWithView:weakSelf duration:.3 options:UIViewAnimationOptionTransitionFlipFromLeft|UIViewAnimationOptionCurveEaseInOut animations:^{
                    
                } completion:^(BOOL finished) {
                    [weakSelf setImageWithImageData:imageData image:image imageFormat:imageFormat];
                }];
            }
                break;
            default:
            {
                weakSelf.image = [UIImage ne_animatedGIFData:imageData];
            }
                break;
        }
        
    } progress:progressBlock completed:completedBlock];
}


/**
 接收到图片回调，可能是网络，也可能是本地
 */
- (void)setImageWithImageData:(NSData *)imageData
                        image:(UIImage *)image
                  imageFormat:(SDImageFormat)imageFormat {
    // 解析动图，播放
    if (imageFormat == SDImageFormatGIF || imageFormat == SDImageFormatWebP || imageFormat == SDImageFormatPNG || image.images) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImage *animationImage = nil;
            if (!image.images) {
                animationImage = [UIImage ne_animatedGIFData:imageData];
            } else {
                animationImage = image;
            }
            NSMutableArray *images = [NSMutableArray new];
            for (UIImage *temp in animationImage.images) {
                [images addObject:(id)temp.CGImage];
            }
            
            dispatch_main_async_safe(^{
                CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
                animation.calculationMode = kCAAnimationDiscrete;
                if (!self.animationDuration) {
                    // 默认给0.1秒每帧，不麻烦算了
                    [self setAnimationDuration:images.count * 0.1];
                }
                animation.duration = self.animationDuration;
                animation.values = images;
                animation.repeatCount = self.animationRepeatCount;
                animation.delegate = self;
                [self.layer addAnimation:animation forKey:@"animation"];
                [super setImage:animationImage.images.lastObject];
            });
        });
    } else {
        [super setImage:image];
    }
}

#pragma mark -- super
- (void)setImage:(UIImage *)image {
    if (image.images) {
        [self setImageWithImageData:nil
                              image:image
                        imageFormat:SDImageFormatUndefined];
    }
}

#pragma mark -- CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (self.animationComplete) {
        self.animationComplete();
    }
}


@end
