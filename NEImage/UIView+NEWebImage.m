//
//  UIView+NEWebImage.m
//  NESocialClient
//
//  Created by Chang Liu on 10/23/17.
//  Copyright © 2017 Chang Liu. All rights reserved.
//

#import "UIView+NEWebImage.h"
#import "objc/runtime.h"
#import <SDWebImage/UIView+WebCache.h>
#import <SDWebImage/UIView+WebCacheOperation.h>
#import <SDWebImage/NSData+ImageContentType.h>

static char FORMATED_URL;

@implementation UIView (NEWebImage)
- (void)setSizeFormatedURL:(NSString *)formatedURL {
    objc_setAssociatedObject(self, &FORMATED_URL, formatedURL, OBJC_ASSOCIATION_COPY);
}
- (NSString *)sizeFormatedURL{
    return objc_getAssociatedObject(self, &FORMATED_URL);
}
- (void)ne_internalSetImageWithURL:(nullable NSString *)url
                  placeholderImage:(nullable UIImage *)placeholder
                          cacheURL:(nullable NSString *)cacheURL
                         imageType:(NEImageType)imageType
                           options:(NEWebImageOptions)options
                      operationKey:(nullable NSString *)operationKey
                     setImageBlock:(nullable NESetImageBlock)setImageBlock
                          progress:(nullable NEWebImageDownloaderProgressBlock)progressBlock
                         completed:(nullable NEExternalCompletionBlock)completedBlock {
    NSString *validOperationKey = operationKey ?: NSStringFromClass([self class]);
    [self sd_cancelImageLoadOperationWithKey:validOperationKey];
    
    if (!(options & SDWebImageDelayPlaceholder)) {
        dispatch_main_async_safe(^{
            [self sd_setImage:placeholder imageData:nil basedOnClassOrViaCustomSetImageBlock:setImageBlock];
        });
    }
    
    if (url) {
        // check if activityView is enabled or not
        if ([self sd_showActivityIndicatorView]) {
            [self sd_addActivityIndicator];
        }
        
        __weak __typeof(self)wself = self;
        
        NEWebImageManager *webImageManager = nil;
        if (!cacheURL.length) {
            webImageManager = [NEWebImageManager sharedManager];
        }else{
            webImageManager = [[NEWebImageManager alloc] initWithCache:[[SDImageCache alloc] initWithNamespace:cacheURL] downloader:[SDWebImageDownloader sharedDownloader]];
        }
        
        [webImageManager setSizeFormatedURL:self.sizeFormatedURL];
        
        id <SDWebImageOperation> operation = [webImageManager ne_loadImageWithURL:url options:options imageType:imageType progress:progressBlock completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
            __strong __typeof (wself) sself = wself;
            [sself sd_removeActivityIndicator];
            if (!sself) {
                return;
            }
            dispatch_main_async_safe(^{
                if (!sself) {
                    return;
                }
                if (image && (options & SDWebImageAvoidAutoSetImage) && completedBlock) {
                    completedBlock(image, error, cacheType, imageURL);
                    return;
                } else if (image) {
                    [sself sd_setImage:image imageData:data basedOnClassOrViaCustomSetImageBlock:setImageBlock];
                    [sself sd_setNeedsLayout];
                } else {
                    if ((options & SDWebImageDelayPlaceholder)) {
                        [sself sd_setImage:placeholder imageData:nil basedOnClassOrViaCustomSetImageBlock:setImageBlock];
                        [sself sd_setNeedsLayout];
                    }
                }
                if (completedBlock && finished) {
                    completedBlock(image, error, cacheType, imageURL);
                }
            });
        }];
        
        [self sd_setImageLoadOperation:operation forKey:validOperationKey];
    } else {
        dispatch_main_async_safe(^{
            [self sd_removeActivityIndicator];
            if (completedBlock) {
                NSError *error = [NSError errorWithDomain:SDWebImageErrorDomain code:-1 userInfo:@{NSLocalizedDescriptionKey : @"Trying to load a nil url"}];
                completedBlock(nil, error, SDImageCacheTypeNone, [NSURL URLWithString:url]);
            }
        });
    }
}

- (void)sd_setImage:(UIImage *)image imageData:(NSData *)imageData basedOnClassOrViaCustomSetImageBlock:(SDSetImageBlock)setImageBlock {
    if (setImageBlock) {
        setImageBlock(image, imageData);
        return;
    }
    
#if SD_UIKIT || SD_MAC
    if ([self isKindOfClass:[UIImageView class]]) {
        UIImageView *imageView = (UIImageView *)self;
        imageView.image = image;
    }
#endif
    
#if SD_UIKIT
    if ([self isKindOfClass:[UIButton class]]) {
        UIButton *button = (UIButton *)self;
        [button setImage:image forState:UIControlStateNormal];
    }
#endif
}

- (void)sd_setNeedsLayout {
#if SD_UIKIT
    [self setNeedsLayout];
#elif SD_MAC
    [self setNeedsLayout:YES];
#endif
}

- (void)sd_cancelCurrentImageLoad {
    [self sd_cancelImageLoadOperationWithKey:NSStringFromClass([self class])];
}
@end
