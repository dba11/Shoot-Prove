/*************************************************************
   Ltsys.h - operating system definition
   Copyright (c) 1991-2016 LEAD Technologies, Inc.
   All Rights Reserved.
*************************************************************/

#if !defined(LTSYS_H)
#define LTSYS_H

#if defined(_LEAD_FORCE_UNICODE_)
   #define FOR_UNICODE
#endif // if defined(_LEAD_FORCE_UNICODE_)

#if defined(_UNICODE)
   // NOTE: if you use the non-UNICODE version of LEADTOOLS in a UNICODE app, then you must undefine this !
   #define FOR_UNICODE
   #if !defined(UNICODE)
      #error UNICODE and _UNICODE must be defined!!!
   #endif // #if !defined(UNICODE)
#endif // #if defined(_UNICODE)

#if defined(_WINRT_DLL) || defined(VCWINRT_DLL)
#include <winapifamily.h> // for WINAPI_FAMILY_APP
#endif // #if defined(_WINRT_DLL) || defined(VCWINRT_DLL)

#if defined(VCWINRT_DLL) || defined(_WINRT_DLL) || (defined(WINAPI_FAMILY) && (WINAPI_FAMILY==WINAPI_FAMILY_APP)) || (defined(WINAPI_FAMILY) && (WINAPI_FAMILY==WINAPI_FAMILY_PHONE_APP))
   #define FOR_WINRT
   #if defined(WINAPI_FAMILY_PHONE_APP) && (WINAPI_FAMILY == WINAPI_FAMILY_PHONE_APP)
   #define FOR_WINRT_PHONE
   #endif // #if WINAPI_FAMILY == WINAPI_FAMILY_PHONE_APP
   #if defined(_M_ARM) || FOR_ARM
      #define FOR_WINRTARM
   #elif defined(_M_X64) || FOR_X64
      #define FOR_WINRT64
   #else
      #define FOR_WINRT32
   #endif // #if defined(_M_ARM)
   #define L_FOR_VISUALSTUDIO
#elif defined(WIN64) || defined(_WIN64)
   #define FOR_WIN64
#elif defined(WIN32)
   #define FOR_WIN32
#endif // #if defined(WIN64)

#if !defined(FOR_WINRT) && (defined(WIN32) || defined(WIN64))
   #define FOR_WINDOWS
   #define L_FOR_VISUALSTUDIO
#endif // #if !defined(FOR_WINRT) && (defined(WIN32) || defined(WIN64))

#if defined(FOR_IOS) || defined(FOR_OSX)
#  define FOR_XCODE
#endif // #if defined(FOR_IOS) || defined(FOR_OSX)

#if defined(FOR_ANDROID) || defined(FOR_XCODE) || defined(FOR_LINUX)
   #define FOR_UNIX
#endif // #if defined(FOR_ANDROID) || defined(FOR_XCODE) || defined(FOR_LINUX)

#if defined(FOR_OSX) || (defined(FOR_IOS) && __LP64__)
#  define FOR_UNIX64
#elif defined(__LP64__) || defined(_LP64)
#  define FOR_UNIX64
#endif // #if defined(FOR_OSX) || (defined(FOR_IOS) && __LP64__)

#if !defined(FOR_X64) && (defined(FOR_WIN64) || defined(FOR_UNIX64))
#  define FOR_X64
#endif // #if !defined(FOR_X64) && (defined(FOR_WIN64) || defined(FOR_UNIX64))

#if defined(FOR_ANDROID) || defined(FOR_XCODE)
   #define L_FOR_GCC
#endif // #if defined(FOR_ANDROID) || defined(FOR_XCODE)

#if defined(FOR_XCODE)
   #define L_FOR_LLVMGCC
#endif // #if defined(FOR_ANDROID) || defined(FOR_XCODE)

#if defined(_DEBUG) || defined(DEBUG)
   #define FOR_DEBUG
