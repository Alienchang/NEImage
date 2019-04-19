//
//  NESocialClient
//
//  Created by Chang Liu on 10/20/17.
//  Copyright © 2017 Chang Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ImageIO/ImageIO.h>

typedef enum : NSUInteger {
    NEImageExtTypeUnknow,
    NEImageExtTypeGIF,
    NEImageExtTypeAPNG,
    NEImageExtTypePNG,
    NEImageExtTypeWebP,
} NEImageExtType;

@interface UIImage (NEAnimated)
/*
 * eg :[UIImage ne_animatedGIFNamed:@"UltimateDifficultJohndory-size_restricted"];  UltimateDifficultJohndory-size_restricted.gif
 */

@property (nonatomic ,assign) NEImageExtType imageExtType;

+ (float)ne_frameDurationAtIndex:(NSUInteger)index
                          source:(CGImageSourceRef)source;


+ (UIImage *)ne_animatedGIFData:(NSData *)data;
+ (UIImage *)ne_animatedAPNGData:(NSData *)data;
+ (UIImage *)ne_animatedWebPData:(NSData *)data;

+ (UIImage *)ne_animatedGIFNamed:(NSString *)name;
+ (UIImage *)ne_animatedAPNGNamed:(NSString *)name;
+ (UIImage *)ne_animatedWebPNamed:(NSString *)name;
+ (UIImage *)ne_animatedImageNamed:(NSString *)name
                              type:(NEImageExtType)extType;

@end
