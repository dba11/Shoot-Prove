//
//  Leadtools.Kernel.h
//  Leadtools.Kernel Framework
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#if !defined(LEADTOOLS_KERNEL_H)
#define LEADTOOLS_KERNEL_H

#if !defined(FOR_IOS) && !defined(FOR_OSX)
// Before you can #include or #import this file, you must add one
// of the following defines FOR_IOS for iOS applications or FOR_OSX
// for OSX applications
// 
// e.g.
// #define FOR_IOS   // This is an iOS application
// #import <Leadtools.Kernel/Leadtools.Kernel.h>  // Or #include
#  error FOR_IOS or FOR_OSX must be defined
#endif // #if !defined(FOR_IOS) && !defined(FOR_OSX)

#if !defined(LEADTOOLS_KERNEL_FRAMEWORK)
#  define LEADTOOLS_KERNEL_FRAMEWORK
#endif // #if !defined(LEADTOOLS_KERNEL_FRAMEWORK)

#if !defined(LT_COMP_UNICODE)
#  define LT_COMP_UNICODE
#endif // #if !defined(LT_COMP_UNICODE)

#include "Kernel/Ltkrn.h"
#include "Kernel/Ltdis.h"
#include "Kernel/Ltimg.h"
#include "Kernel/Ltfil.h"
#include "Kernel/Ltbar.h"
#include "Kernel/LtBarcodeDispatch.h"
#include "Kernel/Ltocr.h"
#include "Kernel/LtSpellCheck.h"
#include "Kernel/ltdocwrt.h"
#include "Kernel/ltsvg.h"

#endif // #if !defined(LEADTOOLS_KERNEL_H)