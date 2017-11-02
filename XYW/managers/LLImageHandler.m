//
//  LLImageHandler.m
//  LLImagePickerController
//
//  Created by 雷亮 on 16/8/17.
//  Copyright © 2016年 Leiliang. All rights reserved.
//

#import "LLImageHandler.h"
#import "Config.h"

static CGFloat const kDefaultThumbnailWidth = 100;

@interface LLImageHandler ()

@property (nonatomic, strong) dispatch_queue_t concurrentQueue;

@end

@implementation LLImageHandler

#pragma mark -
#pragma mark - 获取授权状态
+ (LLAuthorizationStatus)requestAuthorization {
    return (LLAuthorizationStatus)[PHPhotoLibrary authorizationStatus];
}

+ (void)requestAuthorization:(void(^)(LLAuthorizationStatus status))handler {
    handler((LLAuthorizationStatus)[PHPhotoLibrary authorizationStatus]);
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.concurrentQueue = dispatch_queue_create("com.LLImageHandler.global", DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}

#pragma mark -
#pragma mark - 获取所有相册
/** 获取所有相册(iOS8及以上)
 * @brief result 的元素类型为 PHAssetCollection
 */
- (void)enumeratePHAssetCollectionsWithSmartAlbumUserLibrary:(void(^)(PHAssetCollection *collection))collectionHandler finishResultHandler :(void(^)(NSArray <PHAssetCollection *>*result))resultHandler {
    // 照片群组数组
    NSMutableArray *groups = [NSMutableArray array];
    
    dispatch_sync(self.concurrentQueue, ^{
        // 获取系统相册
        PHFetchResult <PHAssetCollection *>*systemAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
        // 获取用户自定义相册
        PHFetchResult <PHAssetCollection *>*userAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
        
        for (PHAssetCollection *collection in systemAlbums) {
            // 过滤照片数量为0的相册
            if ([collection numberOfAssets] > 0) {
                if (collection.assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumUserLibrary) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            Block_exe(collectionHandler, collection);
                        });
                }
                [groups addObject:collection];
            }
        }
        
        for (PHAssetCollection *collection in userAlbums) {
            // 过滤照片数量为0的相册
            if ([collection numberOfAssets] > 0) {
                [groups addObject:collection];
            }
        }
    });
    
    dispatch_sync(self.concurrentQueue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            Block_exe(resultHandler, groups);
        });
    });
}

#pragma mark -
#pragma mark - 获取所有相册
/** 获取所有相册(iOS8及以上)
 * @brief result 的元素类型为 PHAssetCollection
 */
- (void)enumerateiMarkLibrary:(void(^)(PHAssetCollection *collection))collectionHandler{
    dispatch_sync(self.concurrentQueue, ^{
        PHFetchResult <PHAssetCollection *>*userAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
        
        for (PHAssetCollection *collection in userAlbums) {
            if ([collection.localizedTitle isEqualToString:@"爱水印"]) {
                DbLog(@"爱水印相册找到啦！%@",collection.description);
                dispatch_sync(self.concurrentQueue, ^{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        Block_exe(collectionHandler, collection);
                    });
                });
                return ;
            }
        }
    });
}

#pragma mark -
#pragma mark - 获取某一相册下所有图片资源
/** 获取所有在assetCollection中的asset(iOS8以上)
 * @param assetCollection: 照片群组
 */
- (void)enumerateAssetsInAssetCollection:(PHAssetCollection *)collection finishBlock:(void(^)(NSArray <PHAsset *>*result))finishBlock {
    __block NSMutableArray <PHAsset *>*results = [[NSMutableArray alloc]init];
    dispatch_async(self.concurrentQueue, ^{
        // 获取collection这个相册中的所有资源
        PHFetchOptions *options = [[PHFetchOptions alloc] init];
        options.wantsIncrementalChangeDetails = YES;
        options.includeAllBurstAssets = YES;
        options.includeHiddenAssets = YES;
        options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
        PHFetchResult <PHAsset *>*assets = [PHAsset fetchAssetsInAssetCollection:collection options:options];
        [assets enumerateObjectsUsingBlock:^(PHAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.mediaType == PHAssetMediaTypeImage) {
                [results addObject:obj];
            }
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            finishBlock(results);
        });
        
    });
}
@end

@implementation PHAssetCollection (LLAdd)

