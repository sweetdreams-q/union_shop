import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _accessCodeController = TextEditingController();
  bool _showAccessCodeInput = false;
  bool _isLoading = false;
  String? _errorMessage;
  String? _storedAccessCode;
  String? _storedEmail;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    _emailController.dispose();
    _accessCodeController.dispose();
    super.dispose();
  }

  Future<void> _sendAccessCode() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      setState(() => _errorMessage = 'Please enter your email address');
      return;
    }

    // Basic email validation
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      setState(() => _errorMessage = 'Please enter a valid email address');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Generate a random 6-digit access code
      final accessCode = _generateAccessCode();

      // In production, you would:
      // 1. Send this code via email using your backend/Cloud Functions
      // 2. Store the code with timestamp in Firestore/database
      // 3. Verify it when user submits

      // For demo/development: Log the code (in production, send via email)
      print('==============================================');
      print('ACCESS CODE for $email: $accessCode');
      print('==============================================');

      // Store the code temporarily for verification (in production, use backend)
      _storedAccessCode = accessCode;
      _storedEmail = email;

      setState(() {
        _showAccessCodeInput = true;
        _errorMessage = null;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('Access code sent to $email\n(Check console for demo code)'),
            duration: const Duration(seconds: 5),
            backgroundColor: const Color(0xFF4d2963),
          ),
        );
      }
    } catch (e) {
      setState(() =>
          _errorMessage = 'Failed to send access code. Please try again.');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _verifyAccessCode() async {
    final enteredCode = _accessCodeController.text.trim();

    if (enteredCode.isEmpty) {
      setState(() => _errorMessage = 'Please enter your access code');
      return;
    }

    if (enteredCode.length != 6) {
      setState(() => _errorMessage = 'Access code must be 6 digits');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Verify the access code
      if (enteredCode == _storedAccessCode &&
          _emailController.text.trim() == _storedEmail) {
        // Sign in with Firebase
        await _signInWithEmail(_storedEmail!);

        if (mounted) {
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Successfully signed in!'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );

          // Navigate to home page
          context.go('/');
        }
      } else {
        setState(
            () => _errorMessage = 'Invalid access code. Please try again.');
      }
    } on FirebaseAuthException catch (e) {
      setState(() => _errorMessage = _getErrorMessage(e.code));
    } catch (e) {
      setState(() => _errorMessage = 'An error occurred. Please try again.');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _signInWithEmail(String email) async {
    try {
      // Sign in anonymously with Firebase
      // In production, you could:
      // 1. Create custom token on your backend after verifying the code
      // 2. Use signInWithCustomToken() here
      // 3. Or use createUserWithEmailAndPassword() if collecting passwords

      final userCredential = await _auth.signInAnonymously();

      // Update the user's display name with their email
      await userCredential.user?.updateDisplayName(email);

      print('User signed in: ${userCredential.user?.uid}');
      print('Email: $email');

      // In production, you would:
      // - Store user data in Firestore
      // - Link the anonymous account with email
      // - Set up user profile
    } catch (e) {
      rethrow;
    }
  }

  String _generateAccessCode() {
    // Generate a random 6-digit code
    final random = DateTime.now().millisecondsSinceEpoch;
    final code = (random % 900000 + 100000).toString();
    return code;
  }

  String _getErrorMessage(String code) {
    switch (code) {
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'too-many-requests':
        return 'Too many login attempts. Please try again later.';
      default:
        return 'An error occurred. Please try again.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 48),

                // Logo
                Image.network(
                  'https://shop.upsu.net/cdn/shop/files/upsu_300x300.png?v=1614735854',
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 80,
                      height: 80,
                      color: Colors.grey[300],
                      child: const Center(
                        child: Icon(Icons.image_not_supported,
                            color: Colors.grey),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 48),

                // Title
                const Text(
                  'Welcome to Union Shop',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4d2963),
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 16),

                // Subtitle
                const Text(
                  'Sign in to your account to continue shopping',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 48),

                // Email Input
                TextField(
                  controller: _emailController,
                  enabled: !_showAccessCodeInput && !_isLoading,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'Enter your email',
                    labelText: 'Email Address',
                    prefixIcon: const Icon(Icons.email_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                          color: Color(0xFF4d2963), width: 2),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Access Code Input (shown after email is submitted)
                if (_showAccessCodeInput)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: _accessCodeController,
                        enabled: !_isLoading,
                        keyboardType: TextInputType.number,
                        maxLength: 6,
                        decoration: InputDecoration(
                          hintText: 'Enter 6-digit code',
                          labelText: 'Access Code',
                          prefixIcon: const Icon(Icons.security),
                          counterText: '',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                                color: Color(0xFF4d2963), width: 2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Check your email for the 6-digit access code',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),

                const SizedBox(height: 16),

                // Error Message
                if (_errorMessage != null)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFb00020).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFb00020)),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: Color(0xFFb00020),
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _errorMessage!,
                            style: const TextStyle(
                              color: Color(0xFFb00020),
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: 32),

                // Sign In Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading
                        ? null
                        : (_showAccessCodeInput
                            ? _verifyAccessCode
                            : _sendAccessCode),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4d2963),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      disabledBackgroundColor: Colors.grey[300],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Text(
                            _showAccessCodeInput
                                ? 'Verify Code'
                                : 'Send Access Code',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),

                if (_showAccessCodeInput)
                  Column(
                    children: [
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: _isLoading
                            ? null
                            : () {
                                setState(() {
                                  _showAccessCodeInput = false;
                                  _accessCodeController.clear();
                                  _errorMessage = null;
                                  _storedAccessCode = null;
                                  _storedEmail = null;
                                });
                              },
                        child: const Text(
                          'Use a different email',
                          style: TextStyle(color: Color(0xFF4d2963)),
                        ),
                      ),
                    ],
                  ),

                const SizedBox(height: 32),

                // Info Box
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4d2963).withOpacity(0.05),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFF4d2963).withOpacity(0.2),
                    ),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'How it works:',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF4d2963),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '1. Enter your email address\n'
                        '2. We\'ll send you a 6-digit access code\n'
                        '3. Enter the code to sign in\n'
                        '4. No password needed!',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                          height: 1.6,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Continue as Guest Button
                TextButton(
                  onPressed: () => context.go('/'),
                  child: const Text(
                    'Continue as Guest',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
