//
//  CameraPlugin.m
//  testCordova
//
//  Created by 江威严 on 2019/3/28.
//

#import "CameraPlugin.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
#import <objc/message.h>
#import <AssetsLibrary/AssetsLibrary.h>

@implementation CameraPlugin

CDVInvokedUrlCommand *_command  = nil;

- (void)useCameraWithTitle:(CDVInvokedUrlCommand *)command {
    if (![self canUseCamera]) {
        CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"相机不可用，请检查权限"];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
        return;
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"取消调用相册"];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    }];
    UIAlertAction *camera = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self useCameraWithCommand:command];
        _command = command;
    }];
    UIAlertAction *album = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self useAlbumWithCommand:command];
        _command = command;
    }];
    [alert addAction:cancel];
    [alert addAction:camera];
    [alert addAction:album];
    
    [self.viewController presentViewController:alert animated:true completion:nil];
}

//相机是否可用
- (BOOL)canUseCamera {
    NSString *mediaType = AVMediaTypeVideo;//读取媒体类型
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];//读取设备授权状态
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        //应用相机权限受限,请在设置中启用
        return false;
    }
    //相机是否可用
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        return true;
    } else {
        return false;
    }
}

//调用相机
- (void)useCameraWithCommand:(CDVInvokedUrlCommand *)command {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.allowsEditing = true;
        picker.delegate = self;
        picker.allowsEditing = NO;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self.viewController presentViewController:picker animated:YES completion:nil];
    } else {
        CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"相机不可用"];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    }
}

//调用相册
- (void)useAlbumWithCommand:(CDVInvokedUrlCommand *)command {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.allowsEditing = true;
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self.viewController presentViewController:picker animated:YES completion:nil];
    } else {
        CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"相册不可用"];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    }
}

#pragma mark -UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    
    UIImage *image = nil;
    //如果允许编辑则获得编辑后的照片，否则获取原始照片
    if (picker.allowsEditing) {
        image = [info objectForKey:UIImagePickerControllerEditedImage];//获取编辑后的照片
    } else {
        image = [info objectForKey:UIImagePickerControllerOriginalImage];//获取原始照片
    }
    
    NSData *data = UIImageJPEGRepresentation(image, 1.0f);
    NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    NSString *resultStr = [NSString stringWithFormat:@"data:image/jpeg;base64,%@", encodedImageStr];
    CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:resultStr];
    [self.commandDelegate sendPluginResult:result callbackId: _command.callbackId];
    
//    NSURL *url = [info objectForKey:UIImagePickerControllerReferenceURL];
//    if (url == nil) {
//        ALAssetsLibrary* library = [ALAssetsLibrary new];
//        [library writeImageToSavedPhotosAlbum:image.CGImage orientation:(ALAssetOrientation)(image.imageOrientation) completionBlock:^(NSURL *assetURL, NSError *error) {
//            CDVPluginResult* resultToReturn = nil;
//            if (error) {
//                resultToReturn = [CDVPluginResult resultWithStatus:CDVCommandStatus_IO_EXCEPTION messageAsString:[error localizedDescription]];
//            } else {
//                NSString* nativeUri = [[self urlTransformer:assetURL] absoluteString];
//                resultToReturn = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:nativeUri];
//            }
//            [self.commandDelegate sendPluginResult:resultToReturn callbackId:_command.callbackId];
//        }];
//        return;
//    } else {
//        NSString* nativeUri = [[self urlTransformer:url] absoluteString];
//        CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:nativeUri];
//        [self.commandDelegate sendPluginResult:result callbackId: _command.callbackId];
//    }
    
    [self.viewController dismissViewControllerAnimated:true completion:nil];
}

- (NSURL*) urlTransformer:(NSURL*)url {
    NSURL* urlToTransform = url;
    SEL sel = NSSelectorFromString(@"urlTransformer");
    if ([self.commandDelegate respondsToSelector:sel]) {
        NSURL* (^urlTransformer)(NSURL*) = ((id(*)(id, SEL))objc_msgSend)(self.commandDelegate, sel);
        if (urlTransformer) {
            urlToTransform = urlTransformer(url);
        }
    }
    return urlToTransform;
}

@end
