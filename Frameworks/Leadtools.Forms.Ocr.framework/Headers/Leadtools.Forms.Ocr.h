//
//  Leadtools.Forms.Ocr.h
//  Leadtools.Forms.Ocr
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#if !defined(LEADTOOLS_FRAMEWORK)
#error Leadtools.framework not defined before Leadtools.Forms.Ocr.framework. Please include Leadtools/Leadtools.h before including Leadtools.Forms.Ocr/Leadtools.Forms.Ocr.h

#elif !defined(LEADTOOLS_CODECS_FRAMEWORK)
#error Leadtools.Codecs.framework not defined before Leadtools.Forms.Ocr.framework. Please include Leadtools.Codecs/Leadtools.Codecs.h before including Leadtools.Forms.Ocr/Leadtools.Forms.Ocr.h

#elif !defined(LEADTOOLS_FORMS_DOCUMENTWRITERS_FRAMEWORK)
#error Leadtools.Forms.DocumentWriters.framework not defined before Leadtools.Forms.Ocr.framework. Please include Leadtools.Forms.DocumentWriters/Leadtools.Forms.DocumentWriters.h before including Leadtools.Forms.Ocr/Leadtools.Forms.Ocr.h

#else

#if !defined(LEADTOOLS_FORMS_OCR_FRAMEWORK)
#  define LEADTOOLS_FORMS_OCR_FRAMEWORK
#endif // #if !defined(LEADTOOLS_FORMS_OCR_FRAMEWORK)

#import "LTOcrDocument.h"
#import "LTOcrDocumentManager.h"
#import "LTOcrSpellCheckManager.h"
#import "LTOcrLanguage.h"
#import "LTOcrLanguageManager.h"
#import "LTOcrSettingDescriptor.h"
#import "LTOcrSettingManager.h"
#import "LTOcrEngineType.h"
#import "LTOcrEngine.h"
#import "LTOcrEngineManager.h"
#import "LTOcrMicrData.h"
#import "LTOcrWriteXmlOptions.h"
#import "LTOcrPage.h"
#import "LTOcrProgressData.h"
#import "LTOcrPageCollection.h"
#import "LTOcrPageCharacters.h"
#import "LTOcrZoneManager.h"
#import "LTOcrOmrOptions.h"
#import "LTOcrZoneType.h"
#import "LTOcrZone.h"
#import "LTOcrZoneCell.h"
#import "LTOcrZoneCollection.h"
#import "LTOcrImageSharingMode.h"
#import "LTOcrAutoPreprocessPageCommand.h"
#import "LTOcrCharacter.h"
#import "LTOcrWord.h"
#import "LTOcrMicrData.h"
#import "LTOcrStatistic.h"
#import "LTOcrAutoRecognizeManagerJobError.h"
#import "LTOcrAutoRecognizeJobOperationEventArgs.h"
#import "LTOcrAutoRecognizeJobData.h"
#import "LTOcrAutoRecognizeJob.h"
#import "LTOcrAutoRecognizeManager.h"

#endif