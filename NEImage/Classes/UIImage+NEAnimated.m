//
//  NESocialClient
//
//  Created by Chang Liu on 10/20/17.
//  Copyright © 2017 Chang Liu. All rights reserved.
//

#import "UIImage+NEAnimated.h"
#import <objc/runtime.h>
#import <SDWebImage/UIImage+MultiFormat.h>
#import <SDWebImage/UIImage+GIF.h>
#import <SDWebImage/UIImage+WebP.h>
#import <APNGImageSerialization/APNGImageSerialization.h>

@implementation UIImage (NEAnimated)

NSString *const kImageExtType = @"imageExtType";

- (void)setImageExtType:(NEImageExtType)imageExtType {
    objc_setAssociatedObject(self, &kImageExtType, @(imageExtType), OBJC_ASSOCIATION_RETAIN);
}
- (NEImageExtType)imageExtType {
    NSNumber *number = objc_getAssociatedObject(self, &kImageExtType);
    return number.floatValue;
}

//计算每帧需要播放的时间
+ (float)ne_frameDurationAtIndex:(NSUInteger)index source:(CGImageSourceRef)source {
    float frameDuration = 0.1f;
    // 获取这一帧的属性字典
    CFDictionaryRef cfFrameProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil);
    NSDictionary *frameProperties = (__bridge NSDictionary *)cfFrameProperties;
    NSDictionary *gifProperties = frameProperties[(NSString *)kCGImagePropertyGIFDictionary];
    
    // 从字典中获取这一帧持续的时间
    NSNumber *delayTimeUnclampedProp = gifProperties[(NSString *)kCGImagePropertyGIFUnclampedDelayTime];
    if (delayTimeUnclampedProp) {
        frameDuration = [delayTimeUnclampedProp floatValue];
    }
    else {
        
        NSNumber *delayTimeProp = gifProperties[(NSString *)kCGImagePropertyGIFDelayTime];
        if (delayTimeProp) {
            frameDuration = [delayTimeProp floatValue];
        }
    }
    
    // Many annoying ads specify a 0 duration to make an image flash as quickly as possible.
    // We follow Firefox's behavior and use a duration of 100 ms for any frames that specify
    // a duration of <= 10 ms. See <rdar://problem/7689300> and <http://webkit.org/b/36082>
    // for more information.
    
    if (frameDuration < 0.011f) {
        frameDuration = 0.100f;
    }
    
    CFRelease(cfFrameProperties);
    return frameDuration;
}

+ (UIImage *)ne_animatedImageNamed:(NSString *)name type:(NEImageExtType)extType {
    
    name = [name stringByDeletingPathExtension];
    NSString *ext = nil;
    switch (extType) {
        case NEImageExtTypeGIF:
        {
            ext = @"gif";
            CGFloat scale = [UIScreen mainScreen].scale;
            if (scale > 1.0f) {
                NSString *retinaPath = [[NSBundle mainBundle] pathForResource:[name stringByAppendingString:[NSString stringWithFormat:@"@%dx",(int)scale]] ofType:ext];
                NSData *data = [NSData dataWithContentsOfFile:retinaPath];
                
                
                if (data) {
                    UIImage *image = [UIImage ne_animatedGIFData:data];
                    [image setImageExtType:extType];
                    return image;
                }
                NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:ext];
                data = [NSData dataWithContentsOfFile:path];
                if (data) {
                    UIImage *image = [UIImage ne_animatedGIFData:data];
                    [image setImageExtType:extType];
                    return image;
                }
                UIImage *image = [UIImage imageNamed:name];
                [image setImageExtType:extType];
                return image;
            } else {
                NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:ext];
                NSData *data = [NSData dataWithContentsOfFile:path];
                if (data) {
                    UIImage *image = [UIImage ne_animatedGIFData:data];
                    [image setImageExtType:extType];
                    return image;
                }
                UIImage *image = [UIImage imageNamed:name];
                [image setImageExtType:extType];
                return image;
            }
        }
            break;
        case NEImageExtTypeAPNG:
        {
            ext = @"apng";
            NSData *imageData = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@.%@",name,ext]];
            UIImage *image = [UIImage ne_animatedAPNGData:imageData];
            [image setImageExtType:extType];
            return image;
        }
            break;
        case NEImageExtTypePNG:
        {
            ext = @"png";
            NSData *imageData = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@.%@",name,ext]];
            UIImage *image = [UIImage ne_animatedAPNGData:imageData];
            [image setImageExtType:extType];
            return image;
        }
            break;
        case NEImageExtTypeWebP:
        {
            ext = @"webp";
            NSData *imageData = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@.%@",name,ext]];
            UIImage *image = [UIImage ne_animatedWebPData:imageData];
            [image setImageExtType:extType];
            return image;
        }
            break;
        default:
        {
            return nil;
        }
            break;
    }
}

+ (UIImage *)ne_animatedGIFNamed:(NSString *)name {
    return [self ne_animatedImageNamed:name type:NEImageExtTypeGIF];
}
+ (UIImage *)ne_animatedAPNGNamed:(NSString *)name {
    return [self ne_animatedImageNamed:name type:NEImageExtTypeAPNG];
}
+ (UIImage *)ne_animatedWebPNamed:(NSString *)name {
    return [self ne_animatedImageNamed:name type:NEImageExtTypeWebP];
}

+ (UIImage *)ne_animatedGIFData:(NSData *)data {
    return [UIImage sd_animatedGIFWithData:data];
}
+ (UIImage *)ne_animatedAPNGData:(NSData *)data {
    return [UIImage apng_animatedImageWithAPNGData:data];
}
+ (UIImage *)ne_animatedWebPData:(NSData *)data {
    return [UIImage sd_imageWithData:data];
}
@end
