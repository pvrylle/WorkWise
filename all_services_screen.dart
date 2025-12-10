class AllServicesScreen extends StatelessWidget {
  final Map? data;
  
  const AllServicesScreen({super.key, this.data});

  List<Map> get allServices {
    return ServicesConfig.allCategories.map((category) {
      return {
        'name': category.name,
        'icon': category.icon,
        'color': category.color,
      };
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'All Services',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Add More Job Button
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 20),
              child: ElevatedButton.icon(
                onPressed: () {
                  // Navigate to post screen (Post tab)
                  Navigator.of(context).pop(); // Go back to home first
                },
                icon: const Icon(Icons.add_circle_outline, color: Colors.white),
                label: const Text(
                  'Add More Job',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                ),
              ),
            ),

            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: allServices.length,
                itemBuilder: (context, index) {
                  final service = allServices[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.navigate() => ServiceServiceProvidersScreen(
                            serviceName: service['name'],
                            serviceColor: service['color'],
                            data: data,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: (service['color'] as Color).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: (service['color'] as Color).withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              color: (service['color'] as Color).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Icon(
                              service['icon'],
                              color: service['color'],
                              size: 32,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            service['name'],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, -1),
            ),
          ],
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey[600],
          currentIndex: 1, // Search tab selected
          onTap: (index) {
            switch (index) {
              case 0:
                Navigator.of(context).pop(); // Go back to home
                break;
              case 1:
                // Already on search-related screen
                break;
              case 2:
                // Handle Post - Navigate to post job screen
                Navigator.of(context).pop(); // Go back to home
                // TODO: Navigate to post job screen
                break;
              case 3:
                // Handle Chat
                break;
              case 4:
                // Handle Profile
                break;
            }
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
            BottomNavigationBarItem(
              icon: Icon(Icons.work_outline),
              label: 'Post',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_outlined),
              label: 'Chat',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
