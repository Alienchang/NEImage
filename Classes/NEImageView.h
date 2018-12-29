//
//  NEImageView.h
//  NESocialClient
//
//  Created by Chang Liu on 10/20/17.
//  Copyright © 2017 Chang Liu. All rights reserved.
//

#import "UIView+NEWebImage.h"
#import "NEImageTypeDefine.h"
/*
 * 建议ImageView都继承此类
 */
@interface NEImageView : UIImageView

@property (nonatomic ,assign) NEImageAnimatedType imageAnimatedType;

@property (nonatomic ,copy)   void(^animationComplete)(void);

- (void)ne_setImageWithURL:(NSString *_Nullable)url
               placeholder:(UIImage *_Nullable)placeholder;

- (void)ne_setImageWithURL:(NSString *_Nullable)url
               placeholder:(UIImage *_Nullable)placeholder
                    circle:(BOOL)circle;

- (void)ne_setImageWithURL:(NSString *_Nullable)url
               placeholder:(UIImage *_Nullable)placeholder
                  progress:(nullable NEWebImageDownloaderProgressBlock)progressBlock
                 completed:(nullable NEExternalCompletionBlock)completedBlock;

- (void)ne_setImageWithURL:(NSString *_Nullable)url
               placeholder:(UIImage *_Nullable)placeholder
                   options:(NEWebImageOptions)options
                  progress:(nullable NEWebImageDownloaderProgressBlock)progressBlock
                 completed:(nullable NEExternalCompletionBlock)completedBlock;

- (void)ne_setImageWithURL:(NSString *_Nullable)url
               placeholder:(UIImage *_Nullable)placeholder
                 imageType:(NEImageType)imageType;

- (void)ne_setImageWithURL:(NSString *_Nullable)url
               placeholder:(UIImage *_Nullable)placeholder
                  cacheURL:(NSString *_Nullable)cacheURL;

- (void)ne_setImageWithURL:(NSString *_Nullable)url
               placeholder:(UIImage *_Nullable)placeholder
                 imageType:(NEImageType)imageType
                  cacheURL:(NSString *_Nullable)cacheURL;

- (void)ne_setImageWithURL:(NSString *_Nullable)url
               placeholder:(UIImage *_Nullable)placeholder
                imageType:(NEImageType)imageType                            //图片大小
         imageAnimatedType:(NEImageAnimatedType)imageAnimatedType           //动画类型
                   options:(NEWebImageOptions)options
                  cacheURL:(NSString *_Nullable)cacheURL                    //图片缓存路径
                  progress:(nullable NEWebImageDownloaderProgressBlock)progressBlock
                 completed:(nullable NEExternalCompletionBlock)completedBlock;
@end
