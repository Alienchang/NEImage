//
//  NEWebImageManager.m
//  NESocialClient
//
//  Created by Chang Liu on 10/23/17.
//  Copyright © 2017 Chang Liu. All rights reserved.
//

#import "NEWebImageManager.h"

static NSMutableDictionary<NSNumber *,NSValue *> *imageSizeStore;


@implementation NEWebImageManager

+ (instancetype)sharedManager {
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}

+ (void)initialize{
    if (imageSizeStore == nil) {

        NSDictionary *dic = @{
                              [NSNumber numberWithInt:NEImageSizeOriginal]   :[NSValue valueWithCGSize:CGSizeMake(1062, 1770)],
                              [NSNumber numberWithInt:NEImageSizeOriginalSquare]:[NSValue valueWithCGSize:CGSizeMake(1062, 1062)],
                              [NSNumber numberWithInt:NEImageSizeThumbnail] :[NSValue valueWithCGSize:CGSizeMake(450, 450)],
                              [NSNumber numberWithInt:NEImageSizeThumbnailSmall]:[NSValue valueWithCGSize:CGSizeMake(240, 240)],
                              [NSNumber numberWithInt:NEImageSizeAvatar]   :[NSValue valueWithCGSize:CGSizeMake(150, 150)],
                              };
        imageSizeStore = [[NSMutableDictionary alloc] initWithDictionary:dic];
    }
}


- (id <SDWebImageOperation>)ne_loadImageWithURL:(nullable NSString *)url
                                        options:(NEWebImageOptions)options
                                      imageType:(NEImageType)imageType
                                       progress:(nullable NEWebImageDownloaderProgressBlock)progressBlock
                                      completed:(nullable NEInternalCompletionBlock)completedBlock {
    NSURL *imageUrl = nil;
    if ([url isKindOfClass:[NSString class]]) {
        NSString *urlPredicate = @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\-.]+(?::(\\d+))?(?:(?:/[a-zA-Z0-9\\-._?,'+\\&%$=~*!():@\\\\]*)+)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
        if ([[NSPredicate predicateWithFormat:@"SELF MATCHES %@",urlPredicate] evaluateWithObject:url]) {
            imageUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",url,[self generateSizeURLWithImageType:imageType]]];
        }else{
            imageUrl = [NSURL fileURLWithPath:url];
        }
        
    } else if ([url isKindOfClass:[NSURL class]]){
        NSString *stringURL = [(NSURL *)url absoluteString];
        imageUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",stringURL,[self generateSizeURLWithImageType:imageType]]];
    } else {
        imageUrl = nil;
    }
    
    return [self loadImageWithURL:imageUrl options:(SDWebImageOptions)options progress:progressBlock completed:completedBlock];
}

+ (void)registerSize:(CGSize)size ForImageType:(NSInteger)imageType {
    NSAssert(imageType > 10, @"imageType must > 10");
    if ([[imageSizeStore allKeys] containsObject:[NSNumber numberWithInteger:imageType]]) {
        NSAssert(NO, @"type = %ld is register for size = %@",(long)imageType,imageSizeStore[[NSNumber numberWithInteger:imageType]]);
    }
    imageSizeStore[[NSNumber numberWithInteger:imageType]] = [NSValue valueWithCGSize:size];
}


+ (CGSize)imageSizeWithImageType:(NSInteger)imageType {
    CGSize imageSize = CGSizeZero;
    NSValue *sizeValue = imageSizeStore[[NSNumber numberWithInteger:imageType]];
    NSAssert(sizeValue, @"type = %ld is not register,plase register first",(long)imageType);
    imageSize = [sizeValue CGSizeValue];
    return imageSize;
}

- (NSString *)generateSizeURLWithImageType:(NEImageType)imageType {
    if (self.sizeFormatedURL.length) {
        CGSize imageSize = [NEWebImageManager imageSizeWithImageType:imageType];
        NSString *formatedURL = [NSString stringWithFormat:self.sizeFormatedURL,@(imageSize.width),@(imageSize.height)];
        self.sizeFormatedURL = nil;
        return formatedURL;
    }else{
        return @"";
    }
}
@end