#endif // #if defined(_DEBUG)

#if defined(FOR_WINRT) || defined(FOR_WINRT_PHONE) || defined(FOR_IOS) || defined(FOR_ANDROID)
   #define FOR_APP_STORE
#endif // #if defined(FOR_WINRT) || defined(FOR_WINRT_PHONE) || defined(FOR_IOS) || defined(FOR_ANDROID)

#include "ltver.h"

#if defined(FOR_LINUX) || defined(FOR_ANDROID) || (defined(FOR_WINDOWS) && !defined(FOR_MANAGED) && defined(LEADTOOLS_V19_OR_LATER))
   #define FOR_JNI
#endif // #if defined(FOR_LINUX) || defined(FOR_ANDROID) || defined(FOR_XCODE) || (defined(FOR_WINDOWS) && !defined(FOR_MANAGED) && defined(LEADTOOLS_V19_OR_LATER))

// LEADTOOLS Components

#define LT_COMP_BITMAPREGION           // Bitmap region support
#define LT_USE_LTDIS_DISPATCH          // LTDIS functions should be called through a dispatch (separate DLL)
#define LT_COMP_DISKBITMAPS            // Disk bitmaps support
#define LT_COMP_TILEDBITMAPS           // Tiled bitmaps support
#define LT_COMP_SUPERCOMPRESSEDBITMAPS // Super compressed bitmaps support
#define LT_COMP_BITMAPOVERLAYS         // Bitmap overlays support
#define LT_COMP_BITMAPEXTRADATA        // Bitmap DICOM data support
#define LT_COMP_BITMAPDATACALLBACKS    // Bitmap data callbacks support
#define LT_COMP_VECTOR                 // Vector support
#define LT_COMP_MAXIMUMHANDLECOUNT     // Track maximum handle count
#define LT_COMP_ANSILIBRARY            // ANSI support (exported functions with ANSI version)
#define LT_COMP_UNICODE                // Unicode support (support L_WCHAR as 2-byte character)
#define LT_COMP_DIB                    // DIB support (convert and change to/from DIB)
#define LT_COMP_ADVANCEDDIB            // Advanced DIB (JPEG or RLE compressed) support, header version 4 and up (LT_COMP_DIB must be defined)
#define LT_COMP_HUGEMEMORY             // Huge memory support
#define LT_COMP_EMAILFORMATS           // email file formats (PST, MSG, EML)
#define LT_COMP_SVG                    // SVG support

// Undef the components not supported by the platform here
#if defined(FOR_WINDOWS)
   #if !defined(LEADTOOLS_V16_OR_LATER)
      #undef LT_COMP_BITMAPEXTRADATA
   #endif // #if !defined(LEADTOOLS_V16_OR_LATER)

   #if !defined(LEADTOOLS_V18_OR_LATER)
      #undef LT_COMP_BITMAPDATACALLBACKS
   #endif // #if !defined(LEADTOOLS_V18_OR_LATER)

#  if !defined(LEADTOOLS_V19_OR_LATER)
#     undef LT_COMP_EMAILFORMATS
#  endif // #  if !defined(LEADTOOLS_V19_OR_LATER)

#endif // #if defined(FOR_WINDOWS)

// FOR_MANAGED uses FOR_WINDOWS, so it is a combination of both
#if defined(FOR_MANAGED)
   #undef LT_USE_LTDIS_DISPATCH
#endif // #if defined(FOR_MANAGED)

#if !defined(LEADTOOLS_V19_OR_LATER)
#  undef LT_COMP_SVG
#endif // !defined(LEADTOOLS_V19_OR_LATER)

#if (!defined(FOR_WINDOWS) && !defined(LEADTOOLS_V19_OR_LATER))
#  undef LT_COMP_VECTOR
#endif // #if !defined(FOR_WINDOWS) && !defined(LEADTOOLS_V19_OR_LATER)