- (void)posterImage:(void(^)(UIImage *result, NSDictionary *info))resultHandler {
    CGSize const defaultSize = CGSizeMake(kDefaultThumbnailWidth, kDefaultThumbnailWidth);
    [self posterImage:defaultSize resultHandler:resultHandler];
}

- (void)posterImage:(CGSize)targetSize resultHandler:(void(^)(UIImage *result, NSDictionary *info))resultHandler {
    PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:self options:nil];
    if (fetchResult.count > 0) { } else {
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        PHAsset *asset = fetchResult.lastObject;
        CGFloat scale = [UIScreen mainScreen].scale;
        CGSize size = CGSizeMake(targetSize.width * scale, targetSize.height * scale);
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeDefault options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            dispatch_async(dispatch_get_main_queue(), ^{
                Block_exe(resultHandler, result, info);
            });
        }];
    });
}

- (NSInteger)numberOfAssets {
    PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
    // 注意 %zd 这里不识别，直接导致崩溃
    fetchOptions.predicate = [NSPredicate predicateWithFormat:@"mediaType == %d", PHAssetMediaTypeImage];
    PHFetchResult<PHAsset *> *result = [PHAsset fetchAssetsInAssetCollection:self options:fetchOptions];
    return result.count;
}

@end

@implementation PHAsset (LLAdd)

- (void)thumbnail:(void(^)(UIImage *result, NSDictionary *info))resultHandler {
    CGSize const defaultSize = CGSizeMake(kDefaultThumbnailWidth, kDefaultThumbnailWidth);
    [self thumbnail:defaultSize resultHandler:resultHandler];
}

- (void)thumbnail:(CGSize)targetSize resultHandler:(void(^)(UIImage *result, NSDictionary *info))resultHandler {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        CGFloat scale = [UIScreen mainScreen].scale;
        CGSize size = CGSizeMake(targetSize.width * scale, targetSize.height * scale);
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        options.deliveryMode = PHImageRequestOptionsDeliveryModeFastFormat;
        options.resizeMode = PHImageRequestOptionsResizeModeFast;
        options.synchronous = YES;
        options.networkAccessAllowed = YES;
        [[PHImageManager defaultManager] requestImageForAsset:self targetSize:size contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            dispatch_async(dispatch_get_main_queue(), ^{
                Block_exe(resultHandler, result, info);
            });
        }];
    });
}

- (void)original:(void(^)(UIImage *result, NSDictionary *info))resultHandler {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
        option.synchronous = YES;
        option.networkAccessAllowed = YES;
        [[PHImageManager defaultManager] requestImageForAsset:self targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeDefault options:option resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            dispatch_async(dispatch_get_main_queue(), ^{
                Block_exe(resultHandler, result, info);
            });
        }];
    });
}

- (void)requestImageForTargetSize:(CGSize)targetSize resultHandler:(void(^)(UIImage *result, NSDictionary *info))resultHandler {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        CGFloat scale = [UIScreen mainScreen].scale;
//        CGSize size = targetSize;
        CGSize size = CGSizeMake(targetSize.width * scale, targetSize.height * scale);
        PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
        option.synchronous = YES;
        option.deliveryMode = PHImageRequestOptionsDeliveryModeFastFormat;
        option.networkAccessAllowed = YES;
        option.resizeMode = PHImageRequestOptionsResizeModeFast;
        
        [[PHImageManager defaultManager] requestImageForAsset:self targetSize:size contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            dispatch_async(dispatch_get_main_queue(), ^{
                Block_exe(resultHandler, result, info);
            });
        }];
    });
}


/**
 原图内存大小

 @param result 大小的字符串
 */
- (void)originalSize:(void(^)(NSString *result))result {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
        option.resizeMode = PHImageRequestOptionsResizeModeNone;
        option.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
        option.version = PHImageRequestOptionsVersionOriginal;
        option.synchronous = YES;
        
        [[PHImageManager defaultManager] requestImageDataForAsset:self options:option resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
            
            unsigned long size = imageData.length / 1024;
            NSString *sizeString = [NSString stringWithFormat:@"%liK", size];
            if (size > 1024) {
                NSInteger integral = size / 1024.0;
                NSInteger decimal = size % 1024;
                NSString *decimalString = [NSString stringWithFormat:@"%li",decimal];
                if(decimal > 100){ //取两位
                    decimalString = [decimalString substringToIndex:2];
                }
                sizeString = [NSString stringWithFormat:@"%li.%@M", integral, decimalString];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                Block_exe(result, sizeString);
            });
        }];
    });
}

@end

