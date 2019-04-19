//
//  UIImage+NEExtension.h
//  NESocialClient
//
//  Created by Chang Liu on 11/8/17.
//  Copyright © 2017 Next Entertainment. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (NEExtension)
///将UIImage图像切成圆形的图像, 指定宽度(边长)
- (UIImage *)circleImageWithWidth:(double)width;

///切成圆形的图片
- (UIImage *)cuttingCicleImageWithSize:(CGSize)size;

///缩放图片尺寸
- (UIImage *)zoomImageToSize:(CGSize)size;

///按照比例缩放图片, 原始图片为1, 参数(0~1)
- (UIImage *)zoomImageWithScale:(float)scale;
@end
