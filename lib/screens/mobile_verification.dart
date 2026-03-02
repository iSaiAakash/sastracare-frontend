import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sastra_parent/providers/language_provider.dart';
import 'package:sastra_parent/screens/student_selection_screen.dart';
import 'package:sastra_parent/screens/dashboard_screen.dart';
import 'package:sastra_parent/services/api_service.dart';
import 'package:sastra_parent/services/tts_service.dart';
import '../providers/auth_provider.dart';
import '../utils/voice_text.dart';

// SASTRA Official Colors
const Color sastraNavyBlue = Color(0xFF002B5C);
const Color sastraGold = Color(0xFFFDB913);
const Color sastraWhite = Color(0xFFFFFFFF);
const Color sastraLightGray = Color(0xFFF5F5F5);

class MobileVerificationScreen extends StatefulWidget {
  const MobileVerificationScreen({super.key});

  @override
  State<MobileVerificationScreen> createState() =>
      _MobileVerificationScreenState();
}

class _MobileVerificationScreenState extends State<MobileVerificationScreen> {
  final TextEditingController _mobileController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;
  final TTSService _ttsService = TTSService();

  void _speakText(String text) {
    final languageProvider = context.read<LanguageProvider>();
    _ttsService.speak(text, languageCode: languageProvider.currentLanguage);
  }

  void _goBack() {
    final languageProvider = context.read<LanguageProvider>();
    _speakText(VoiceText.getGoingBack(languageProvider.currentLanguage));
    Navigator.pop(context);
  }

