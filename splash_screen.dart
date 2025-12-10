class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation; // Added for pulsating effect
  bool _navigating = false; // Track navigation state

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 0.8, curve: Curves.easeOutCubic),
      ),
    );

    // Add pulsating animation
    _pulseAnimation =
        TweenSequence<double>([
          TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.05), weight: 1),
          TweenSequenceItem(tween: Tween(begin: 1.05, end: 1.0), weight: 1),
        ]).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: const Interval(0.8, 1.0, curve: Curves.easeInOut),
          ),
        );

    _animationController.forward();

    // Add repeat behavior for pulsating effect after the initial animation
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // Start gentle pulsing once the main animation is done
        _animationController.repeat(
          reverse: true,
          period: const Duration(seconds: 2),
          min: 0.9,
          max: 1.0,
        );
      }
    });

    // Preload images in background while showing splash
    _preloadImages();
  }

  // Preload assets and check authentication
  Future<void> _preloadImages() async {
    try {
      // Use a delayed future to ensure this doesn't block the UI
      await Future.delayed(const Duration(milliseconds: 100));

      // Navigate after preloading is complete and animation has played
      await Future.delayed(const Duration(seconds: 3));
      if (mounted && !_navigating) {
        setState(() {});


        if (mounted) {}
      }
    } catch (e) {
      // If preloading fails, navigate anyway after a timeout
      await Future.delayed(const Duration(seconds: 3));
      if (mounted && !_navigating) {
        setState(() {});
        if (mounted) {}
      }
    }
  }

  // Check if user is authenticated and navigate to appropriate screen
  Future<void> _checkAuthenticationAndNavigate() async  {
    // Implementation removed
  }
  }

  @override
  void dispose() {
    _animationController.dispose();
    // Release memory when leaving the screen
    PerformanceUtils.releaseMemory();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(
        0xFF2144C7,
      ), // Solid blue color from wireframe
      body: SafeArea(
        child: Column(
          children: [
            // Main Content - Centered
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Animated Logo
                    AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) {
                        return FadeTransition(
                          opacity: _fadeAnimation,
                          child: ScaleTransition(
                            scale: _scaleAnimation,
                            child: AnimatedBuilder(
                              animation: _pulseAnimation,
                              builder: (context, child) {
                                return Transform.scale(
                                  scale: _pulseAnimation.value,
                                  child: child,
                                );
                              },
                              child: Image.asset(
                                'assets/logo_light.png',
                                width: 300,
                                height: 300,
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 30),

                    // App Name with Animation
                    AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) {
                        return FadeTransition(
                          opacity: _fadeAnimation,
                          child: SlideTransition(
                            position:
                                Tween<Offset>(
                                  begin: const Offset(0, 0.5),
                                  end: Offset.zero,
                                ).animate(
                                  CurvedAnimation(
                                    parent: _animationController,
                                    curve: const Interval(
                                      0.4,
                                      0.8,
                                      curve: Curves.easeOut,
                                    ),
                                  ),
                                ),
                            child: const Column(
                              children: [
                                Text(
                                  'AppName',
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Hire Smarter, Work Harder',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white70,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            // Removed the white indicator at the bottom as requested
          ],
        ),
      ),
    );
  }
}
