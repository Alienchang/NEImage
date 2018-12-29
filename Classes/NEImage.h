//
//  NEImage.h
//  NESocialClient
//
//  Created by Chang Liu on 10/20/17.
//  Copyright © 2017 Chang Liu. All rights reserved.
//

#ifndef NEImage_h
#define NEImage_h

#import "NEImageView.h"
#import "UIImage+NEAnimated.h"
#import "UIImage+NEExtension.h"
#import "UIButton+NEWebImage.h"
#import "UIView+NEWebImage.h"

#endif /* NEImage_h */

/*
 依赖:
 pod 'SDWebImage'
 pod 'SDWebImage/WebP'
 pod 'SDWebImage/GIF'
 pod 'APNGImageSerialization', '~> 0.1.3'
 */

/*
  例子:
    1.webP
        (1)remote
        NSString *netWebpURL = @"https://i.giphy.com/media/l1J9HiRwGvhkQX6tW/200.webp";
        NEImageView *imageView = [NEImageView new];
        [imageView ne_setImageWithURL:netWebpURL placeholder:nil]
        (2)local
        NSString *path = [[NSBundle mainBundle] pathForResource:@"streaming_loading" ofType:@"webp"];
        [imageView ne_setImageWithURL:path placeholder:nil];
 
    2.Gif
        (1)remote
        NEImageView *imageView = [NEImageView new];
        NSString *gifURL = @"https://thumbs.gfycat.com/UltimateDifficultJohndory-size_restricted.gif";
        [imageView ne_setImageWithURL:gifURL placeholder:nil];
        (local)
        UIImage *image = [UIImage ne_animatedGIFNamed:@"UltimateDifficultJohndory-size_restricted"];
        [image setImage:image];
    3.apng
        NEImageView *imageView = [NEImageView new];
        UIImage *image = [UIImage ne_animatedImageNamed:@"100171_showPreview" type:NEImageExtTypePNG];
        [imageView setImage:image];
 */
