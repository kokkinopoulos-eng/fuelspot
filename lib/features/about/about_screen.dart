import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Πληροφορίες')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Center(child: Column(children: [
            Image.asset('assets/icon/splash.png', width: 80, height: 80),
            const SizedBox(height: 12),
            const Text('FuelSpot', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
            const Text('v1.0.2', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 4),
            const Text('By Kokkinopoulos Babis', style: TextStyle(color: Colors.grey, fontSize: 13)),
          ])),
          const SizedBox(height: 28),
          _section('Τι είναι το FuelSpot;',
            'Το FuelSpot σε βοηθά να βρεις γρήγορα κοντινά πρατήρια καυσίμων και σημεία φόρτισης ηλεκτρικών οχημάτων στην Ελλάδα.'),
          _section('Πρατήρια',
            'Εμφανίζει τα κοντινότερα πρατήρια βάσει GPS. Οι μέσες τιμές ανά νομό προέρχονται από επίσημα στοιχεία ΥΠΑΝ.'),
          _section('Φόρτιση',
            'Σημεία φόρτισης EV από OpenStreetMap. Πατώντας "Οδηγίες" ανοίγει το Google Maps. Για πραγματική διαθεσιμότητα χρησιμοποιήστε το PlugShare.'),
          _section('Τιμές',
            'Μέσες τιμές καυσίμων ανά νομό, ενημερωμένες από το ΥΠΑΝ.'),
          _section('Δεδομένα',
            '© OpenStreetMap contributors (ODbL)\nΤιμές: ΥΠΑΝ'),
          const Divider(height: 32),
          _linkRow(context, 'Όροι Χρήσης', Icons.description_outlined, () => _showTerms(context)),
          _linkRow(context, 'Πολιτική Απορρήτου', Icons.privacy_tip_outlined, () => _showPrivacy(context)),
          _linkRow(context, 'Επικοινωνία', Icons.email_outlined,
            () => launchUrl(Uri.parse('mailto:fuelspot@webdevelopment.gr'), mode: LaunchMode.externalApplication)),
          const SizedBox(height: 20),
        ]),
      ),
    );
  }

  Widget _section(String title, String body) => Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
      const SizedBox(height: 4),
      Text(body, style: const TextStyle(fontSize: 14, height: 1.5)),
    ]),
  );

  Widget _linkRow(BuildContext context, String label, IconData icon, VoidCallback onTap) =>
    ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: const Color(0xFF0D3F6B)),
      title: Text(label),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );

  void _showTerms(BuildContext context) {
    _showTextDialog(context, 'Όροι Χρήσης', _termsText);
  }

  void _showPrivacy(BuildContext context) {
    _showTextDialog(context, 'Πολιτική Απορρήτου', _privacyText);
  }

  void _showTextDialog(BuildContext context, String title, String text) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => _TextPage(title: title, text: text)));
  }

  static const String _termsText = '''
ΟΡΟΙ ΧΡΗΣΗΣ - FuelSpot
Τελευταία ενημέρωση: Ιούνιος 2026

1. Αποδοχή Όρων
Χρησιμοποιώντας την εφαρμογή FuelSpot, αποδέχεστε πλήρως τους παρόντες όρους χρήσης. Αν διαφωνείτε, παρακαλούμε μην χρησιμοποιείτε την εφαρμογή.

2. Περιγραφή Υπηρεσίας
Η FuelSpot παρέχει πληροφορίες για πρατήρια καυσίμων και σημεία φόρτισης ηλεκτρικών οχημάτων στην Ελλάδα, βασισμένες σε δεδομένα OpenStreetMap και επίσημες πηγές (ΥΠΑΝ). Η εφαρμογή είναι δωρεάν.

3. Ακρίβεια Δεδομένων
Οι πληροφορίες τιμών και τοποθεσιών παρέχονται ενδεικτικά. Η FuelSpot δεν εγγυάται την ακρίβεια, πληρότητα ή επικαιρότητα των δεδομένων. Η τελική τιμή καθορίζεται από το πρατήριο.

4. Χρήση Τοποθεσίας
Η εφαρμογή χρησιμοποιεί GPS αποκλειστικά για εύρεση κοντινών πρατηρίων. Τα δεδομένα τοποθεσίας δεν αποθηκεύονται ούτε μεταδίδονται σε τρίτους.

5. Πνευματικά Δικαιώματα Δεδομένων
Τα δεδομένα χαρτών προέρχονται από το OpenStreetMap (© OpenStreetMap contributors) υπό την άδεια ODbL. Οι μέσες τιμές καυσίμων προέρχονται από δημόσια στοιχεία του ΥΠΑΝ.

6. Διαφημίσεις
Η εφαρμογή ενδέχεται να εμφανίζει διαφημίσεις μέσω Google AdMob. Για πληροφορίες σχετικά με τη συλλογή δεδομένων από τη Google, δείτε την Πολιτική Απορρήτου Google.

7. Περιορισμός Ευθύνης
Η FuelSpot και ο δημιουργός της δεν φέρουν ευθύνη για οποιαδήποτε ζημία προκύψει από τη χρήση της εφαρμογής.

8. Τροποποιήσεις
Οι όροι χρήσης ενδέχεται να τροποποιούνται. Η συνέχιση χρήσης της εφαρμογής μετά από αλλαγές συνεπάγεται αποδοχή των νέων όρων.

9. Επικοινωνία
fuelspot@webdevelopment.gr''';

  static const String _privacyText = '''
ΠΟΛΙΤΙΚΗ ΑΠΟΡΡΗΤΟΥ - FuelSpot
Τελευταία ενημέρωση: Ιούνιος 2026

1. Γενικά
Η FuelSpot σέβεται την ιδιωτικότητά σας. Η παρούσα πολιτική περιγράφει ποια δεδομένα συλλέγονται και πώς χρησιμοποιούνται.

2. Δεδομένα που συλλέγουμε
- Τοποθεσία (GPS): Χρησιμοποιείται αποκλειστικά για εύρεση κοντινών πρατηρίων και σημείων φόρτισης. Δεν αποθηκεύεται, δεν καταγράφεται και δεν μεταδίδεται σε τρίτους.
- Δεν συλλέγουμε ονόματα, email, τηλέφωνα ή άλλα προσωπικά δεδομένα.

3. Διαφημίσεις (Google AdMob)
Η εφαρμογή χρησιμοποιεί Google AdMob για εμφάνιση διαφημίσεων. Η Google ενδέχεται να συλλέγει δεδομένα σύμφωνα με τη δική της πολιτική: https://policies.google.com/privacy

4. Δεδομένα τρίτων
- OpenStreetMap: Τα ερωτήματα δεν περιέχουν προσωπικά δεδομένα.
- Google Maps: Αν επιλέξετε "Οδηγίες", μεταφέρεστε σε εξωτερική εφαρμογή με τη δική της πολιτική.

5. GDPR
Εφόσον δεν συλλέγουμε προσωπικά δεδομένα, δεν απαιτείται επεξεργασία υπό τον GDPR από πλευράς μας.

6. Επικοινωνία
fuelspot@webdevelopment.gr''';
}

class _TextPage extends StatelessWidget {
  final String title;
  final String text;
  const _TextPage({required this.title, required this.text});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Text(text, style: const TextStyle(fontSize: 14, height: 1.6)),
      ),
    );
  }
}
