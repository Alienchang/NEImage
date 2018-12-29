//
//  UIView+NEWebImage.h
//  NESocialClient
//
//  Created by Chang Liu on 10/23/17.
//  Copyright © 2017 Chang Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NEWebImageManager.h"
#import "NEImageTypeDefine.h"

@interface UIView (NEWebImage)
- (void)ne_internalSetImageWithURL:(nullable NSString *)url
                  placeholderImage:(nullable UIImage *)placeholder
                          cacheURL:(nullable NSString *)cacheURL
                         imageType:(NEImageType)imageType
                           options:(NEWebImageOptions)options
                      operationKey:(nullable NSString *)operationKey
                     setImageBlock:(nullable NESetImageBlock)setImageBlock
                          progress:(nullable NEWebImageDownloaderProgressBlock)progressBlock
                         completed:(nullable NEExternalCompletionBlock)completedBlock;

//图片地址后面追加size url
- (void)setSizeFormatedURL:(NSString *_Nonnull)formatedURL;
- (NSString *_Nullable)sizeFormatedURL;

@end