#if defined(FOR_ANDROID)
   #undef LT_USE_LTDIS_DISPATCH
   #undef LT_COMP_UNICODE
#if !defined(LEADTOOLS_V19_OR_LATER)
   #undef LT_COMP_DISKBITMAPS
   #undef LT_COMP_TILEDBITMAPS
   #undef LT_COMP_SUPERCOMPRESSEDBITMAPS
#endif
   #undef LT_COMP_MAXIMUMHANDLECOUNT
   #undef LT_COMP_ADVANCEDDIB
   #undef LT_COMP_EMAILFORMATS
#endif // #if defined(FOR_ANDROID)

#if defined(FOR_LINUX)
   #undef LT_USE_LTDIS_DISPATCH
   #undef LT_COMP_UNICODE
#if !defined(LEADTOOLS_V19_OR_LATER)
   #undef LT_COMP_DISKBITMAPS
   #undef LT_COMP_TILEDBITMAPS
   #undef LT_COMP_SUPERCOMPRESSEDBITMAPS
#endif
   #undef LT_COMP_MAXIMUMHANDLECOUNT
   #undef LT_COMP_ADVANCEDDIB
   #undef LT_COMP_EMAILFORMATS
#endif // defined(FOR_LINUX)

#if defined(FOR_XCODE)
   #undef LT_USE_LTDIS_DISPATCH
   #undef LT_COMP_UNICODE
#if !defined(LEADTOOLS_V19_OR_LATER)
   #undef LT_COMP_SUPERCOMPRESSEDBITMAPS
#endif // #if !defined(LEADTOOLS_V19_OR_LATER)
   #undef LT_COMP_MAXIMUMHANDLECOUNT
   #undef LT_COMP_ADVANCEDDIB
   #undef LT_COMP_EMAILFORMATS
#endif // #if defined(FOR_XCODE)

#if defined(FOR_WINRT)
   #undef LT_USE_LTDIS_DISPATCH
   #undef LT_COMP_MAXIMUMHANDLECOUNT
   #undef LT_COMP_ADVANCEDDIB
#endif // #if defined(FOR_WINRT)

#if defined(FOR_JUSTLIB)
   #undef LT_USE_LTDIS_DISPATCH
   #undef LT_COMP_SUPERCOMPRESSEDBITMAPS
   #undef LT_COMP_BITMAPOVERLAYS
#endif // #if defined(FOR_JUSTLIB)

#if defined(LT_COMP_DISKBITMAPS) || defined(LT_COMP_TILEDBITMAPS) || defined(LT_COMP_HUGEMEMORY)
#  define LT_COMP_TEMPFILES
#endif // #if defined(LT_COMP_DISKBITMAPS) || defined(LT_COMP_TILEDBITMAPS) || defined(LT_COMP_HUGEMEMORY)

#if defined(LT_COMP_BITMAPDATACALLBACKS)
// If LEAK DETECTOR kernel or a debug kernel, then use the Lock/Unlock detector and BITMAPHANDLE detector
#if defined(USE_LEAK_DETECTOR)
#  define USE_LOCKUNLOCK_DETECTOR
#if defined(FOR_MANAGED)
#  define USE_BITMAPHANDLE_DETECTOR
#endif // #if defined(FOR_MANAGED)
#endif // #if defined(USE_LEAK_DETECTOR)
#endif // #if defined(USE_LEAK_DETECTOR) && defined(LT_COMP_BITMAPDATACALLBACKS)

#if !defined(LEADTOOLS_V18_OR_LATER)
   #if defined(FOR_WINDOWS)
      #include <windows.h>
   #endif // #if defined(FOR_WINDOWS)
#else
   #include "ltplatforms.h"
#endif // #if !defined(LEADTOOLS_V18_OR_LATER)

#if defined(FOR_UNIX)
#  define LT_EXPORTED EXTERN_C
#else
#  define LT_EXPORTED
#endif

#endif // #if !defined(LTSYS_H)
