class VoiceText {
  // Welcome & General
  static String getWelcome(String language) {
    switch(language) {
      case 'ta':
        return 'SASTRA பெற்றோர் செயலிக்கு வரவேற்கிறோம். உங்கள் குழந்தையின் கல்வி தகவல்களைக் காண டாஷ்போர்டில் இருந்து ஒரு விருப்பத்தைத் தேர்ந்தெடுக்கவும்.';
      case 'te':
        return 'SASTRA తల్లిదండ్రుల యాప్‌కు స్వాగతం. మీ పిల్లల విద్యా సమాచారాన్ని చూడటానికి డాష్‌బోర్డ్ నుండి ఒక ఎంపికను ఎంచుకోండి.';
      case 'hi':
        return 'SASTRA अभिभावक ऐप में आपका स्वागत है। अपने बच्चे की शैक्षणिक जानकारी देखने के लिए डैशबोर्ड से कोई विकल्प चुनें।';
      default:
        return 'Welcome to SASTRA Parent App. Select an option from the dashboard to view your child\'s academic information.';
    }
  }

  static String getMenu(String language) {
    switch(language) {
      case 'ta':
        return 'மெனு விருப்பங்கள்: வெளியேறு';
      case 'te':
        return 'మెనూ ఎంపికలు: నిష్క్రమించు';
      case 'hi':
        return 'मेनू विकल्प: लॉगआउट';
      default:
        return 'Menu options: Logout';
    }
  }

  static String getStudentInfo(String language, String name, String regNo, String branch) {
    switch(language) {
      case 'ta':
        return 'மாணவர் பெயர்: $name. பதிவு எண்: $regNo. பிரிவு: $branch.';
      case 'te':
        return 'విద్యార్థి పేరు: $name. రిజిస్టర్ నంబర్: $regNo. బ్రాంచ్: $branch.';
      case 'hi':
        return 'छात्र का नाम: $name. पंजीकरण संख्या: $regNo. शाखा: $branch.';
      default:
        return 'Student name: $name. Register number: $regNo. Branch: $branch.';
    }
  }

  // Dashboard Cards
  static String getOpeningCard(String language, String cardName) {
    switch(language) {
      case 'ta':
        return '$cardName திறக்கப்படுகிறது';
      case 'te':
        return '$cardName తెరవబడుతోంది';
      case 'hi':
        return '$cardName खोला जा रहा है';
      default:
        return 'Opening $cardName';
    }
  }

  // Going Back
  static String getGoingBack(String language) {
    switch(language) {
      case 'ta':
        return 'பின்செல்கிறது';
      case 'te':
        return 'వెనుకకు వెళ్తోంది';
      case 'hi':
        return 'वापस जा रहे हैं';
      default:
        return 'Going back';
    }
  }

  // Attendance
  static String getAttendanceSummary(String language, int semester, double percentage, int total, int attended) {
    switch(language) {
      case 'ta':
        return 'செமஸ்டர் $semester வருகைப்பதிவு $percentage சதவீதம். மொத்த வகுப்புகள் $total, பங்கேற்றவை $attended.';
      case 'te':
        return 'సెమిస్టర్ $semester హాజరు $percentage శాతం. మొత్తం తరగతులు $total, హాజరైనవి $attended.';
      case 'hi':
        return 'सेमेस्टर $semester उपस्थिति $percentage प्रतिशत। कुल कक्षाएं $total, उपस्थित कक्षाएं $attended।';
      default:
        return 'Semester $semester attendance is $percentage percent. Total classes $total, attended $attended.';
    }
  }

  static String getAttendanceStatus(String language, double percentage) {
    String status = percentage >= 85 ? 'Good' : (percentage >= 75 ? 'Satisfactory' : 'Needs Improvement');
    switch(language) {
      case 'ta':
        return 'வருகைப்பதிவு நிலை: $status';
      case 'te':
        return 'హాజరు స్థితి: $status';
      case 'hi':
        return 'उपस्थिति स्थिति: $status';
      default:
        return 'Attendance status: $status';
    }
  }

