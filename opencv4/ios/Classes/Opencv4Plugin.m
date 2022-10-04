#import "Opencv4Plugin.h"
#import <opencv2/imgproc/imgproc.hpp>
#import <opencv2/imgcodecs/imgcodecs.hpp>
#import <opencv2/core/core.hpp>
#import <opencv2/highgui/highgui.hpp>
#import <opencv2/core/mat.hpp>
#import <opencv2/imgcodecs/ios.h>
#import <Flutter/Flutter.h>


using namespace cv;

@implementation Opencv4Plugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel methodChannelWithName:@"opencv4" binaryMessenger:[registrar messenger]];
  Opencv4Plugin* instance = [[Opencv4Plugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  } else if ([@"getOpenCVVersion" isEqualToString:call.method]) {
      NSString * openCVVersionStr = [self openCVVersionString];
      result([@"OpenCV" stringByAppendingString:openCVVersionStr]);
  } else if ([@"rotate" isEqualToString:call.method]) {
      
      FlutterStandardTypedData * byteData = call.arguments[@"byteData"];
      NSNumber * angle = call.arguments[@"angle"];
      NSData * data = [self rotate:byteData.data secondNumber:angle];
      
      FlutterStandardTypedData * tmp = [FlutterStandardTypedData typedDataWithBytes: data];
      
      result(tmp);
  } else if ([@"grayScale" isEqualToString:call.method]) {
      
      FlutterStandardTypedData * byteData = call.arguments[@"byteData"];
      NSData * data = [self grayScale:byteData.data];
      
      FlutterStandardTypedData * tmp = [FlutterStandardTypedData typedDataWithBytes: data];
      
      result(tmp);
  } else if ([@"adaptiveThreshold" isEqualToString:call.method]) {
      
      FlutterStandardTypedData * byteData = call.arguments[@"byteData"];
      NSNumber * maxValue = call.arguments[@"maxValue"];
      NSNumber * adaptiveMethod = call.arguments[@"adaptiveMethod"];
      NSNumber * thresholdType = call.arguments[@"thresholdType"];
      NSNumber * blockSize = call.arguments[@"blockSize"];
      NSNumber * constantValue = call.arguments[@"constantValue"];
      
      NSData * data = [self adaptiveThreshold:byteData.data sencondArgument:maxValue thirdArgument:adaptiveMethod fourthArgument:thresholdType fiveArgument:blockSize sixArgument:constantValue];
      
      FlutterStandardTypedData * tmp = [FlutterStandardTypedData typedDataWithBytes: data];
      
      result(tmp);
  } else if ([@"blur" isEqualToString:call.method]) {
      
      FlutterStandardTypedData * byteData = call.arguments[@"byteData"];
      NSArray * kernelSize = call.arguments[@"kernelSize"];
      NSArray * anchorPoint = call.arguments[@"anchorPoint"];
      NSNumber * borderType = call.arguments[@"borderType"];
      NSData * data = [self blur:byteData.data secondNumber:kernelSize thirdArgument:anchorPoint fourthArgument:borderType];
      
      FlutterStandardTypedData * tmp = [FlutterStandardTypedData typedDataWithBytes: data];
      
      result(tmp);
  } else if ([@"threshold" isEqualToString:call.method]) {
      
      FlutterStandardTypedData * byteData = call.arguments[@"byteData"];
      NSNumber * thresholdValue = call.arguments[@"thresholdValue"];
      NSNumber * maxThresholdValue = call.arguments[@"maxThresholdValue"];
      NSNumber * thresholdType = call.arguments[@"thresholdType"];
      
      NSData * data = [self threshold:byteData.data secondNumber:thresholdValue thirdArgument:maxThresholdValue fourthArgument:thresholdType];
      
      FlutterStandardTypedData * tmp = [FlutterStandardTypedData typedDataWithBytes: data];
      
      result(tmp);
  } else if ([@"brightness" isEqualToString:call.method]) {
      
      FlutterStandardTypedData * byteData = call.arguments[@"byteData"];
      NSNumber * rtype = call.arguments[@"rtype"];
      NSNumber * alpha = call.arguments[@"alpha"];
      NSNumber * beta = call.arguments[@"beta"];
      
      NSData * data = [self brightness:byteData.data secondArgument:rtype thirdArgument:alpha fourthArgument:beta];
      
      FlutterStandardTypedData * tmp = [FlutterStandardTypedData typedDataWithBytes: data];
      
      result(tmp);
  } else if ([@"warpPerspectiveTransform" isEqualToString:call.method]) {
      
      FlutterStandardTypedData * byteData = call.arguments[@"byteData"];
      NSArray * sourcePoints = call.arguments[@"sourcePoints"];
      NSArray * destinationPoints = call.arguments[@"destinationPoints"];
      NSArray * outputSize = call.arguments[@"outputSize"];
      
      NSData * data = [self warpPerspectiveTransform:byteData.data secondArgument:sourcePoints thirdArgument:destinationPoints fourthArgument:outputSize];
      
      FlutterStandardTypedData * tmp = [FlutterStandardTypedData typedDataWithBytes: data];
      
      result(tmp);
  } else {
    result(FlutterMethodNotImplemented);
  }
}

