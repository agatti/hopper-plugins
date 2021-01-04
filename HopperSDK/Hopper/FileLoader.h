//
// Hopper Disassembler SDK
//
// (c) Cryptic Apps SARL. All Rights Reserved.
// https://www.hopperapp.com
//
// THIS CODE AND INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY
// KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
// PARTICULAR PURPOSE.
//

#import <Foundation/Foundation.h>
#import "HPDisassembledFile.h"
#import "HPDetectedFileType.h"
#import "HopperPlugin.h"
#import "CommonTypes.h"

@protocol FileLoader <NSObject,HopperPlugin>

- (BOOL)canLoadDebugFiles;

/// Returns an array of DetectedFileType objects.
- (nullable NSArray<NSObject<HPDetectedFileType> *> *)detectedTypesForData:(nonnull NSData *)data ofFileNamed:(nullable NSString *)filename;

/// Load a file.
/// The plugin should create HPSegment and HPSection objects.
/// It should also fill information about the CPU by setting the CPU family, the CPU subfamily and optionally the CPU plugin UUID.
/// The CPU plugin UUID should be set ONLY if you want a specific CPU plugin to be used. If you don't set it, it will be later set by Hopper.
/// During long operations, you should call the provided "callback" block to give a feedback to the user on the loading process.
- (FileLoaderLoadingStatus)loadData:(nonnull NSData *)data
              usingDetectedFileType:(nonnull NSObject<HPDetectedFileType> *)fileType
                            options:(FileLoaderOptions)options
                            forFile:(nonnull NSObject<HPDisassembledFile> *)file
                      usingCallback:(nullable FileLoadingCallbackInfo)callback;

- (FileLoaderLoadingStatus)loadDebugData:(nonnull NSData *)data
                                 forFile:(nonnull NSObject<HPDisassembledFile> *)file
                           usingCallback:(nullable FileLoadingCallbackInfo)callback;

/// Hopper changed the base address of the file, and needs help to fix it up.
/// The address of every segment was shifted of "slide" bytes.
- (void)fixupRebasedFile:(nonnull NSObject<HPDisassembledFile> *)file
               withSlide:(int64_t)slide
        originalFileData:(nonnull NSData *)fileData;

/// Extract a file
/// In the case of a "composite loader", extract the NSData object of the selected file.
- (nullable NSData *)extractFromData:(nonnull NSData *)data
               usingDetectedFileType:(nonnull NSObject<HPDetectedFileType> *)fileType
                    originalFileName:(nullable NSString *)filename
                  returnAdjustOffset:(nullable uint64_t *)adjustOffset
                returnAdjustFilename:(NSString * _Nullable __autoreleasing * _Nullable)newFilename;


/// If a loader has extracted data from a container file, it'll get a chance to modify properties
/// of the final file at the end of the loading process. For that, Hopper will call this method on
/// the participating extractors in reverse order.
- (void)setupFile:(nonnull NSObject<HPDisassembledFile> *)file afterExtractionOf:(nonnull NSString *)filename type:(nonnull NSObject<HPDetectedFileType> *)fileType;

@end
