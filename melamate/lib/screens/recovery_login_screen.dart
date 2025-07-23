import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'home_screen.dart';

class RecoveryLoginScreen extends StatefulWidget {
  const RecoveryLoginScreen({super.key});

  @override
  State<RecoveryLoginScreen> createState() => _RecoveryLoginScreenState();
}

class _RecoveryLoginScreenState extends State<RecoveryLoginScreen> {
  final List<TextEditingController> _controllers = List.generate(12, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(12, (index) => FocusNode());
  bool _isLoading = false;
  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
    for (var controller in _controllers) {
      controller.addListener(_validateForm);
    }
  }

  void _validateForm() {
    setState(() {
      _isFormValid = _controllers.every((controller) => controller.text.trim().isNotEmpty);
    });
  }

  Future<void> _loginWithRecoveryPhrase() async {
    if (!_isFormValid) return;

    setState(() {
      _isLoading = true;
    });

    // Simulate recovery phrase validation
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });

    // Navigate to home screen
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
    }
  }

  void _pasteRecoveryPhrase() async {
    // This would typically get text from clipboard
    // For demo purposes, we'll fill with sample words
    final sampleWords = [
      'abandon', 'ability', 'able', 'about', 'above', 'absent',
      'absorb', 'abstract', 'absurd', 'abuse', 'access', 'accident'
    ];

    for (int i = 0; i < _controllers.length && i < sampleWords.length; i++) {
      _controllers[i].text = sampleWords[i];
    }
    _validateForm();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recovery Phrase Login'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.darkBackground,
              Color(0xFF1E293B),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Enter Recovery Phrase',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Enter your 12-word recovery phrase to restore your wallet',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 24),
                // Paste button
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: _pasteRecoveryPhrase,
                    icon: const Icon(Icons.content_paste, color: AppTheme.primaryBlue),
                    label: const Text(
                      'Paste',
                      style: TextStyle(color: AppTheme.primaryBlue),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Recovery phrase input grid
                Expanded(
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 3,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: 12,
                    itemBuilder: (context, index) {
                      return TextField(
                        controller: _controllers[index],
                        focusNode: _focusNodes[index],
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: '${index + 1}',
                          labelStyle: const TextStyle(color: AppTheme.textSecondary),
                          hintText: 'word',
                          hintStyle: const TextStyle(color: AppTheme.textSecondary),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          filled: true,
                          fillColor: AppTheme.cardBackground,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: AppTheme.primaryBlue),
                          ),
                        ),
                        onChanged: (value) {
                          if (value.contains(' ')) {
                            // Handle pasted text with multiple words
                            final words = value.trim().split(' ');
                            for (int i = 0; i < words.length && (index + i) < _controllers.length; i++) {
                              _controllers[index + i].text = words[i];
                            }
                            _validateForm();
                          }
                        },
                        onSubmitted: (value) {
                          if (index < 11) {
                            _focusNodes[index + 1].requestFocus();
                          }
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
                // Warning message
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.orange.withOpacity(0.3)),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.warning_amber, color: Colors.orange),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Never share your recovery phrase with anyone. MellaMate will never ask for it.',
                          style: TextStyle(
                            color: Colors.orange,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Login button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isFormValid && !_isLoading ? _loginWithRecoveryPhrase : null,
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text('Restore Wallet'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.removeListener(_validateForm);
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }
}