- (NSString *)openCVVersionString {
    return [NSString stringWithFormat:@"OpenCV Version %s",  CV_VERSION];
}

- (NSData *) rotate: (NSData *) byteData secondNumber: (NSNumber *) angle {
    Mat dst = Mat();
    UIImage * image = [UIImage imageWithData:byteData];
    cv::Mat imageMat;
    UIImageToMat(image, imageMat);
    cv::rotate(imageMat, dst, cv::ROTATE_90_CLOCKWISE);
    UIImage * oImage = MatToUIImage(dst);
    CGFloat quality = 1;
    NSData * imageData = UIImageJPEGRepresentation(oImage,quality);
    return imageData;
}

- (NSData *) brightness: (NSData *) byteData secondArgument: (NSNumber *) rtype thirdArgument: (NSNumber *) alpha fourthArgument: (NSNumber *) beta {
    Mat dst = Mat();
    UIImage * image = [UIImage imageWithData:byteData];
    cv::Mat imageMat;
    UIImageToMat(image, imageMat);

    imageMat.convertTo(dst, (int)(size_t)rtype, (double)(size_t)alpha, (double)(size_t)beta);
    
    UIImage * oImage = MatToUIImage(dst);
    CGFloat quality = 1;
    NSData * imageData = UIImageJPEGRepresentation(oImage,quality);
    return imageData;
}

- (NSData *) blur: (NSData*) byteData secondNumber: (NSArray*) kernelSize thirdArgument: (NSArray *) anchorPoint fourthArgument: (NSNumber *) borderType {
    Mat dst = Mat();
    UIImage * image = [UIImage imageWithData:byteData];
    cv::Mat imageMat;
    UIImageToMat(image, imageMat);
    
    Size2i size = Size2i(
     (int)(size_t)[kernelSize objectAtIndex:0],
     (int)(size_t)[kernelSize objectAtIndex:1]
    );
    
    Point2i anchor = Point2i(
     (int)(size_t)[anchorPoint objectAtIndex:0],
     (int)(size_t)[anchorPoint objectAtIndex:1]
    );
    
    cv::blur(imageMat, dst, size, anchor, (int)(size_t)borderType);
    
    UIImage * oImage = MatToUIImage(dst);
    CGFloat quality = 1;
    NSData * imageData = UIImageJPEGRepresentation(oImage,quality);
    return imageData;
}

- (NSData *) threshold: (NSData*) byteData secondNumber: (NSNumber*) thresholdValue thirdArgument: (NSNumber *) maxThresholdValue fourthArgument: (NSNumber *) thresholdType {
    Mat dst = Mat();
    UIImage * image = [UIImage imageWithData:byteData];
    cv::Mat imageMat;
    UIImageToMat(image, imageMat);
    
    cv::threshold(imageMat, dst, (double)(size_t)thresholdValue, (double)(size_t)maxThresholdValue, (int)(size_t)thresholdType);
    
    UIImage * oImage = MatToUIImage(dst);
    CGFloat quality = 1;
    NSData * imageData = UIImageJPEGRepresentation(oImage,quality);
    return imageData;
}

