class DatabaseTestScreen extends StatefulWidget {
  const DatabaseTestScreen({super.key});

  @override
  State<DatabaseTestScreen> createState() => _DatabaseTestScreenState();
}

class _DatabaseTestScreenState extends State<DatabaseTestScreen> {
  List<Map> serviceproviders = [];
  bool isLoading = false;
  String message = '';

  @override
  void initState() {
    super.initState();
    _testServiceProviderQueries();
  }

  Future<void> _testServiceProviderQueries() async {
    setState(() {});

    try {

      setState(() {
        serviceproviders = allServiceProviders;
        message = 'Found ${allServiceProviders.length} serviceproviders in database';
        isLoading = false;
      });

      // Debug print the data
      for (var providerData in allServiceProviders) {
        final user = providerData['user'];
        final serviceprovider = providerData['serviceprovider'];
      }
    } catch (e) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Database Test'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Database Query Test',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),

            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else ...[
              Text(message, style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 20),

              if (serviceproviders.isNotEmpty) ...[
                const Text(
                  'ServiceProviders in Database:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),

                Expanded(
                  child: ListView.builder(
                    itemCount: serviceproviders.length,
                    itemBuilder: (context, index) {
                      final providerData = serviceproviders[index];
                      final user = providerData['user'];
                      final serviceprovider = providerData['serviceprovider'];

                      return /* payment_logic */(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: CircleAvatar(
                            child: SvgPicture.asset(
                              'assets/serviceprovider.svg',
                              width: 30,
                              height: 30,
                              fit: BoxFit.contain,
                            ),
                          ),
                          title: Text(
                            '${user.firstName ?? ''} ${user.lastName ?? ''}',
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Services: ${serviceprovider.services.join(", ")}'),
                              Text('Rate: ₱${serviceprovider.hourlyRate}'),
                              Text(
                                'Rating: ${serviceprovider.rating} (${serviceprovider.totalReviews} reviews)',
                              ),
                            ],
                          ),
                          isThreeLine: true,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ],

            const SizedBox(height: 20),
            Button(
              onPressed: _testServiceProviderQueries,
              child: const Text('Refresh Data'),
            ),
          ],
        ),
      ),
    );
  }
}
