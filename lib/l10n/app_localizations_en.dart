// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Smart Accounting';

  @override
  String get onboardingTitle => 'Welcome';

  @override
  String get onboardingSubtitle =>
      'Set your preferred language, currency, and inventory mode.';

  @override
  String get chooseLanguage => 'Language';

  @override
  String get chooseCurrency => 'Default currency';

  @override
  String get chooseInventoryMode => 'Inventory mode';

  @override
  String get inventorySimple => 'Simple (no stock)';

  @override
  String get inventoryFull => 'Full inventory';

  @override
  String get currencyYER => 'YER';

  @override
  String get currencySAR => 'SAR';

  @override
  String get languageArabic => 'Arabic';

  @override
  String get languageEnglish => 'English';

  @override
  String get continueLabel => 'Continue';

  @override
  String get dashboardTitle => 'Dashboard';

  @override
  String get dashboardSales => 'Sales';

  @override
  String get dashboardPurchases => 'Purchases';

  @override
  String get dashboardExpenses => 'Expenses';

  @override
  String get dashboardExpiryAlerts => 'Expiry alerts';

  @override
  String dashboardLastUpdated(String date) {
    return 'Last updated: $date';
  }

  @override
  String get dashboardPeriodDaily => 'Daily';

  @override
  String get dashboardPeriodWeekly => 'Weekly';

  @override
  String get dashboardPeriodMonthly => 'Monthly';

  @override
  String get dashboardCurrentAgency => 'Current agency';

  @override
  String dashboardLastUpdatedShort(String time) {
    return 'Last updated $time ago';
  }

  @override
  String get dashboardScanDocument => 'Scan document';

  @override
  String get dashboardNetBalance => 'Net balance';

  @override
  String get dashboardTotalPurchases => 'Total purchases';

  @override
  String get dashboardReturns => 'Returns';

  @override
  String get dashboardDisbursements => 'Disbursements';

  @override
  String get dashboardExportReport => 'Export report';

  @override
  String get dashboardAddManual => 'Add manual entry';

  @override
  String get dashboardHelp => 'Help center';

  @override
  String get dashboardManageAgency => 'Manage agency';

  @override
  String get dashboardRecentOperations => 'Recent operations';

  @override
  String get dashboardViewAll => 'View all';

  @override
  String get dashboardColumnDocument => 'Document';

  @override
  String get dashboardColumnType => 'Type';

  @override
  String get dashboardColumnDate => 'Date';

  @override
  String get dashboardColumnNumber => 'No.';

  @override
  String get dashboardNoAgencyTitle => 'No agency selected yet';

  @override
  String get dashboardNoAgencySubtitle =>
      'Create your first agency to start tracking transactions.';

  @override
  String get dashboardSelectAgency => 'Select agency';

  @override
  String get dashboardSampleAgencyName => 'Advanced Tech Agency';

  @override
  String get dashboardSampleUpdatedTime => '5 min';

  @override
  String get scanTitle => 'Scan document';

  @override
  String get scanSubtitle => 'Choose a source to capture the document.';

  @override
  String get scanFromCamera => 'Camera';

  @override
  String get scanFromCameraHint => 'Capture a new photo.';

  @override
  String get scanFromGallery => 'Gallery';

  @override
  String get scanFromGalleryHint => 'Pick one or more photos.';

  @override
  String get scanFromPdf => 'PDF file';

  @override
  String get scanFromPdfHint => 'Import a PDF document.';

  @override
  String get pdfReviewTitle => 'PDF pages';

  @override
  String get pdfReviewProcessing =>
      'Preparing PDF pages and extracting data...';

  @override
  String get pdfReviewNoPages => 'No pages found in the PDF.';

  @override
  String pdfReviewPageLabel(int index) {
    return 'Page $index';
  }

  @override
  String get pdfReviewOpenEntry => 'Open entry';

  @override
  String get scanContinue => 'Continue';

  @override
  String get scanClearSelection => 'Clear';

  @override
  String scanSelectedImages(int count) {
    return 'Selected images: $count';
  }

  @override
  String get scanSelectedPdf => 'Selected PDF file';

  @override
  String scanError(String message) {
    return 'Could not complete the request: $message';
  }

  @override
  String get manualEntryTitle => 'Manual entry';

  @override
  String get manualEntryDetailsTitle => 'Transaction details';

  @override
  String get manualEntryOcrTitle => 'OCR extraction';

  @override
  String get manualEntryOcrInProgress => 'Extracting data from the document...';

  @override
  String get manualEntryOcrPdfNotice =>
      'PDF OCR is not available yet. Please enter details manually.';

  @override
  String get manualEntryOcrFailed =>
      'Could not extract data. Please enter details manually.';

  @override
  String manualEntryOcrFailedReason(String message) {
    return 'Reason: $message';
  }

  @override
  String get manualEntryOcrNoData => 'No extractable data found yet.';

  @override
  String manualEntryOcrInvoice(String value) {
    return 'Invoice: $value';
  }

  @override
  String manualEntryOcrDate(String value) {
    return 'Date: $value';
  }

  @override
  String manualEntryOcrTotal(num value) {
    return 'Total: $value';
  }

  @override
  String get manualEntryInvoiceNumber => 'Invoice number (optional)';

  @override
  String get manualEntryAmount => 'Amount';

  @override
  String get manualEntryAmountRequired => 'Amount is required.';

  @override
  String get manualEntryAmountInvalid => 'Enter a valid amount.';

  @override
  String get manualEntryCurrency => 'Invoice currency';

  @override
  String get manualEntryDate => 'Transaction date';

  @override
  String get manualEntryDateRequired => 'Select a transaction date.';

  @override
  String get manualEntryExchangeRate => 'Exchange rate to base currency';

  @override
  String get manualEntryExchangeRateRequired => 'Enter a valid exchange rate.';

  @override
  String get manualEntryTransactionType => 'Invoice type';

  @override
  String get manualEntryTransactionTypeRequired => 'Select an invoice type.';

  @override
  String get manualEntryNotes => 'Notes (optional)';

  @override
  String get manualEntrySave => 'Save entry';

  @override
  String get manualEntrySaveDraft => 'Save draft';

  @override
  String get manualEntryPost => 'Post entry';

  @override
  String get manualEntryConfirmTitle => 'Confirm save';

  @override
  String get manualEntryConfirmMessage =>
      'This will save the entry and update the dashboard.';

  @override
  String get manualEntryCancel => 'Cancel';

  @override
  String get manualEntryConfirm => 'Confirm';

  @override
  String get manualEntrySaved => 'Entry saved.';

  @override
  String get manualEntryNoAgency => 'Please select an agency before saving.';

  @override
  String get manualEntryAddItem => 'Add item';

  @override
  String get manualEntryItemName => 'Item name';

  @override
  String get manualEntryItemQuantity => 'Quantity';

  @override
  String get manualEntryItemUnitPrice => 'Unit price';

  @override
  String get manualEntryItemTotal => 'Total';

  @override
  String get transactionTypePurchase => 'Purchase';

  @override
  String get transactionTypeReturn => 'Return';

  @override
  String get transactionTypeDisbursement => 'Disbursement';

  @override
  String get transactionTypeOpening => 'Opening balance';

  @override
  String get transactionTypePurchaseCredit => 'Purchase (credit)';

  @override
  String get transactionTypePayment => 'Payment';

  @override
  String get transactionTypeOpeningBalance => 'Opening balance';

  @override
  String get transactionTypePurchaseCash => 'Purchase (cash)';

  @override
  String get transactionTypeCompensation => 'Compensation';

  @override
  String get transactionStatusPosted => 'Posted';

  @override
  String get transactionStatusDraft => 'Draft';

  @override
  String get reportsTitle => 'Reports';

  @override
  String get reportsSetupTitle => 'Generate report';

  @override
  String get reportsTypeLabel => 'Report type';

  @override
  String get reportsTypeStatement => 'Statement';

  @override
  String get reportsTypeMonthlySummary => 'Monthly summary';

  @override
  String get reportsTypePurchases => 'Purchases';

  @override
  String get reportsTypePurchasesCredit => 'Purchases (credit)';

  @override
  String get reportsTypePayments => 'Payments';

  @override
  String get reportsTypeReturns => 'Returns';

  @override
  String get reportsTypePurchasesCash => 'Purchases (cash)';

  @override
  String get reportsTypeCompensation => 'Compensation';

  @override
  String get reportsPeriodLabel => 'Period';

  @override
  String get reportsPeriodHint => 'Select period';

  @override
  String get reportsFormatPdf => 'PDF';

  @override
  String get reportsFormatExcel => 'Excel';

  @override
  String get reportsGenerate => 'Generate report';

  @override
  String get reportsGenerating => 'Generating...';

  @override
  String get reportsTableTitle => 'Report table';

  @override
  String get reportsColumnAmount => 'Amount';

  @override
  String get reportsNoDataToExport => 'No data to export.';

  @override
  String get reportsExportFailed => 'Failed to export report.';

  @override
  String reportsSaved(String path) {
    return 'Report saved: $path';
  }

  @override
  String get reportsCreatedNoFile =>
      'Report created, but no file was saved yet.';

  @override
  String get reportsRecentTitle => 'Recent reports';

  @override
  String get reportsEmpty => 'No reports generated yet.';

  @override
  String get helpTitle => 'Help center';

  @override
  String get helpAccuracyTitle => 'How accurate is OCR?';

  @override
  String get helpAccuracyBody =>
      'Accuracy depends on image clarity. Use clear, well-lit scans for best results.';

  @override
  String get helpCorrectionsTitle => 'How do I correct extracted data?';

  @override
  String get helpCorrectionsBody =>
      'Use the manual edit screen to fix fields before posting the transaction.';

  @override
  String get helpDuplicatesTitle => 'How are duplicates detected?';

  @override
  String get helpDuplicatesBody =>
      'We check invoice number, date, and amount to flag possible duplicates.';

  @override
  String get helpReportsTitle => 'How do I export reports?';

  @override
  String get helpReportsBody =>
      'Choose a report type, period, and format, then generate the report from the Reports screen.';

  @override
  String get agenciesTitle => 'Agencies';

  @override
  String get agenciesEmpty =>
      'No agencies yet. Add your first agency to start tracking balances.';

  @override
  String get agenciesCreate => 'Add agency';

  @override
  String get agenciesName => 'Agency name';

  @override
  String get agenciesOpeningBalanceLabel => 'Opening balance';

  @override
  String get agenciesPrimaryCurrency => 'Primary currency';

  @override
  String get agenciesAllowedCurrencies => 'Allowed currencies';

  @override
  String get agenciesOpeningBalanceDate => 'Opening balance date';

  @override
  String get agenciesOpeningBalanceDateInvalid =>
      'Opening balance must be dated on Jan 1.';

  @override
  String get agenciesSave => 'Save agency';

  @override
  String agenciesOpeningBalance(num amount) {
    return 'Opening balance: $amount';
  }

  @override
  String get recentOperationsTitle => 'Recent operations';

  @override
  String get recentOperationsEmpty => 'No operations yet.';

  @override
  String get drawerDashboard => 'Dashboard';

  @override
  String get drawerScan => 'Scan document';

  @override
  String get drawerManualEntry => 'Manual entry';

  @override
  String get drawerReports => 'Reports';

  @override
  String get drawerAgencies => 'Agencies';

  @override
  String get drawerHelp => 'Help center';

  @override
  String get drawerSettings => 'Settings';

  @override
  String get dashboardQuickActions => 'Quick actions';

  @override
  String get dashboardActionNewEntry => 'New entry';

  @override
  String get dashboardActionInvoice => 'Invoice';

  @override
  String get dashboardActionChart => 'Chart of accounts';

  @override
  String get dashboardActionLedger => 'Ledger';

  @override
  String get dashboardActionArchive => 'Archive';

  @override
  String get dashboardActionBackup => 'Backup';

  @override
  String get dashboardAlerts => 'Alerts';

  @override
  String get dashboardNoAlerts => 'No alerts yet';

  @override
  String get dashboardCharts => 'Charts';

  @override
  String get dashboardNoCharts => 'No charts yet';

  @override
  String get dashboardRecentEntries => 'Recent entries';

  @override
  String get dashboardNoRecentEntries => 'No entries yet';

  @override
  String get dashboardNoCards => 'No cards to show';

  @override
  String get dashboardCustomize => 'Customize dashboard';

  @override
  String get dashboardSectionQuickActions => 'Show quick actions';

  @override
  String get dashboardSectionAlerts => 'Show alerts';

  @override
  String get dashboardSectionCharts => 'Show charts';

  @override
  String get dashboardSectionRecent => 'Show recent entries';

  @override
  String dashboardViewDetails(String title) {
    return 'Details: $title';
  }

  @override
  String get dashboardCopyValue => 'Copy value';

  @override
  String get dashboardCopyTitle => 'Copy title';

  @override
  String get emptyStateNoData => 'No data yet';

  @override
  String get settingsBackupTitle => 'Backup';

  @override
  String get settingsDriveBackupToggle => 'Daily Google Drive backup';

  @override
  String get settingsDriveBackupHint =>
      'Upload a backup file to Drive at the end of each day.';

  @override
  String get settingsDriveAccountTitle => 'Google Drive account';

  @override
  String get settingsDriveAccountSubtitle =>
      'Connect a Google account to store backups.';

  @override
  String get settingsDriveAccountConnected => 'Connected';

  @override
  String get settingsConnect => 'Connect';

  @override
  String get settingsDisconnect => 'Disconnect';

  @override
  String get settingsLastBackup => 'Last backup';

  @override
  String get settingsBackupNow => 'Backup now';

  @override
  String get settingsBackupInProgress => 'Backing up...';

  @override
  String settingsBackupFailed(String message) {
    return 'Backup failed: $message';
  }

  @override
  String get settingsOcrTitle => 'OCR';

  @override
  String get settingsOcrCloudToggle => 'Use OCR.space cloud OCR';

  @override
  String get settingsOcrCloudHint =>
      'Sends images to OCR.space for better accuracy.';

  @override
  String get settingsTitle => 'Settings';
}
