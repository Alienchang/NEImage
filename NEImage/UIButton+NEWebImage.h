//
//  UIButton+NEWebImage.h
//  NESocialClient
//
//  Created by Chang Liu on 10/23/17.
//  Copyright © 2017 Chang Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (NEWebImage)
- (void)ne_setImageWithURL:(NSString *)url
                  forState:(UIControlState)state;

- (void)ne_setImageWithURL:(NSString *)url
                  forState:(UIControlState)state
          placeholderImage:(UIImage *)placeholder;

- (void)ne_setBackgroundImageWithURL:(NSString *)url
                            forState:(UIControlState)state;

- (void)ne_setBackgroundImageWithURL:(NSString *)url
                            forState:(UIControlState)state
                    placeholderImage:(UIImage *)placeholder;
@end
