//
//  LTOcrOmrOptions.h
//  Leadtools.Forms.Ocr
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

typedef NS_ENUM(NSInteger, LTOcrOmrSensitivity) {
   LTOcrOMRSensitivityHighest = 0,
   LTOcrOMRSensitivityHigh,
   LTOcrOMRSensitivityLow,
   LTOcrOMRSensitivityLowest,
   LTOcrOMRSensitivityLast = LTOcrOMRSensitivityLowest
};

typedef NS_ENUM(NSInteger, LTOcrOmrFrameDetectionMethod) {
   LTOcrOMRFrameDetectionMethodAuto = 0,
   LTOcrOMRFrameDetectionMethodWithoutFrame,
   LTOcrOMRFrameDetectionMethodWithFrame,
   LTOcrOMRFrameDetectionMethodLast = LTOcrOMRFrameDetectionMethodWithFrame
};

typedef NS_ENUM(NSInteger, LTOcrOmrZoneState) {
   LTOcrOmrZoneStateUnfilled = 0,
   LTOcrOmrZoneStateFilled
};

NS_ASSUME_NONNULL_BEGIN

@interface LTOcrOmrOptions : NSObject

@property (nonatomic, assign) LTOcrOmrFrameDetectionMethod frameDetectionMethod;
@property (nonatomic, assign) LTOcrOmrSensitivity sensitivity;

- (unichar)recognitionCharacterForState:(LTOcrOmrZoneState)state;
- (void)setRecognitionCharacter:(unichar)character forState:(LTOcrOmrZoneState)state;

@end

NS_ASSUME_NONNULL_END