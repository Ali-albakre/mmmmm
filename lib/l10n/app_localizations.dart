import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Smart Accounting'**
  String get appTitle;

  /// No description provided for @onboardingTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get onboardingTitle;

  /// No description provided for @onboardingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Set your preferred language, currency, and inventory mode.'**
  String get onboardingSubtitle;

  /// No description provided for @chooseLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get chooseLanguage;

  /// No description provided for @chooseCurrency.
  ///
  /// In en, this message translates to:
  /// **'Default currency'**
  String get chooseCurrency;

  /// No description provided for @chooseInventoryMode.
  ///
  /// In en, this message translates to:
  /// **'Inventory mode'**
  String get chooseInventoryMode;

  /// No description provided for @inventorySimple.
  ///
  /// In en, this message translates to:
  /// **'Simple (no stock)'**
  String get inventorySimple;

  /// No description provided for @inventoryFull.
  ///
  /// In en, this message translates to:
  /// **'Full inventory'**
  String get inventoryFull;

  /// No description provided for @currencyYER.
  ///
  /// In en, this message translates to:
  /// **'YER'**
  String get currencyYER;

  /// No description provided for @currencySAR.
  ///
  /// In en, this message translates to:
  /// **'SAR'**
  String get currencySAR;

  /// No description provided for @languageArabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get languageArabic;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @continueLabel.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueLabel;

  /// No description provided for @dashboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboardTitle;

  /// No description provided for @dashboardSales.
  ///
  /// In en, this message translates to:
  /// **'Sales'**
  String get dashboardSales;

  /// No description provided for @dashboardPurchases.
  ///
  /// In en, this message translates to:
  /// **'Purchases'**
  String get dashboardPurchases;

  /// No description provided for @dashboardExpenses.
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get dashboardExpenses;

  /// No description provided for @dashboardExpiryAlerts.
  ///
  /// In en, this message translates to:
  /// **'Expiry alerts'**
  String get dashboardExpiryAlerts;

  /// No description provided for @dashboardLastUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last updated: {date}'**
  String dashboardLastUpdated(String date);

  /// No description provided for @dashboardPeriodDaily.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get dashboardPeriodDaily;

  /// No description provided for @dashboardPeriodWeekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get dashboardPeriodWeekly;

  /// No description provided for @dashboardPeriodMonthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get dashboardPeriodMonthly;

  /// No description provided for @dashboardCurrentAgency.
  ///
  /// In en, this message translates to:
  /// **'Current agency'**
  String get dashboardCurrentAgency;

  /// No description provided for @dashboardLastUpdatedShort.
  ///
  /// In en, this message translates to:
  /// **'Last updated {time} ago'**
  String dashboardLastUpdatedShort(String time);

  /// No description provided for @dashboardScanDocument.
  ///
  /// In en, this message translates to:
  /// **'Scan document'**
  String get dashboardScanDocument;

  /// No description provided for @dashboardNetBalance.
  ///
  /// In en, this message translates to:
  /// **'Net balance'**
  String get dashboardNetBalance;

  /// No description provided for @dashboardTotalPurchases.
  ///
  /// In en, this message translates to:
  /// **'Total purchases'**
  String get dashboardTotalPurchases;

  /// No description provided for @dashboardReturns.
  ///
  /// In en, this message translates to:
  /// **'Returns'**
  String get dashboardReturns;

  /// No description provided for @dashboardDisbursements.
  ///
  /// In en, this message translates to:
  /// **'Disbursements'**
  String get dashboardDisbursements;

  /// No description provided for @dashboardExportReport.
  ///
  /// In en, this message translates to:
  /// **'Export report'**
  String get dashboardExportReport;

  /// No description provided for @dashboardAddManual.
  ///
  /// In en, this message translates to:
  /// **'Add manual entry'**
  String get dashboardAddManual;

  /// No description provided for @dashboardHelp.
  ///
  /// In en, this message translates to:
  /// **'Help center'**
  String get dashboardHelp;

  /// No description provided for @dashboardManageAgency.
  ///
  /// In en, this message translates to:
  /// **'Manage agency'**
  String get dashboardManageAgency;

  /// No description provided for @dashboardRecentOperations.
  ///
  /// In en, this message translates to:
  /// **'Recent operations'**
  String get dashboardRecentOperations;

  /// No description provided for @dashboardViewAll.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get dashboardViewAll;

  /// No description provided for @dashboardColumnDocument.
  ///
  /// In en, this message translates to:
  /// **'Document'**
  String get dashboardColumnDocument;

  /// No description provided for @dashboardColumnType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get dashboardColumnType;

  /// No description provided for @dashboardColumnDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get dashboardColumnDate;

  /// No description provided for @dashboardColumnNumber.
  ///
  /// In en, this message translates to:
  /// **'No.'**
  String get dashboardColumnNumber;

  /// No description provided for @dashboardNoAgencyTitle.
  ///
  /// In en, this message translates to:
  /// **'No agency selected yet'**
  String get dashboardNoAgencyTitle;

  /// No description provided for @dashboardNoAgencySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create your first agency to start tracking transactions.'**
  String get dashboardNoAgencySubtitle;

  /// No description provided for @dashboardSelectAgency.
  ///
  /// In en, this message translates to:
  /// **'Select agency'**
  String get dashboardSelectAgency;

  /// No description provided for @dashboardSampleAgencyName.
  ///
  /// In en, this message translates to:
  /// **'Advanced Tech Agency'**
  String get dashboardSampleAgencyName;

  /// No description provided for @dashboardSampleUpdatedTime.
  ///
  /// In en, this message translates to:
  /// **'5 min'**
  String get dashboardSampleUpdatedTime;

  /// No description provided for @scanTitle.
  ///
  /// In en, this message translates to:
  /// **'Scan document'**
  String get scanTitle;

  /// No description provided for @scanSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose a source to capture the document.'**
  String get scanSubtitle;

  /// No description provided for @scanFromCamera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get scanFromCamera;

  /// No description provided for @scanFromCameraHint.
  ///
  /// In en, this message translates to:
  /// **'Capture a new photo.'**
  String get scanFromCameraHint;

  /// No description provided for @scanFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get scanFromGallery;

  /// No description provided for @scanFromGalleryHint.
  ///
  /// In en, this message translates to:
  /// **'Pick one or more photos.'**
  String get scanFromGalleryHint;

  /// No description provided for @scanFromPdf.
  ///
  /// In en, this message translates to:
  /// **'PDF file'**
  String get scanFromPdf;

  /// No description provided for @scanFromPdfHint.
  ///
  /// In en, this message translates to:
  /// **'Import a PDF document.'**
  String get scanFromPdfHint;

  /// No description provided for @pdfReviewTitle.
  ///
  /// In en, this message translates to:
  /// **'PDF pages'**
  String get pdfReviewTitle;

  /// No description provided for @pdfReviewProcessing.
  ///
  /// In en, this message translates to:
  /// **'Preparing PDF pages and extracting data...'**
  String get pdfReviewProcessing;

  /// No description provided for @pdfReviewNoPages.
  ///
  /// In en, this message translates to:
  /// **'No pages found in the PDF.'**
  String get pdfReviewNoPages;

  /// No description provided for @pdfReviewPageLabel.
  ///
  /// In en, this message translates to:
  /// **'Page {index}'**
  String pdfReviewPageLabel(int index);

  /// No description provided for @pdfReviewOpenEntry.
  ///
  /// In en, this message translates to:
  /// **'Open entry'**
  String get pdfReviewOpenEntry;

  /// No description provided for @scanContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get scanContinue;

  /// No description provided for @scanClearSelection.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get scanClearSelection;

  /// No description provided for @scanSelectedImages.
  ///
  /// In en, this message translates to:
  /// **'Selected images: {count}'**
  String scanSelectedImages(int count);

  /// No description provided for @scanSelectedPdf.
  ///
  /// In en, this message translates to:
  /// **'Selected PDF file'**
  String get scanSelectedPdf;

  /// No description provided for @scanError.
  ///
  /// In en, this message translates to:
  /// **'Could not complete the request: {message}'**
  String scanError(String message);

  /// No description provided for @manualEntryTitle.
  ///
  /// In en, this message translates to:
  /// **'Manual entry'**
  String get manualEntryTitle;

  /// No description provided for @manualEntryDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Transaction details'**
  String get manualEntryDetailsTitle;

  /// No description provided for @manualEntryOcrTitle.
  ///
  /// In en, this message translates to:
  /// **'OCR extraction'**
  String get manualEntryOcrTitle;

  /// No description provided for @manualEntryOcrInProgress.
  ///
  /// In en, this message translates to:
  /// **'Extracting data from the document...'**
  String get manualEntryOcrInProgress;

  /// No description provided for @manualEntryOcrPdfNotice.
  ///
  /// In en, this message translates to:
  /// **'PDF OCR is not available yet. Please enter details manually.'**
  String get manualEntryOcrPdfNotice;

  /// No description provided for @manualEntryOcrFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not extract data. Please enter details manually.'**
  String get manualEntryOcrFailed;

  /// No description provided for @manualEntryOcrFailedReason.
  ///
  /// In en, this message translates to:
  /// **'Reason: {message}'**
  String manualEntryOcrFailedReason(String message);

  /// No description provided for @manualEntryOcrNoData.
  ///
  /// In en, this message translates to:
  /// **'No extractable data found yet.'**
  String get manualEntryOcrNoData;

  /// No description provided for @manualEntryOcrInvoice.
  ///
  /// In en, this message translates to:
  /// **'Invoice: {value}'**
  String manualEntryOcrInvoice(String value);

  /// No description provided for @manualEntryOcrDate.
  ///
  /// In en, this message translates to:
  /// **'Date: {value}'**
  String manualEntryOcrDate(String value);

  /// No description provided for @manualEntryOcrTotal.
  ///
  /// In en, this message translates to:
  /// **'Total: {value}'**
  String manualEntryOcrTotal(num value);

  /// No description provided for @manualEntryInvoiceNumber.
  ///
  /// In en, this message translates to:
  /// **'Invoice number (optional)'**
  String get manualEntryInvoiceNumber;

  /// No description provided for @manualEntryAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get manualEntryAmount;

  /// No description provided for @manualEntryAmountRequired.
  ///
  /// In en, this message translates to:
  /// **'Amount is required.'**
  String get manualEntryAmountRequired;

  /// No description provided for @manualEntryAmountInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid amount.'**
  String get manualEntryAmountInvalid;

  /// No description provided for @manualEntryCurrency.
  ///
  /// In en, this message translates to:
  /// **'Invoice currency'**
  String get manualEntryCurrency;

  /// No description provided for @manualEntryDate.
  ///
  /// In en, this message translates to:
  /// **'Transaction date'**
  String get manualEntryDate;

  /// No description provided for @manualEntryDateRequired.
  ///
  /// In en, this message translates to:
  /// **'Select a transaction date.'**
  String get manualEntryDateRequired;

  /// No description provided for @manualEntryExchangeRate.
  ///
  /// In en, this message translates to:
  /// **'Exchange rate to base currency'**
  String get manualEntryExchangeRate;

  /// No description provided for @manualEntryExchangeRateRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid exchange rate.'**
  String get manualEntryExchangeRateRequired;

  /// No description provided for @manualEntryTransactionType.
  ///
  /// In en, this message translates to:
  /// **'Invoice type'**
  String get manualEntryTransactionType;

  /// No description provided for @manualEntryTransactionTypeRequired.
  ///
  /// In en, this message translates to:
  /// **'Select an invoice type.'**
  String get manualEntryTransactionTypeRequired;

  /// No description provided for @manualEntryNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes (optional)'**
  String get manualEntryNotes;

  /// No description provided for @manualEntrySave.
  ///
  /// In en, this message translates to:
  /// **'Save entry'**
  String get manualEntrySave;

  /// No description provided for @manualEntrySaveDraft.
  ///
  /// In en, this message translates to:
  /// **'Save draft'**
  String get manualEntrySaveDraft;

  /// No description provided for @manualEntryPost.
  ///
  /// In en, this message translates to:
  /// **'Post entry'**
  String get manualEntryPost;

  /// No description provided for @manualEntryConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm save'**
  String get manualEntryConfirmTitle;

  /// No description provided for @manualEntryConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'This will save the entry and update the dashboard.'**
  String get manualEntryConfirmMessage;

  /// No description provided for @manualEntryCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get manualEntryCancel;

  /// No description provided for @manualEntryConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get manualEntryConfirm;

  /// No description provided for @manualEntrySaved.
  ///
  /// In en, this message translates to:
  /// **'Entry saved.'**
  String get manualEntrySaved;

  /// No description provided for @manualEntryNoAgency.
  ///
  /// In en, this message translates to:
  /// **'Please select an agency before saving.'**
  String get manualEntryNoAgency;

  /// No description provided for @transactionTypePurchase.
  ///
  /// In en, this message translates to:
  /// **'Purchase'**
  String get transactionTypePurchase;

  /// No description provided for @transactionTypeReturn.
  ///
  /// In en, this message translates to:
  /// **'Return'**
  String get transactionTypeReturn;

  /// No description provided for @transactionTypeDisbursement.
  ///
  /// In en, this message translates to:
  /// **'Disbursement'**
  String get transactionTypeDisbursement;

  /// No description provided for @transactionTypeOpening.
  ///
  /// In en, this message translates to:
  /// **'Opening balance'**
  String get transactionTypeOpening;

  /// No description provided for @transactionTypePurchaseCredit.
  ///
  /// In en, this message translates to:
  /// **'Purchase (credit)'**
  String get transactionTypePurchaseCredit;

  /// No description provided for @transactionTypePayment.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get transactionTypePayment;

  /// No description provided for @transactionTypeOpeningBalance.
  ///
  /// In en, this message translates to:
  /// **'Opening balance'**
  String get transactionTypeOpeningBalance;

  /// No description provided for @transactionTypePurchaseCash.
  ///
  /// In en, this message translates to:
  /// **'Purchase (cash)'**
  String get transactionTypePurchaseCash;

  /// No description provided for @transactionTypeCompensation.
  ///
  /// In en, this message translates to:
  /// **'Compensation'**
  String get transactionTypeCompensation;

  /// No description provided for @transactionStatusPosted.
  ///
  /// In en, this message translates to:
  /// **'Posted'**
  String get transactionStatusPosted;

  /// No description provided for @transactionStatusDraft.
  ///
  /// In en, this message translates to:
  /// **'Draft'**
  String get transactionStatusDraft;

  /// No description provided for @reportsTitle.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reportsTitle;

  /// No description provided for @reportsSetupTitle.
  ///
  /// In en, this message translates to:
  /// **'Generate report'**
  String get reportsSetupTitle;

  /// No description provided for @reportsTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Report type'**
  String get reportsTypeLabel;

  /// No description provided for @reportsTypeStatement.
  ///
  /// In en, this message translates to:
  /// **'Statement'**
  String get reportsTypeStatement;

  /// No description provided for @reportsTypeMonthlySummary.
  ///
  /// In en, this message translates to:
  /// **'Monthly summary'**
  String get reportsTypeMonthlySummary;

  /// No description provided for @reportsTypePurchases.
  ///
  /// In en, this message translates to:
  /// **'Purchases'**
  String get reportsTypePurchases;

  /// No description provided for @reportsTypePurchasesCredit.
  ///
  /// In en, this message translates to:
  /// **'Purchases (credit)'**
  String get reportsTypePurchasesCredit;

  /// No description provided for @reportsTypePayments.
  ///
  /// In en, this message translates to:
  /// **'Payments'**
  String get reportsTypePayments;

  /// No description provided for @reportsTypeReturns.
  ///
  /// In en, this message translates to:
  /// **'Returns'**
  String get reportsTypeReturns;

  /// No description provided for @reportsTypePurchasesCash.
  ///
  /// In en, this message translates to:
  /// **'Purchases (cash)'**
  String get reportsTypePurchasesCash;

  /// No description provided for @reportsTypeCompensation.
  ///
  /// In en, this message translates to:
  /// **'Compensation'**
  String get reportsTypeCompensation;

  /// No description provided for @reportsPeriodLabel.
  ///
  /// In en, this message translates to:
  /// **'Period'**
  String get reportsPeriodLabel;

  /// No description provided for @reportsPeriodHint.
  ///
  /// In en, this message translates to:
  /// **'Select period'**
  String get reportsPeriodHint;

  /// No description provided for @reportsFormatPdf.
  ///
  /// In en, this message translates to:
  /// **'PDF'**
  String get reportsFormatPdf;

  /// No description provided for @reportsFormatExcel.
  ///
  /// In en, this message translates to:
  /// **'Excel'**
  String get reportsFormatExcel;

  /// No description provided for @reportsGenerate.
  ///
  /// In en, this message translates to:
  /// **'Generate report'**
  String get reportsGenerate;

  /// No description provided for @reportsGenerating.
  ///
  /// In en, this message translates to:
  /// **'Generating...'**
  String get reportsGenerating;

  /// No description provided for @reportsTableTitle.
  ///
  /// In en, this message translates to:
  /// **'Report table'**
  String get reportsTableTitle;

  /// No description provided for @reportsColumnAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get reportsColumnAmount;

  /// No description provided for @reportsNoDataToExport.
  ///
  /// In en, this message translates to:
  /// **'No data to export.'**
  String get reportsNoDataToExport;

  /// No description provided for @reportsExportFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to export report.'**
  String get reportsExportFailed;

  /// No description provided for @reportsSaved.
  ///
  /// In en, this message translates to:
  /// **'Report saved: {path}'**
  String reportsSaved(String path);

  /// No description provided for @reportsCreatedNoFile.
  ///
  /// In en, this message translates to:
  /// **'Report created, but no file was saved yet.'**
  String get reportsCreatedNoFile;

  /// No description provided for @reportsRecentTitle.
  ///
  /// In en, this message translates to:
  /// **'Recent reports'**
  String get reportsRecentTitle;

  /// No description provided for @reportsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No reports generated yet.'**
  String get reportsEmpty;

  /// No description provided for @helpTitle.
  ///
  /// In en, this message translates to:
  /// **'Help center'**
  String get helpTitle;

  /// No description provided for @helpAccuracyTitle.
  ///
  /// In en, this message translates to:
  /// **'How accurate is OCR?'**
  String get helpAccuracyTitle;

  /// No description provided for @helpAccuracyBody.
  ///
  /// In en, this message translates to:
  /// **'Accuracy depends on image clarity. Use clear, well-lit scans for best results.'**
  String get helpAccuracyBody;

  /// No description provided for @helpCorrectionsTitle.
  ///
  /// In en, this message translates to:
  /// **'How do I correct extracted data?'**
  String get helpCorrectionsTitle;

  /// No description provided for @helpCorrectionsBody.
  ///
  /// In en, this message translates to:
  /// **'Use the manual edit screen to fix fields before posting the transaction.'**
  String get helpCorrectionsBody;

  /// No description provided for @helpDuplicatesTitle.
  ///
  /// In en, this message translates to:
  /// **'How are duplicates detected?'**
  String get helpDuplicatesTitle;

  /// No description provided for @helpDuplicatesBody.
  ///
  /// In en, this message translates to:
  /// **'We check invoice number, date, and amount to flag possible duplicates.'**
  String get helpDuplicatesBody;

  /// No description provided for @helpReportsTitle.
  ///
  /// In en, this message translates to:
  /// **'How do I export reports?'**
  String get helpReportsTitle;

  /// No description provided for @helpReportsBody.
  ///
  /// In en, this message translates to:
  /// **'Choose a report type, period, and format, then generate the report from the Reports screen.'**
  String get helpReportsBody;

  /// No description provided for @agenciesTitle.
  ///
  /// In en, this message translates to:
  /// **'Agencies'**
  String get agenciesTitle;

  /// No description provided for @agenciesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No agencies yet. Add your first agency to start tracking balances.'**
  String get agenciesEmpty;

  /// No description provided for @agenciesCreate.
  ///
  /// In en, this message translates to:
  /// **'Add agency'**
  String get agenciesCreate;

  /// No description provided for @agenciesName.
  ///
  /// In en, this message translates to:
  /// **'Agency name'**
  String get agenciesName;

  /// No description provided for @agenciesOpeningBalanceLabel.
  ///
  /// In en, this message translates to:
  /// **'Opening balance'**
  String get agenciesOpeningBalanceLabel;

  /// No description provided for @agenciesPrimaryCurrency.
  ///
  /// In en, this message translates to:
  /// **'Primary currency'**
  String get agenciesPrimaryCurrency;

  /// No description provided for @agenciesAllowedCurrencies.
  ///
  /// In en, this message translates to:
  /// **'Allowed currencies'**
  String get agenciesAllowedCurrencies;

  /// No description provided for @agenciesOpeningBalanceDate.
  ///
  /// In en, this message translates to:
  /// **'Opening balance date'**
  String get agenciesOpeningBalanceDate;

  /// No description provided for @agenciesOpeningBalanceDateInvalid.
  ///
  /// In en, this message translates to:
  /// **'Opening balance must be dated on Jan 1.'**
  String get agenciesOpeningBalanceDateInvalid;

  /// No description provided for @agenciesSave.
  ///
  /// In en, this message translates to:
  /// **'Save agency'**
  String get agenciesSave;

  /// No description provided for @agenciesOpeningBalance.
  ///
  /// In en, this message translates to:
  /// **'Opening balance: {amount}'**
  String agenciesOpeningBalance(num amount);

  /// No description provided for @recentOperationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Recent operations'**
  String get recentOperationsTitle;

  /// No description provided for @recentOperationsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No operations yet.'**
  String get recentOperationsEmpty;

  /// No description provided for @drawerDashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get drawerDashboard;

  /// No description provided for @drawerScan.
  ///
  /// In en, this message translates to:
  /// **'Scan document'**
  String get drawerScan;

  /// No description provided for @drawerManualEntry.
  ///
  /// In en, this message translates to:
  /// **'Manual entry'**
  String get drawerManualEntry;

  /// No description provided for @drawerReports.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get drawerReports;

  /// No description provided for @drawerAgencies.
  ///
  /// In en, this message translates to:
  /// **'Agencies'**
  String get drawerAgencies;

  /// No description provided for @drawerHelp.
  ///
  /// In en, this message translates to:
  /// **'Help center'**
  String get drawerHelp;

  /// No description provided for @drawerSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get drawerSettings;

  /// No description provided for @dashboardQuickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick actions'**
  String get dashboardQuickActions;

  /// No description provided for @dashboardActionNewEntry.
  ///
  /// In en, this message translates to:
  /// **'New entry'**
  String get dashboardActionNewEntry;

  /// No description provided for @dashboardActionInvoice.
  ///
  /// In en, this message translates to:
  /// **'Invoice'**
  String get dashboardActionInvoice;

  /// No description provided for @dashboardActionChart.
  ///
  /// In en, this message translates to:
  /// **'Chart of accounts'**
  String get dashboardActionChart;

  /// No description provided for @dashboardActionLedger.
  ///
  /// In en, this message translates to:
  /// **'Ledger'**
  String get dashboardActionLedger;

  /// No description provided for @dashboardActionArchive.
  ///
  /// In en, this message translates to:
  /// **'Archive'**
  String get dashboardActionArchive;

  /// No description provided for @dashboardActionBackup.
  ///
  /// In en, this message translates to:
  /// **'Backup'**
  String get dashboardActionBackup;

  /// No description provided for @dashboardAlerts.
  ///
  /// In en, this message translates to:
  /// **'Alerts'**
  String get dashboardAlerts;

  /// No description provided for @dashboardNoAlerts.
  ///
  /// In en, this message translates to:
  /// **'No alerts yet'**
  String get dashboardNoAlerts;

  /// No description provided for @dashboardCharts.
  ///
  /// In en, this message translates to:
  /// **'Charts'**
  String get dashboardCharts;

  /// No description provided for @dashboardNoCharts.
  ///
  /// In en, this message translates to:
  /// **'No charts yet'**
  String get dashboardNoCharts;

  /// No description provided for @dashboardRecentEntries.
  ///
  /// In en, this message translates to:
  /// **'Recent entries'**
  String get dashboardRecentEntries;

  /// No description provided for @dashboardNoRecentEntries.
  ///
  /// In en, this message translates to:
  /// **'No entries yet'**
  String get dashboardNoRecentEntries;

  /// No description provided for @dashboardNoCards.
  ///
  /// In en, this message translates to:
  /// **'No cards to show'**
  String get dashboardNoCards;

  /// No description provided for @dashboardCustomize.
  ///
  /// In en, this message translates to:
  /// **'Customize dashboard'**
  String get dashboardCustomize;

  /// No description provided for @dashboardSectionQuickActions.
  ///
  /// In en, this message translates to:
  /// **'Show quick actions'**
  String get dashboardSectionQuickActions;

  /// No description provided for @dashboardSectionAlerts.
  ///
  /// In en, this message translates to:
  /// **'Show alerts'**
  String get dashboardSectionAlerts;

  /// No description provided for @dashboardSectionCharts.
  ///
  /// In en, this message translates to:
  /// **'Show charts'**
  String get dashboardSectionCharts;

  /// No description provided for @dashboardSectionRecent.
  ///
  /// In en, this message translates to:
  /// **'Show recent entries'**
  String get dashboardSectionRecent;

  /// No description provided for @dashboardViewDetails.
  ///
  /// In en, this message translates to:
  /// **'Details: {title}'**
  String dashboardViewDetails(String title);

  /// No description provided for @dashboardCopyValue.
  ///
  /// In en, this message translates to:
  /// **'Copy value'**
  String get dashboardCopyValue;

  /// No description provided for @dashboardCopyTitle.
  ///
  /// In en, this message translates to:
  /// **'Copy title'**
  String get dashboardCopyTitle;

  /// No description provided for @emptyStateNoData.
  ///
  /// In en, this message translates to:
  /// **'No data yet'**
  String get emptyStateNoData;

  /// No description provided for @settingsBackupTitle.
  ///
  /// In en, this message translates to:
  /// **'Backup'**
  String get settingsBackupTitle;

  /// No description provided for @settingsDriveBackupToggle.
  ///
  /// In en, this message translates to:
  /// **'Daily Google Drive backup'**
  String get settingsDriveBackupToggle;

  /// No description provided for @settingsDriveBackupHint.
  ///
  /// In en, this message translates to:
  /// **'Upload a backup file to Drive at the end of each day.'**
  String get settingsDriveBackupHint;

  /// No description provided for @settingsDriveAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Google Drive account'**
  String get settingsDriveAccountTitle;

  /// No description provided for @settingsDriveAccountSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Connect a Google account to store backups.'**
  String get settingsDriveAccountSubtitle;

  /// No description provided for @settingsDriveAccountConnected.
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get settingsDriveAccountConnected;

  /// No description provided for @settingsConnect.
  ///
  /// In en, this message translates to:
  /// **'Connect'**
  String get settingsConnect;

  /// No description provided for @settingsDisconnect.
  ///
  /// In en, this message translates to:
  /// **'Disconnect'**
  String get settingsDisconnect;

  /// No description provided for @settingsLastBackup.
  ///
  /// In en, this message translates to:
  /// **'Last backup'**
  String get settingsLastBackup;

  /// No description provided for @settingsBackupNow.
  ///
  /// In en, this message translates to:
  /// **'Backup now'**
  String get settingsBackupNow;

  /// No description provided for @settingsBackupInProgress.
  ///
  /// In en, this message translates to:
  /// **'Backing up...'**
  String get settingsBackupInProgress;

  /// No description provided for @settingsBackupFailed.
  ///
  /// In en, this message translates to:
  /// **'Backup failed: {message}'**
  String settingsBackupFailed(String message);

  /// No description provided for @settingsOcrTitle.
  ///
  /// In en, this message translates to:
  /// **'OCR'**
  String get settingsOcrTitle;

  /// No description provided for @settingsOcrCloudToggle.
  ///
  /// In en, this message translates to:
  /// **'Use OCR.space cloud OCR'**
  String get settingsOcrCloudToggle;

  /// No description provided for @settingsOcrCloudHint.
  ///
  /// In en, this message translates to:
  /// **'Sends images to OCR.space for better accuracy.'**
  String get settingsOcrCloudHint;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
