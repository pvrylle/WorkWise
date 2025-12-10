class CustomerConversationScreen extends StatefulWidget {
  final String conversationId;
  final Map serviceprovider;
  final Map? data;

  const CustomerConversationScreen({
    super.key,
    required this.conversationId,
    required this.serviceprovider,
    this.data,
  });

  @override
  State<CustomerConversationScreen> createState() =>
      _CustomerConversationScreenState();
}

class _CustomerConversationScreenState extends State<CustomerConversationScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _refreshMessages() async {
    setState(() {}); // Trigger rebuild
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          // Messages List with Real-time StreamBuilder
          Expanded(
            child: StreamBuilder<List<Map>>(
              stream: Service.streamMessages(widget.conversationId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(color: Color(0xFF1E40AF)),
                        SizedBox(height: 16),
                        Text('Loading messages...', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  );
                }
                
                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, size: 64, color: Colors.red),
                        const SizedBox(height: 16),
                        Text(
                          'Error: ${snapshot.error}',
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Button(
                          onPressed: () {
                            setState(() {}); // Trigger rebuild to retry
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }
                
                final messages = snapshot.data ?? [];
                
                // Auto-scroll to bottom when new messages arrive
                if (messages.isNotEmpty) {
                  // Post-frame callback((_) {
                    _scrollToBottom();
                  });
                }
                
                if (messages.isEmpty) {
                  return RefreshIndicator(
                    onRefresh: _refreshMessages,
                    child: const SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: SizedBox(
                        height: 400,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.chat_bubble_outline, size: 64, color: Colors.grey),
                              SizedBox(height: 16),
                              Text(
                                'No messages yet',
                                style: TextStyle(fontSize: 18, color: Colors.grey),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Start the conversation!',
                                style: TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }
                
                return RefreshIndicator(
                  onRefresh: _refreshMessages,
                  child: ListView.builder(
                    controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      
                      final currentUserId = /* FirebaseAuth removed *//* .instance removed */.currentUser?.uid;
                      final isMe = message['senderId'] == currentUserId;
                      
                      return _buildMessageBubble(message, isMe);
                    },
                  ),
                );
              },
            ),
          ),

          // Hiring Button
          _buildHiringButton(),

          // Message Input
          _buildMessageInput(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildWidget() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Navigator.navigate(),
      ),
      title: Row(
        children: [
          UserProfileAvatar(
            photoURL: widget.serviceprovider['photoURL'],
            firstName: widget.serviceprovider['firstName'],
            lastName: widget.serviceprovider['lastName'],
            fullName: widget.serviceprovider['displayName'],
            radius: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${widget.serviceprovider['firstName']} ${widget.serviceprovider['lastName']}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                Text(
                  widget.serviceprovider['profession'] ?? 'Construction Worker',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.video_call, color: Color(0xFF1E40AF)),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Video call feature coming soon!'),
                backgroundColor: Color(0xFF1E40AF),
              ),
            );
          },
        ),
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert, color: Colors.black),
          onSelected: (value) {
            switch (value) {
              case 'profile':
                break;
              case 'report':
                _showReportDialog();
                break;
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'profile',
              child: Row(
                children: [
                  Icon(Icons.person, color: Color(0xFF1E40AF)),
                  SizedBox(width: 8),
                  Text('View Profile'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'report',
              child: Row(
                children: [
                  Icon(Icons.report, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Report User'),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMessageBubble(Map message, bool isMe) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: isMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) ...[
            UserProfileAvatar(
              photoURL: widget.serviceprovider['photoURL'],
              firstName: widget.serviceprovider['firstName'],
              lastName: widget.serviceprovider['lastName'],
              fullName: widget.serviceprovider['displayName'],
              radius: 16,
            ),
            const SizedBox(width: 8),
          ],

          // Message Container
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isMe ? const Color(0xFF1E40AF) : Colors.grey[100],
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isMe ? 16 : 4),
                  bottomRight: Radius.circular(isMe ? 4 : 16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: _buildMessageContent(message, isMe),
            ),
          ),

          // User's side (right)
          if (isMe) ...[
            const SizedBox(width: 8),
            UserProfileAvatar(
              photoURL: widget.data?['photoURL'],
              firstName: widget.data?['firstName'],
              lastName: widget.data?['lastName'],
              fullName: widget.data?['displayName'],
              radius: 16,
              backgroundColor: const Color(0xFF1E40AF),
              textColor: Colors.white,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMessageContent(Map message, bool isMe) {
    // Handle both 'type' and 'messageType' fields for compatibility
    final messageType = message['type'] ?? message['messageType'] ?? 'text';
    
    switch (messageType) {
      case 'payment_request':
        return _buildPaymentRequestMessage(message, isMe) {
          // Implementation removed
        }
  }

  /// 💳 Build payment request message with button
  Widget _buildPaymentRequestMessage(Map message, bool isMe)  {
    // Implementation removed
  }
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.payment, color: Colors.white, size: 20) {
                        // Implementation removed
                      }
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
        
        if (isMe) ...[
          const SizedBox(height: 8),
          Text(
            '⏳ Awaiting client payment',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 12,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildAvailabilityMessage(Map message, bool isMe) {
    // Enhanced availability message display for comprehensive calendar sharing
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.calendar_month,
              color: isMe ? Colors.white : const Color(0xFF1E40AF),
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              'Complete Calendar Shared',
              style: TextStyle(
                color: isMe ? Colors.white : const Color(0xFF1E40AF),
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Calendar preview container
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isMe
                ? Colors.white.withOpacity(0.2)
                : const Color(0xFF1E40AF).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isMe
                  ? Colors.white.withOpacity(0.3)
                  : const Color(0xFF1E40AF).withOpacity(0.3),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Icon(
                    Icons.schedule,
                    color: isMe ? Colors.white : const Color(0xFF1E40AF),
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Monthly Schedule Overview',
                    style: TextStyle(
                      color: isMe ? Colors.white : const Color(0xFF1E40AF),
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Legend
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildAvailabilityLegend(
                    'Available',
                    const Color(0xFF4CAF50),
                    isMe,
                  ),
                  _buildAvailabilityLegend('Partial', Colors.orange, isMe),
                  _buildAvailabilityLegend('Busy', Colors.red, isMe),
                ],
              ),

              const SizedBox(height: 12),

              // Schedule summary
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isMe
                      ? Colors.white.withOpacity(0.1)
                      : Colors.white.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Weekly Schedule:',
                      style: TextStyle(
                        color: isMe ? Colors.white : Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '• Mon-Fri: 8:00 AM - 6:00 PM\n• Saturday: 9:00 AM - 3:00 PM\n• Sunday: Rest day',
                      style: TextStyle(
                        color: isMe
                            ? Colors.white.withOpacity(0.9)
                            : Colors.black87,
                        fontSize: 11,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // Call to action
              Text(
                '📞 Ask about specific dates for your project!',
                style: TextStyle(
                  color: isMe
                      ? Colors.white.withOpacity(0.8)
                      : Colors.grey[600],
                  fontSize: 11,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAvailabilityLegend(String label, Color color, bool isMe) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 9,
            color: isMe ? Colors.white.withOpacity(0.8) : Colors.grey[700],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildInteractiveCalendarMessage(
    Map message,
    bool isMe,
  ) {
    final availabilityData =
        message['availabilityData'] as Map?;

    if (availabilityData == null) {
      return Text(
        'Calendar data unavailable',
        style: TextStyle(
          color: isMe ? Colors.white : Colors.black,
          fontSize: 15,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with calendar icon
        Row(
          children: [
            Icon(
              Icons.calendar_today,
              color: isMe ? Colors.white : const Color(0xFF1E40AF),
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'Interactive Calendar Shared',
              style: TextStyle(
                color: isMe ? Colors.white : const Color(0xFF1E40AF),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Interactive Calendar Container
        Container(
          decoration: BoxDecoration(
            color: isMe
                ? Colors.white.withOpacity(0.1)
                : const Color(0xFF1E40AF).withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isMe
                  ? Colors.white.withOpacity(0.3)
                  : const Color(0xFF1E40AF).withOpacity(0.2),
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Calendar Header
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.schedule,
                      color: isMe ? Colors.white : const Color(0xFF1E40AF),
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${availabilityData['monthName']} ${availabilityData['year']}',
                      style: TextStyle(
                        color: isMe ? Colors.white : const Color(0xFF1E40AF),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // Days of week header
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
                      .map(
                        (day) => Expanded(
                          child: Center(
                            child: Text(
                              day,
                              style: TextStyle(
                                color: isMe ? Colors.white70 : Colors.grey[600],
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),

              // Interactive Calendar Grid
              _buildInteractiveCalendarGrid(availabilityData, isMe),

              const SizedBox(height: 16),

              // Legend
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildCalendarLegendItem('Available', Colors.green, isMe),
                  _buildCalendarLegendItem('Partial', Colors.orange, isMe),
                  _buildCalendarLegendItem('Busy', Colors.red, isMe),
                ],
              ),

              if (availabilityData['schedule'] != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isMe
                        ? Colors.white.withOpacity(0.1)
                        : Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        color: isMe ? Colors.white70 : Colors.grey[600],
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Default Schedule: ${availabilityData['schedule']}',
                        style: TextStyle(
                          color: isMe ? Colors.white70 : Colors.grey[700],
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 12),

              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () =>
                          _showCalendarDetailsDialog(availabilityData),
                      icon: Icon(
                        Icons.visibility,
                        size: 16,
                        color: isMe ? Colors.white : const Color(0xFF1E40AF),
                      ),
                      label: Text(
                        'View Details',
                        style: TextStyle(
                          color: isMe ? Colors.white : const Color(0xFF1E40AF),
                          fontSize: 13,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: isMe
                              ? Colors.white.withOpacity(0.5)
                              : const Color(0xFF1E40AF),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _requestBooking(availabilityData),
                      icon: const Icon(
                        Icons.book_online,
                        size: 16,
                        color: Colors.white,
                      ),
                      label: const Text(
                        'Book Now',
                        style: TextStyle(color: Colors.white, fontSize: 13),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E40AF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInteractiveCalendarGrid(
    Map availabilityData,
    bool isMe,
  ) {
    final daysInMonth = availabilityData['daysInMonth'] as int;
    final startingWeekday = availabilityData['startingWeekday'] as int;
    final availability =
        availabilityData['availability'] as Map;

    final totalCells = ((daysInMonth + startingWeekday) / 7).ceil() * 7;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 1,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
      ),
      itemCount: totalCells,
      itemBuilder: (context, index) {
        final dayNumber = index - startingWeekday + 1;

        if (dayNumber <= 0 || dayNumber > daysInMonth) {
          return const SizedBox();
        }

        final dayKey = dayNumber.toString();
        final dayAvailability = availability[dayKey] ?? 'unavailable';

        Color cellColor;
        Color textColor;

        switch (dayAvailability) {
          case 'available':
            cellColor = Colors.green;
            textColor = Colors.white;
            break;
          case 'partial':
            cellColor = Colors.orange;
            textColor = Colors.white;
            break;
          case 'busy':
            cellColor = Colors.red;
            textColor = Colors.white;
            break;
          default:
            cellColor = isMe
                ? Colors.white.withOpacity(0.1)
                : Colors.grey[200]!;
            textColor = isMe ? Colors.white54 : Colors.grey[500]!;
        }

        return GestureDetector(
          onTap: dayAvailability != 'unavailable'
              ? () => _showDayAvailabilityDetails(
                  dayNumber,
                  dayAvailability,
                  availabilityData,
                )
              : null,
          child: Container(
            decoration: BoxDecoration(
              color: cellColor,
              borderRadius: BorderRadius.circular(6),
              border: dayAvailability != 'unavailable'
                  ? Border.all(color: Colors.white.withOpacity(0.3))
                  : null,
            ),
            child: Center(
              child: Text(
                dayNumber.toString(),
                style: TextStyle(
                  color: textColor,
                  fontSize: 14,
                  fontWeight: dayAvailability != 'unavailable'
                      ? FontWeight.w600
                      : FontWeight.normal,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCalendarLegendItem(String label, Color color, bool isMe) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            color: isMe ? Colors.white70 : Colors.grey[700],
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  void _showCalendarDetailsDialog(Map availabilityData) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.calendar_month, color: Color(0xFF1E40AF)),
            const SizedBox(width: 8),
            Text(
              '${availabilityData['monthName']} ${availabilityData['year']} Details',
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Complete availability overview for ${widget.serviceprovider['firstName']}\'s schedule.',
            ),
            const SizedBox(height: 16),
            if (availabilityData['schedule'] != null)
              Text('Default working hours: ${availabilityData['schedule']}'),
            const SizedBox(height: 12),
            const Text(
              'Tap on any available day in the calendar to see specific time slots and book an appointment.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          Button(
            onPressed: () => Navigator.navigate(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showDayAvailabilityDetails(
    int day,
    String availability,
    Map availabilityData,
  ) {
    String statusText;
    Color statusColor;

    switch (availability) {
      case 'available':
        statusText = 'Fully Available';
        statusColor = Colors.green;
        break;
      case 'partial':
        statusText = 'Partially Available';
        statusColor = Colors.orange;
        break;
      case 'busy':
        statusText = 'Busy';
        statusColor = Colors.red;
        break;
      default:
        statusText = 'Unavailable';
        statusColor = Colors.grey;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: statusColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 8),
            Text('Day $day - $statusText'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${availabilityData['monthName']} $day, ${availabilityData['year']}',
            ),
            const SizedBox(height: 16),
            if (availability == 'available') ...[
              const Text('✓ Available for full-day bookings'),
              if (availabilityData['schedule'] != null)
                Text('Working hours: ${availabilityData['schedule']}'),
            ] else if (availability == 'partial') ...[
              const Text('⚠ Limited availability'),
              const Text('Some time slots may be occupied'),
            ] else if (availability == 'busy') ...[
              const Text('✗ Already booked'),
              const Text('No available slots for this day'),
            ],
          ],
        ),
        actions: [
          if (availability == 'available' || availability == 'partial')
            Button(
              onPressed: () {
                Navigator.navigate();
                _requestBooking(availabilityData, specificDay: day);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E40AF),
              ),
              child: const Text(
                'Book This Day',
                style: TextStyle(color: Colors.white),
              ),
            ),
          Button(
            onPressed: () => Navigator.navigate(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _requestBooking(
    Map availabilityData, {
    int? specificDay,
  }) {
    // Handle booking request
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.book_online, color: Color(0xFF1E40AF)),
            SizedBox(width: 8),
            Text('Request Data'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (specificDay != null)
              Text(
                'Requesting booking for ${availabilityData['monthName']} $specificDay, ${availabilityData['year']}',
              )
            else
              Text(
                'Requesting booking for ${availabilityData['monthName']} ${availabilityData['year']}',
              ),
            const SizedBox(height: 16),
            const Text(
              'This will send a booking request to the worker with your preferred dates and times.',
            ),
          ],
        ),
        actions: [
          Button(
            onPressed: () => Navigator.navigate(),
            child: const Text('Cancel'),
          ),
          Button(
            onPressed: () {
              Navigator.navigate();
              _sendBookingRequest(availabilityData, specificDay);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1E40AF),
            ),
            child: const Text(
              'Send Request',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _sendBookingRequest(
    Map availabilityData,
    int? specificDay,
  ) {
    // Simulate sending booking request
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              specificDay != null
                  ? 'Data request sent for day $specificDay!'
                  : 'Data request sent for available dates!',
            ),
          ],
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Widget _buildWidget() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ElevatedButton.icon(
        onPressed: _showHiringDialog,
        icon: const Icon(Icons.handshake, color: Colors.white, size: 18),
        label: Text(
          'Hire ${widget.serviceprovider['firstName'] ?? 'Worker'}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1E40AF),
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
      ),
    );
  }

  Widget _buildWidget() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Attachment Button
            IconButton(
              onPressed: _showAttachmentOptions,
              icon: const Icon(Icons.add, color: Color(0xFF1E40AF)),
              tooltip: 'Add attachment',
            ),

            // Message Input Field
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(24),
                ),
                child: TextField(
                  controller: _messageController,
                  decoration: const InputDecoration(
                    hintText: 'Type a message...',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  maxLines: null,
                  textCapitalization: TextCapitalization.sentences,
                ),
              ),
            ),

            const SizedBox(width: 8),

            // Send Button
            Container(
              decoration: const BoxDecoration(
                color: Color(0xFF1E40AF),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: _sendMessage,
                icon: const Icon(Icons.send, color: Colors.white),
                tooltip: 'Send message',
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _sendMessage() async {
    final content = _messageController.text.trim();
    if (content.isEmpty) return;

    _messageController.clear();

    try {
        conversationId: widget.conversationId,
        message: content,
        messageType: 'text',
      );

      // Message will be updated automatically through the stream
      _scrollToBottom();
      
    } catch (e) {
      // Show error to user
      if (mounted) {}
    }
  }

  void _showAttachmentOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildAttachmentOption(
                  icon: Icons.photo_camera,
                  label: 'Camera',
                  color: const Color(0xFF1E40AF),
                  onTap: () {
                    Navigator.navigate();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Camera feature coming soon!'),
                        backgroundColor: Color(0xFF1E40AF),
                      ),
                    );
                  },
                ),
                _buildAttachmentOption(
                  icon: Icons.photo_library,
                  label: 'Gallery',
                  color: Colors.green,
                  onTap: () {
                    Navigator.navigate();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Gallery feature coming soon!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                ),
                _buildAttachmentOption(
                  icon: Icons.location_on,
                  label: 'Location',
                  color: Colors.red,
                  onTap: () {
                    Navigator.navigate();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Location sharing coming soon!'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildAttachmentOption({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  void _showHiringDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Row(
                children: [
                  UserProfileAvatar(
                    photoURL: widget.serviceprovider['photoURL'],
                    firstName: widget.serviceprovider['firstName'],
                    lastName: widget.serviceprovider['lastName'],
                    fullName: widget.serviceprovider['displayName'],
                    radius: 24,
                    backgroundColor: const Color(0xFF1E40AF).withOpacity(0.1),
                    textColor: const Color(0xFF1E40AF),
                    fontSize: 18,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hire ${widget.serviceprovider['firstName']}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          widget.serviceprovider['profession'] ?? 'Construction Worker',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    _buildDetailRow(
                      'Rate',
                      '₱${widget.serviceprovider['price'] ?? '750'}/day',
                    ),
                    _buildDetailRow('Experience', '5+ years'),
                    _buildDetailRow('Rating', '★ 4.8 (127 reviews)'),
                    _buildDetailRow(
                      'Location',
                      widget.serviceprovider['location'] ?? 'El Paso, TX',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: Button(
                      onPressed: () => Navigator.navigate(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: const BorderSide(color: Color(0xFF1E40AF)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Color(0xFF1E40AF)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Button(
                      onPressed: () {
                        Navigator.navigate();
                        _proceedWithHiring();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E40AF),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Hire Now',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
        ],
      ),
    );
  }

  void _proceedWithHiring() async {
    // Send hiring confirmation message
    try {
        conversationId: widget.conversationId,
        message: 'Great! I\'d like to hire you for the project we discussed. When can we start?',
        messageType: 'text',
      );

      // Show confirmation
      if (mounted) {}

      // Auto-scroll to bottom
      _scrollToBottom();
    } catch (e) {
      if (mounted) {}
    }
  }

  void _showReportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Report User'),
        content: Text(
          'Report ${widget.serviceprovider['firstName']} for inappropriate behavior?',
        ),
        actions: [
          Button(
            onPressed: () => Navigator.navigate(),
            child: const Text('Cancel'),
          ),
          Button(
            onPressed: () {
              Navigator.navigate();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Report submitted. Thank you for your feedback.',
                  ),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Report', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
