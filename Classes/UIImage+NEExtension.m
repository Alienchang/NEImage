//
//  UIImage+NEExtension.m
//  NESocialClient
//
//  Created by Chang Liu on 11/8/17.
//  Copyright © 2017 Next Entertainment. All rights reserved.
//

#import "UIImage+NEExtension.h"

@implementation UIImage (NEExtension)
- (UIImage *)circleImageWithWidth:(double)width {
    
    // 计算一些变量, 供后面使用
    float screenScale = [[UIScreen mainScreen] scale];
    float scale = width / MIN(self.size.width, self.size.height);
    CGSize originalScaleSize = CGSizeMake(self.size.width * scale, self.size.height * scale);
    CGRect centerRange = CGRectOffset(CGRectMake(0, 0, width, width), (originalScaleSize.width-width)/2, (originalScaleSize.height-width)/2);
    
    
    
    // 调用方法将图像缩放到指定的比例
    UIImage *newImage = [self zoomImageWithScale:scale];
    
    
    // 开始获取图片中间 正方形区域
    CGImageRef imageRef = newImage.CGImage;
    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, CGRectMake(centerRange.origin.x, centerRange.origin.y, centerRange.size.width * screenScale, centerRange.size.height * screenScale));
    newImage = [UIImage imageWithCGImage:subImageRef];
    
    
    //切成圆角并返回图像
    return [newImage cuttingCicleImageWithSize:CGSizeMake(width, width)];
}

///切成圆形的图片
- (UIImage *)cuttingCicleImageWithSize:(CGSize)size {
    
    double screenScale = [[UIScreen mainScreen] scale];
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    
    UIGraphicsBeginImageContextWithOptions(size, NO, screenScale);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextAddEllipseInRect(ctx, rect);
    CGContextClip(ctx);
    [self drawInRect:rect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

///缩放图片尺寸
- (UIImage *)zoomImageToSize:(CGSize)size {
    
    UIGraphicsBeginImageContextWithOptions(size, NO, [[UIScreen mainScreen] scale]);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

///按照比例缩放图片, 原始图片为1, 参数(0~1)
- (UIImage *)zoomImageWithScale:(float)scale {
    
    CGSize targetSize = CGSizeMake(self.size.width * scale, self.size.height * scale);
    return [self zoomImageToSize:targetSize];
}
@end
