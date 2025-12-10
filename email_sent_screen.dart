class EmailSentScreen extends StatefulWidget {
  final String email;

  const EmailSentScreen({super.key, required this.email});

  @override
  State<EmailSentScreen> createState() => _EmailSentScreenState();
}

class _EmailSentScreenState extends State<EmailSentScreen> {
  bool _isResending = false;

  Future<void> _resendEmail() async {
    setState(() {});

    try {

      if (mounted) {}
    } catch (e) {
      if (mounted) {}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } finally {
      if (mounted) {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),

              // Email image
              Image.asset(
                'assets/email.png',
                width: 150,
                height: 150,
                fit: BoxFit.contain,
              ),

              const SizedBox(height: 40),

              // Success message
              const Text(
                'Check Your Email',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 16),

              // Instruction text
              Text(
                'We\'ve sent a verification link to',
                style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 8),

              // Email address
              Text(
                widget.email,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade700,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 24),

              // Information container
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.shade100, width: 1),
                ),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Colors.blue.shade700,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Click the verification link in your email to activate your account. You\'ll need to log in again after verifying to complete registration.',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey.shade800,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Tips
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.lightbulb_outline,
                          color: Colors.orange.shade600,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Didn\'t receive the email?',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade800,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '• Check your spam or junk folder\n'
                      '• Make sure the email address is correct\n'
                      '• Wait a few minutes for the email to arrive',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Resend link
              Center(
                child: _isResending
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.blue.shade700,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Resending...',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      )
                    : GestureDetector(
                        onTap: _resendEmail,
                        child: Text(
                          'Resend Email',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.blue.shade700,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
              ),

              const SizedBox(height: 24),

              // Done button
              SizedBox(
                width: double.infinity,
                child: Button(
                  onPressed: () async {
                    // First, reload the user to get the latest emailVerified status
                    try {
                      
                      // Check if email is now verified
                      final isVerified = // Service call;
                      
                      if (isVerified) {
                        // Email is verified, proceed without signing out
                        if (mounted) {}
                        // Return false to indicate no sign-out needed
                        Navigator.of(context).pop(false);
                      } else {
                        // Email is not verified yet, show error message
                        if (mounted) {},
                              ),
                            ),
                          );
                        }
                        // Don't close the screen, let user try again
                        // Navigator.of(context).pop(true);
                      }
                    } catch (e) {
                      // If there's an error checking verification status
                      if (mounted) {}
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade700,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Done',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
