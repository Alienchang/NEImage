//
//  NEWebImageManager.h
//  NESocialClient
//
//  Created by Chang Liu on 10/23/17.
//  Copyright © 2017 Chang Liu. All rights reserved.
//

#import <SDWebImage/SDWebImageManager.h>
#import "NEImageTypeDefine.h"

@interface NEWebImageManager : SDWebImageManager

@property (nonatomic ,copy) NSString * _Nullable sizeFormatedURL;  //eg: ?imageView2/1/w/%@/h/%@" 如果给单例实例设置这个参数，对于需要单独缓存路径的请求不生效，需要调用UIView+NEWebImage的setSizeFormatedURL
/*
 * 全局注册图片大小以及对应的imageType，imageType必须大于10，预留
 */
+ (void)registerSize:(CGSize)size ForImageType:(NSInteger)imageType;

- (nullable id <SDWebImageOperation>)ne_loadImageWithURL:(nullable NSString *)url
                                                 options:(NEWebImageOptions)options
                                               imageType:(NEImageType)imageType
                                                progress:(nullable NEWebImageDownloaderProgressBlock)progressBlock
                                               completed:(nullable NEInternalCompletionBlock)completedBlock;


@end