  Future<void> _sendOTP() async {
    final mobile = _mobileController.text.trim();
    final languageProvider = context.read<LanguageProvider>();

    if (mobile.isEmpty || mobile.length != 10 || !RegExp(r'^[0-9]+$').hasMatch(mobile)) {
      setState(() {
        _errorMessage = languageProvider.translate('enter_valid_mobile');
      });
      _speakText(_errorMessage!);
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final message = await ApiService.requestOtp(mobile);
      _speakText(message);

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => OTPScreen(mobileNumber: mobile),
        ),
      );
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceAll("Exception: ", "");
      });
      _speakText(_errorMessage!);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = context.watch<LanguageProvider>();

    return Scaffold(
      body: Column(
        children: [
          // Header with SASTRA gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [sastraNavyBlue, Color(0xFF1A4A7A)],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            padding: const EdgeInsets.only(top: 60, bottom: 30, left: 20, right: 20),
            child: Row(
              children: [
                GestureDetector(
                  onTap: _goBack,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: sastraWhite.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_back,
                      color: sastraWhite,
                      size: 22,
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Text(
                    languageProvider.translate('mobile_verification'),
                    style: const TextStyle(
                      color: sastraWhite,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _speakText(languageProvider.translate('enter_mobile'));
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: sastraWhite.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.volume_up,
                      color: sastraGold,
                      size: 22,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Gold accent line
          Container(
            height: 4,
            color: sastraGold,
          ),

          // Main content
          Expanded(
            child: Container(
              color: sastraLightGray,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),

                      // Instruction Card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: sastraWhite,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withValues(alpha: 0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: sastraNavyBlue.withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.phone_android,
                                size: 40,
                                color: sastraNavyBlue,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              languageProvider.translate('mobile_verification'),
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                                color: sastraNavyBlue,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              languageProvider.translate('enter_mobile_hint'),
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Mobile Number Input
                      Text(
                        languageProvider.translate('enter_mobile'),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[800],
                        ),
                      ),
                      const SizedBox(height: 8),

                      Container(
                        decoration: BoxDecoration(
                          color: sastraWhite,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withValues(alpha: 0.1),
                              blurRadius: 5,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _mobileController,
                          keyboardType: TextInputType.phone,
                          maxLength: 10,
                          style: const TextStyle(fontSize: 18),
                          decoration: InputDecoration(
                            hintText: '9876543210',
                            hintStyle: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[400],
                            ),
                            prefixIcon: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 15),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.phone,
                                    color: sastraNavyBlue,
                                    size: 22,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    '+91',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            prefixIconConstraints: const BoxConstraints(
                              minWidth: 80,
                              minHeight: 50,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: sastraWhite,
                            errorText: _errorMessage,
                            counterText: '',
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 18,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Send OTP Button
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _sendOTP,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: sastraNavyBlue,
                            foregroundColor: sastraWhite,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
                          ),
                          child: _isLoading
                              ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: sastraWhite,
                              strokeWidth: 2,
                            ),
                          )
                              : Text(
                            languageProvider.translate('send_otp'),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Security Note
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.lock_outline,
                              size: 14,
                              color: Colors.grey[500],
                            ),
                            const SizedBox(width: 6),
                            Text(
                              languageProvider.translate('secure_info'),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// OTP Screen with proper UI
class OTPScreen extends StatefulWidget {
  final String mobileNumber;
  const OTPScreen({super.key, required this.mobileNumber});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final List<TextEditingController> _otpControllers = List.generate(
    6,
        (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  bool _isLoading = false;
  int _secondsRemaining = 60;
  bool _canResend = false;
  String? _otpError;
  final TTSService _ttsService = TTSService();

  void _speakText(String text) {
    final languageProvider = context.read<LanguageProvider>();
    _ttsService.speak(text, languageCode: languageProvider.currentLanguage);
  }

  void _goBack() {
    final languageProvider = context.read<LanguageProvider>();
    _speakText(VoiceText.getGoingBack(languageProvider.currentLanguage));
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
        _startTimer();
      } else {
        setState(() => _canResend = true);
      }
    });
  }

  Future<void> _verifyOTP() async {
    final otp = _otpControllers.map((c) => c.text).join();
    final languageProvider = context.read<LanguageProvider>();

    if (otp.length != 6) {
      setState(() => _otpError = languageProvider.translate('invalid_otp'));
      _speakText(languageProvider.translate('invalid_otp'));
      return;
    }

    setState(() {
      _isLoading = true;
      _otpError = null;
    });

    try {
      await ApiService.verifyOtp(widget.mobileNumber, otp);
      final children = await ApiService.getMyChildren();

      if (!mounted) return;

      if (children.isEmpty) {
        throw Exception("No students linked to this parent.");
      }

      if (children.length == 1) {
        final studentId = (children[0]["id"] as num).toInt();
        await ApiService.setSelectedStudentId(studentId);
        context.read<AuthProvider>().setSelectedStudentId(studentId);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const StudentSelectionScreen(),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const StudentSelectionScreen(),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _otpError = e.toString().replaceAll("Exception: ", "");
      });
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _resendOTP() {
    setState(() {
      _secondsRemaining = 60;
      _canResend = false;
    });
    for (var c in _otpControllers) c.clear();
    _focusNodes[0].requestFocus();
    _startTimer();
    _speakText(context.read<LanguageProvider>().translate('otp_sent'));
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = context.watch<LanguageProvider>();

    return Scaffold(
      body: Column(
        children: [
          // Header
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [sastraNavyBlue, Color(0xFF1A4A7A)],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            padding: const EdgeInsets.only(top: 60, bottom: 30, left: 20, right: 20),
            child: Row(
              children: [
                GestureDetector(
                  onTap: _goBack,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: sastraWhite.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_back,
                      color: sastraWhite,
                      size: 22,
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Text(
                    languageProvider.translate('verify_otp'),
                    style: const TextStyle(
                      color: sastraWhite,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _speakText(languageProvider.translate('enter_otp'));
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: sastraWhite.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.volume_up,
                      color: sastraGold,
                      size: 22,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Container(height: 4, color: sastraGold),

          Expanded(
            child: Container(
              color: sastraLightGray,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),

                      // OTP Info Card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: sastraWhite,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withValues(alpha: 0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                color: sastraNavyBlue.withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.sms,
                                size: 35,
                                color: sastraNavyBlue,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              languageProvider.translate('verify_otp'),
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: sastraNavyBlue,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              languageProvider.translate('enter_otp_hint'),
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '+91 ${widget.mobileNumber}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: sastraNavyBlue,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

                      // OTP Input Fields - 6 boxes
                      Text(
                        languageProvider.translate('enter_otp'),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[800],
                        ),
                      ),
                      const SizedBox(height: 16),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(6, (index) {
                          return SizedBox(
                            width: 45,
                            height: 55,
                            child: TextField(
                              controller: _otpControllers[index],
                              focusNode: _focusNodes[index],
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              maxLength: 1,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                              decoration: InputDecoration(
                                counterText: '',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: sastraNavyBlue,
                                    width: 2,
                                  ),
                                ),
                                filled: true,
                                fillColor: sastraWhite,
                                contentPadding: const EdgeInsets.all(12),
                              ),
                              onChanged: (value) {
                                if (value.isNotEmpty && index < 5) {
                                  FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
                                } else if (value.isEmpty && index > 0) {
                                  FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
                                }
                                if (_otpError != null) setState(() => _otpError = null);
                              },
                            ),
                          );
                        }),
                      ),

                      if (_otpError != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Text(
                            _otpError!,
                            style: const TextStyle(color: Colors.red, fontSize: 13),
                          ),
                        ),

                      const SizedBox(height: 24),

                      // Timer and Resend
                      Center(
                        child: Text(
                          _canResend
                              ? languageProvider.translate('didnt_receive_otp')
                              : '${languageProvider.translate('resend_otp')} $_secondsRemaining s',
                          style: TextStyle(
                            fontSize: 14,
                            color: _canResend ? sastraNavyBlue : Colors.grey[600],
                            fontWeight: _canResend ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                      ),

                      if (_canResend)
                        Center(
                          child: TextButton(
                            onPressed: _resendOTP,
                            style: TextButton.styleFrom(foregroundColor: sastraNavyBlue),
                            child: Text(
                              languageProvider.translate('resend_otp'),
                              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                            ),
                          ),
                        ),

                      const SizedBox(height: 30),

                      // Verify Button
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _verifyOTP,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: sastraNavyBlue,
                            foregroundColor: sastraWhite,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: _isLoading
                              ? const CircularProgressIndicator(color: sastraWhite, strokeWidth: 2)
                              : Text(
                            languageProvider.translate('verify_otp'),
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}