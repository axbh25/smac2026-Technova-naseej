// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'نسيج';

  @override
  String get appNameEnglish => 'Naseej';

  @override
  String get appNameArabic => 'نسيج';

  @override
  String get tagline => 'كل جيل يعلّم، وكل جيل يتعلّم.';

  @override
  String get englishLanguage => 'English';

  @override
  String get arabicLanguage => 'العربية';

  @override
  String get privacyTitle => 'الخصوصية أولًا';

  @override
  String get privacyBody => 'لا تحتاج إلى حساب أو مشاركة موقعك للبدء.';

  @override
  String get continueLabel => 'متابعة';

  @override
  String get changeLanguageLabel => 'تغيير اللغة';

  @override
  String get profileSetupTitle => 'أنشئ ملفك المحلي';

  @override
  String get profileSetupBody =>
      'اختر اسمًا مختصرًا ودورك في الأسرة. تبقى هذه البيانات على هذا الهاتف.';

  @override
  String get nicknameLabel => 'الاسم أو اللقب';

  @override
  String get nicknameHint => 'مثل: فاطمة';

  @override
  String get chooseRoleLabel => 'اختر دورك';

  @override
  String get roleGrandparent => 'جد أو جدة';

  @override
  String get roleParent => 'أب أو أم';

  @override
  String get roleTeen => 'مراهق أو مراهقة';

  @override
  String get roleChild => 'طفل أو طفلة';

  @override
  String get saveProfileLabel => 'حفظ الملف';

  @override
  String get savingProfileLabel => 'جارٍ الحفظ...';

  @override
  String get profileSaveError => 'تعذر حفظ هذا الملف. حاول مرة أخرى.';

  @override
  String homeGreeting(String name) {
    return 'مرحبًا، $name';
  }

  @override
  String get profileStoredLocally => 'محفوظ على هذا الهاتف';

  @override
  String get emptyWeaveTitle => 'يبدأ نسيج عائلتك من هنا';

  @override
  String get emptyWeaveBody => 'علِّم مهارة وتعلَّم مهارة لتضيفوا أول خيط.';

  @override
  String get teachSkillLabel => 'علِّم مهارة';

  @override
  String get learnSkillLabel => 'تعلَّم مهارة';

  @override
  String get featureComingSoon => 'ستُربط هذه الميزة في الإصدار القادم.';

  @override
  String get teachSkillScreenTitle => 'علِّم مهارة';

  @override
  String get teacherSectionTitle => 'المعلّم';

  @override
  String get teacherCardBody => 'سيكون هذا الملف هو المعلّم في هذه المسودة.';

  @override
  String get learnerSectionTitle => 'من سيتعلّم؟';

  @override
  String get learnerNicknameLabel => 'اسم المتعلّم أو لقبه';

  @override
  String get learnerNicknameHint => 'مثل: مريم';

  @override
  String get learnerRoleLabel => 'اختر دور المتعلّم في الأسرة';

  @override
  String get categorySectionTitle => 'اختر فئة المهارة';

  @override
  String get skillCategoryHeritage => 'التراث والآداب';

  @override
  String get skillCategoryEveryday => 'مهارة يومية';

  @override
  String get skillCategoryDigital => 'الثقة الرقمية';

  @override
  String get skillCategoryFamilyCare => 'الرعاية العائلية';

  @override
  String get contextPhotoSectionTitle => 'صورة توضيحية';

  @override
  String get contextPhotoTitle => 'أظهر الغرض أو المكان';

  @override
  String get contextPhotoBody =>
      'أضف صورة اختيارية تساعد المتعلّم على فهم المهارة.';

  @override
  String get addContextPhotoLabel => 'أضف صورة توضيحية';

  @override
  String get replaceContextPhotoLabel => 'استبدال الصورة';

  @override
  String get removeContextPhotoLabel => 'إزالة الصورة';

  @override
  String get takePhotoLabel => 'التقاط صورة';

  @override
  String get chooseFromGalleryLabel => 'اختيار من المعرض';

  @override
  String get cancelLabel => 'إلغاء';

  @override
  String get photoProcessingLabel => 'جارٍ تجهيز الصورة…';

  @override
  String get photoPrivacyNotice =>
      'تبقى هذه الصورة على هذا الهاتف ولا تُرسل إلى الذكاء الاصطناعي في النسخة الأولية.';

  @override
  String get photoPermissionDenied =>
      'تم رفض الوصول إلى الصور. تابع دون صورة أو غيّر الإذن من إعدادات Android.';

  @override
  String get photoSourceUnavailable =>
      'الكاميرا أو مصدر الصور غير متاح. تابع دون صورة.';

  @override
  String get photoInvalidFile => 'تعذر فتح الصورة المحددة. اختر صورة أخرى.';

  @override
  String get photoStorageError =>
      'تعذر نسخ الصورة إلى التخزين الخاص بالتطبيق. تابع دونها أو حاول مرة أخرى.';

  @override
  String get photoGenericError =>
      'تعذر إضافة الصورة. حاول مرة أخرى أو تابع دونها.';

  @override
  String get contextPhotoUnavailable =>
      'لم تعد الصورة المحفوظة متاحة على هذا الهاتف.';

  @override
  String get voiceInputSectionTitle => 'الإدخال الصوتي';

  @override
  String get voiceInputTitle => 'تحدّث بشرحك';

  @override
  String get voiceInputBody =>
      'تحدّث بشرح قصير، وستظهر الكلمات التي تم التعرف إليها في الحقل القابل للتعديل أدناه.';

  @override
  String get speechListeningTitle => 'جارٍ الاستماع…';

  @override
  String get speechListeningBody =>
      'تحدّث بوضوح. تظهر الكلمات التي تم التعرف إليها أدناه.';

  @override
  String get speechUnavailableTitle => 'الميكروفون غير متاح';

  @override
  String get speechPermissionDenied =>
      'تم رفض إذن الميكروفون. تابع بالكتابة أدناه. ويمكنك تفعيل الإذن لاحقًا من إعدادات Android.';

  @override
  String get speechNetworkError =>
      'تعذر اتصال خدمة التعرّف إلى الكلام. تابع بالكتابة أو حاول مرة أخرى لاحقًا.';

  @override
  String get speechNoMatch =>
      'لم يتم التعرف إلى كلام واضح. حاول مرة أخرى أو تابع بالكتابة.';

  @override
  String get speechGenericError =>
      'توقف الإدخال الصوتي. حاول مرة أخرى أو تابع بالكتابة.';

  @override
  String get startSpeakingLabel => 'ابدأ التحدث';

  @override
  String get stopListeningLabel => 'إيقاف الاستماع';

  @override
  String get typedFallbackLabel => 'تابع بالكتابة أدناه';

  @override
  String get voicePrivacyNotice =>
      'لا يحفظ نسيج التسجيل الصوتي. قد تعالج خدمة التعرّف في جهازك الكلام عبر الإنترنت. راجع النص وعدّله قبل الحفظ.';

  @override
  String get explanationSectionTitle => 'اشرح المهارة';

  @override
  String get explanationHint => 'اكتب ما تريد تعليمه بكلماتك.';

  @override
  String get explanationHelper =>
      'اكتب أو أمْلِ 20 حرفًا على الأقل، ثم راجع النص قبل الحفظ.';

  @override
  String get saveDraftLabel => 'حفظ المسودة';

  @override
  String get savingDraftLabel => 'جارٍ الحفظ...';

  @override
  String get draftSaveError => 'تعذر حفظ المسودة. حاول مرة أخرى.';

  @override
  String get savedDraftTitle => 'مسودة مهارة محفوظة';

  @override
  String draftLearnerSummary(String name, String role) {
    return 'المتعلّم: $name — $role';
  }

  @override
  String draftCategorySummary(String category) {
    return 'الفئة: $category';
  }

  @override
  String get draftStoredLocally => 'محفوظة على هذا الهاتف وجاهزة للمتابعة.';

  @override
  String get continueDraftLabel => 'متابعة المسودة';

  @override
  String get aiReadinessTitle => 'اتصال الذكاء الاصطناعي';

  @override
  String get aiReadinessIdleBody =>
      'تحقّق من الاتصال الآمن قبل إنشاء درس عائلي.';

  @override
  String get aiCheckingTitle => 'جارٍ التحقق من الاتصال…';

  @override
  String get aiCheckingBody => 'يرسل نسيج عبارة اختبار ثابتة فقط.';

  @override
  String get aiReadyTitle => 'اتصال الذكاء الاصطناعي جاهز';

  @override
  String get aiReadyBody => 'استجابت خدمة Firebase AI Logic بنجاح.';

  @override
  String get aiUnavailableTitle => 'الذكاء الاصطناعي غير متاح الآن';

  @override
  String get aiCheckConnectionLabel => 'التحقق من اتصال الذكاء الاصطناعي';

  @override
  String get aiCheckAgainLabel => 'التحقق مرة أخرى';

  @override
  String get aiCheckingButtonLabel => 'جارٍ التحقق…';

  @override
  String get aiNoFamilyDataNotice =>
      'لا يرسل هذا التحقق نص المسودة أو الصورة التوضيحية.';

  @override
  String aiModelLabel(String model) {
    return 'النموذج: $model';
  }

  @override
  String get aiFirebaseConfigError =>
      'لم تتم تهيئة Firebase بصورة صحيحة في هذا الإصدار. تبقى مسودتك المحلية آمنة.';

  @override
  String get aiOfflineError =>
      'تعذر الوصول إلى خدمة الذكاء الاصطناعي. تابع باستخدام المسودة المحلية وحاول مرة أخرى عند توفر الاتصال.';

  @override
  String get aiAppCheckError =>
      'لم تتم الموافقة على جهاز الاختبار في App Check بعد. سجّل رمز التصحيح وحاول مرة أخرى.';

  @override
  String get aiQuotaError =>
      'تم بلوغ حد طلبات الذكاء الاصطناعي. تبقى مسودتك المحلية متاحة.';

  @override
  String get aiServiceDisabledError =>
      'لم يتم تفعيل Firebase AI Logic لهذا المشروع بعد.';

  @override
  String get aiInvalidResponseError =>
      'استجابت خدمة الذكاء الاصطناعي، لكن نتيجة اختبار الاتصال كانت غير متوقعة.';

  @override
  String get aiGenericError =>
      'تعذر إكمال التحقق من الذكاء الاصطناعي. تابع باستخدام التطبيق المحلي وحاول لاحقًا.';

  @override
  String get buildSkillCardLabel => 'إنشاء بطاقة من ثلاث خطوات';

  @override
  String get reviewSkillCardLabel => 'مراجعة البطاقة';

  @override
  String get savedSkillCardSummaryTitle => 'بطاقة من ثلاث خطوات جاهزة';

  @override
  String get savedSkillCardSummaryBody =>
      'تم حفظ بطاقة تمت مراجعتها على هذا الهاتف.';

  @override
  String get skillCardScreenTitle => 'بطاقة المهارة';

  @override
  String get aiDataBoundaryTitle => 'قبل الإنشاء';

  @override
  String get aiDataSentTitle => 'ما الذي سيُرسل';

  @override
  String get aiDataSentBody =>
      'الشرح الذي راجعته، ودور المعلّم، ودور المتعلّم، وفئة المهارة، ولغة الناتج.';

  @override
  String get aiDataNotSentTitle => 'ما الذي سيبقى على هذا الهاتف';

  @override
  String get aiDataNotSentBody =>
      'الأسماء المحفوظة والصورة التوضيحية. إذا كتبت اسمًا داخل الشرح، فسيكون جزءًا من النص الذي سيُرسل.';

  @override
  String get skillCardChoiceTitle => 'أنشئ الدرس العائلي';

  @override
  String get skillCardChoiceBody =>
      'أنشئ بطاقة منظمة بالذكاء الاصطناعي أو استخدم دليلًا محليًا دون اتصال.';

  @override
  String get generateWithAiLabel => 'الإنشاء بالذكاء الاصطناعي';

  @override
  String get useOfflineGuideLabel => 'استخدام دليل دون اتصال';

  @override
  String get skillCardGeneratingTitle => 'جارٍ إنشاء البطاقة من ثلاث خطوات…';

  @override
  String get skillCardGeneratingBody =>
      'ينظم نسيج الشرح الذي راجعته. لن تُحفظ المعاينة تلقائيًا.';

  @override
  String get skillCardAiOrigin => 'مسودة منشأة بالذكاء الاصطناعي';

  @override
  String get skillCardOfflineOrigin => 'دليل دون اتصال';

  @override
  String skillCardModelLabel(String model) {
    return 'النموذج: $model';
  }

  @override
  String skillCardStepLabel(int number) {
    return 'الخطوة $number';
  }

  @override
  String get safetyNoteTitle => 'ملاحظة سلامة';

  @override
  String get teachBackQuestionTitle => 'سؤال إعادة الشرح';

  @override
  String get reciprocalSuggestionTitle => 'علّم في المقابل';

  @override
  String get saveSkillCardLabel => 'حفظ البطاقة';

  @override
  String get savingSkillCardLabel => 'جارٍ حفظ البطاقة…';

  @override
  String get backToHomeLabel => 'العودة إلى الرئيسية';

  @override
  String get regenerateWithAiLabel => 'إعادة الإنشاء بالذكاء الاصطناعي';

  @override
  String get skillCardSaveError =>
      'تعذر حفظ البطاقة. ارجع إلى المسودة وحاول مرة أخرى.';

  @override
  String get skillCardFirebaseError =>
      'Firebase غير متاح، لذلك أنشأ نسيج دليلًا محليًا دون اتصال.';

  @override
  String get skillCardOfflineError =>
      'تعذر الوصول إلى خدمة الذكاء الاصطناعي، لذلك أنشأ نسيج دليلًا محليًا دون اتصال.';

  @override
  String get skillCardAppCheckError =>
      'رفض App Check الطلب السحابي، لذلك أنشأ نسيج دليلًا محليًا دون اتصال.';

  @override
  String get skillCardQuotaError =>
      'تم بلوغ حد طلبات الذكاء الاصطناعي، لذلك أنشأ نسيج دليلًا محليًا دون اتصال.';

  @override
  String get skillCardServiceError =>
      'خدمة Firebase AI Logic غير متاحة، لذلك أنشأ نسيج دليلًا محليًا دون اتصال.';

  @override
  String get skillCardInvalidResponseError =>
      'لم تجتز استجابة الذكاء الاصطناعي التحقق، لذلك أنشأ نسيج دليلًا محليًا دون اتصال.';

  @override
  String get skillCardClarificationError =>
      'تعذر تنظيم الشرح بأمان. راجع المسودة؛ ويظهر الآن دليل محلي مؤقت.';

  @override
  String get skillCardGenericError =>
      'تعذر إكمال الإنشاء السحابي، لذلك أنشأ نسيج دليلًا محليًا دون اتصال.';

  @override
  String get startLearningLabel => 'ابدأ التعلّم';

  @override
  String get continueLearningLabel => 'متابعة التعلّم';

  @override
  String get reviewCompletedLessonLabel => 'مراجعة الدرس المكتمل';

  @override
  String get learningRequiresCardBody =>
      'أنشئ بطاقة من ثلاث خطوات واحفظها قبل بدء تدريب المتعلّم.';

  @override
  String get learningProgressSummaryTitle => 'تقدّم المتعلّم';

  @override
  String get learningNotStartedBody => 'المتعلّم جاهز لبدء الخطوات الثلاث.';

  @override
  String get learningInProgressBody =>
      'يُحفظ تقدّم المتعلّم محليًا ويمكنه المتابعة لاحقًا.';

  @override
  String get learningCompletedBody =>
      'أكمل المتعلّم الخطوات الثلاث وإجابة إعادة الشرح.';

  @override
  String get learnSkillScreenTitle => 'تعلّم مهارة';

  @override
  String learnerLessonTitle(String name) {
    return 'درس $name';
  }

  @override
  String learningProgressCount(int completed, int total) {
    return 'اكتملت $completed من $total خطوات';
  }

  @override
  String get learningOfflineNotice =>
      'يعمل التدريب وحفظ التقدّم دون اتصال بالإنترنت.';

  @override
  String get practiceStepsTitle => 'تدرّب على الخطوات الثلاث';

  @override
  String get teachBackResponseLabel => 'اشرح ما تعلّمته';

  @override
  String get teachBackResponseHint => 'اكتب الدرس بكلماتك.';

  @override
  String teachBackResponseHelper(int minimum) {
    return 'اكتب $minimum أحرف على الأقل. تبقى هذه الإجابة على هذا الهاتف.';
  }

  @override
  String get learningSavingLabel => 'جارٍ حفظ التقدّم…';

  @override
  String get learningSavedLabel => 'تم حفظ التقدّم على هذا الهاتف.';

  @override
  String get learningSaveError =>
      'تعذر حفظ التقدّم. أجرِ تغييرًا آخر للمحاولة مجددًا.';

  @override
  String get learningChangesPendingLabel => 'توجد تغييرات في انتظار الحفظ.';

  @override
  String get learningLocalSaveReadyLabel => 'سيُحفظ التقدّم على هذا الهاتف.';

  @override
  String get completeAllStepsLabel => 'أكمل الخطوات الثلاث';

  @override
  String get writeTeachBackLabel => 'اكتب إجابة إعادة الشرح';

  @override
  String get completeFamilyLessonLabel => 'إكمال الدرس العائلي';

  @override
  String get lessonCompletedLabel => 'اكتمل الدرس';

  @override
  String get lessonCompletedTitle => 'اكتمل الدرس العائلي';

  @override
  String get lessonCompletedBody =>
      'تدرّبت على الخطوات الثلاث وشرحت ما تعلّمته.';

  @override
  String get listenToStepsTitle => 'استمع إلى كل خطوة';

  @override
  String get listenToStepsBody =>
      'استخدم زر استمع لخطوة واحدة في كل مرة. يمكنك إيقاف القراءة قبل اختيار خطوة أخرى.';

  @override
  String get ttsDeviceNotice =>
      'يستخدم نسيج صوت تحويل النص إلى كلام المثبّت على هذا الجهاز، ولا يحفظ ملفًا صوتيًا.';

  @override
  String get ttsPreparingLabel => 'جارٍ تجهيز الصوت…';

  @override
  String get ttsSpeakingLabel => 'تُقرأ إحدى خطوات الدرس بصوت عالٍ.';

  @override
  String get ttsUnavailableTitle => 'القراءة الصوتية غير متاحة';

  @override
  String get ttsLanguageUnavailableBody =>
      'لا يوجد صوت مثبّت للغة البطاقة على هذا الجهاز. تابع بقراءة الدرس أو ثبّت الصوت من إعدادات Android.';

  @override
  String get ttsPlaybackErrorBody =>
      'تعذر على الجهاز قراءة هذه الخطوة. يمكنك متابعة القراءة وتحديد الخطوات وكتابة إجابتك.';

  @override
  String get listenLabel => 'استمع';

  @override
  String get stopSpeakingLabel => 'إيقاف';

  @override
  String get replayLabel => 'إعادة الاستماع';
}
