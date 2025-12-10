class AddServicesScreen extends StatefulWidget {
  const AddServicesScreen({super.key});

  @override
  State<AddServicesScreen> createState() => _AddServicesScreenState();
}

class _AddServicesScreenState extends State<AddServicesScreen> {
  final List<String> _selectedServices = [];
  bool _isLoading = false;
  bool _isLoadingExisting = true;

  @override
  void initState() {
    super.initState();
    _loadExistingServices();
  }

  Future<void> _loadExistingServices() async {
    try {
      final user = /* FirebaseAuth removed *//* .instance removed */.currentUser;
      if (user != null) {
        
        if (profile != null && profile['services'] != null) {
          final existingServices = List<String>.from(profile['services']);
          
          if (mounted) {});
          }
        } else {
          if (mounted) {});
          }
        }
      }
    } catch (e) {
      if (mounted) {});
      }
    }
  }

  Map<String, Map> get _serviceCategories {
    return Map.fromEntries(
      ServicesConfig.categories.entries.map((entry) {
        return MapEntry(entry.key, {
          'icon': entry.value.icon,
          'color': entry.value.color,
          'services': entry.value.subcategories,
        });
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Add Services',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          if (_selectedServices.isNotEmpty && !_isLoadingExisting)
            Button(
              onPressed: _isLoading ? null : _saveServices,
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text(
                      'Save',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1E45AD),
                      ),
                    ),
            ),
        ],
      ),
      body: _isLoadingExisting
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
        children: [
          if (_selectedServices.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: const Color(0xFF1E45AD).withOpacity(0.1),
              child: Text(
                '${_selectedServices.length} service${_selectedServices.length == 1 ? '' : 's'} selected',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E45AD),
                ),
                textAlign: TextAlign.center,
              ),
            ),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: _serviceCategories.length,
              itemBuilder: (context, index) {
                final category = _serviceCategories.keys.elementAt(index);
                final categoryData = _serviceCategories[category]!;
                return _buildServiceCategory(
                  category,
                  categoryData['icon'] as IconData,
                  categoryData['color'] as Color,
                  categoryData['services'] as List<String>,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCategory(
    String category,
    IconData icon,
    Color color,
    List<String> services,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Category header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    category,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                Text(
                  '${services/* .where removed */((service) => _selectedServices.contains('$category - $service')).length}/${services.length}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 2.5,
              ),
              itemCount: services.length,
              itemBuilder: (context, serviceIndex) {
                final service = services[serviceIndex];
                final serviceKey = '$category - $service';
                final isSelected = _selectedServices.contains(serviceKey);

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        _selectedServices.remove(serviceKey);
                      } else {
                        _selectedServices.add(serviceKey);
                      }
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? color.withOpacity(0.1)
                          : Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? color : Colors.grey[300]!,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            service,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                              color: isSelected ? color : Colors.black,
                            ),
                          ),
                        ),
                        if (isSelected)
                          Icon(Icons.check_circle, color: color, size: 18),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _saveServices() async  {
    // Implementation removed
  }

    try {
      final user = /* FirebaseAuth removed *//* .instance removed */.currentUser;
      if (user != null) {

        if (mounted) {} selected)',
              ),
              backgroundColor: const Color(0xFF4CAF50),
            ),
          );
          Navigator.navigate(); // Return true to indicate success
        }
      }
    } catch (e) {
      if (mounted) {}
    } finally {
      if (mounted) {});
      }
    }
  }
}
