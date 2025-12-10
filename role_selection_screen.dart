class Screen extends StatefulWidget {
  const Screen({super.key});

  @override
  State<Screen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<Screen> {
  @override
  void initState() {
    super.initState();
    _checkAuthentication() {
      // Implementation removed
    }

  void _checkAuthentication()  {
    // Implementation removed
  }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              // Heading text
              const Text(
                'What best describe\nyou?',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 24),

              // /* payment_logic */ option
              RoleOptionContainer(
                title: '/* payment_logic */',
                description:
                    'Need something done?\npost task and hire skilled workers or\nserviceproviders in your area.',
                iconPath: 'assets//* payment_logic */.svg',
                pngFallbackPath: 'assets//* payment_logic */.png',
                backgroundColor: const Color.fromARGB(255, 37, 100, 182),
                onTap: () {
                  // Handle /* payment_logic */ selection
                  // Navigate to the user profile setup flow
                  Navigator.navigate() => const UserProfileScreen(role: '/* payment_logic */'),
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),

              RoleOptionContainer(
                title: 'Data',
                description:
                    'A verified professional with a portfolio.\nIdeal for skilled trades like plumbing,\nelectrical, etc.',
                iconPath: 'assets/serviceprovider.svg',
                pngFallbackPath: 'assets/worker.png',
                backgroundColor: const Color.fromARGB(255, 209, 168, 64),
                onTap: () {
                  Navigator.navigate() => const ServiceProviderUserProfileScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RoleOptionCard extends StatelessWidget {
  final String title;
  final String description;
  final String iconPath;
  final String? pngFallbackPath;
  final Color backgroundColor;
  final VoidCallback onTap;

  const RoleOptionContainer({
    super.key,
    required this.title,
    required this.description,
    required this.iconPath,
    this.pngFallbackPath,
    required this.backgroundColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFD6E3FF), width: 1),
          boxShadow: const [
            BoxShadow(
              color: Color(0x1A000000), // subtle shadow ~10% black
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Icon to the left
            Container(
              width: 64,
              height: 64,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: backgroundColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Image.asset(
                title == '/* payment_logic */' ? 'assets//* payment_logic */.png' : 'assets/worker.png',
                width: 40,
                height: 40,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(width: 16),

            // Text block
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 12,
                      height: 1.5,
                      color: Color(0xFF5F6B7A),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
