// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'المحاسب الذكي';

  @override
  String get onboardingTitle => 'مرحبًا';

  @override
  String get onboardingSubtitle => 'حدد اللغة والعملة الافتراضية ووضع المخزون.';

  @override
  String get chooseLanguage => 'اللغة';

  @override
  String get chooseCurrency => 'العملة الافتراضية';

  @override
  String get chooseInventoryMode => 'وضع المخزون';

  @override
  String get inventorySimple => 'مبسط (بدون مخزون)';

  @override
  String get inventoryFull => 'مخزون كامل';

  @override
  String get currencyYER => 'ريال يمني';

  @override
  String get currencySAR => 'ريال سعودي';

  @override
  String get languageArabic => 'العربية';

  @override
  String get languageEnglish => 'الإنجليزية';

  @override
  String get continueLabel => 'متابعة';

  @override
  String get dashboardTitle => 'لوحة التحكم';

  @override
  String get dashboardSales => 'المبيعات';

  @override
  String get dashboardPurchases => 'المشتريات';

  @override
  String get dashboardExpenses => 'المصروفات';

  @override
  String get dashboardExpiryAlerts => 'تنبيهات انتهاء الصلاحية';

  @override
  String dashboardLastUpdated(String date) {
    return 'آخر تحديث: $date';
  }

  @override
  String get dashboardPeriodDaily => 'يومي';

  @override
  String get dashboardPeriodWeekly => 'أسبوعي';

  @override
  String get dashboardPeriodMonthly => 'شهري';

  @override
  String get dashboardCurrentAgency => 'الوكالة الحالية';

  @override
  String dashboardLastUpdatedShort(String time) {
    return 'آخر تحديث منذ $time';
  }

  @override
  String get dashboardScanDocument => 'مسح مستند';

  @override
  String get dashboardNetBalance => 'صافي الرصيد';

  @override
  String get dashboardTotalPurchases => 'إجمالي المشتريات';

  @override
  String get dashboardReturns => 'المرتجعات';

  @override
  String get dashboardDisbursements => 'سندات الصرف';

  @override
  String get dashboardExportReport => 'تصدير تقرير';

  @override
  String get dashboardAddManual => 'إضافة يدوية';

  @override
  String get dashboardHelp => 'المساعدة';

  @override
  String get dashboardManageAgency => 'إدارة الوكالة';

  @override
  String get dashboardRecentOperations => 'آخر العمليات';

  @override
  String get dashboardViewAll => 'عرض الكل';

  @override
  String get dashboardColumnDocument => 'المستند';

  @override
  String get dashboardColumnType => 'نوع العملية';

  @override
  String get dashboardColumnDate => 'التاريخ';

  @override
  String get dashboardColumnNumber => 'رقم الفاتورة';

  @override
  String get dashboardNoAgencyTitle => 'لا توجد وكالة محددة بعد';

  @override
  String get dashboardNoAgencySubtitle =>
      'أنشئ أول وكالة للبدء في تتبع العمليات.';

  @override
  String get dashboardSelectAgency => 'اختيار الوكالة';

  @override
  String get dashboardSampleAgencyName => 'وكالة التقنية المتقدمة';

  @override
  String get dashboardSampleUpdatedTime => '5 دقائق';

  @override
  String get scanTitle => 'مسح مستند';

  @override
  String get scanSubtitle => 'اختر المصدر لالتقاط المستند.';

  @override
  String get scanFromCamera => 'الكاميرا';

  @override
  String get scanFromCameraHint => 'التقاط صورة جديدة.';

  @override
  String get scanFromGallery => 'المعرض';

  @override
  String get scanFromGalleryHint => 'اختيار صورة أو أكثر.';

  @override
  String get scanFromPdf => 'ملف PDF';

  @override
  String get scanFromPdfHint => 'استيراد مستند PDF.';

  @override
  String get pdfReviewTitle => 'صفحات PDF';

  @override
  String get pdfReviewProcessing => 'جاري تجهيز الصفحات واستخراج البيانات...';

  @override
  String get pdfReviewNoPages => 'لا توجد صفحات في ملف PDF.';

  @override
  String pdfReviewPageLabel(int index) {
    return 'صفحة $index';
  }

  @override
  String get pdfReviewOpenEntry => 'فتح الإدخال';

  @override
  String get scanContinue => 'متابعة';

  @override
  String get scanClearSelection => 'مسح';

  @override
  String scanSelectedImages(int count) {
    return 'عدد الصور المختارة: $count';
  }

  @override
  String get scanSelectedPdf => 'تم اختيار ملف PDF';

  @override
  String scanError(String message) {
    return 'تعذر إكمال الطلب: $message';
  }

  @override
  String get manualEntryTitle => 'إضافة يدوية';

  @override
  String get manualEntryDetailsTitle => 'تفاصيل العملية';

  @override
  String get manualEntryOcrTitle => 'نتائج المسح';

  @override
  String get manualEntryOcrInProgress => 'جارٍ استخراج البيانات من المستند...';

  @override
  String get manualEntryOcrPdfNotice =>
      'استخراج PDF غير متاح حاليًا، يرجى إدخال البيانات يدويًا.';

  @override
  String get manualEntryOcrFailed =>
      'تعذر استخراج البيانات، يرجى الإدخال يدويًا.';

  @override
  String manualEntryOcrFailedReason(String message) {
    return 'السبب: $message';
  }

  @override
  String get manualEntryOcrNoData => 'لم يتم العثور على بيانات واضحة بعد.';

  @override
  String manualEntryOcrInvoice(String value) {
    return 'رقم الفاتورة: $value';
  }

  @override
  String manualEntryOcrDate(String value) {
    return 'التاريخ: $value';
  }

  @override
  String manualEntryOcrTotal(num value) {
    return 'الإجمالي: $value';
  }

  @override
  String get manualEntryInvoiceNumber => 'رقم الفاتورة (اختياري)';

  @override
  String get manualEntryAmount => 'المبلغ';

  @override
  String get manualEntryAmountRequired => 'المبلغ مطلوب.';

  @override
  String get manualEntryAmountInvalid => 'أدخل مبلغًا صحيحًا.';

  @override
  String get manualEntryCurrency => 'عملة الفاتورة';

  @override
  String get manualEntryDate => 'تاريخ العملية';

  @override
  String get manualEntryDateRequired => 'اختر تاريخ العملية.';

  @override
  String get manualEntryExchangeRate => 'سعر الصرف للعملة الأساسية';

  @override
  String get manualEntryExchangeRateRequired => 'أدخل سعر صرف صحيح.';

  @override
  String get manualEntryTransactionType => 'نوع الفاتورة';

  @override
  String get manualEntryTransactionTypeRequired => 'اختر نوع الفاتورة.';

  @override
  String get manualEntryNotes => 'ملاحظات (اختياري)';

  @override
  String get manualEntrySave => 'حفظ العملية';

  @override
  String get manualEntrySaveDraft => 'حفظ كمسودة';

  @override
  String get manualEntryPost => 'ترحيل العملية';

  @override
  String get manualEntryConfirmTitle => 'تأكيد الحفظ';

  @override
  String get manualEntryConfirmMessage =>
      'سيتم حفظ العملية وتحديث لوحة التحكم.';

  @override
  String get manualEntryCancel => 'إلغاء';

  @override
  String get manualEntryConfirm => 'تأكيد';

  @override
  String get manualEntrySaved => 'تم حفظ العملية.';

  @override
  String get manualEntryNoAgency => 'يرجى اختيار وكالة قبل الحفظ.';

  @override
  String get transactionTypePurchase => 'مشتريات';

  @override
  String get transactionTypeReturn => 'مرتجع';

  @override
  String get transactionTypeDisbursement => 'سند صرف';

  @override
  String get transactionTypeOpening => 'رصيد افتتاحي';

  @override
  String get transactionTypePurchaseCredit => 'شراء آجل';

  @override
  String get transactionTypePayment => 'دفعة/سند قبض';

  @override
  String get transactionTypeOpeningBalance => 'قيد افتتاحي';

  @override
  String get transactionTypePurchaseCash => 'شراء نقدي';

  @override
  String get transactionTypeCompensation => 'تعويض/بونص';

  @override
  String get transactionStatusPosted => 'مرحّل';

  @override
  String get transactionStatusDraft => 'مسودة';

  @override
  String get reportsTitle => 'التقارير';

  @override
  String get reportsSetupTitle => 'إنشاء تقرير';

  @override
  String get reportsTypeLabel => 'نوع التقرير';

  @override
  String get reportsTypeStatement => 'كشف حساب تفصيلي';

  @override
  String get reportsTypeMonthlySummary => 'ملخص شهري';

  @override
  String get reportsTypePurchases => 'المشتريات فقط';

  @override
  String get reportsTypePurchasesCredit => 'المشتريات الآجلة';

  @override
  String get reportsTypePayments => 'السداد/الدفعات';

  @override
  String get reportsTypeReturns => 'المرتجعات فقط';

  @override
  String get reportsTypePurchasesCash => 'المشتريات النقدية';

  @override
  String get reportsTypeCompensation => 'التعويضات/البونص';

  @override
  String get reportsPeriodLabel => 'الفترة';

  @override
  String get reportsPeriodHint => 'اختر الفترة';

  @override
  String get reportsFormatPdf => 'PDF';

  @override
  String get reportsFormatExcel => 'Excel';

  @override
  String get reportsGenerate => 'إنشاء التقرير';

  @override
  String get reportsGenerating => 'جارٍ إنشاء التقرير...';

  @override
  String get reportsTableTitle => 'جدول التقرير';

  @override
  String get reportsColumnAmount => 'المبلغ';

  @override
  String get reportsNoDataToExport => 'لا توجد بيانات للتصدير.';

  @override
  String get reportsExportFailed => 'تعذر تصدير التقرير.';

  @override
  String reportsSaved(String path) {
    return 'تم حفظ التقرير: $path';
  }

  @override
  String get reportsCreatedNoFile =>
      'تم إنشاء التقرير، لكن لم يتم حفظ الملف بعد.';

  @override
  String get reportsRecentTitle => 'آخر التقارير';

  @override
  String get reportsEmpty => 'لا توجد تقارير بعد.';

  @override
  String get helpTitle => 'مركز المساعدة';

  @override
  String get helpAccuracyTitle => 'ما مدى دقة OCR؟';

  @override
  String get helpAccuracyBody =>
      'تعتمد الدقة على جودة الصورة. استخدم صورًا واضحة وبإضاءة جيدة.';

  @override
  String get helpCorrectionsTitle => 'كيف أصحح البيانات المستخرجة؟';

  @override
  String get helpCorrectionsBody =>
      'يمكنك تعديل الحقول يدويًا قبل ترحيل العملية.';

  @override
  String get helpDuplicatesTitle => 'كيف يتم كشف التكرار؟';

  @override
  String get helpDuplicatesBody =>
      'نستخدم رقم الفاتورة والتاريخ والمبلغ لاكتشاف التكرار المحتمل.';

  @override
  String get helpReportsTitle => 'كيف أصدّر التقارير؟';

  @override
  String get helpReportsBody =>
      'اختر نوع التقرير والفترة والصيغة ثم أنشئ التقرير من شاشة التقارير.';

  @override
  String get agenciesTitle => 'الوكالات';

  @override
  String get agenciesEmpty => 'لا توجد وكالات بعد. أضف وكالتك الأولى للبدء.';

  @override
  String get agenciesCreate => 'إضافة وكالة';

  @override
  String get agenciesName => 'اسم الوكالة';

  @override
  String get agenciesOpeningBalanceLabel => 'الرصيد الافتتاحي';

  @override
  String get agenciesPrimaryCurrency => 'العملة الأساسية';

  @override
  String get agenciesAllowedCurrencies => 'العملات المسموحة';

  @override
  String get agenciesOpeningBalanceDate => 'تاريخ الرصيد الافتتاحي';

  @override
  String get agenciesOpeningBalanceDateInvalid =>
      'يجب أن يكون تاريخ الرصيد الافتتاحي في 1 يناير.';

  @override
  String get agenciesSave => 'حفظ الوكالة';

  @override
  String agenciesOpeningBalance(num amount) {
    return 'الرصيد الافتتاحي: $amount';
  }

  @override
  String get recentOperationsTitle => 'آخر العمليات';

  @override
  String get recentOperationsEmpty => 'لا توجد عمليات بعد.';

  @override
  String get drawerDashboard => 'لوحة التحكم';

  @override
  String get drawerScan => 'مسح مستند';

  @override
  String get drawerManualEntry => 'إضافة يدوية';

  @override
  String get drawerReports => 'التقارير';

  @override
  String get drawerAgencies => 'الوكالات';

  @override
  String get drawerHelp => 'المساعدة';

  @override
  String get drawerSettings => 'الإعدادات';

  @override
  String get dashboardQuickActions => 'الإجراءات السريعة';

  @override
  String get dashboardActionNewEntry => 'قيد جديد';

  @override
  String get dashboardActionInvoice => 'فاتورة';

  @override
  String get dashboardActionChart => 'دليل الحسابات';

  @override
  String get dashboardActionLedger => 'دفتر الأستاذ';

  @override
  String get dashboardActionArchive => 'الأرشيف';

  @override
  String get dashboardActionBackup => 'نسخ احتياطي';

  @override
  String get dashboardAlerts => 'التنبيهات';

  @override
  String get dashboardNoAlerts => 'لا توجد تنبيهات بعد';

  @override
  String get dashboardCharts => 'المخططات';

  @override
  String get dashboardNoCharts => 'لا توجد مخططات بعد';

  @override
  String get dashboardRecentEntries => 'آخر القيود';

  @override
  String get dashboardNoRecentEntries => 'لا توجد قيود بعد';

  @override
  String get dashboardNoCards => 'لا توجد بطاقات للعرض';

  @override
  String get dashboardCustomize => 'تخصيص اللوحة';

  @override
  String get dashboardSectionQuickActions => 'إظهار الإجراءات السريعة';

  @override
  String get dashboardSectionAlerts => 'إظهار التنبيهات';

  @override
  String get dashboardSectionCharts => 'إظهار المخططات';

  @override
  String get dashboardSectionRecent => 'إظهار آخر القيود';

  @override
  String dashboardViewDetails(String title) {
    return 'تفاصيل: $title';
  }

  @override
  String get dashboardCopyValue => 'نسخ القيمة';

  @override
  String get dashboardCopyTitle => 'نسخ العنوان';

  @override
  String get emptyStateNoData => 'لا توجد بيانات بعد';

  @override
  String get settingsBackupTitle => 'النسخ الاحتياطي';

  @override
  String get settingsDriveBackupToggle => 'نسخ احتياطي يومي إلى Google Drive';

  @override
  String get settingsDriveBackupHint => 'يرفع نسخة احتياطية في نهاية كل يوم.';

  @override
  String get settingsDriveAccountTitle => 'حساب Google Drive';

  @override
  String get settingsDriveAccountSubtitle =>
      'اربط حسابًا لحفظ النسخ الاحتياطية.';

  @override
  String get settingsDriveAccountConnected => 'متصل';

  @override
  String get settingsConnect => 'ربط';

  @override
  String get settingsDisconnect => 'فصل';

  @override
  String get settingsLastBackup => 'آخر نسخة احتياطية';

  @override
  String get settingsBackupNow => 'نسخ احتياطي الآن';

  @override
  String get settingsBackupInProgress => 'جارٍ النسخ...';

  @override
  String settingsBackupFailed(String message) {
    return 'فشل النسخ الاحتياطي: $message';
  }

  @override
  String get settingsOcrTitle => 'التعرف الضوئي';

  @override
  String get settingsOcrCloudToggle => 'استخدام OCR.space السحابي';

  @override
  String get settingsOcrCloudHint => 'يرسل الصور إلى OCR.space لتحسين الدقة.';

  @override
  String get settingsTitle => 'الإعدادات';
}
