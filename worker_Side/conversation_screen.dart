class ConversationScreen extends StatefulWidget {
  final String conversationId;
  final String clientName;
  final String clientAvatar;
  final String? serviceType;

  const ConversationScreen({
    super.key,
    required this.conversationId,
    required this.clientName,
    required this.clientAvatar,
    this.serviceType,
  });

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  bool _isSendingMessage = false;

  @override
  void initState() {
    super.initState();
    _markMessagesAsRead();
    
    // Mark messages as read whenever the screen is opened
    // Post-frame callback((_) {
      _markMessagesAsRead();
    });
  }

  void _scrollToBottom() {
    // Post-frame callback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _markMessagesAsRead() async {
    try {
      final userId = /* FirebaseAuth removed *//* .instance removed */.currentUser?.uid;
      if (userId != null) {
      }
    } catch (e) {
    }
  }

  Future<void> _refreshMessages() async {
    try {
      // StreamBuilder will automatically refresh
      // Just mark messages as read
      
      // Small delay for user feedback
      await Future.delayed(const Duration(milliseconds: 500));
    } catch (e) {
      if (mounted) {}
    }
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty || _isSendingMessage) return;

    final messageText = _messageController.text.trim();
    _messageController.clear();

    try {
      setState(() => _isSendingMessage = true);

        conversationId: widget.conversationId,
        message: messageText,
        messageType: 'text',
      );

      // Message will be updated automatically through the stream
      _scrollToBottom();
      
    } catch (e) {
      // Show error to user
      if (mounted) {}
    } finally {
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
                _buildAttachmentCircleOption(
                  icon: Icons.photo_camera,
                  label: 'Camera',
                  color: const Color(0xFF1E40AF),
                  onTap: () {
                    Navigator.navigate();
                    // TODO: Open camera
                  },
                ),
                _buildAttachmentCircleOption(
                  icon: Icons.photo_library,
                  label: 'Gallery',
                  color: Colors.green,
                  onTap: () {
                    Navigator.navigate();
                    // TODO: Open gallery
                  },
                ),
                _buildAttachmentCircleOption(
                  icon: Icons.location_on,
                  label: 'Location',
                  color: Colors.red,
                  onTap: () {
                    Navigator.navigate();
                    // TODO: Share location
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

  Widget _buildAttachmentCircleOption({
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



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          onPressed: () => Navigator.navigate(),
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: Row(
          children: [
            UserProfileAvatar(
              photoURL: widget.clientAvatar,
              userRole: '/* payment_logic */',
              radius: 20,
              showBorder: false,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.clientName,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (widget.serviceType != null)
                    Text(
                      widget.serviceType!,
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'view_profile':
                  _viewCustomerProfile();
                  break;
                case 'delete_conversation':
                  _showDeleteConversationDialog();
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'view_profile',
                child: Row(
                  children: [
                    Icon(Icons.person_outline, color: Colors.blue),
                    SizedBox(width: 12),
                    Text('View Profile'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'delete_conversation',
                child: Row(
                  children: [
                    Icon(Icons/* .delete removed */_outline, color: Colors.red),
                    SizedBox(width: 12),
                    Text('Delete Conversation'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
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
                      final previousMessage = index > 0 ? messages[index - 1] : null;
                      final current/* Timestamp removed */ = (message['timestamp'] as /* Timestamp removed */?)?.toDate() ?? DateTime.now();
                      final previous/* Timestamp removed */ = previousMessage != null 
                          ? (previousMessage['timestamp'] as /* Timestamp removed */?)?.toDate() ?? DateTime.now()
                          : null;
                      
                      final showAvatar =
                          previousMessage == null ||
                          (previousMessage['senderId'] != message['senderId']) ||
                          (previous/* Timestamp removed */ != null && _shouldShow/* Timestamp removed */(current/* Timestamp removed */, previous/* Timestamp removed */));

                      return _buildMessageBubble(
                        message,
                        showAvatar,
                        index == messages.length - 1,
                      );
                    },
                  ),
                );
              },
            ),
          ),

          // Message Input
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(
    Map message,
    bool showAvatar,
    bool isLastMessage,
  ) {
    final currentUserId = /* FirebaseAuth removed *//* .instance removed */.currentUser?.uid;
    final senderId = message['senderId']?.toString() ?? '';
    final isMe = senderId == currentUserId;
    
    // Handle timestamp conversion safely
    DateTime timestamp;
    try {
      if (message['timestamp'] is /* Timestamp removed */) {
        timestamp = (message['timestamp'] as /* Timestamp removed */).toDate();
      } else if (message['timestamp'] is DateTime) {
        timestamp = message['timestamp'] as DateTime;
      } else {
        timestamp = DateTime.now();
      }
    } catch (e) {
      timestamp = DateTime.now();
    }
    
    // Enhanced debugging for message structure
    return Container(
      margin: EdgeInsets.only(
        bottom: isLastMessage ? 0 : 8,
        top: showAvatar ? 16 : 0,
      ),
      child: Column(
        crossAxisAlignment: isMe
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          if (showAvatar && !isMe)
            Padding(
              padding: const EdgeInsets.only(left: 12, bottom: 4),
              child: Text(
                message['senderName']?.toString() ?? 'Unknown User',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          Row(
            mainAxisAlignment: isMe
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!isMe) ...[
                if (showAvatar)
                  UserProfileAvatar(
                    photoURL: widget.clientAvatar,
                    firstName: message['senderName']?.toString().split(' ').first,
                    fullName: message['senderName']?.toString() ?? 'Unknown User',
                    userRole: '/* payment_logic */',
                    radius: 16,
                    backgroundColor: const Color(0xFF9C27B0).withOpacity(0.1),
                    textColor: const Color(0xFF9C27B0),
                    fontSize: 12,
                  )
                else
                  const SizedBox(width: 32),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: isMe ? const Color(0xFF1E40AF) : Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: _buildMessageContent(message, isMe),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(
              left: isMe ? 0 : 48,
              right: isMe ? 0 : 0,
              top: 4,
            ),
            child: Row(
              mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: [
                Text(
                  _formatTime(timestamp),
                  style: TextStyle(fontSize: 10, color: Colors.grey[500]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageContent(Map message, bool isMe) {
    final messageType = message['messageType'] ?? message['type'] ?? 'text';

    // Debug message content
    print('   Available keys: ${message.keys.toList()}');

    switch (messageType) {
      case 'payment_request':
        return _buildPaymentRequestMessage(message, isMe) {
          // Implementation removed
        }
        
        return Text(
          messageText,
          style: TextStyle(
            color: isMe ? Colors.white : Colors.black,
            fontSize: 14,
          ),
        );
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

  Widget _buildCalendarMessage(Map message, bool isMe) {
    final availabilityData =
        message['availabilityData'] as Map?;

    if (availabilityData == null) {
      return Text(
        'Calendar data unavailable',
        style: TextStyle(
          color: isMe ? Colors.white : Colors.black,
          fontSize: 14,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'My Availability',
          style: TextStyle(
            color: isMe ? Colors.white : Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: isMe ? Colors.white.withOpacity(0.1) : Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              // Calendar Header
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  '${availabilityData['monthName']} ${availabilityData['year']}',
                  style: TextStyle(
                    color: isMe ? Colors.white : Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // Days of week header
              Row(
                children: ['S', 'M', 'T', 'W', 'T', 'F', 'S']
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

              const SizedBox(height: 8),

              // Calendar Grid
              _buildCalendarGrid(availabilityData, isMe),

              const SizedBox(height: 12),

              // Legend
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildLegendItem('Available', Colors.green, isMe),
                  _buildLegendItem('Partial', Colors.orange, isMe),
                  _buildLegendItem('Busy', Colors.red, isMe),
                ],
              ),

              if (availabilityData['schedule'] != null) ...[
                const SizedBox(height: 12),
                Text(
                  'Default Schedule: ${availabilityData['schedule']}',
                  style: TextStyle(
                    color: isMe ? Colors.white70 : Colors.grey[700],
                    fontSize: 12,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCalendarGrid(Map availabilityData, bool isMe) {
    final daysInMonth = availabilityData['daysInMonth'] as int;
    final startingWeekday = availabilityData['startingWeekday'] as int;
    final availability =
        availabilityData['availability'] as Map;

    final totalCells = ((daysInMonth + startingWeekday - 1) / 7).ceil() * 7;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 1,
      ),
      itemCount: totalCells,
      itemBuilder: (context, index) {
        final dayNumber = index - startingWeekday + 2;

        if (dayNumber <= 0 || dayNumber > daysInMonth) {
          return const SizedBox();
        }

        final dayKey = dayNumber.toString();
        final dayAvailability = availability[dayKey] ?? 'unavailable';

        Color cellColor;
        switch (dayAvailability) {
          case 'available':
            cellColor = Colors.green;
            break;
          case 'partial':
            cellColor = Colors.orange;
            break;
          case 'busy':
            cellColor = Colors.red;
            break;
          default:
            cellColor = isMe
                ? Colors.white.withOpacity(0.2)
                : Colors.grey[300]!;
        }

        return Container(
          margin: const EdgeInsets.all(1),
          decoration: BoxDecoration(
            color: cellColor,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Center(
            child: Text(
              dayNumber.toString(),
              style: TextStyle(
                color: dayAvailability == 'unavailable'
                    ? (isMe ? Colors.white54 : Colors.grey[600])
                    : Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLegendItem(String label, Color color, bool isMe) {
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
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            color: isMe ? Colors.white70 : Colors.grey[700],
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  Widget _buildWidget() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: _showAttachmentOptions,
            icon: const Icon(
              Icons.add_circle_outline,
              color: Color(0xFF1E40AF),
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      focusNode: _focusNode,
                      decoration: const InputDecoration(
                        hintText: 'Type a message...',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      maxLines: null,
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      // TODO: Attach image functionality
                    },
                    icon: const Icon(Icons.camera_alt, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFF1E40AF),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: _sendMessage,
              icon: const Icon(Icons.send, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }



  bool _shouldShow/* Timestamp removed */(DateTime current, DateTime previous) {
    return current.difference(previous).inMinutes > 5;
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(
      timestamp.year,
      timestamp.month,
      timestamp.day,
    );

    if (messageDate == today) {
      // Today - show time only
      return '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
    } else if (messageDate == today.subtract(const Duration(days: 1))) {
      // Yesterday
      return 'Yesterday ${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
    } else {
      // Older - show date
      return '${timestamp.month}/${timestamp.day} ${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
    }
  }

  void _viewCustomerProfile() {
    // Show /* payment_logic */ basic info in a modal instead of full profile
    // Get /* payment_logic */ ID from conversation
    /* FirebaseFirestore removed *//* .instance removed */
        // Database operation removed
        // Database operation removed
        /* .get removed */()
        .then((doc) {
      if (!doc.exists) {
        _showError('Conversation not found');
        return;
      }

      final data = doc.data() as Map;
      final participants = List<String>.from(data['participants'] ?? []);
      final currentUserId = /* FirebaseAuth removed *//* .instance removed */.currentUser?.uid;
      
      // Find the /* payment_logic */ (the participant who is not the current user)
      final customerId = participants.firstWhere(
        (id) => id != currentUserId && id.isNotEmpty,
        orElse: () => '',
      );
      
      if (customerId.isEmpty) {
        _showError('Could not identify /* payment_logic */ in conversation');
        return;
      }

      // Fetch /* payment_logic */ data from users collection
      /* FirebaseFirestore removed *//* .instance removed */
          // Database operation removed
          // Database operation removed
          /* .get removed */()
          .then((userDoc) {
        if (!userDoc.exists) {
          _showError('/* payment_logic */ profile not found');
          return;
        }

        if (!mounted) return;

        final data = userDoc.data() as Map;
        data['uid'] = customerId;
        _showCustomerInfoModal(data);
      }).catchError((e) {
        _showError('Failed to load /* payment_logic */ information');
      });
    }).catchError((e) {
      _showError('Failed to load conversation');
    });
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showCustomerInfoModal(Map data) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            // Header
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  const Text(
                    'Client Information',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.navigate(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            
            const Divider(height: 1),
            
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Picture and Name
                    Center(
                      child: Column(
                        children: [
                          UserProfileAvatar(
                            photoURL: data['photoURL'] ?? 
                                      data['profileImageUrl'] ?? 
                                      data['profilePicture'] ?? 
                                      data['avatar'],
                            firstName: data['firstName'],
                            lastName: data['lastName'],
                            fullName: data['displayName'],
                            userRole: '/* payment_logic */', // Client is always a /* payment_logic */
                            radius: 50,
                            backgroundColor: const Color(0xFF1E40AF),
                            textColor: Colors.white,
                            fontSize: 32,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            '${data['firstName'] ?? ''} ${data['lastName'] ?? ''}',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E40AF).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'Client',
                              style: TextStyle(
                                color: Color(0xFF1E40AF),
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Contact Information Section
                    const Text(
                      'Contact Information',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    _buildInfoRow(
                      icon: Icons.email_outlined,
                      label: 'Email',
                      value: data['email'] ?? 'Not provided',
                    ),
                    
                    if (data['phoneNumber'] != null && data['phoneNumber'].toString().isNotEmpty)
                      _buildInfoRow(
                        icon: Icons.phone_outlined,
                        label: 'Phone',
                        value: data['phoneNumber'],
                      ),
                    
                    if (_extractAddressString(data['address']) != null && _extractAddressString(data['address'])!.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      const Text(
                        'Location',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildInfoRow(
                        icon: Icons.location_on_outlined,
                        label: 'Data',
                        value: _extractAddressString(data['address'])!,
                      ),
                    ],
                    
                    const SizedBox(height: 24),
                    
                    // Member Since
                    const Text(
                      'Account Information',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    _buildInfoRow(
                      icon: Icons.calendar_today_outlined,
                      label: 'Member Since',
                      value: data['createdAt'] != null
                          ? _formatMemberSince(data['createdAt'])
                          : 'Recently joined',
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Note
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.blue[200]!),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Colors.blue[700],
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'This is the basic information about your client. For privacy reasons, detailed profile information is only visible to the client.',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.blue[900],
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to extract address string from various formats
  String? _extractAddressString(dynamic address) {
    if (address == null) return null;
    
    // If it's already a string, return it
    if (address is String) {
      return address.isNotEmpty ? address : null;
    }
    
    // If it's a Map, format it nicely
    if (address is Map) {
      return _formatAddressFromMap(address);
    }
    
    return null;
  }

  // Helper method to format address from Map structure
  String? _formatAddressFromMap(Map<dynamic, dynamic> addressMap) {
    try {
      List<String> addressParts = [];
      
      // Extract address components in a logical order
      if (addressMap.containsKey('streetAddress')) {
        final street = addressMap['streetAddress']?.toString();
        if (street != null && street.isNotEmpty) {
          addressParts.add(street);
        }
      }
      
      if (addressMap.containsKey('barangay')) {
        final barangay = addressMap['barangay']?.toString();
        if (barangay != null && barangay.isNotEmpty) {
          addressParts.add(barangay);
        }
      }
      
      if (addressMap.containsKey('city')) {
        final city = addressMap['city']?.toString();
        if (city != null && city.isNotEmpty) {
          addressParts.add(city);
        }
      }
      
      if (addressMap.containsKey('province')) {
        final province = addressMap['province']?.toString();
        if (province != null && province.isNotEmpty) {
          addressParts.add(province);
        }
      }
      
      if (addressMap.containsKey('country')) {
        final country = addressMap['country']?.toString();
        if (country != null && country.isNotEmpty) {
          addressParts.add(country);
        }
      }
      
      // Try fallback keys if primary keys don't exist
      if (addressParts.isEmpty) {
        if (addressMap.containsKey('address')) {
          return addressMap['address']?.toString();
        }
        if (addressMap.containsKey('description')) {
          return addressMap['description']?.toString();
        }
        if (addressMap.containsKey('formatted_address')) {
          return addressMap['formatted_address']?.toString();
        }
      }
      
      // Join the parts with commas
      return addressParts.isNotEmpty ? addressParts.join(', ') : null;
    } catch (e) {
      return null;
    }
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 20, color: const Color(0xFF1E40AF)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatMemberSince(dynamic timestamp) {
    try {
      DateTime date;
      if (timestamp is /* Timestamp removed */) {
        date = timestamp.toDate();
      } else if (timestamp is DateTime) {
        date = timestamp;
      } else {
        return 'Recently joined';
      }
      
      final months = [
        'January', 'February', 'March', 'April', 'May', 'June',
        'July', 'August', 'September', 'October', 'November', 'December'
      ];
      
      return '${months[date.month - 1]} ${date.year}';
    } catch (e) {
      return 'Recently joined';
    }
  }

  void _showDeleteConversationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Conversation'),
          content: Text(
            'Are you sure you want to delete this conversation with ${widget.clientName}? This action cannot be undone.',
          ),
          actions: [
            Button(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            Button(
              onPressed: () => _deleteConversation(),
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteConversation() async  {
    // Implementation removed
  }
  }
}
