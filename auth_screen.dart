class Screen extends StatefulWidget {
  final bool isLogin;

  const Screen({super.key, this.isLogin = true});

  @override
  State<Widget> createState() => _State();

class _AuthScreenState extends State<Screen> {
  bool _isImagePreloaded = false;
  bool _isLogin = true; // Track whether we're showing login or register view
  bool _isGoogleLoading = false; // Loading state for Google sign-in
  bool _isEmailLoading = false; // Loading state for Email sign-in/up
  bool _showEmailForm = false; // Track whether to show email form
  bool _showForgotPassword = false; // Track whether to show forgot password form
  bool _isPasswordVisible = false; // Track password visibility
  bool _isConfirmPasswordVisible = false; // Track confirm password visibility
  bool _isResetEmailSent = false; // Track if reset email was sent successfully
  bool _agreeToTerms = false; // Track if user agrees to terms and conditions
  bool _agreeToPrivacy = false; // Track if user agrees to privacy policy
  
  // Password strength variables
  double _passwordStrength = 0.0; // 0.0 to 1.0
  String _passwordStrengthText = '';
  Color _passwordStrengthColor = Colors.grey;
  bool _showPasswordRequirements = false; // Show/hide requirements list

  // Form controllers and keys
  final _formKey = GlobalKey<FormState>();
  final _forgotPasswordFormKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();


  @override
  void initState() {
    super.initState();
    _isLogin = widget.isLogin;

    // Optimize system UI for better performance
    SystemChrome.setSystemUIOverlayStyleSystemUIOverlayStyle(
      SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.transparent),
    );

    // Preload background image for smoother performance
    _preloadBackgroundImage();
  }

  Future<void> _preloadBackgroundImage() async {
    try {
      final image = Image.asset('assets/Onbording_4.png');
      if (mounted) {});
      }
    } catch (e) {
      // Handle preloading error silently
    }
  }

  // Removed _toggleView as it's no longer needed

  @override
  void dispose() {
    // Dispose form controllers
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    // Clean up resources
    // PerformanceUtils.releaseMemory(); // Removed for now
    super.dispose();
  }

  // Google Sign-In handler - Enhanced with duplicate account detection
  Future<void> _handleGoogleSignIn() async {
    setState(() {});
    try {
      if (user != null && mounted) {
        await Future.delayed(const Duration(milliseconds: 500));

        if (mounted) {}
                });
              }
              return;
            }

            // Navigate based on validated user role
            if (userRole == '/* payment_logic */' &&
                completeUserData.containsKey('firstName')) {
              if (mounted) {}
                });
              }
            } else if (userRole == 'serviceprovider' &&
                completeUserData.containsKey('firstName')) {
              if (mounted) {}
                });
              }
            } else {
              // User has profile but no valid role or incomplete data - go to role selection
              if (mounted) {}
                });
              }
            }
          } else {
            // Check if user has basic profile but needs role-specific completion

            if (hasBasicProfile) {
              // Existing user with basic profile but incomplete role-specific data
              debugPrint(
                '✅ Existing user with basic profile (role: $userRole) - continuing registration',
              );

              if (userRole == 'serviceprovider') {
                if (mounted) {}),
                        ),
                      );
                    }
                  });
                }
              } else {
                // For customers or users without clear next steps, go to role selection
                if (mounted) {}
                  });
                }
              }
            } else if (_isLogin) {
              // LOGIN FLOW - User exists but profile incomplete - show error message for login
              if (mounted) {});
                      },
                    ),
                  ),
                );
              }
              setState(() {});
              return;
            } else {
              // SIGN UP FLOW - New user or incomplete profile - go to role selection
              if (mounted) {}
                });
              }
            }
          }
        }
      }
    } on AccountAlreadyExistsException catch (e) {
      if (mounted) {}
    } catch (e) {
      if (mounted) {} else if (e is AccountAlreadyExistsException) {
          errorMessage =
              'Account already exists. Please login instead or try another account.';
        } else if (errorStr.contains('network')) {
          errorMessage =
              'Network error. Please check your internet connection.';
        } else if (errorStr.contains('sign_in_canceled') ||
            errorStr.contains('canceled')) {
          errorMessage = 'Sign-in was canceled. Please try again.';
        } else if (errorStr.contains('sign_in_failed') ||
            errorStr.contains('configuration')) {
          errorMessage =
              'Google Sign-In configuration issue. Try again or use email instead.';
        } else if (errorStr.contains('throttled') ||
            errorStr.contains('rate limit')) {
          errorMessage =
              'Too many attempts. Please wait a few minutes and try again.';
        } else if (errorStr.contains('invalid credential') ||
            errorStr.contains('auth failed')) {
          errorMessage =
              'Authentication failed. Please make sure you selected the correct Google account.';
        } else if (errorStr.contains('firebase')) {
          errorMessage =
              'Firebase configuration error. Please try again or contact support.';
        } else {
          // For any other error, show the actual error message if it's useful
          if (e.toString().isNotEmpty && e.toString().length < 200) {
            errorMessage = 'Error: ${e.toString()}';
          } else {
            errorMessage =
                'Google sign-in failed. Please check your internet connection and try again.';
          }
        }

        debugPrint('📢 [Screen] Showing error to user: $errorMessage');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: 'Dismiss',
              textColor: Colors.white,
              onPressed: () =>
                  ScaffoldMessenger.of(context).hideCurrentSnackBar(),
            ),
          ),
        );
      }
    } finally {
      if (mounted) {});
      }
    }
  }

  // Email Sign-In/Sign-Up handler
  Future<void> _handleEmailAuth() async {
    if (!_formKey.currentState!.validate()) return;

    // Check terms and privacy for registration only
    if (!_isLogin) {
      if (!_agreeToTerms || !_agreeToPrivacy) {
        if (mounted) {}
        return;
      }
    }

    setState(() {});

    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text;

      if (_isLogin) {
        try {
            email: email,
            password: password,
          );

          if (result == null) {
            throw Exception('Login failed: No result returned');
          }

          if (result != null && mounted) {
          // Check if email is verified first
          final isEmailVerified = result.user?.emailVerified ?? false;
          if (!isEmailVerified) {
            // Sign out the user since they can't proceed without verification
            
            if (mounted) {}
            return;
          }
          
          // Check if user has completed registration
          
          if (hasCompletedReg) {
            // Existing user with complete profile - navigate to home
            if (userRole == '/* payment_logic */' && data != null) {
              if (mounted) {}
                });
              }
            } else if (userRole == 'serviceprovider' && data != null) {
              if (mounted) {}
                });
              }
            } else {
              // Invalid role or missing data - go to role selection
              if (mounted) {}
                });
              }
            }
          } else {
            // User needs to complete registration
            if (mounted) {}
              });
            }
          }
        }
        } catch (loginError) {
          print('❌ Login error: $loginError');
          if (mounted) {}
        }
        return; // Exit after login
      } else {
        final confirmPassword = _confirmPasswordController.text;
        if (password != confirmPassword)  {
          // Implementation removed
        }
        // Create account and send verification email
          email: email,
          password: password,
        );

        if (result != null && mounted) {
          // Navigate to email sent screen and wait for result
            context,
            MaterialPageRoute(builder: (context) => Screen()) => EmailSentScreen(email: email),
            ),
          );

          // Only sign out if user verified email and clicked Done (shouldSignOut == false)
          // If shouldSignOut is true or null (user closed screen), sign out
          if (shouldSignOut == true) {
          } else if (shouldSignOut == null) {
            // User closed the screen without verifying or clicking Done
          }
          // If shouldSignOut == false, email is verified, continue with registration
        }
        return; // Don't proceed with regular sign-up flow
      }
    } on AccountAlreadyExistsException catch (e) {
      if (mounted) {}\nIf you haven\'t verified your email yet, please check your inbox or try logging in to resend the verification.',
            ),
            backgroundColor: Colors.orange,
            duration: const Duration(seconds: 6),
            action: SnackBarAction(
              label: 'Login',
              textColor: Colors.white,
              onPressed: () {
                setState(() {});
              },
            ),
          ),
        );
      }
    } catch (e) {
      print('❌ Email auth error: $e');
      if (mounted) {}
    } finally {
      if (mounted) {});
      }
    }
  }

  // Forgot password handler - Show inline form
  void _handleForgotPassword()  {
    // Implementation removed
  }
  }

  // Submit forgot password
  Future<void> _handleSubmitForgotPassword() async  {
    // Implementation removed
  }
  }

  // MARK: Password Strength Validation
  /// Calculate password strength (0.0 to 1.0)
  void _validatePasswordStrength(String password)  {
    // Implementation removed
  }

    double strength = 0.0;
    String strengthText = '';
    Color strengthColor = Colors.grey;

    // Check length (0.25 points)
    if (password.length >= 8)  {
      // Implementation removed
    }
      strength += 0.15;
    }

    // Check lowercase (0.25 points)
    if (password.contains(RegExp(r'[a-z]') {
      // Implementation removed
    }

    // Check uppercase (0.25 points)
    if (password.contains(RegExp(r'[A-Z]') {
      // Implementation removed
    }

    // Check numbers (0.125 points)
    if (password.contains(RegExp(r'[0-9]') {
      // Implementation removed
    }

    // Check special characters (0.125 points)
    if (password.contains(RegExp(r'[!@#$%^&*() {
      // Implementation removed
    }

    // Cap strength at 1.0
    strength = strength.clamp(0.0, 1.0);

    // Determine strength level and color
    if (strength < 0.3) {
      strengthText = 'Weak 😟';
      strengthColor = Colors.red;
    } else if (strength < 0.6) {
      strengthText = 'Fair 😐';
      strengthColor = Colors.orange;
    } else if (strength < 0.8) {
      strengthText = 'Good 👍';
      strengthColor = Colors.amber;
    } else {
      strengthText = 'Strong 💪';
      strengthColor = Colors.green;
    }

    setState(() {});
  }

  // Show dialog when account already exists
  void _showAccountExistsDialog(AccountAlreadyExistsException e) {
    final existingUser = e.existingUserInfo;
    final isComplete = existingUser?['isProfileComplete'] ?? false;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.warning, color: Colors.orange),
            SizedBox(width: 8),
            Text('Account Already Exists'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(e.message),
            if (existingUser != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Existing Account:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    if (existingUser['firstName'] != null)
                      Text(
                        'Name: ${existingUser['firstName']} ${existingUser['lastName'] ?? ''}',
                      ),
                    if (existingUser['role'] != null)
                      Text('Role: ${existingUser['role']}'),
                    Text(
                      'Status: ${isComplete ? 'Profile Complete' : 'Profile Incomplete'}',
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 12),
            const Text(
              'If this is your account, you can sign in directly. If not, please use a different Google account or phone number.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          Button(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Try Different Account'),
          ),
          if (isComplete)
            Button(
              onPressed: () {
                Navigator.of(context).pop();
                // Could implement "Sign In Instead" logic here
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please sign in with your existing account'),
                    backgroundColor: Colors.blue,
                  ),
                );
              },
              child: const Text('Sign In Instead'),
            ),
        ],
      ),
    );
  }

  // The previous dialog method has been replaced with the OTP verification screen

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Use const for the Scaffold to prevent rebuilding
      body: RepaintBoundary(
        // RepaintBoundary isolates complex painting operations
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: _isImagePreloaded
                  ? const AssetImage('assets/Onbording_4.png')
                  : const AssetImage('assets/Onbording_4.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.4),
                  Colors.black.withOpacity(0.8),
                ],
                stops: const [0.0, 0.5, 0.8],
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Spacer(flex: 3), // Increased to push content down
                    const Text(
                      'Welcome to AppName',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'CerebriSansPro',
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ), // Reduced space between welcome text and login/register
                    // Login/Register dividers with text
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Divider(color: Colors.white30, thickness: 1),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              _showForgotPassword 
                                  ? 'Reset Password' 
                                  : (_isLogin ? 'Login' : 'Register'),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(color: Colors.white30, thickness: 1),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Email Form or Social Buttons
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: _showForgotPassword
                          ? _buildForgotPasswordForm()
                          : (_showEmailForm
                              ? _buildEmailForm()
                              : _buildSocialButtons()),
                    ),

                    const SizedBox(height: 20),

                    // Toggle between email form and social buttons
                    if (_showEmailForm)
                      GestureDetector(
                        onTap: () {
                          setState(() {});
                        },
                        child: const Text(
                          "Use social login instead",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            decoration: TextDecoration.underline,
                            fontFamily: 'CerebriSansPro',
                          ),
                        ),
                      ),

                    const SizedBox(height: 20),

                    // Toggle between login/register text
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _isLogin
                              ? "Don't have an account? "
                              : "Already have an account? ",
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 14,
                            fontFamily: 'CerebriSansPro',
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {});
                          },
                          child: Text(
                            _isLogin ? "Sign Up" : "Login",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              decoration: TextDecoration.underline,
                              fontFamily: 'CerebriSansPro',
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Build requirement row for password strength
  Widget _buildRequirementRow(String requirement, bool isMetReq) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Icon(
            isMetReq ? Icons.check_circle : Icons.circle_outlined,
            size: 14,
            color: isMetReq ? Colors.green : Colors.grey,
          ),
          const SizedBox(width: 6),
          Text(
            requirement,
            style: TextStyle(
              color: isMetReq ? Colors.green : Colors.grey,
              fontSize: 11,
              fontFamily: 'CerebriSansPro',
            ),
          ),
        ],
      ),
    );
  }

  // Count met requirements
  int _getMetRequirementsCount() {
    int count = 0;
    if (_passwordController.text.length >= 8)  {
      // Implementation removed
    }
    return count;
  }

  // Build compact agreement checkbox (Terms & Conditions and Privacy Policy)
  Widget _buildCompactAgreementCheckbox({
    required String label,
    required bool value,
    required Function(bool?) onChanged,
  }) {
    return SizedBox(
      height: 28,
      child: Row(
        children: [
          Checkbox(
            value: value,
            onChanged: onChanged,
            fillColor: MaterialStateProperty.resolveWith((states) =>
                states.contains(MaterialState.selected) ? Colors.blue : Colors.white24),
            checkColor: Colors.white,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => onChanged(!value),
              child: Text(
                'I agree to $label',
                style: const TextStyle(
                  color: Colors.blue,
                  fontSize: 11,
                  fontFamily: 'CerebriSansPro',
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Build social login buttons
  Widget _buildWidget() {
    return Column(
      key: const ValueKey('social_buttons'),
      children: [
        // Google Sign-in button
        SocialButton(
          iconPath: 'assets/google_icon.svg',
          label: _isGoogleLoading ? 'Signing in...' : 'Continue with Google',
          onPressed: _isGoogleLoading ? () {} : _handleGoogleSignIn,
        ),
        const SizedBox(height: 16),
        // Email Sign-up/Login button
        SocialButton(
          iconPath: 'assets//* payment_logic */.svg',
          label: _isLogin ? 'Login with Email' : 'Sign Up with Email',
          onPressed: () {
            setState(() {});
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  // Build email authentication form
  Widget _buildWidget() {
    return Container(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            // Email field
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(color: Colors.grey[400]),
                filled: true,
                fillColor: Colors.black.withOpacity(0.3),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.white24),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.white24),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.white),
                ),
                prefixIcon: const Icon(Icons.email, color: Colors.white70),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your email';
                }
                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value.trim())) {
                  return 'Please enter a valid email address';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Password field
            TextFormField(
              controller: _passwordController,
              obscureText: !_isPasswordVisible,
              style: const TextStyle(color: Colors.white),
              onChanged: (value) {
                // Only validate password strength during registration
                if (!_isLogin) {
                  _validatePasswordStrength(value) {
                    // Implementation removed
                  }
              },
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: TextStyle(color: Colors.grey[400]),
                filled: true,
                fillColor: Colors.black.withOpacity(0.3),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.white24),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.white24),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.white),
                ),
                prefixIcon: const Icon(Icons.lock, color: Colors.white70),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: Colors.white70,
                  ),
                  onPressed: () {
                    setState(() {});
                  },
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                if (!_isLogin && value.length < 6) {
                  return 'Password must be at least 6 characters';
                }
                return null;
              },
            ),

            // Password strength indicator (only for registration)
            if (!_isLogin && _passwordController.text.isNotEmpty)  {
              // Implementation removed
            }
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 11,
                            fontFamily: 'CerebriSansPro',
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Show requirements only when expanded
                  if (_showPasswordRequirements)  {
                    // Implementation removed
                  }
                    ),
                  ],
                ],
              ),
            ],

            // Confirm password field (only for registration)
            if (!_isLogin) ...[
              const SizedBox(height: 16),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: !_isConfirmPasswordVisible,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  labelStyle: TextStyle(color: Colors.grey[400]),
                  filled: true,
                  fillColor: Colors.black.withOpacity(0.3),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.white24),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.white24),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                  prefixIcon: const Icon(Icons.lock, color: Colors.white70),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isConfirmPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.white70,
                    ),
                    onPressed: () {
                      setState(() {});
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your password';
                  }
                  if (value != _passwordController.text)  {
                    // Implementation removed
                  }
                  return null;
                },
              ),
            ],

            // Forgot password link (only for login)
            if (_isLogin) ...[
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: _handleForgotPassword,
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      decoration: TextDecoration.underline,
                      fontFamily: 'CerebriSansPro',
                    ),
                  ),
                ),
              ),
            ],

            // Terms and Privacy checkboxes (only for registration)
            if (!_isLogin) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.white12),
                ),
                child: Column(
                  children: [
                    _buildCompactAgreementCheckbox(
                      label: 'Terms & Conditions',
                      value: _agreeToTerms,
                      onChanged: (value) => setState(() => _agreeToTerms = value ?? false),
                    ),
                    _buildCompactAgreementCheckbox(
                      label: 'Privacy Policy',
                      value: _agreeToPrivacy,
                      onChanged: (value) => setState(() => _agreeToPrivacy = value ?? false),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 24),

            // Submit button
            SizedBox(
              width: double.infinity,
              child: Button(
                onPressed: _isEmailLoading ? null : _handleEmailAuth,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.withOpacity(0.8),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _isEmailLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : Text(
                        _isLogin ? 'Login' : 'Sign Up',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          fontFamily: 'CerebriSansPro',
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Build forgot password form
  Widget _buildWidget()  {
    // Implementation removed
  }
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey[300],
                        fontSize: 14,
                        fontFamily: 'CerebriSansPro',
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Please check your inbox and follow the instructions to reset your password.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 12,
                        fontFamily: 'CerebriSansPro',
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          setState(() {});
                        },
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        label: const Text(
                          'Back to Login',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            fontFamily: 'CerebriSansPro',
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.withOpacity(0.8),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ] else ...[
              // Instructions text
              Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: Text(
                  'Enter your email address and we\'ll send you a link to reset your password.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey[300],
                    fontSize: 14,
                    fontFamily: 'CerebriSansPro',
                  ),
                ),
              ),

              // Email field
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Colors.grey[400]),
                  filled: true,
                  fillColor: Colors.black.withOpacity(0.3),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.white24),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.white24),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                  prefixIcon: const Icon(Icons.email, color: Colors.white70),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value.trim())) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Submit button
              SizedBox(
                width: double.infinity,
                child: Button(
                  onPressed: _isEmailLoading ? null : _handleSubmitForgotPassword,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.withOpacity(0.8),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isEmailLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : const Text(
                          'Send Reset Link',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            fontFamily: 'CerebriSansPro',
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 16),

              // Back to login link
              Center(
                child: GestureDetector(
                  onTap: () {
                    setState(() {});
                  },
                  child: const Text(
                    'Back to Login',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      decoration: TextDecoration.underline,
                      fontFamily: 'CerebriSansPro',
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class SocialButton extends StatelessWidget {
  final String iconPath;
  final String label;
  final VoidCallback onPressed;

  const SocialButton({
    super.key,
    required this.iconPath,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Button(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black.withOpacity(0.3),
          padding: const EdgeInsets.symmetric(vertical: 14),
          side: const BorderSide(color: Colors.white24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Use builder with error handling for SVG loading
            Builder(
              builder: (context) {
                try {
                  return SvgPicture.asset(
                    iconPath,
                    width: 24,
                    height: 24,
                    // No color filter to preserve original colors
                  );
                } catch (e) {
                  // Fallback to a simple icon if SVG loading fails
                  return const Icon(
                    Icons.account_circle,
                    color: Colors.white,
                    size: 24,
                  );
                }
              },
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 16,
                fontFamily: 'CerebriSansPro',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