  // SGPA/CGPA
  static String getCGPASummary(String language, double cgpa) {
    switch(language) {
      case 'ta':
        return 'உங்கள் CGPA $cgpa';
      case 'te':
        return 'మీ CGPA $cgpa';
      case 'hi':
        return 'आपका CGPA $cgpa';
      default:
        return 'Your CGPA is $cgpa';
    }
  }

  static String getSemesterSGPASummary(String language, Map<int, double> sgpaData) {
    switch(language) {
      case 'ta':
        return 'செமஸ்டர் 1: ${sgpaData[1]}, செமஸ்டர் 2: ${sgpaData[2]}, செமஸ்டர் 3: ${sgpaData[3]}, செமஸ்டர் 4: ${sgpaData[4]}';
      case 'te':
        return 'సెమిస్టర్ 1: ${sgpaData[1]}, సెమిస్టర్ 2: ${sgpaData[2]}, సెమిస్టర్ 3: ${sgpaData[3]}, సెమిస్టర్ 4: ${sgpaData[4]}';
      case 'hi':
        return 'सेमेस्टर 1: ${sgpaData[1]}, सेमेस्टर 2: ${sgpaData[2]}, सेमेस्टर 3: ${sgpaData[3]}, सेमेस्टर 4: ${sgpaData[4]}';
      default:
        return 'Semester 1: ${sgpaData[1]}, Semester 2: ${sgpaData[2]}, Semester 3: ${sgpaData[3]}, Semester 4: ${sgpaData[4]}';
    }
  }

  // Results
  static String getResultsSummary(String language, int semester, int total, int passed, int arrears) {
    switch(language) {
      case 'ta':
        return 'செமஸ்டர் $semester முடிவுகள்: மொத்தம் $total பாடங்கள். $passed தேர்ச்சி, $arrears நிலுவை.';
      case 'te':
        return 'సెమిస్టర్ $semester ఫలితాలు: మొత్తం $total సబ్జెక్ట్లు. $passed పాస్, $arrears అరియర్.';
      case 'hi':
        return 'सेमेस्टर $semester के परिणाम: कुल $total विषय। $passed पास, $arrears बकाया।';
      default:
        return 'Semester $semester results: $total subjects total. $passed passed, $arrears arrears.';
    }
  }

  // Fees
  static String getFeesSummary(String language, int semester, int totalFees, int paid, int pending, String dueDate, int fine) {
    switch(language) {
      case 'ta':
        return 'செமஸ்டர் $semester க்கான மொத்த கட்டணம் ரூ $totalFees. செலுத்தியது: ரூ $paid. நிலுவை: ரூ $pending. கடைசி தேதி: $dueDate. தாமத கட்டணம்: ரூ $fine.';
      case 'te':
        return 'సెమిస్టర్ $semester కి మొత్తం ఫీజు రూ $totalFees. చెల్లించినది: రూ $paid. పెండింగ్: రూ $pending. గడువు తేదీ: $dueDate. లేట్ ఫైన్: రూ $fine.';
      case 'hi':
        return 'सेमेस्टर $semester के लिए कुल फीस रु $totalFees. भुगतान किया: रु $paid. लंबित: रु $pending. नियत तारीख: $dueDate. विलंब शुल्क: रु $fine.';
      default:
        return 'Semester $semester total fees is Rs $totalFees. Paid: Rs $paid. Pending: Rs $pending. Due date: $dueDate. Late fine: Rs $fine.';
    }
  }

  static String getDueDateInfo(String language, String amount, String dueDate, String fine) {
    switch(language) {
      case 'ta':
        return 'நிலுவைத் தொகை: $amount. கடைசி தேதி: $dueDate. தாமத கட்டணம்: $fine';
      case 'te':
        return 'పెండింగ్ మొత్తం: $amount. గడువు తేదీ: $dueDate. లేట్ ఫైన్: $fine';
      case 'hi':
        return 'लंबित राशि: $amount. नियत तारीख: $dueDate. विलंब शुल्क: $fine';
      default:
        return 'Pending amount: $amount. Due date: $dueDate. Late fine: $fine';
    }
  }
}