- (NSData *) grayScale: (NSData*) byteData {
    Mat dst = Mat();
    UIImage * image = [UIImage imageWithData:byteData];
    cv::Mat imageMat;
    UIImageToMat(image, imageMat);
    	
    cv::cvtColor(imageMat, dst, cv::IMREAD_GRAYSCALE);
    
    UIImage * oImage = MatToUIImage(dst);
    CGFloat quality = 1;
    NSData * imageData = UIImageJPEGRepresentation(oImage, quality);
    return imageData;
}

- (NSData *) adaptiveThreshold: (NSData*) byteData sencondArgument: (NSNumber *) maxValue thirdArgument: (NSNumber *) adaptiveMethod fourthArgument: (NSNumber *) thresholdType fiveArgument: (NSNumber *) blockSize sixArgument: (NSNumber *) constantValue {
    Mat dst = Mat();
    UIImage * image = [UIImage imageWithData:byteData];
    cv::Mat imageMat;
    UIImageToMat(image, imageMat);

    cv::cvtColor(imageMat, dst, cv::IMREAD_GRAYSCALE);
    cv::adaptiveThreshold(dst, dst, (double)(size_t)maxValue, (int)(size_t)adaptiveMethod, (int)(size_t)thresholdType, (int)(size_t)blockSize, (double)(size_t)constantValue);
    
    UIImage * oImage = MatToUIImage(dst);
    CGFloat quality = 1;
    NSData * imageData = UIImageJPEGRepresentation(oImage, quality);
    return imageData;
}

- (NSData *) warpPerspectiveTransform: (NSData *) byteData secondArgument: (NSArray *) sourcePoints thirdArgument: (NSArray *) destinationPoints fourthArgument: (NSArray *) outputSize {
    Mat dstMat = Mat();
    UIImage * image = [UIImage imageWithData:byteData];
    cv::Mat imageMat;
    UIImageToMat(image, imageMat);
    
    // implement logic here
    NSMutableArray * s = [[NSMutableArray alloc] init];
    NSMutableArray * t = [[NSMutableArray alloc] init];
    
    int i = 0;
    for (i = 0; i < [sourcePoints count]; i++) {
        id element = [sourcePoints objectAtIndex:i];
        int intValue = (int)(size_t)element;
        float doubleValue = (float)(size_t)intValue;
        [s addObject:[NSNumber numberWithDouble:doubleValue]];
    }
    
    for (i = 0; i < [destinationPoints count]; i++) {
        id element = [destinationPoints objectAtIndex:i];
        int intValue = (int)(size_t)element;
        float doubleValue = (float)(size_t)intValue;
        [t addObject:[NSNumber numberWithDouble:doubleValue]];
    }
    
    cv::Point2f src[4];
    src[0].x = (float)(size_t)[s objectAtIndex:0];
    src[0].y = (float)(size_t)[s objectAtIndex:1];
    src[1].x = (float)(size_t)[s objectAtIndex:2];
    src[1].y = (float)(size_t)[s objectAtIndex:3];
    src[2].x = (float)(size_t)[s objectAtIndex:4];
    src[2].y = (float)(size_t)[s objectAtIndex:5];
    src[3].x = (float)(size_t)[s objectAtIndex:6];
    src[3].y = (float)(size_t)[s objectAtIndex:7];
    
    Point2f dst[4];
    dst[0].x = (float)(size_t)[t objectAtIndex:0];
    dst[0].y = (float)(size_t)[t objectAtIndex:1];
    dst[1].x = (float)(size_t)[t objectAtIndex:2];
    dst[1].y = (float)(size_t)[t objectAtIndex:3];
    dst[2].x = (float)(size_t)[t objectAtIndex:4];
    dst[2].y = (float)(size_t)[t objectAtIndex:5];
    dst[3].x = (float)(size_t)[t objectAtIndex:6];
    dst[3].y = (float)(size_t)[t objectAtIndex:7];
 
    Mat warpMatrix = getPerspectiveTransform(src, dst);
    Size2i size = Size2i(
     (int)(size_t)[outputSize objectAtIndex:0],
     (int)(size_t)[outputSize objectAtIndex:1]
    );
    cv::warpPerspective(imageMat, dstMat, warpMatrix, size);

    UIImage * oImage = MatToUIImage(dstMat);
    CGFloat quality = 1;
    NSData * imageData = UIImageJPEGRepresentation(oImage, quality);
    return imageData;

}
 
@end
