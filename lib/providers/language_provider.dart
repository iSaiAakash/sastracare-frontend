import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  String _currentLanguage = 'en';
  String _currentLanguageName = 'English';
  bool _isLoaded = false;

  String get currentLanguage => _currentLanguage;
  String get currentLanguageName => _currentLanguageName;
  bool get isLoaded => _isLoaded;

  LanguageProvider() {
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();

    _currentLanguage = prefs.getString("language") ?? 'en';
    _currentLanguageName = prefs.getString("languageName") ?? 'English';

    _isLoaded = true;
    notifyListeners();
  }

  Future<void> setLanguage(String languageCode, String languageName) async {
    _currentLanguage = languageCode;
    _currentLanguageName = languageName;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("language", languageCode);
    await prefs.setString("languageName", languageName);

    notifyListeners();
  }

  String translate(String key) {
    return _translations[_currentLanguage]?[key] ??
        _translations['en']?[key] ??
        key;
  }

  final Map<String, Map<String, String>> _translations = {
    'ta': { // Tamil
      // General
      'app_title': 'SASTRA பெற்றோர்',
      'welcome': 'வணக்கம், பெற்றோரே',
      'welcome_back': 'மீண்டும் வரவேற்கிறோம்',
      'select_language': 'மொழியைத் தேர்ந்தெடுக்கவும்',
      'processing': 'செயலாக்கப்படுகிறது...',
      'success': 'வெற்றிகரமாக',
      'error': 'பிழை',
      'back': 'பின்செல்',
      'continue': 'தொடர்க',
      'cancel': 'ரத்து',
      'select_option': 'ஒரு விருப்பத்தைத் தேர்ந்தெடுக்கவும்',

      // Mobile Verification
      'mobile_verification': 'கைப்பேசி சரிபார்ப்பு',
      'enter_mobile': 'கைப்பேசி எண்ணை உள்ளிடவும்',
      'enter_mobile_hint': 'உங்கள் பதிவு செய்யப்பட்ட கைப்பேசி எண்',
      'send_otp': 'OTP அனுப்பவும்',
      'otp_sent': 'OTP அனுப்பப்பட்டது',
      'enter_valid_mobile': 'சரியான 10 இலக்க கைப்பேசி எண்ணை உள்ளிடவும்',
      'verifying_mobile': 'உங்கள் கைப்பேசி எண் சரிபார்க்கப்படுகிறது',
      'mobile_not_found': 'கைப்பேசி எண் பதிவு செய்யப்படவில்லை. பல்கலைக்கழகத்தை தொடர்பு கொள்ளவும்.',
      'secure_info': 'உங்கள் தகவல் பாதுகாப்பானது',

      // OTP Verification
      'sending_otp': 'OTP அனுப்பப்படுகிறது',
      'verify_otp': 'OTP ஐ சரிபார்க்கவும்',
      'enter_otp': '6-இலக்க OTP ஐ உள்ளிடவும்',
      'enter_otp_hint': 'உங்கள் கைப்பேசிக்கு வந்த OTP',
      'resend_otp': 'OTP மீண்டும் அனுப்பவும்',
      'otp_verified': 'OTP வெற்றிகரமாக சரிபார்க்கப்பட்டது',
      'invalid_otp': 'தவறான OTP',
      'otp_expired': 'OTP காலாவதியானது',
      'verifying_otp': 'OTP சரிபார்க்கப்படுகிறது',
      'didnt_receive_otp': 'OTP வரவில்லையா?',

      // Dashboard
      'dashboard': 'முகப்பு',
      'attendance': 'வருகைப்பதிவு',
      'sgpa_cgpa': 'SGPA & CGPA',
      'exam_results': 'தேர்வு முடிவுகள்',
      'fees': 'கட்டண விவரங்கள்',
      'logout': 'வெளியேறு',
      'logout_confirm': 'நிச்சயமாக வெளியேற விரும்புகிறீர்களா?',
      'notifications': 'அறிவிப்புகள்',
      'no_notifications': 'புதிய அறிவிப்புகள் இல்லை',

      // Student Info
      'student_name': 'மாணவர் பெயர்',
      'register_number': 'பதிவு எண்',
      'branch': 'பிரிவு',

      // Attendance Module
      'attendance_percentage': 'வருகைப்பதிவு சதவீதம்',
      'attendance_status': 'வருகைப்பதிவு நிலை',
      'good': 'நல்லது',
      'satisfactory': 'திருப்திகரமானது',
      'needs_improvement': 'முன்னேற்றம் தேவை',
      'total_classes': 'மொத்த வகுப்புகள்',
      'classes_attended': 'பங்கேற்ற வகுப்புகள்',
      'classes_missed': 'தவறிய வகுப்புகள்',
      'subject_wise_attendance': 'பாடவாரியான வருகைப்பதிவு',
      'semester': 'செமஸ்டர்',
      'select_semester': 'செமஸ்டரைத் தேர்ந்தெடுக்கவும்',

      // Results Module
      'sgpa': 'SGPA',
      'cgpa': 'CGPA',
      'overall_performance': 'ஒட்டுமொத்த செயல்திறன்',
      'subject': 'பாடம்',
      'grade': 'தரம்',
      'credits': 'கிரெடிட்கள்',
      'status': 'நிலை',
      'pass': 'தேர்ச்சி',
      'fail': 'தோல்வி',
      'arrear': 'நிலுவை',
      'no_arrears': 'நிலுவைகள் இல்லை',
      'total_subjects': 'மொத்த பாடங்கள்',
      'passed': 'தேர்ச்சி',
      'arrears': 'நிலுவைகள்',
      'subject_wise_results': 'பாடவாரியான முடிவுகள்',

      // Fees Module
      'fee_status': 'கட்டண நிலை',
      'total_fees': 'மொத்த கட்டணம்',
      'paid': 'செலுத்தப்பட்டது',
      'pending': 'நிலுவை',
      'due_date': 'கடைசி தேதி',
      'fine': 'அபராதம்',
      'late_fee': 'தாமத கட்டணம்',
      'paid_on': 'செலுத்திய தேதி',
      'receipt': 'ரசீது',
      'fee_breakdown': 'கட்டண விவரங்கள்',
      'payment_due': 'கட்டணம் நிலுவையில் உள்ளது',
      'amount_due': 'நிலுவைத் தொகை',

      // Messages
      'welcome_message': 'உங்கள் பிள்ளையின் கல்வி முன்னேற்றத்தை அறிய வரவேற்கிறோம்',
      'loading': 'ஏற்றப்படுகிறது...',
      'no_data': 'தரவு இல்லை',
      'retry': 'மீண்டும் முயற்சிக்கவும்',
      'network_error': 'நெட்வொர்க் பிழை. தயவுசெய்து மீண்டும் முயற்சிக்கவும்',
      'demo_numbers': 'சோதனை எண்கள்: 9876543210, 9988776655, 9123456789',
    },

    'en': { // English
      // General
      'app_title': 'SASTRA Parent',
      'welcome': 'Welcome, Parent',
      'welcome_back': 'Welcome back',
      'select_language': 'Select Language',
      'processing': 'Processing...',
      'success': 'Success',
      'error': 'Error',
      'back': 'Back',
      'continue': 'Continue',
      'cancel': 'Cancel',
      'select_option': 'Select an option',

      // Mobile Verification
      'mobile_verification': 'Mobile Verification',
      'enter_mobile': 'Enter Mobile Number',
      'enter_mobile_hint': 'Your registered mobile number',
      'send_otp': 'Send OTP',
      'otp_sent': 'OTP Sent',
      'enter_valid_mobile': 'Enter valid 10-digit mobile number',
      'verifying_mobile': 'Verifying your mobile number',
      'mobile_not_found': 'Mobile number not registered. Please contact university.',
      'secure_info': 'Your information is secure',

      // OTP Verification
      'sending_otp': 'Sending OTP',
      'verify_otp': 'Verify OTP',
      'enter_otp': 'Enter 6-digit OTP',
      'enter_otp_hint': 'OTP sent to your mobile',
      'resend_otp': 'Resend OTP',
      'otp_verified': 'OTP Verified Successfully',
      'invalid_otp': 'Invalid OTP',
      'otp_expired': 'OTP Expired',
      'verifying_otp': 'Verifying OTP',
      'didnt_receive_otp': 'Didn\'t receive OTP?',

      // Dashboard
      'dashboard': 'Dashboard',
      'attendance': 'Attendance',
      'sgpa_cgpa': 'SGPA & CGPA',
      'exam_results': 'Exam Results',
      'fees': 'Fee Details',
      'logout': 'Logout',
      'logout_confirm': 'Are you sure you want to logout?',
      'notifications': 'Notifications',
      'no_notifications': 'No new notifications',

      // Student Info
      'student_name': 'Student Name',
      'register_number': 'Register Number',
      'branch': 'Branch',

      // Attendance Module
      'attendance_percentage': 'Attendance Percentage',
      'attendance_status': 'Attendance Status',
      'good': 'Good',
      'satisfactory': 'Satisfactory',
      'needs_improvement': 'Needs Improvement',
      'total_classes': 'Total Classes',
      'classes_attended': 'Classes Attended',
      'classes_missed': 'Classes Missed',
      'subject_wise_attendance': 'Subject-wise Attendance',
      'semester': 'Semester',
      'select_semester': 'Select Semester',

      // Results Module
      'sgpa': 'SGPA',
      'cgpa': 'CGPA',
      'overall_performance': 'Overall Performance',
      'subject': 'Subject',
      'grade': 'Grade',
      'credits': 'Credits',
      'status': 'Status',
      'pass': 'Pass',
      'fail': 'Fail',
      'arrear': 'Arrear',
      'no_arrears': 'No Arrears',
      'total_subjects': 'Total Subjects',
      'passed': 'Passed',
      'arrears': 'Arrears',
      'subject_wise_results': 'Subject-wise Results',

      // Fees Module
      'fee_status': 'Fee Status',
      'total_fees': 'Total Fees',
      'paid': 'Paid',
      'pending': 'Pending',
      'due_date': 'Due Date',
      'fine': 'Fine',
      'late_fee': 'Late Fee',
      'paid_on': 'Paid On',
      'receipt': 'Receipt',
      'fee_breakdown': 'Fee Breakdown',
      'payment_due': 'Payment Due',
      'amount_due': 'Amount Due',

      // Messages
      'welcome_message': 'Welcome to check your child\'s academic progress',
      'loading': 'Loading...',
      'no_data': 'No data available',
      'retry': 'Retry',
      'network_error': 'Network error. Please try again',
      'demo_numbers': 'Demo numbers: 9876543210, 9988776655, 9123456789',
    },

    'te': { // Telugu
      // General
      'app_title': 'SASTRA తల్లిదండ్రులు',
      'welcome': 'స్వాగతం, తల్లిదండ్రులారా',
      'welcome_back': 'మీరు మళ్లీ స్వాగతం',
      'select_language': 'భాషను ఎంచుకోండి',
      'processing': 'ప్రాసెస్ చేస్తోంది...',
      'success': 'విజయవంతం',
      'error': 'లోపం',
      'back': 'వెనుకకు',
      'continue': 'కొనసాగించు',
      'cancel': 'రద్దు',
      'select_option': 'ఒక ఎంపికను ఎంచుకోండి',

      // Mobile Verification
      'mobile_verification': 'మొబైల్ ధృవీకరణ',
      'enter_mobile': 'మొబైల్ నంబర్ నమోదు చేయండి',
      'enter_mobile_hint': 'మీ రిజిస్టర్ చేసిన మొబైల్ నంబర్',
      'send_otp': 'OTP పంపండి',
      'otp_sent': 'OTP పంపబడింది',
      'enter_valid_mobile': 'చెల్లుబాటు అయ్యే 10 అంకెల మొబైల్ నంబర్ నమోదు చేయండి',
      'verifying_mobile': 'మీ మొబైల్ నంబర్ ధృవీకరించబడుతోంది',
      'mobile_not_found': 'మొబైల్ నంబర్ నమోదు కాలేదు. దయచేసి విశ్వవిద్యాలయాన్ని సంప్రదించండి.',
      'secure_info': 'మీ సమాచారం సురక్షితం',

      // OTP Verification
      'sending_otp': 'OTP పంపబడుతోంది',
      'verify_otp': 'OTP ధృవీకరించండి',
      'enter_otp': '6-అంకెల OTP నమోదు చేయండి',
      'enter_otp_hint': 'మీ మొబైల్‌కు పంపిన OTP',
      'resend_otp': 'OTP మళ్లీ పంపండి',
      'otp_verified': 'OTP విజయవంతంగా ధృవీకరించబడింది',
      'invalid_otp': 'చెల్లని OTP',
      'otp_expired': 'OTP గడువు ముగిసింది',
      'verifying_otp': 'OTP ధృవీకరిస్తోంది',
      'didnt_receive_otp': 'OTP రాలేదా?',

      // Dashboard
      'dashboard': 'డాష్బోర్డ్',
      'attendance': 'హాజరు',
      'sgpa_cgpa': 'SGPA & CGPA',
      'exam_results': 'పరీక్ష ఫలితాలు',
      'fees': 'రుసుము వివరాలు',
      'logout': 'నిష్క్రమించు',
      'logout_confirm': 'మీరు ఖచ్చితంగా నిష్క్రమించాలనుకుంటున్నారా?',
      'notifications': 'నోటిఫికేషన్లు',
      'no_notifications': 'కొత్త నోటిఫికేషన్లు లేవు',

      // Student Info
      'student_name': 'విద్యార్థి పేరు',
      'register_number': 'రిజిస్టర్ నంబర్',
      'branch': 'బ్రాంచ్',

      // Attendance Module
      'attendance_percentage': 'హాజరు శాతం',
      'attendance_status': 'హాజరు స్థితి',
      'good': 'మంచిది',
      'satisfactory': 'సంతృప్తికరంగా',
      'needs_improvement': 'మెరుగుదల అవసరం',
      'total_classes': 'మొత్తం తరగతులు',
      'classes_attended': 'హాజరైన తరగతులు',
      'classes_missed': 'తప్పిన తరగతులు',
      'subject_wise_attendance': 'సబ్జెక్ట్ వారీ హాజరు',
      'semester': 'సెమిస్టర్',
      'select_semester': 'సెమిస్టర్ ఎంచుకోండి',

      // Results Module
      'sgpa': 'SGPA',
      'cgpa': 'CGPA',
      'overall_performance': 'మొత్తం పనితీరు',
      'subject': 'సబ్జెక్ట్',
      'grade': 'గ్రేడ్',
      'credits': 'క్రెడిట్స్',
      'status': 'స్థితి',
      'pass': 'పాస్',
      'fail': 'ఫెయిల్',
      'arrear': 'అరియర్',
      'no_arrears': 'అరియర్లు లేవు',
      'total_subjects': 'మొత్తం సబ్జెక్ట్లు',
      'passed': 'పాస్ అయినవి',
      'arrears': 'అరియర్లు',
      'subject_wise_results': 'సబ్జెక్ట్ వారీ ఫలితాలు',

      // Fees Module
      'fee_status': 'రుసుము స్థితి',
      'total_fees': 'మొత్తం రుసుము',
      'paid': 'చెల్లించిన',
      'pending': 'పెండింగ్',
      'due_date': 'గడువు తేదీ',
      'fine': 'జరిమానా',
      'late_fee': 'ఆలస్యం రుసుము',
      'paid_on': 'చెల్లించిన తేదీ',
      'receipt': 'రసీదు',
      'fee_breakdown': 'రుసుము వివరాలు',
      'payment_due': 'చెల్లింపు పెండింగ్',
      'amount_due': 'పెండింగ్ మొత్తం',

      // Messages
      'welcome_message': 'మీ పిల్లల విద్యా పురోగతిని తనిఖీ చేయడానికి స్వాగతం',
      'loading': 'లోడ్ అవుతోంది...',
      'no_data': 'డేటా అందుబాటులో లేదు',
      'retry': 'మళ్ళీ ప్రయత్నించండి',
      'network_error': 'నెట్వర్క్ లోపం. దయచేసి మళ్ళీ ప్రయత్నించండి',
      'demo_numbers': 'డెమో నంబర్లు: 9876543210, 9988776655, 9123456789',
    },

    'hi': { // Hindi
      // General
      'app_title': 'SASTRA अभिभावक',
      'welcome': 'स्वागत है, अभिभावक',
      'welcome_back': 'आपका फिर से स्वागत है',
      'select_language': 'भाषा चुनें',
      'processing': 'प्रक्रिया जारी...',
      'success': 'सफल',
      'error': 'त्रुटि',
      'back': 'वापस',
      'continue': 'जारी रखें',
      'cancel': 'रद्द करें',
      'select_option': 'कोई विकल्प चुनें',

      // Mobile Verification
      'mobile_verification': 'मोबाइल सत्यापन',
      'enter_mobile': 'मोबाइल नंबर दर्ज करें',
      'enter_mobile_hint': 'आपका पंजीकृत मोबाइल नंबर',
      'send_otp': 'OTP भेजें',
      'otp_sent': 'OTP भेजा गया',
      'enter_valid_mobile': 'वैध 10-अंकीय मोबाइल नंबर दर्ज करें',
      'verifying_mobile': 'आपका मोबाइल नंबर सत्यापित किया जा रहा है',
      'mobile_not_found': 'मोबाइल नंबर पंजीकृत नहीं है। कृपया विश्वविद्यालय से संपर्क करें।',
      'secure_info': 'आपकी जानकारी सुरक्षित है',

      // OTP Verification
      'sending_otp': 'OTP भेजा जा रहा है',
      'verify_otp': 'OTP सत्यापित करें',
      'enter_otp': '6-अंकों का OTP दर्ज करें',
      'enter_otp_hint': 'आपके मोबाइल पर भेजा गया OTP',
      'resend_otp': 'OTP पुनः भेजें',
      'otp_verified': 'OTP सफलतापूर्वक सत्यापित हुआ',
      'invalid_otp': 'अमान्य OTP',
      'otp_expired': 'OTP की अवधि समाप्त',
      'verifying_otp': 'OTP सत्यापित किया जा रहा है',
      'didnt_receive_otp': 'OTP नहीं मिला?',

      // Dashboard
      'dashboard': 'डैशबोर्ड',
      'attendance': 'उपस्थिति',
      'sgpa_cgpa': 'SGPA और CGPA',
      'exam_results': 'परीक्षा परिणाम',
      'fees': 'शुल्क विवरण',
      'logout': 'लॉग आउट',
      'logout_confirm': 'क्या आप वाकई लॉग आउट करना चाहते हैं?',
      'notifications': 'सूचनाएं',
      'no_notifications': 'कोई नई सूचना नहीं',

      // Student Info
      'student_name': 'छात्र का नाम',
      'register_number': 'पंजीकरण संख्या',
      'branch': 'शाखा',

      // Attendance Module
      'attendance_percentage': 'उपस्थिति प्रतिशत',
      'attendance_status': 'उपस्थिति स्थिति',
      'good': 'अच्छा',
      'satisfactory': 'संतोषजनक',
      'needs_improvement': 'सुधार की आवश्यकता',
      'total_classes': 'कुल कक्षाएं',
      'classes_attended': 'उपस्थित कक्षाएं',
      'classes_missed': 'छूटी कक्षाएं',
      'subject_wise_attendance': 'विषयवार उपस्थिति',
      'semester': 'सेमेस्टर',
      'select_semester': 'सेमेस्टर चुनें',

      // Results Module
      'sgpa': 'SGPA',
      'cgpa': 'CGPA',
      'overall_performance': 'समग्र प्रदर्शन',
      'subject': 'विषय',
      'grade': 'ग्रेड',
      'credits': 'क्रेडिट',
      'status': 'स्थिति',
      'pass': 'पास',
      'fail': 'फेल',
      'arrear': 'बकाया',
      'no_arrears': 'कोई बकाया नहीं',
      'total_subjects': 'कुल विषय',
      'passed': 'पास',
      'arrears': 'बकाया',
      'subject_wise_results': 'विषयवार परिणाम',

      // Fees Module
      'fee_status': 'शुल्क स्थिति',
      'total_fees': 'कुल शुल्क',
      'paid': 'भुगतान किया',
      'pending': 'लंबित',
      'due_date': 'नियत तारीख',
      'fine': 'जुर्माना',
      'late_fee': 'विलंब शुल्क',
      'paid_on': 'भुगतान तिथि',
      'receipt': 'रसीद',
      'fee_breakdown': 'शुल्क विवरण',
      'payment_due': 'भुगतान लंबित',
      'amount_due': 'लंबित राशि',

      // Messages
      'welcome_message': 'अपने बच्चे की शैक्षणिक प्रगति देखने के लिए स्वागत है',
      'loading': 'लोड हो रहा है...',
      'no_data': 'कोई डेटा उपलब्ध नहीं',
      'retry': 'पुनः प्रयास करें',
      'network_error': 'नेटवर्क त्रुटि। कृपया पुनः प्रयास करें',
      'demo_numbers': 'डेमो नंबर: 9876543210, 9988776655, 9123456789',
    },
  };

}