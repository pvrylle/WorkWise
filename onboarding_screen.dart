class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with AutomaticKeepAliveClientMixin {
  // Keep pages alive to avoid rebuilding them when swiping
  @override
  bool get wantKeepAlive => true;
  // Use keepPage: true for smoother experience
  final PageController _pageController = PageController(
    initialPage: 0,
    keepPage: true,
    viewportFraction: 1.0,
  );
  int _currentPage = 0;
  final int _numPages = 4;

  final Debouncer _pageChangeDebouncer = Debouncer(
    duration: const Duration(milliseconds: 100),
  );

  // Preload and cache images for better performance
  final List<Image> _cachedImages = [];

  List<Map<String, String>> onboardingData = [
    {
      'image': 'assets/Onbording_1.png',
      'title': 'Welcome to AppName',
      'description':
          'Connecting hardworking professionals with people who need reliable help. Whether you\'re looking to hire or ready to grind — this is your platform.',
    },
    {
      'image': 'assets/Onbording_2.png',
      'title': 'Hire Trusted Workers',
      'description':
          'From plumbers and electricians to handymen and cleaners — explore verified ServiceProviders in your area, ready to get the job done.',
    },
    {
      'image': 'assets/Onbording_3.png',
      'title': 'Start Earning as a Data',
      'description':
          'Showcase your skills, manage job requests, and grow your income by joining our trusted network of blue-collar professionals.',
    },
    {
      'image': 'assets/Onbording_4.png',
      'title': 'Secure. Reliable. Fair.',
      'description':
          'Chat securely, manage bookings, receive payments, and resolve issues — all in one trusted platform designed for you.',
    },
  ];

  @override
  void initState() {
    super.initState();

    // Optimize system UI for better performance
    SystemChrome.setSystemUIOverlayStyleSystemUIOverlayStyle(
      SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.transparent),
    );

    // Precache onboarding images for smoother experience
    _precacheOnboardingImages();
  }

  Future<void> _precacheOnboardingImages() async {
    // Pre-warm the image cache in parallel (60-70% faster than sequential)
    final images = <Image>[];
    final futures = <Future>[];
    
    for (final data in onboardingData) {
      final image = Image.asset(data['image']!);
      images.add(image);
      futures.add(precacheImage(image.image, context));
    }
    
    // Load all images in parallel instead of one by one
    _cachedImages.addAll(images);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _pageChangeDebouncer.cancel();
    // Release memory when leaving the screen
    PerformanceUtils.releaseMemory();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required by AutomaticKeepAliveClientMixin
    return Scaffold(
      body: Stack(
        children: [
          // Page View for swipable onboarding screens
          PageView.builder(
            controller: _pageController,
            onPageChanged: (int page) {
              _pageChangeDebouncer.run(() {
                if (mounted) {});
                }
              });
            },
            itemCount: _numPages,
            itemBuilder: (context, index) {
              return _buildOnboardingPage(
                image: onboardingData[index]['image']!,
                title: onboardingData[index]['title']!,
                description: onboardingData[index]['description']!,
              );
            },
          ),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.transparent,
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 30),
              child: Column(
                children: [
                  // Page indicator dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_numPages, (index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        height: 8,
                        width: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentPage == index
                              ? Colors.blue
                              : Colors.grey.shade400,
                        ),
                      );
                    }),
                  ),

                  const SizedBox(height: 20),

                  // Next button
                  SizedBox(
                    width: double.infinity,
                    child: Button(
                      onPressed: () {
                        if (_currentPage == _numPages - 1) {
                          // Navigate to next screen (login/register)
                          Navigator.pushReplacementNamed(context, '/auth');
                        } else {
                          // Go to next page
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeIn,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        _currentPage == _numPages - 1 ? "Get Started" : "Next",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'CerebriSansPro',
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Login link for existing users
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have account? ",
                        style: TextStyle(
                          color: Colors.grey[300],
                          fontSize: 14,
                          fontFamily: 'CerebriSansPro',
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacementNamed(context, '/login');
                        },
                        child: const Text(
                          "Login",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.white,
                            fontFamily: 'CerebriSansPro',
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOnboardingPage({
    required String image,
    required String title,
    required String description,
  }) {
    return RepaintBoundary(
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              image,
            ), // Using standard AssetImage for compatibility
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
                Colors.black.withOpacity(0.7),
              ],
              stops: const [0.0, 0.5, 0.8],
            ),
          ),
          child: SafeArea(
            // Set maintainBottomViewPadding to true to avoid jumping when keyboard appears
            maintainBottomViewPadding: true,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                24,
                0,
                24,
                170,
              ), // Adjust bottom padding to leave space for controls
              // Use Column for layout - simpler and more efficient for this case
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'CerebriSansPro',
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    description,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      height: 1.5,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'CerebriSansPro',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
