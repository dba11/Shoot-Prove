//
//  LTPrimitives.h
//  Leadtools Framework
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#if !defined(LTPRIMITIVES_XCODE_H)
#define LTPRIMITIVES_XCODE_H

#if defined(__cplusplus)
extern "C" {
#endif // #if defined(__cplusplus)

#pragma pack(1)

    /**
     @typedef LeadPoint
     
     @brief Stores two integer numbers that represent the coordinates of a point (X and Y).
     */
    // Integer point
    typedef struct LeadPoint
    {
       NSInteger x;
       NSInteger y;
    } LeadPoint;
   
    /** 
     @typedef LeadSize
     
     @brief Stores two integer numbers that represent a size (Width and Height).
     */
    // Integer size
    typedef struct LeadSize
    {
       NSInteger width;
       NSInteger height;
    } LeadSize;
   
    /** 
     @typedef LeadRect
     
     @brief Stores four integer numbers that represent the coordinates and size of a rectangle (X, Y, Width, and Height).
     */
    // Integer rect
    typedef struct LeadRect
    {
       NSInteger x;
       NSInteger y;
       NSInteger width;
       NSInteger height;
    } LeadRect;
   
    /**
     @typedef LeadPointD
     
     @brief Stores two double numbers that represent the coordinates of a point (X and Y).
     */
    // Double point
    typedef struct LeadPointD
    {
       double x;
       double y;
    } LeadPointD;
   
    /**
     @typedef LeadSizeD
     
     @brief Stores two double numbers that represent a size (Width and Height).
     */
    // Double size
    typedef struct LeadSizeD
    {
       double width;
       double height;
    } LeadSizeD;
    /**
     @typedef LeadRectD
     
     @brief Stores four double numbers that represent the coordinates and size of a rectangle (X, Y, Width, and Height).
     */
    // Double rect
    typedef struct LeadRectD
    {
       double x;
       double y;
       double width;
       double height;
    } LeadRectD;
   
    /** 
     @typedef LeadLengthD
     
     @brief Defines a double length value.
     */
    // Double length
    typedef struct LeadLengthD
    {
       double value;
    } LeadLengthD;
   
    /** 
     @typedef LeadMatrix
     
     @brief Represents a 3x3 affine transformation matrix used for transformations in 2D space.
     */
    // Double matrix
    // Do not set the values of this matrix directly, instead use
    // LeadMatrix_GetM11/SetM11 for example or LeadMatrix_Set
    // This will ensure that type is set to the correct internal type
    // and greatly speeds up the matrix operations
    typedef struct LeadMatrix
    {
       double m11;
       double m12;
       double m21;
       double m22;
       double offsetX;
       double offsetY;
       NSInteger type;
       NSInteger padding;
    } LeadMatrix;
   
    // NAN
    extern const double LT_NAN;
   
    
    
    // LeadPoint functions
    LeadPoint LeadPoint_Make(int x, int y) LT_DEPRECATED_USENEW(19_0, "LeadPointMake");
    LeadPoint LeadPoint_Empty(void) LT_DEPRECATED_USENEW(19_0, "LeadPointZero");
    int LeadPoint_IsEmpty(LeadPoint point) LT_DEPRECATED_USENEW(19_0, "LeadPointIsZero");
    int LeadPoint_IsEqual(LeadPoint point1, LeadPoint point2) LT_DEPRECATED_USENEW(19_0, "LeadPointEqualToPoint");
    
    // // // // // // // //
    NS_INLINE LeadPoint LeadPointMake(NSInteger x, NSInteger y);
    
    extern const LeadPoint LeadPointZero;
    
    BOOL LeadPointIsZero(LeadPoint point1);
    BOOL LeadPointEqualToPoint(LeadPoint point1, LeadPoint point2);
    
    CGPoint CGPointFromLeadPoint(LeadPoint point);
    
    LeadPoint LeadPointFromCGPoint(CGPoint point);
    LeadPoint LeadPointFromLeadPointD(LeadPointD point);
    // // // // // // // //
   
    
    
    // LeadSize functions
    LeadSize LeadSize_Make(int width, int height) LT_DEPRECATED_USENEW(19_0, "LeadSizeMake");
    LeadSize LeadSize_Empty(void) LT_DEPRECATED_USENEW(19_0, "LeadSizeZero");
    int LeadSize_IsEmpty(LeadSize size) LT_DEPRECATED_USENEW(19_0, "LeadSizeIsZero");
    int LeadSize_IsEqual(LeadSize size1, LeadSize size2) LT_DEPRECATED_USENEW(19_0, "LeadPointEqualToPoint");
    
    // // // // // // // //
    NS_INLINE LeadSize LeadSizeMake(NSInteger width, NSInteger height);
    
    extern const LeadSize LeadSizeZero;
    
    BOOL LeadSizeIsZero(LeadSize size);
    BOOL LeadSizeEqualToSize(LeadSize size1, LeadSize size2);
    
    CGSize CGPointFromLeadSize(LeadSize size);
    
    LeadSize LeadSizeFromCGSize(CGSize size);
    LeadSize LeadSizeFromLeadSizeD(LeadSizeD size);
    // // // // // // // //
   
    
    
    // LeadRect functions
    LeadRect LeadRect_Make(int x, int y, int width, int height) LT_DEPRECATED_USENEW(19_0, "LeadRectMake");
    LeadRect LeadRect_FromLTRB(int left, int top, int right, int bottom) LT_DEPRECATED_USENEW(19_0, "LeadRectFromLTRB");
    LeadRect LeadRect_Empty(void) LT_DEPRECATED_USENEW(19_0, "LeadRectZero");
    int LeadRect_IsEmpty(LeadRect rect) LT_DEPRECATED_USENEW(19_0, "LeadRectIsZero");
    int LeadRect_IsEqual(LeadRect rect1, LeadRect rect2) LT_DEPRECATED_USENEW(19_0, "LeadRectEqualToRect");
    int LeadRect_Left(LeadRect rect) LT_DEPRECATED_USENEW(19_0, "LeadRectLeft");
    int LeadRect_Right(LeadRect rect) LT_DEPRECATED_USENEW(19_0, "LeadRectRight");
    int LeadRect_Top(LeadRect rect) LT_DEPRECATED_USENEW(19_0, "LeadRectTop");
    int LeadRect_Bottom(LeadRect rect) LT_DEPRECATED_USENEW(19_0, "LeadRectBottom");
    LeadPoint LeadRect_TopLeft(LeadRect rect) LT_DEPRECATED_USENEW(19_0, "LeadRectTopLeft");
    LeadPoint LeadRect_TopRight(LeadRect rect) LT_DEPRECATED_USENEW(19_0, "LeadRectTopRight");
    LeadPoint LeadRect_BottomRight(LeadRect rect) LT_DEPRECATED_USENEW(19_0, "LeadRectBottomRight");
    LeadPoint LeadRect_BottomLeft(LeadRect rect) LT_DEPRECATED_USENEW(19_0, "LeadRectBottomLeft");
    LeadPoint LeadRect_Location(LeadRect rect) LT_DEPRECATED_USENEW(19_0, "LeadRectLocation");
    LeadSize LeadRect_Size(LeadRect rect) LT_DEPRECATED_USENEW(19_0, "LeadRectSize");
    int LeadRect_ContainsPoint(LeadRect rect, LeadPoint testPoint) LT_DEPRECATED_USENEW(19_0, "LeadRectContainsPoint");
    int LeadRect_ContainsRect(LeadRect rect, LeadRect testRect) LT_DEPRECATED_USENEW(19_0, "LeadRectContainsRect");
    int LeadRect_IntersectsWith(LeadRect rect, LeadRect testRect) LT_DEPRECATED_USENEW(19_0, "LeadRectIntersectsRect");
    LeadRect LeadRect_Inflate(LeadRect rect, LeadSize size) LT_DEPRECATED_USENEW(19_0, "LeadRectInflate");
    LeadRect LeadRect_Intersect(LeadRect rect1, LeadRect rect2) LT_DEPRECATED_USENEW(19_0, "LeadRectIntersect");
    LeadRect LeadRect_Union(LeadRect rect1, LeadRect rect2) LT_DEPRECATED_USENEW(19_0, "LeadRectUnion");
    LeadRect LeadRect_Offset(LeadRect rect, LeadSize size) LT_DEPRECATED_USENEW(19_0, "LeadRectOffset");
    LeadRect LeadRect_Standardize(LeadRect rect) LT_DEPRECATED_USENEW(19_0, "LeadRectStandardize");
    
    // // // // // // // //
    NS_INLINE LeadRect LeadRectMake(NSInteger x, NSInteger y, NSInteger width, NSInteger height);
    LeadRect LeadRectFromLTRB(NSInteger left, NSInteger top, NSInteger right, NSInteger bottom);
    
    extern const LeadRect LeadRectZero;
    
    BOOL LeadRectIsZero(LeadRect rect);
    BOOL LeadRectEqualToRect(LeadRect rect1, LeadRect rect2);
    
    NSInteger LeadRectLeft(LeadRect rect);
    NSInteger LeadRectRight(LeadRect rect);
    NSInteger LeadRectTop(LeadRect rect);
    NSInteger LeadRectBottom(LeadRect rect);
    
    LeadPoint LeadRectTopLeft(LeadRect rect);
    LeadPoint LeadRectTopRight(LeadRect rect);
    LeadPoint LeadRectBottomRight(LeadRect rect);
    LeadPoint LeadRectBottomLeft(LeadRect rect);
    LeadPoint LeadRectLocation(LeadRect rect);
    
    LeadSize LeadRectSize(LeadRect rect);
    
    BOOL LeadRectContainsPoint(LeadRect rect, LeadPoint point);
    BOOL LeadRectContainsRect(LeadRect rect1, LeadRect rect2);
    BOOL LeadRectIntersectsRect(LeadRect rect1, LeadRect rect2);
    
    LeadRect LeadRectInflate(LeadRect rect, LeadSize size);
    LeadRect LeadRectIntersect(LeadRect rect1, LeadRect rect2);
    LeadRect LeadRectUnion(LeadRect rect1, LeadRect rect2);
    LeadRect LeadRectOffset(LeadRect rect, LeadSize size);
    LeadRect LeadRectStandardize(LeadRect rect);
    
    CGRect CGRectFromLeadRect(LeadRect rect);
    
    LeadRect LeadRectFromCGRect(CGRect rect);
    LeadRect LeadRectFromLeadRectD(LeadRectD rect);
    // // // // // // // //
   
    
    
    NS_ASSUME_NONNULL_BEGIN
    
    // LeadPointD functions
    LeadPointD LeadPointD_Make(double x, double y) LT_DEPRECATED_USENEW(19_0, "LeadPointDMake");
    LeadPointD LeadPointD_Empty(void) LT_DEPRECATED_USENEW(19_0, "LeadPointDEmpty");
    int LeadPointD_IsEmpty(LeadPointD point) LT_DEPRECATED_USENEW(19_0, "LeadPointDIsEmpty");
    int LeadPointD_IsEqual(LeadPointD point1, LeadPointD point2) LT_DEPRECATED_USENEW(19_0, "LeadPointDEqualToPointD");
    LeadPointD LeadPointD_Multiply(LeadPointD point, const LeadMatrix *matrix) LT_DEPRECATED_USENEW(19_0, "LeadPointDMultiply");
    
    // // // // // // // //
    NS_INLINE LeadPointD LeadPointDMake(double x, double y);
    
    extern const LeadPointD LeadPointDZero;
    extern const LeadPointD LeadPointDEmpty;
    
    BOOL LeadPointDIsZero(LeadPointD point);
    BOOL LeadPointDIsEmpty(LeadPointD point);
    BOOL LeadPointDEqualToPointD(LeadPointD point1, LeadPointD point2);
    
    LeadPointD LeadPointDMultiply(LeadPointD point, const LeadMatrix *matrix);
    
    CGPoint CGPointFromLeadPointD(LeadPointD point);
    
    LeadPointD LeadPointDFromCGPoint(CGPoint point);
    LeadPointD LeadPointDFromLeadPoint(LeadPoint point);
    // // // // // // // //
    
    
    
    // LeadSizeD functions
    LeadSizeD LeadSizeD_Make(double width, double height) LT_DEPRECATED_USENEW(19_0, "LeadSizeDMake");
    LeadSizeD LeadSizeD_Empty(void) LT_DEPRECATED_USENEW(19_0, "LeadSizeDZero");
    int LeadSizeD_IsEmpty(LeadSizeD size) LT_DEPRECATED_USENEW(19_0, "LeadSizeDIsZero");
    int LeadSizeD_IsEqual(LeadSizeD size1, LeadSizeD size2) LT_DEPRECATED_USENEW(19_0, "LeadSizeDEqualToSizeD");
    
    // // // // // // // //
    NS_INLINE LeadSizeD LeadSizeDMake(double width, double height);
    
    extern const LeadSizeD LeadSizeDZero;
    
    BOOL LeadSizeDIsZero(LeadSizeD size);
    BOOL LeadSizeDEqualToSizeD(LeadSizeD size1, LeadSizeD size2);
    
    CGSize CGSizeFromLeadSizeD(LeadSizeD size);
    
    LeadSizeD LeadSizeDFromCGSize(CGSize size);
    LeadSizeD LeadSizeDFromLeadSize(LeadSize size);
    // // // // // // // //
    
    
    
    // LeadRectD functions
    LeadRectD LeadRectD_Make(double x, double y, double width, double height) LT_DEPRECATED_USENEW(19_0, "LeadRectDMake");
    LeadRectD LeadRectD_FromLTRB(double left, double top, double right, double bottom) LT_DEPRECATED_USENEW(19_0, "LeadRectDFromLTRB");
    LeadRectD LeadRectD_Empty(void) LT_DEPRECATED_USENEW(19_0, "LeadRectDEmpty");
    int LeadRectD_IsEmpty(LeadRectD rect) LT_DEPRECATED_USENEW(19_0, "LeadRectDIsEmpty");
    int LeadRectD_IsEqual(LeadRectD rect1, LeadRectD rect2) LT_DEPRECATED_USENEW(19_0, "LeadRectDEqualToRectD");
    double LeadRectD_Left(LeadRectD rect) LT_DEPRECATED_USENEW(19_0, "LeadRectDLeft");
    double LeadRectD_Right(LeadRectD rect) LT_DEPRECATED_USENEW(19_0, "LeadRectDRight");
    double LeadRectD_Top(LeadRectD rect) LT_DEPRECATED_USENEW(19_0, "LeadRectDTop");
    double LeadRectD_Bottom(LeadRectD rect) LT_DEPRECATED_USENEW(19_0, "LeadRectDBottom");
    LeadPointD LeadRectD_TopLeft(LeadRectD rect) LT_DEPRECATED_USENEW(19_0, "LeadRectDTopLeft");
    LeadPointD LeadRectD_TopRight(LeadRectD rect) LT_DEPRECATED_USENEW(19_0, "LeadRectDTopRight");
    LeadPointD LeadRectD_BottomRight(LeadRectD rect) LT_DEPRECATED_USENEW(19_0, "LeadRectDBottomRight");
    LeadPointD LeadRectD_BottomLeft(LeadRectD rect) LT_DEPRECATED_USENEW(19_0, "LeadRectDBottomLeft");
    LeadPointD LeadRectD_Location(LeadRectD rect) LT_DEPRECATED_USENEW(19_0, "LeadRectDLocalization");
    LeadSizeD LeadRectD_Size(LeadRectD rect) LT_DEPRECATED_USENEW(19_0, "LeadRectDSize");
    int LeadRectD_ContainsPoint(LeadRectD rect, LeadPointD testPoint) LT_DEPRECATED_USENEW(19_0, "LeadRectDContainsPoint");
    int LeadRectD_ContainsRect(LeadRectD rect, LeadRectD testRect) LT_DEPRECATED_USENEW(19_0, "LeadRectDContainsRect");
    int LeadRectD_IntersectsWith(LeadRectD rect, LeadRectD testRect) LT_DEPRECATED_USENEW(19_0, "LeadRectDIntersectsWith");
    LeadRectD LeadRectD_Intersect(LeadRectD rect1, LeadRectD rect2) LT_DEPRECATED_USENEW(19_0, "LeadRectDIntersection");
    LeadRectD LeadRectD_Union(LeadRectD rect1, LeadRectD rect2) LT_DEPRECATED_USENEW(19_0, "LeadRectDUnion");
    LeadRectD LeadRectD_Offset(LeadRectD rect, LeadSizeD size) LT_DEPRECATED_USENEW(19_0, "LeadRectDOffset");
    LeadRectD LeadRectD_Inflate(LeadRectD rect, LeadSizeD size) LT_DEPRECATED_USENEW(19_0, "LeadRectDInflate");
    LeadRectD LeadRectD_Scale(LeadRectD rect, double scaleX, double scaleY) LT_DEPRECATED_USENEW(19_0, "LeadRectDScale");
    LeadRectD LeadRectD_Transform(LeadRectD rect, const LeadMatrix *matrix) LT_DEPRECATED_USENEW(19_0, "LeadRectDTransform");
    
    // // // // // // // //
    NS_INLINE LeadRectD LeadRectDMake(double x, double y, double width, double height);
    LeadRectD LeadRectDFromLTRB(double left, double top, double right, double bottom);
    
    extern const LeadRectD LeadRectDEmpty;
    extern const LeadRectD LeadRectDZero;
    
    BOOL LeadRectDEqualToRectD(LeadRectD rect1, LeadRectD rect2);
    BOOL LeadRectDIsEmpty(LeadRectD rect);
    BOOL LeadRectDIsZero(LeadRectD rect);
    
    double LeadRectDLeft(LeadRectD rect);
    double LeadRectDRight(LeadRectD rect);
    double LeadRectDTop(LeadRectD rect);
    double LeadRectDBottom(LeadRectD rect);
    
    LeadPointD LeadRectDTopLeft(LeadRectD rect);
    LeadPointD LeadRectDTopRight(LeadRectD rect);
    LeadPointD LeadRectDBottomRight(LeadRectD rect);
    LeadPointD LeadRectDBottomLeft(LeadRectD rect);
    LeadPointD LeadRectDLocation(LeadRectD rect);
    
    LeadSizeD LeadRectDSize(LeadRectD rect);
    
    BOOL LeadRectDContainsPoint(LeadRectD rect, LeadPointD point);
    BOOL LeadRectDContainsRect(LeadRectD rect1, LeadRectD rect2);
    BOOL LeadRectDIntersectsWith(LeadRectD rect1, LeadRectD rect2);
    
    LeadRectD LeadRectDIntersection(LeadRectD rect1, LeadRectD rect2);
    LeadRectD LeadRectDUnion(LeadRectD rect1, LeadRectD rect2);
    LeadRectD LeadRectDOffset(LeadRectD rect, LeadPointD offset);
    LeadRectD LeadRectDInflate(LeadRectD rect, LeadSizeD size);
    LeadRectD LeadRectDScale(LeadRectD rect, double scaleX, double scaleY);
    LeadRectD LeadRectDTransform(LeadRectD rect, const LeadMatrix *matrix);
    
    CGRect CGRectFromLeadRectD(LeadRectD rect);
    
    LeadRectD LeadRectDFromCGRect(CGRect rect);
    LeadRectD LeadRectDFromLeadRect(LeadRect rect);
    // // // // // // // //
   
    
    
    // LeadLengthD functions
    LeadLengthD LeadLengthD_Make(double value) LT_DEPRECATED_USENEW(19_0, "LeadLengthDMake");
    int LeadLengthD_IsEqual(LeadLengthD length1, LeadLengthD length2) LT_DEPRECATED_USENEW(19_0, "LeadLengthDEqualToLengthD");
    
    // // // // // // // //
    LeadLengthD LeadLengthDMake(double value);
    
    BOOL LeadLengthDEqualToLengthD(LeadLengthD length1, LeadLengthD length2);
    // // // // // // // //
    
    
   
    // LeadMatrix functions
    void LeadMatrix_Set(LeadMatrix *matrix, double m11, double m12, double m21, double m22, double offsetX, double offsetY) LT_DEPRECATED_USENEW(19_0, "LeadMatrixSet");
    extern const LeadMatrix LeadMatrix_Identity LT_DEPRECATED_USENEW(19_0, "LeadMatrixIdentity");
    int LeadMatrix_IsIdentity(const LeadMatrix *matrix) LT_DEPRECATED_USENEW(19_0, "LeadMatrixEqualToMatrix(matrix, &LeadMatrixIdentity)");
    double LeadMatrix_Determinant(const LeadMatrix *matrix) LT_DEPRECATED_USENEW(19_0, "LeadMatrixDeterminant");
    int LeadMatrix_HasInverse(const LeadMatrix *matrix) LT_DEPRECATED_USENEW(19_0, "LeadMatrixHasInverse");
    double LeadMatrix_GetM11(const LeadMatrix *matrix) LT_DEPRECATED_USENEW(19_0, "LeadMatrixGetM11");
    void LeadMatrix_SetM11(LeadMatrix *matrix, double value) LT_DEPRECATED_USENEW(19_0, "LeadMatrixSetM11");
    double LeadMatrix_GetM12(const LeadMatrix *matrix) LT_DEPRECATED_USENEW(19_0, "LeadMatrixGetM12");
    void LeadMatrix_SetM12(LeadMatrix *matrix, double value) LT_DEPRECATED_USENEW(19_0, "LeadMatrixSetM12");
    double LeadMatrix_GetM21(const LeadMatrix *matrix) LT_DEPRECATED_USENEW(19_0, "LeadMatrixGetM21");
    void LeadMatrix_SetM21(LeadMatrix *matrix, double value) LT_DEPRECATED_USENEW(19_0, "LeadMatrixSetM21");
    double LeadMatrix_GetM22(const LeadMatrix *matrix) LT_DEPRECATED_USENEW(19_0, "LeadMatrixGetM22");
    void LeadMatrix_SetM22(LeadMatrix *matrix, double value) LT_DEPRECATED_USENEW(19_0, "LeadMatrixSetM22");
    double LeadMatrix_GetOffsetX(const LeadMatrix *matrix) LT_DEPRECATED_USENEW(19_0, "LeadMatrixGetOffsetX");
    void LeadMatrix_SetOffsetX(LeadMatrix *matrix, double value) LT_DEPRECATED_USENEW(19_0, "LeadMatrixSetOffsetX");
    double LeadMatrix_GetOffsetY(const LeadMatrix *matrix) LT_DEPRECATED_USENEW(19_0, "LeadMatrixGetOffsetY");
    void LeadMatrix_SetOffsetY(LeadMatrix *matrix, double value) LT_DEPRECATED_USENEW(19_0, "LeadMatrixSetOffsetY");
    void LeadMatrix_SetIdentity(LeadMatrix *matrix) LT_DEPRECATED_USENEW(19_0, "LeadMatrixSetIdentity");
    void LeadMatrix_Multiply(LeadMatrix *result, const LeadMatrix *matrix1, const LeadMatrix *matrix2) LT_DEPRECATED_USENEW(19_0, "LeadMatrixMultiply");
    void LeadMatrix_Append(LeadMatrix *result, const LeadMatrix *matrix) LT_DEPRECATED_USENEW(19_0, "LeadMatrixAppend");
    void LeadMatrix_Prepend(LeadMatrix *result, const LeadMatrix *matrix) LT_DEPRECATED_USENEW(19_0, "LeadMatrixPrepend");
    void LeadMatrix_Rotate(LeadMatrix *matrix, double degrees) LT_DEPRECATED_USENEW(19_0, "LeadMatrixRotate");
    void LeadMatrix_RotatePrepend(LeadMatrix *matrix, double degrees) LT_DEPRECATED_USENEW(19_0, "LeadMatrixRotatePrepend");
    void LeadMatrix_RotateAt(LeadMatrix *matrix, double degrees, double centerX, double centerY) LT_DEPRECATED_USENEW(19_0, "LeadMatrixRotateAt");
    void LeadMatrix_RotateAtPrepend(LeadMatrix *matrix, double degrees, double centerX, double centerY) LT_DEPRECATED_USENEW(19_0, "LeadMatrixRotateAtPrepend");
    void LeadMatrix_Scale(LeadMatrix *matrix, double scaleX, double scaleY) LT_DEPRECATED_USENEW(19_0, "LeadMatrixScale");
    void LeadMatrix_ScalePrepend(LeadMatrix *matrix, double scaleX, double scaleY) LT_DEPRECATED_USENEW(19_0, "LeadMatrixScalePrepend");
    void LeadMatrix_ScaleAt(LeadMatrix *matrix, double scaleX, double scaleY, double centerX, double centerY) LT_DEPRECATED_USENEW(19_0, "LeadMatrixScaleAt");
    void LeadMatrix_ScaleAtPrepend(LeadMatrix *matrix, double scaleX, double scaleY, double centerX, double centerY) LT_DEPRECATED_USENEW(19_0, "LeadMatrixScaleAtPrepend");
    void LeadMatrix_Skew(LeadMatrix *matrix, double degreesX, double degreesY) LT_DEPRECATED_USENEW(19_0, "LeadMatrixSkew");
    void LeadMatrix_SkewPrepend(LeadMatrix *matrix, double degreesX, double degreesY) LT_DEPRECATED_USENEW(19_0, "LeadMatrixSkewPrepend");
    void LeadMatrix_Translate(LeadMatrix *matrix, double offsetX, double offsetY) LT_DEPRECATED_USENEW(19_0, "LeadMatrixTranslate");
    void LeadMatrix_TranslatePrepend(LeadMatrix *matrix, double offsetX, double offsetY) LT_DEPRECATED_USENEW(19_0, "LeadMatrixTranslatePrepend");
    LeadPointD LeadMatrix_TransformPoint(const LeadMatrix *matrix, LeadPointD point) LT_DEPRECATED_USENEW(19_0, "LeadMatrixTransformPoint");
    LeadPointD LeadMatrix_TransformVector(const LeadMatrix *matrix, LeadPointD point) LT_DEPRECATED_USENEW(19_0, "LeadMatrixTransformVector");
    void LeadMatrix_TransformPoints(const LeadMatrix *matrix, LeadPointD* points, unsigned int count) LT_DEPRECATED_USENEW(19_0, "LeadMatrixTransformPoints");
    LeadRectD LeadMatrix_TransformRect(const LeadMatrix *matrix, LeadRectD rect) LT_DEPRECATED_USENEW(19_0, "LeadMatrixTransformRect");
    int LeadMatrix_Invert(LeadMatrix *matrix) LT_DEPRECATED_USENEW(19_0, "LeadMatrixInvert");
    int LeadMatrix_IsEqual(const LeadMatrix *matrix1, const LeadMatrix *matrix2) LT_DEPRECATED_USENEW(19_0, "LeadMatrixEqualToMatrix");
    
    // // // // // // // //
    LeadMatrix LeadMatrixMake(double m11, double m12, double m21, double m22, double offsetX, double offsetY);
    void LeadMatrixSet(LeadMatrix *matrix, double m11, double m12, double m21, double m22, double offsetX, double offsetY);
    
    extern const LeadMatrix LeadMatrixIdentity;
    
    double LeadMatrixDeterminant(const LeadMatrix *matrix);
    double LeadMatrixGetM11(const LeadMatrix *matrix);
    double LeadMatrixGetM12(const LeadMatrix *matrix);
    double LeadMatrixGetM21(const LeadMatrix *matrix);
    double LeadMatrixGetM22(const LeadMatrix *matrix);
    double LeadMatrixGetOffsetX(const LeadMatrix *matrix);
    double LeadMatrixGetOffsetY(const LeadMatrix *matrix);
    
    BOOL LeadMatrixHasInverse(const LeadMatrix *matrix);
    BOOL LeadMatrixInvert(LeadMatrix *matrix);
    
    void LeadMatrixSetM11(LeadMatrix *matrix, double value);
    void LeadMatrixSetM12(LeadMatrix *matrix, double value);
    void LeadMatrixSetM21(LeadMatrix *matrix, double value);
    void LeadMatrixSetM22(LeadMatrix *matrix, double value);
    void LeadMatrixSetOffsetX(LeadMatrix *matrix, double value);
    void LeadMatrixSetOffsetY(LeadMatrix *matrix, double value);
    void LeadMatrixSetIdentity(LeadMatrix *matrix);
    
    void LeadMatrixMultiply(LeadMatrix *result, const LeadMatrix *matrix1, const LeadMatrix *matrix2);
    void LeadMatrixAppend(LeadMatrix *result, const LeadMatrix *matrix);
    void LeadMatrixPrepend(LeadMatrix *result, const LeadMatrix *matrix);
    void LeadMatrixRotate(LeadMatrix *matrix, double degrees);
    void LeadMatrixRotatePrepend(LeadMatrix *matrix, double degrees);
    void LeadMatrixRotateAt(LeadMatrix *matrix, double degrees, double centerX, double centerY);
    void LeadMatrixRotateAtPrepend(LeadMatrix *matrix, double degrees, double centerX, double centerY);
    void LeadMatrixScale(LeadMatrix *matrix, double scaleX, double scaleY);
    void LeadMatrixScalePrepend(LeadMatrix *matrix, double scaleX, double scaleY);
    void LeadMatrixScaleAt(LeadMatrix *matrix, double scaleX, double scaleY, double centerX, double centerY);
    void LeadMatrixScaleAtPrepend(LeadMatrix *matrix, double scaleX, double scaleY, double centerX, double centerY);
    void LeadMatrixSkew(LeadMatrix *matrix, double degreesX, double degreesY);
    void LeadMatrixSkewPrepend(LeadMatrix *matrix, double degreesX, double degreesY);
    void LeadMatrixTranslate(LeadMatrix *matrix, double offsetX, double offsetY);
    void LeadMatrixTranslatePrepend(LeadMatrix *matrix, double offsetX, double offsetY);
    
    LeadPointD LeadMatrixTransformPoint(const LeadMatrix *matrix, LeadPointD point);
    LeadPointD LeadMatrixTransformVector(const LeadMatrix *matrix, LeadPointD point);
    LeadRectD  LeadMatrixTransformRect(const LeadMatrix *matrix, LeadRectD rect);
    
    void LeadMatrixTransformPoints(const LeadMatrix *matrix, LeadPointD* points, NSUInteger count);
    
    BOOL LeadMatrixEqualToMatrix(const LeadMatrix *matrix1, const LeadMatrix *matrix2);
    // // // // // // // //
    
    // // // // // // // //
    LeadPoint LeadPointMake(NSInteger x, NSInteger y) {
        LeadPoint point = {x, y}; return point;
    }
    
    LeadSize LeadSizeMake(NSInteger width, NSInteger height) {
        LeadSize size = {width, height}; return size;
    }
    
    LeadRect LeadRectMake(NSInteger x, NSInteger y, NSInteger width, NSInteger height) {
        LeadRect rect = {x, y, width, height}; return rect;
    }
    
    LeadPointD LeadPointDMake(double x, double y) {
        LeadPointD point = {x, y}; return point;
    }
    
    LeadSizeD LeadSizeDMake(double width, double height) {
        LeadSizeD size = {width, height}; return size;
    }
    
    LeadRectD LeadRectDMake(double x, double y, double width, double height) {
        LeadRectD rect = {x, y, width, height}; return rect;
    }
    // // // // // // // //
    
    // // // // // // // //
#if defined(__OBJC__)
    @interface NSValue (LTPrimitives)

    @property (nonatomic, assign, readonly) LeadPoint leadPointValue;
    @property (nonatomic, assign, readonly) LeadSize leadSizeValue;
    @property (nonatomic, assign, readonly) LeadRect leadRectValue;

    @property (nonatomic, assign, readonly) LeadPointD leadPointDValue;
    @property (nonatomic, assign, readonly) LeadSizeD leadSizeDValue;
    @property (nonatomic, assign, readonly) LeadRectD leadRectDValue;

    @property (nonatomic, assign, readonly) LeadLengthD leadLengthDValue;

    @property (nonatomic, assign, readonly) LeadMatrix leadMatrixValue;



    - (instancetype)initWithLeadPoint:(LeadPoint)point;
    - (instancetype)initWithLeadSize:(LeadSize)size;
    - (instancetype)initWithLeadRect:(LeadRect)rect;

    - (instancetype)initWithLeadPointD:(LeadPointD)point;
    - (instancetype)initWithLeadSizeD:(LeadSizeD)size;
    - (instancetype)initWithLeadRectD:(LeadRectD)rect;

    - (instancetype)initWithLeadLengthD:(LeadLengthD)length;

    - (instancetype)initWithLeadMatrix:(LeadMatrix)matrix;

    @end
#endif // #if defined(__OBJC__)
    // // // // // // // //
    
    NS_ASSUME_NONNULL_END

#pragma pack()

#if defined(__cplusplus)
}
#endif // #if defined(__cplusplus)

#endif // #if !defined(LTPRIMITIVES_XCODE_H)
