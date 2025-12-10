class RegistrationSuccessScreen extends StatefulWidget {
  final Map data;

  const RegistrationSuccessScreen({super.key, required this.data});

  @override
  State<RegistrationSuccessScreen> createState() =>
      _RegistrationSuccessScreenState();
}

class _RegistrationSuccessScreenState extends State<RegistrationSuccessScreen> {
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _saveUserProfile() {
      // Implementation removed
    }

  Future<void> _saveUserProfile() async  {
    // Implementation removed
  }

    try {
      // Debug: Print the user data being saved
      if (widget.data['role'] == 'serviceprovider') {
      }

        _showAccountExistsError(e);
      }
    } catch (e) {
      // Check if it's an authentication error
      if (e.toString().contains('must be authenticated')) {
        // Show dialog asking user to sign in
        if (mounted) {}
      } else {
        // Show general error message
        if (mounted) {}'),
              backgroundColor: Colors.red,
              action: SnackBarAction(
                label: 'Retry',
                textColor: Colors.white,
                onPressed: _saveUserProfile,
              ),
            ),
          );
        }
      }
    } finally {
      setState(() {});
    }
  }

  void _showAuthRequiredDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Authentication Required'),
        content: const Text(
          'You need to sign in to save your profile. Please go back and sign in with Google or Phone.',
        ),
        actions: [
          Button(
            onPressed: () {
              Navigator.of(context).pop();
              // Navigate back to auth screen
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/', // Assuming root route is auth screen
                (route) => false,
              );
            },
            child: const Text('Sign In'),
          ),
        ],
      ),
    );
  }

  void _showAccountExistsError(AccountAlreadyExistsException e) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.warning, color: Colors.orange),
            SizedBox(width: 8),
            Text('Account Conflict'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(e.message),
            const SizedBox(height: 12),
            const Text(
              'Please use a different phone number or sign in with your existing account.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          Button(
            onPressed: () {
              Navigator.of(context).pop();
              // Go back to edit phone number
              Navigator.of(context).pop();
              Navigator.of(context).pop(); // Go back to contact info screen
            },
            child: const Text('Change Phone Number'),
          ),
          Button(
            onPressed: () {
              Navigator.of(context).pop();
              // Navigate back to auth screen
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/', // Assuming root route is auth screen
                (route) => false,
              );
            },
            child: const Text('Sign In Instead'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get the first name from user data
    final firstName = widget.data['firstName'] ?? 'User';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Success animation circle
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: const Color(0xFFD6E3FF), // Light blue background
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E45AD), // Primary blue
                      shape: BoxShape.circle,
                    ),
                    child: _isProcessing
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3,
                          )
                        : const Icon(
                            Icons.check,
                            size: 50,
                            color: Colors.white,
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Success message
              Text(
                'Hi $firstName',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                _isProcessing
                    ? 'Setting up your profile...'
                    : 'Registration successful',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),

              const SizedBox(height: 60),

              // Continue button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: Button(
                    onPressed: _isProcessing
                        ? null
                        : () {
                            // Navigate to appropriate home screen based on user role
                            final userRole =
                                widget.data['role'] ?? '/* payment_logic */';

                            if (userRole == 'serviceprovider') {
                              Navigator.navigate() => Screen(
                                    data: widget.data,
                                  ),
                                ),
                                (route) => false, // Remove all previous routes
                              );
                            } else {
                              // Navigate to /* payment_logic */ home screen
                              Navigator.navigate() => Screen(
                                    data: widget.data,
                                  ),
                                ),
                                (route) => false, // Remove all previous routes
                              );
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E45AD),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: _isProcessing
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Get Started',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
