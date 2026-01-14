# Assumptions

- Display name is "PharmaLedger" for now; package name remains `mmmmm` until rebranding steps are done.
- Default database choice will be Drift (SQLite) unless requested otherwise.
- Inventory costing method will be FIFO unless requested otherwise.
- OCR runs on images using on-device ML Kit; PDF pages are converted to images before OCR.
- Google Drive backup requires OAuth client configuration and Drive API access for the chosen Google account.
- Daily Drive backup runs on app start; background scheduling requires adding a platform job (e.g., WorkManager).
