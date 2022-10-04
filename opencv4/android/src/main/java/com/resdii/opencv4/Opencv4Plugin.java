package com.resdii.opencv4;

import androidx.annotation.NonNull;

import android.annotation.SuppressLint;

import org.opencv.android.OpenCVLoader;
import org.opencv.core.Core;
import org.opencv.core.CvType;
import org.opencv.core.Mat;
import org.opencv.core.Point;
import org.opencv.core.Size;
import org.opencv.core.MatOfByte;
import org.opencv.core.MatOfInt;
import org.opencv.imgcodecs.Imgcodecs;
import org.opencv.imgproc.Imgproc;

import java.util.ArrayList;
import io.flutter.Log;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/**
 * Opencv4Plugin
 */
public class Opencv4Plugin implements FlutterPlugin, MethodCallHandler {
    static boolean OpenCVFLag = false;

    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private MethodChannel channel;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "opencv4");
        channel.setMethodCallHandler(this);
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        if (call.method.equals("getPlatformVersion")) {
            result.success("Android " + android.os.Build.VERSION.RELEASE);
        } else {
            if (!OpenCVFLag) {
                if (!OpenCVLoader.initDebug()) {
                    System.out.println("Err");
                } else {
                    OpenCVFLag = true;
                }
                // Handle initialization error
            }
            OpenCVImpl core = new OpenCVImpl();
            switch (call.method) {
                case "getOpenCVVersion":
                    result.success("OpenCV " + Core.VERSION);
                    break;
                case "cvtColor":
                    result.success(core.cvtColor((byte[]) call.argument("byteData"), (int) call.argument("outputType")));
                    break;
                case "blur":
                    result.success(core.blur((byte[]) call.argument("byteData"), (ArrayList) call.argument("kernelSize"),
                            (ArrayList) call.argument("anchorPoint"), (int) call.argument("borderType")));
                    break;
                case "gaussianBlur":
                    result.success(core.gaussianBlur((byte[]) call.argument("byteData"),
                            (ArrayList) call.argument("kernelSize"), (double) call.argument("sigmaX")));
                    break;
                case "medianBlur":
                    result.success(core.medianBlur((byte[]) call.argument("byteData"), (int) call.argument("kernelSize")));
                    break;
                case "bilateralFilter":
                    result.success(core.bilateralFilter((byte[]) call.argument("byteData"), (int) call.argument("diameter"),
                            (int) call.argument("sigmaColor"), (int) call.argument("sigmaSpace"),
                            (int) call.argument("borderType")));
                    break;
                case "boxFilter":
                    result.success(core.boxFilter((byte[]) call.argument("byteData"), (int) call.argument("outputDepth"),
                            (ArrayList) call.argument("kernelSize"), (ArrayList) call.argument("anchorPoint"),
                            (boolean) call.argument("normalize"), (int) call.argument("borderType")));
                    break;
                case "sqrBoxFilter":
                    result.success(core.sqrBoxFilter((byte[]) call.argument("byteData"), (int) call.argument("outputDepth"),
                            (ArrayList) call.argument("kernelSize")));
                    break;
                case "filter2D":
                    result.success(core.filter2D((byte[]) call.argument("byteData"), (int) call.argument("outputDepth"),
                            (ArrayList) call.argument("kernelSize")));
                    break;
                case "dilate":
                    result.success(
                            core.dilate((byte[]) call.argument("byteData"), (ArrayList) call.argument("kernelSize")));
                    break;
                case "erode":
                    result.success(core.erode((byte[]) call.argument("byteData"), (ArrayList) call.argument("kernelSize")));
                    break;
                case "morphologyEx":
                    result.success(core.morphologyEx((byte[]) call.argument("byteData"), (int) call.argument("operation"),
                            (ArrayList) call.argument("kernelSize")));
                    break;
                case "pyrUp":
                    result.success(core.pyrUp((byte[]) call.argument("byteData"), (ArrayList) call.argument("kernelSize"),
                            (int) call.argument("borderType")));
                    break;
                case "pyrDown":
                    result.success(core.pyrDown((byte[]) call.argument("byteData"), (ArrayList) call.argument("kernelSize"),
                            (int) call.argument("borderType")));
                    break;
                case "pyrMeanShiftFiltering":
                    result.success(core.pyrMeanShiftFiltering((byte[]) call.argument("byteData"),
                            (double) call.argument("spatialWindowRadius"), (double) call.argument("colorWindowRadius")));
                    break;
                case "threshold":
                    result.success(
                            core.threshold((byte[]) call.argument("byteData"), (double) call.argument("thresholdValue"),
                                    (double) call.argument("maxThresholdValue"), (int) call.argument("thresholdType")));
                    break;
                case "adaptiveThreshold":
                    result.success(
                            core.adaptiveThreshold((byte[]) call.argument("byteData"), (double) call.argument("maxValue"),
                                    (int) call.argument("adaptiveMethod"), (int) call.argument("thresholdType"),
                                    (int) call.argument("blockSize"), (double) call.argument("constantValue")));
                    break;
                case "copyMakeBorder":
                    result.success(core.copyMakeBorder((byte[]) call.argument("byteData"), (int) call.argument("top"),
                            (int) call.argument("bottom"), (int) call.argument("left"), (int) call.argument("right"),
                            (int) call.argument("borderType")));
                    break;
                case "sobel":
                    result.success(core.sobel((byte[]) call.argument("byteData"), (int) call.argument("depth"),
                            (int) call.argument("dx"), (int) call.argument("dy")));
                // Rotate Image
                case "rotate":
                    result.success(core.rotate((byte[]) call.argument("byteData"), (int) call.argument("angle")));
                    break;
                // grayScale
                case "grayScale":
                    result.success(core.grayScale((byte[]) call.argument("byteData")));
                    break;
                // brightness
                case "brightness":
                    result.success(core.brightness((byte[]) call.argument("byteData"), (int) call.argument("rtype"),
                            (double) call.argument("alpha"), (double) call.argument("beta") ));
                    break;
                case "scharr":
                    result.success(core.scharr((byte[]) call.argument("byteData"), (int) call.argument("depth"),
                            (int) call.argument("dx"), (int) call.argument("dy")));
                    break;
                case "laplacian":
                    result.success(core.laplacian((byte[]) call.argument("byteData"), (int) call.argument("depth")));
                    break;
                case "distanceTransform":
                    result.success(core.distanceTransform((byte[]) call.argument("byteData"),
                            (int) call.argument("distanceType"), (int) call.argument("maskSize")));
                    break;
                /*
                 * case "warpAffine": result.success(core.warpAffine((byte[])
                 * call.argument("byteData"), (int) call.argument("tranformMatrix"), (int)
                 * call.argument("size"))); break;
                 */
                case "resize":
                    result.success(core.resize((byte[]) call.argument("byteData"), (ArrayList) call.argument("outputSize"),
                            (double) call.argument("fx"), (double) call.argument("fy"),
                            (int) call.argument("interpolation")));
                    break;
                case "applyColorMap":
                    result.success(core.applyColorMap((byte[]) call.argument("byteData"), (int) call.argument("colorMap")));
                    break;
                case "canny":
                    result.success(core.canny((byte[]) call.argument("byteData"), (double) call.argument("threshold1"),
                            (double) call.argument("threshold2")));
                    break;
                case "houghLines":
                    result.success(core.houghLines((byte[]) call.argument("byteData"), (double) call.argument("rho"),
                            (double) call.argument("theta"), (int) call.argument("threshold"),
                            (double) call.argument("srn"), (double) call.argument("stn"),
                            (double) call.argument("minTheta"), (double) call.argument("maxTheta"),
                            (String) call.argument("lineColor"), (int) call.argument("lineThickness"),
                            (int) call.argument("lineType"), (int) call.argument("shift")));
                    break;
                case "houghLinesProbabilistic":
                    result.success(
                            core.houghLinesProbabilistic((byte[]) call.argument("byteData"), (double) call.argument("rho"),
                                    (double) call.argument("theta"), (int) call.argument("threshold"),
                                    (double) call.argument("minLineLength"), (double) call.argument("maxLineGap"),
                                    (String) call.argument("lineColor"), (int) call.argument("lineThickness"),
                                    (int) call.argument("lineType"), (int) call.argument("shift")));
                    break;
                case "houghCircles":
                    result.success(core.houghCircles((byte[]) call.argument("byteData"), (int) call.argument("method"),
                            (double) call.argument("dp"), (double) call.argument("minDist"),
                            (double) call.argument("param1"), (double) call.argument("param2"),
                            (int) call.argument("minRadius"), (int) call.argument("maxRadius"),
                            (int) call.argument("centerWidth"), (String) call.argument("centerColor"),
                            (int) call.argument("circleWidth"), (String) call.argument("circleColor")));
                    break;
                case "grabCut":
                    result.success(core.grabCut((byte[]) call.argument("byteData"), (int) call.argument("px"), (int) call.argument("py"), (int) call.argument("qx"), (int) call.argument("qy"), (int) call.argument("itercount"), (int) call.argument("mode")));
                    break;
                case "warpPerspectiveTransform":
                    result.success(core.warpPerspectiveTransform((byte[]) call.argument("byteData"),
                            (ArrayList) call.argument("sourcePoints"), (ArrayList) call.argument("destinationPoints"), (ArrayList) call.argument("outputSize")));
                    break;
                default:
                    result.notImplemented();
                    break;
            }
        }
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
    }
}
