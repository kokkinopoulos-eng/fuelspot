import 'package:flutter/material.dart';

class TermsDialog extends StatelessWidget {
  const TermsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Column(children: [
        Image.asset('assets/icon/splash.png', width: 64, height: 64),
        const SizedBox(height: 10),
        const Text('Όροι Χρήσης', textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ]),
      content: SizedBox(
        width: double.maxFinite,
        height: 300,
        child: SingleChildScrollView(
          child: const Text(termsText,
              style: TextStyle(fontSize: 13, height: 1.5)),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          style: TextButton.styleFrom(foregroundColor: Colors.red),
          child: const Text('Απόρριψη'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Αποδέχομαι'),
        ),
      ],
    );
  }

  static const String termsText =
    'ΟΡΟΙ ΧΡΗΣΗΣ - FuelSpot\n'
    'Τελευταία ενημέρωση: Ιούνιος 2026\n\n'
    '1. Αποδοχή Όρων\n'
    'Χρησιμοποιώντας την εφαρμογή FuelSpot, αποδέχεστε πλήρως τους παρόντες όρους χρήσης.\n\n'
    '2. Περιγραφή Υπηρεσίας\n'
    'Η FuelSpot παρέχει πληροφορίες για πρατήρια καυσίμων και σημεία φόρτισης στην Ελλάδα, '
    'βασισμένες σε δεδομένα OpenStreetMap και επίσημες πηγές (ΥΠΑΝ). Η εφαρμογή είναι δωρεάν.\n\n'
    '3. Ακρίβεια Δεδομένων\n'
    'Οι πληροφορίες παρέχονται ενδεικτικά. Η FuelSpot δεν εγγυάται την ακρίβεια των δεδομένων. '
    'Η τελική τιμή καθορίζεται από το πρατήριο.\n\n'
    '4. Χρήση Τοποθεσίας\n'
    'Η εφαρμογή χρησιμοποιεί GPS αποκλειστικά για εύρεση κοντινών πρατηρίων. '
    'Τα δεδομένα δεν αποθηκεύονται.\n\n'
    '5. Πνευματικά Δικαιώματα\n'
    'OpenStreetMap contributors (ODbL). Τιμές: ΥΠΑΝ.\n\n'
    '6. Περιορισμός Ευθύνης\n'
    'Η FuelSpot και ο δημιουργός της δεν φέρουν ευθύνη για ζημία από τη χρήση της εφαρμογής.\n\n'
    '7. Επικοινωνία\n'
    'fuelspot@webdevelopment.gr';
}
