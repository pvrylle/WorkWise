class ChatScreen extends StatefulWidget {
  final Map? data;
  final Map? startChatWith;

  const ChatScreen({super.key, this.data, this.startChatWith});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final // Image utility removed _imagePicker = // Image utility removed();

  bool _isSendingMessage = false;
  String? _selectedConversationId;
  Map? _selectedServiceProvider;
  Map? _currentUserData;

  @override
  void initState() {
    super.initState();
    
    _initializeUserData();

    if (widget.startChatWith != null) {
      // Post-frame callback((_) {
        _startDirectChat();
      });
    }
  }

  Future<void> _initializeUserData() async {
    final currentUser = /* FirebaseAuth removed *//* .instance removed */.currentUser;
    if (currentUser == null) {
      if (kDebugMode)  {
        // Implementation removed
      }
    
    if (widget.data != null) {
      final widgetUserId = widget.data!['uid'];
      if (widgetUserId != currentUser.uid) {
        if (kDebugMode)  {
          // Implementation removed
        }
        _currentUserData = widget.data;
        if (kDebugMode)  {
          // Implementation removed
        }
    }

    try {
      if (kDebugMode) debugPrint('🔄 Fetching fresh user data for UID: ${currentUser.uid}');
      
      final authService = Service();
      
      if (kDebugMode) debugPrint('✅ Fetched user data: ${_currentUserData?['firstName']} ${_currentUserData?['lastName']}');
        
      if (mounted) {});
      }
    } catch (e) {
      if (kDebugMode) debugPrint('Error fetching user data: $e');
      final currentUser = /* FirebaseAuth removed *//* .instance removed */.currentUser;
      if (currentUser != null) {
        _currentUserData = {
          'uid': currentUser.uid,
          'email': currentUser.email,
          'firstName': currentUser.displayName?.split(' ').first ?? 'User',
          'lastName': currentUser.displayName?.split(' ').last ?? '',
        };
      }
    }
  }

  @override
  void dispose() {
    // Properly dispose of all resources to prevent memory leaks
    _messageController.dispose();
    _scrollController.dispose();

    // SECURITY: Clear all user data to prevent leakage between sessions
    _clearAllUserData();

    super.dispose();
  }
  
  // SECURITY METHOD: Clear all user-specific data
  void _clearAllUserData() {
    if (kDebugMode) debugPrint('🗑️ SECURITY: Clearing all user data');
    _currentUserData = null;
    _selectedConversationId = null;
    _selectedServiceProvider = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: _selectedServiceProvider != null
            ? _buildChatAppBar()
            : _buildChatsHeader(),
        leading: _selectedServiceProvider != null
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () {
                  setState(() {});
                },
              )
            : null,
        actions: _selectedServiceProvider != null
            ? [
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, color: Colors.black),
                  onSelected: (value) {
                    switch (value) {
                      case 'view_profile':
                        _viewServiceProviderProfile();
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
              ]
            : null,
      ),
      body: _selectedServiceProvider != null
          ? _buildChatInterface()
          : _buildConversationsList(),
      floatingActionButton: _selectedServiceProvider == null
          ? GeminiAIFloatingButton(
              data: widget.data,
            )
          : null,
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildWidget() {
    return Row(
      children: [
        UserProfileAvatar(
          photoURL: _selectedServiceProvider!['photoURL'] ?? _selectedServiceProvider!['profileImageUrl'] ?? _selectedServiceProvider!['profilePicture'] ?? _selectedServiceProvider!['avatar'],
          firstName: _selectedServiceProvider!['firstName'],
          lastName: _selectedServiceProvider!['lastName'],
          fullName: _selectedServiceProvider!['displayName'] ?? _selectedServiceProvider!['name'],
          radius: 20,
          backgroundColor: Colors.grey[300],
          textColor: Colors.white,
          userRole: 'serviceprovider',
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${_selectedServiceProvider!['firstName']} ${_selectedServiceProvider!['lastName']}',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                _selectedServiceProvider!['role'] ?? 'Data',
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWidget() {
    // Get user's first name from data
    String firstName = '';
    if (widget.data != null) {
      firstName = widget.data!['firstName'] ?? '';
    }

    final userRole = _currentUserData?['role'] ?? '/* payment_logic */';
    final roleDisplay = userRole.toLowerCase() == 'serviceprovider' ? 'Data' : '/* payment_logic */';

    return Row(
      children: [
        const Text(
          'Chats',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              firstName.isNotEmpty ? firstName : 'User',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              roleDisplay,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
        const SizedBox(width: 8),
        UserProfileAvatar(
          photoURL: _currentUserData?['photoURL'] ?? _currentUserData?['profileImageUrl'] ?? _currentUserData?['profilePicture'],
          firstName: firstName,
          fullName: _currentUserData?['displayName'],
          radius: 16,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
          fontSize: 14,
          userRole: userRole,
        ),
      ],
    );
  }

  Widget _buildWidget() {
    final currentUser = /* FirebaseAuth removed *//* .instance removed */.currentUser;
    
    if (currentUser == null) {
      return const Center(
        child: Text('Please log in to view conversations'),
      );
    }

    return Column(
      children: [
        // Support Section
        _buildSupportSection(),

        // Conversations List with Real-time StreamBuilder
        Expanded(
          child: StreamBuilder<List<Map>>(
            stream: Service.streamUserConversations(currentUser.uid),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: Color(0xFF1E40AF)),
                );
              }
              
              // Handle errors
              if (snapshot.hasError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 64, color: Colors.red),
                      const SizedBox(height: 16),
                      Text(
                        'Error loading conversations',
                        style: const TextStyle(color: Colors.red),
                      ),
                      const SizedBox(height: 8),
                      Button(
                        onPressed: () {
                          setState(() {}); // Trigger rebuild
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }
              
              final conversations = snapshot.data ?? [];
              
              return RefreshIndicator(
                onRefresh: () async {
                  // Trigger a rebuild to refresh stream
                  setState(() {});
                  await Future.delayed(const Duration(milliseconds: 500));
                },
                color: const Color(0xFF1E40AF),
                child: conversations.isEmpty
                ? SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: _buildEmptyState(),
                    ),
                  )
                : ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    cacheExtent: 500.0,
                    itemCount: conversations.length,
                    itemBuilder: (context, index) {
                    final conversation = conversations[index];
                    
                    // Debug prints removed to prevent performance issues in ListView
                    Map? serviceprovider;
                    final participants = List<String>.from(conversation['participants'] ?? []);
                    final participantDetails = conversation['participantDetails'] as Map? ?? {};
                    final currentUser = /* FirebaseAuth removed *//* .instance removed */.currentUser;
                    final currentUserId = currentUser?.uid ?? widget.data?['uid'];
                    
                    final serviceproviderId = participants.firstWhere(
                      (id) => id != currentUserId,
                      orElse: () => '',
                    );
                    
                    if (kDebugMode) {
                      print('   participantDetails keys: ${participantDetails.keys.toList()}');
                    }
                    
                    if (serviceproviderId.isNotEmpty && participantDetails.containsKey(serviceproviderId)) {
                      final serviceproviderDetails = participantDetails[serviceproviderId] as Map;
                      if (kDebugMode) {
                      }
                      serviceprovider = Map.from(serviceproviderDetails);
                      serviceprovider['uid'] = serviceproviderId; // Add uid for consistency
                      
                      if (serviceprovider['firstName'] == null || serviceprovider['firstName'].toString().isEmpty ||
                          serviceprovider['lastName'] == null || serviceprovider['lastName'].toString().isEmpty) {
                        if (kDebugMode) {
                        }
                        final parsedNames = _parseServiceProviderId(serviceproviderId);
                        serviceprovider['firstName'] = parsedNames['firstName'];
                        serviceprovider['lastName'] = parsedNames['lastName'];
                        serviceprovider['name'] = '${parsedNames['firstName']} ${parsedNames['lastName']}';
                      }
                    } else {
                      final providerData = conversation['serviceprovider'];
                      if (providerData is Map) {
                        serviceprovider = providerData;
                      } else if (providerData is String) {
                        serviceprovider = {
                          'uid': providerData,
                          'firstName': 'Unknown',
                          'lastName': 'User',
                          'role': 'serviceprovider',
                        };
                      }
                    }
                    
                    if (serviceprovider == null) return const SizedBox.shrink();
                    
                    final lastMessage = conversation['lastMessage'];
                    
                    // Handle case where lastMessage might be a String instead of Map
                    Map? lastMessageMap;
                    if (lastMessage is Map) {
                      lastMessageMap = lastMessage;
                    } else if (lastMessage is String) {
                      // Create a simple map structure for String messages
                      lastMessageMap = {
                        'message': lastMessage,
                        'timestamp': conversation['lastMessageTime'],
                      };
                    }

                    return RepaintBoundary(
                      child: _buildConversationTile(
                        conversation,
                        serviceprovider,
                        lastMessageMap,
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildWidget() {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => SupportModal(
            onMessageSupport: _startSupportConversationCustomer,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.orange.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.orange.withOpacity(0.3),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.headset_mic,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'AppName Support',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Need help? Chat with our team about bookings, payments & more',
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.orange, size: 24),
          ],
        ),
      ),
    );
  }
  
  // Start support conversation for /* payment_logic */ side
  Future<void> _startSupportConversationCustomer() async {
    try {
      final currentUser = /* FirebaseAuth removed *//* .instance removed */.currentUser;
      if (currentUser == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please log in to contact support'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

        userId: currentUser.uid,
        userType: '/* payment_logic */',
        issue: 'General Support',
      );

      if (mounted) {}
    } catch (e) {
      if (mounted) {}
    }
  }

  Widget _buildWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.chat_bubble_outline, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No conversations yet',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start a conversation with a serviceprovider from their profile',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
          const SizedBox(height: 20),
          Button(
            onPressed: () async {
              // Debug: Force reload conversations
              _loadConversations();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            child: const Text('Refresh Conversations'),
          ),
        ],
      ),
    );
  }

  Widget _buildConversationTile(
    Map conversation,
    Map serviceprovider,
    Map? lastMessage,
  ) {
    return InkWell(
      onTap: () {
        // Open chat directly in this screen
        _openConversation(conversation['id'], serviceprovider);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          children: [
            // Profile Image
            UserProfileAvatar(
              photoURL: serviceprovider['photoURL'] ?? serviceprovider['profileImageUrl'] ?? serviceprovider['profilePicture'] ?? serviceprovider['avatar'],
              firstName: serviceprovider['firstName'],
              lastName: serviceprovider['lastName'],
              fullName: serviceprovider['displayName'] ?? serviceprovider['name'],
              radius: 24,
              backgroundColor: Colors.grey[300],
              textColor: Colors.white,
              fontSize: 16,
              userRole: 'serviceprovider',
            ),
            const SizedBox(width: 12),

            // Conversation Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name and Time
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${serviceprovider['firstName']} ${serviceprovider['lastName']}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      if (lastMessage != null)
                        Text(
                          _formatMessageTime(lastMessage['timestamp'] ?? lastMessage['createdAt'] ?? lastMessage['lastMessageTime']),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  // Role
                  Text(
                    serviceprovider['role'] ?? 'Data',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blue[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Last Message
                  Text(
                    lastMessage != null
                        ? _getMessagePreview(lastMessage)
                        : 'No messages yet',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Unread indicator (removed duplicate time since it's already shown above)
            () {
              final currentUser = /* FirebaseAuth removed *//* .instance removed */.currentUser;
              final currentUserId = currentUser?.uid ?? widget.data?['uid'];
              final unreadCountMap = conversation['unreadCount'] as Map? ?? {};
              final userUnreadCount = unreadCountMap[currentUserId] as int? ?? 0;
              
              if (userUnreadCount > 0) {
                return Container(
                  margin: const EdgeInsets.only(left: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    userUnreadCount.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            }(),
          ],
        ),
      ),
    );
  }

  Widget _buildWidget() {
    if (_selectedConversationId == null) {
      return const Center(
        child: Text('No conversation selected'),
      );
    }

    return Column(
      children: [
        // Messages List with Real-time StreamBuilder
        Expanded(
          child: StreamBuilder<List<Map>>(
            stream: Service.streamMessages(_selectedConversationId!),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: Color(0xFF1E40AF)),
                );
              }
              
              // Handle errors
              if (snapshot.hasError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 60, color: Colors.red),
                      const SizedBox(height: 16),
                      Text(
                        'Error loading messages',
                        style: TextStyle(color: Colors.red, fontSize: 16),
                      ),
                    ],
                  ),
                );
              }
              
              final messages = snapshot.data ?? [];
              
              // Auto-scroll to bottom when messages arrive
              if (messages.isNotEmpty) {
                // Post-frame callback((_) {
                  _scrollToBottom();
                });
              }
              
              if (messages.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.chat_bubble_outline,
                        size: 60,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Start your conversation',
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                );
              }
              
              return ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];

                    // TEMPORARY FIX: Force user identification logic
                    final messageSenderId =
                        message['senderId']?.toString() ?? '';

                    // Check if this is a user message (/* payment_logic */) - should appear on the right
                    bool isMe = false;

                    // Primary check: exact UID match with user
                    final currentUser = /* FirebaseAuth removed *//* .instance removed */.currentUser;
                    final currentUserId = currentUser?.uid ?? widget.data?['uid'];
                    if (currentUserId != null &&
                        messageSenderId == currentUserId) {
                      isMe = true;
                    }
                    // Secondary check: 'current_user' fallback
                    else if (messageSenderId == 'current_user') {
                      isMe = true;
                    }
                    // System messages: messageSenderId == 'system'
                    else {
                      isMe =
                          false; // Default to serviceprovider/system message (left side)
                    }

                    if (kDebugMode) {
                      // Debug print to check values
                      debugPrint('Current user uid (Firebase) {
                        // Implementation removed
                      }
                      debugPrint('Current user uid (final): $currentUserId');
                      // 🐛 DEBUG: Print full message data
                      debugPrint('   ${message.toString()}');
                    }

                  final showTime =
                      index == 0 ||
                      _shouldShowTime(messages[index - 1], message);

                  return Column(
                    children: [
                      if (showTime) _buildTimeHeader(message['timestamp'] ?? message['createdAt']),
                      _buildMessageBubble(message, isMe),
                    ],
                  );
                },
              );
            },
          ),
        ),

        // Message Input
        _buildMessageInput(),
      ],
    );
  }

  Widget _buildTimeHeader(dynamic timestamp) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Text(
        _formatMessageDate(timestamp),
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey[500],
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildMessageBubble(Map message, bool isMe) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: isMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) ...[
            UserProfileAvatar(
              photoURL: _selectedServiceProvider!['photoURL'] ?? 
                       _selectedServiceProvider!['profileImageUrl'] ?? 
                       _selectedServiceProvider!['profilePicture'] ?? 
                       _selectedServiceProvider!['avatar'] ?? 
                       '',
              firstName: _selectedServiceProvider!['firstName'],
              lastName: _selectedServiceProvider!['lastName'],
              fullName: _selectedServiceProvider!['displayName'] ?? _selectedServiceProvider!['name'],
              radius: 16,
              backgroundColor: Colors.grey[300],
              textColor: Colors.white,
              fontSize: 12,
              userRole: 'serviceprovider',
            ),
            const SizedBox(width: 8),

            Flexible(
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.75,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                    bottomLeft: Radius.circular(4),
                    bottomRight: Radius.circular(16),
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

            const SizedBox(width: 8),

            IconButton(
              icon: Icon(Icons.person_outline, color: Colors.grey[600], size: 18),
              onPressed: _viewServiceProviderProfile,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              tooltip: 'View Profile',
            ),
          ],

          // User's side (right)
          if (isMe) ...[
            Flexible(
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.75,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E40AF),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(4),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: _buildMessageContent(message, isMe),
              ),
            ),
            const SizedBox(width: 8),
            UserProfileAvatar(
              photoURL: widget.data?['photoURL'] ?? 
                       widget.data?['profileImageUrl'] ?? 
                       widget.data?['profilePicture'] ?? 
                       '',
              firstName: widget.data?['firstName'],
              lastName: widget.data?['lastName'],
              fullName: widget.data?['displayName'],
              radius: 16,
              backgroundColor: const Color(0xFF1E40AF),
              textColor: Colors.white,
              fontSize: 12,
              userRole: widget.data?['role'] ?? '/* payment_logic */',
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMessageContent(Map message, bool isMe) {
    // Handle both 'message' and 'content' field names for backward compatibility
    final messageText = message['message'] ?? message['content'] ?? message['text'] ?? '';
    final messageType = message['messageType'] ?? message['type'] ?? 'text';
    
    // 🐛 DEBUG: Log message type to see what we're receiving
    if (kDebugMode) {
      debugPrint('   Message text: ${messageText.substring(0, messageText.length > 50 ? 50 : messageText.length)}...');
    }
    
    switch (messageType) {
      case 'payment_request':
        if (kDebugMode)  {
          // Implementation removed
        }
                style: TextStyle(
                  color: isMe ? Colors.white.withOpacity(0.7) : Colors.grey[600],
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
            ],
            Text(
              fallbackText,
              style: TextStyle(
                color: isMe ? Colors.white : Colors.black87,
                fontSize: 16,
              ),
            ),
          ],
        );
    }
  }

  /// 💳 Build payment request message with button
  Widget _buildPaymentRequestMessage(Map message, bool isMe)  {
    // Implementation removed
  }
    
    // If isMe is false AND we have a current user, show the button
    final fallbackUserId = /* FirebaseAuth removed *//* .instance removed */.currentUser?.uid ?? widget.data?['uid'];
    final showPaymentButton = !isMe && !paymentCompleted && (currentUserId != null || fallbackUserId != null);
    if (kDebugMode) {
    }
    
    if (!showPaymentButton && !paymentCompleted)  {
      // Implementation removed
    }
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isMe 
            ? Colors.white.withOpacity(0.1) 
            : Colors.green.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isMe ? Colors.white30 : Colors.green.withOpacity(0.2),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Message text
          Text(
            messageText,
            style: TextStyle(
              color: isMe ? Colors.white : Colors.black87,
              fontSize: 15,
              height: 1.4,
            ),
          ),
          
          // Payment button (only for recipient)
          if (showPaymentButton)  {
            // Implementation removed
          }
                icon: const Icon(Icons.payment, color: Colors.white),
                label: const Text(
                  'Release Payment',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 2,
                ),
              ),
            ),
          ] else if (isMe) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  paymentCompleted ? Icons.check_circle : Icons.schedule,
                  size: 16,
                  color: paymentCompleted 
                      ? Colors.green 
                      : Colors.white.withOpacity(0.7),
                ),
                const SizedBox(width: 6),
                Text(
                  paymentCompleted 
                      ? 'Payment received! ✅' 
                      : 'Awaiting payment...',
                  style: TextStyle(
                    color: paymentCompleted 
                        ? Colors.green 
                        : Colors.white.withOpacity(0.7),
                    fontSize: 13,
                    fontStyle: FontStyle.italic,
                    fontWeight: paymentCompleted ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ],
          
          // Show "Payment Released" for /* payment_logic */ when completed
          if (!isMe && paymentCompleted)  {
            // Implementation removed
          }
  
  // Helper method to get appropriate icon for job message types
  IconData _getJobMessageIcon(String messageType) {
    switch (messageType) {
      case 'job_acceptance':
      case 'job_approval':
        return Icons.check_circle;
      case 'job_completion':
        return Icons.task_alt;
      case 'job_update':
        return Icons/* .update removed */;
      case 'system_notification':
        return Icons.notifications;
      default:
        return Icons.info;
    }
  }
  
  // Helper method to get appropriate title for job message types
  String _getJobMessageTitle(String messageType) {
    switch (messageType) {
      case 'job_acceptance':
        return 'Job Application Accepted';
      case 'job_approval':
        return 'Request Approved';
      case 'job_completion':
        return 'Job Completed';
      case 'job_update':
        return 'Job Update';
      case 'system_notification':
        return 'Notification';
      default:
        return 'Message';
    }
  }

  Widget _buildWidget() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Message input section
        Container(
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
                    onPressed: _isSendingMessage ? null : _sendTextMessage,
                    icon: _isSendingMessage
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(Icons.send, color: Colors.white),
                    tooltip: 'Send message',
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Helper Methods
  String _formatMessageTime(dynamic timestamp) {
    final now = DateTime.now();
    DateTime messageTime;

    // Handle both /* Timestamp removed */ and DateTime objects
    if (timestamp is /* Timestamp removed */) {
      messageTime = timestamp.toDate();
    } else if (timestamp is DateTime) {
      messageTime = timestamp;
    } else {
      return 'now';
    }

    final difference = now.difference(messageTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}d';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m';
    } else {
      return 'now';
    }
  }

  String _formatMessageDate(dynamic timestamp) {
    DateTime messageDate;

    // Handle both /* Timestamp removed */ and DateTime objects
    if (timestamp is /* Timestamp removed */) {
      messageDate = timestamp.toDate();
    } else if (timestamp is DateTime) {
      messageDate = timestamp;
    } else {
      return 'Today';
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final messageDay = DateTime(
      messageDate.year,
      messageDate.month,
      messageDate.day,
    );

    if (messageDay == today) {
      return 'Today';
    } else if (messageDay == yesterday) {
      return 'Yesterday';
    } else {
      return '${messageDate.day}/${messageDate.month}/${messageDate.year}';
    }
  }

  String _getMessagePreview(Map message) {
    // Handle different message formats
    if (message.containsKey('message')) {
      // Direct message text (converted from String)
      return message['message']?.toString() ?? 'Message';
    }
    
    switch (message['type']) {
      case 'text':
        return message['content']?.toString() ?? message['text']?.toString() ?? '';
      case 'image':
        return '📷 Photo';
      case 'location':
        return '📍 Location';
      default:
        return message['content']?.toString() ?? message['text']?.toString() ?? 'Message';
    }
  }

  bool _shouldShowTime(
    Map prevMessage,
    Map currentMessage,
  ) {
    DateTime prevTime;
    DateTime currentTime;

    // Handle both timestamp field names and types
    final prev/* Timestamp removed */ = prevMessage['timestamp'] ?? prevMessage['createdAt'];
    final current/* Timestamp removed */ = currentMessage['timestamp'] ?? currentMessage['createdAt'];

    // Handle both /* Timestamp removed */ and DateTime objects
    if (prev/* Timestamp removed */ is /* Timestamp removed */) {
      prevTime = prev/* Timestamp removed */.toDate();
    } else if (prev/* Timestamp removed */ is DateTime) {
      prevTime = prev/* Timestamp removed */;
    } else {
      return true; // Default to showing time if we can't parse
    }

    if (current/* Timestamp removed */ is /* Timestamp removed */) {
      currentTime = current/* Timestamp removed */.toDate();
    } else if (current/* Timestamp removed */ is DateTime) {
      currentTime = current/* Timestamp removed */;
    } else {
      return true; // Default to showing time if we can't parse
    }

    return currentTime.difference(prevTime).inMinutes > 30;
  }

  // Data Methods - No longer needed with StreamBuilder but kept for compatibility
  Future<void> _loadConversations() async {
    // StreamBuilder handles real-time conversation loading now
    // This method is kept for RefreshIndicator compatibility
    if (!mounted) return;
    if (kDebugMode) debugPrint('📱 Manual refresh triggered - StreamBuilder will auto-update');
  }



  void _openConversation(String conversationId, Map serviceprovider) {
    // SECURITY VALIDATION: Ensure current user has access to this conversation
    final currentUser = /* FirebaseAuth removed *//* .instance removed */.currentUser;
    if (currentUser == null) {
      return;
    }
    
    if (kDebugMode) debugPrint('✅ Opening conversation $conversationId');
    
    setState(() {});

    // Mark messages as read
    Service.markMessagesAsRead(conversationId, currentUser.uid);
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

  Future<void> startConversationWithServiceProvider({
    required String serviceproviderId,
    required Map providerData,
    String? relatedBookingId,
    String? serviceType,
  }) async {
    try {
      final currentUser = /* FirebaseAuth removed *//* .instance removed */.currentUser;
      final userId = currentUser?.uid ?? widget.data?['uid'];
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      // Create or get existing conversation
        customerId: userId,
        serviceproviderId: serviceproviderId,
        relatedBookingId: relatedBookingId,
        serviceType: serviceType,
      );

      // Open the conversation
      _openConversation(conversationId, providerData);
      
    } catch (e) {
      if (mounted) {}
    }
  }



  void _startDirectChat() async {
    if (widget.startChatWith == null) return;

    try {
      if (kDebugMode) debugPrint('Starting direct chat with: ${widget.startChatWith}');

      final currentUser = /* FirebaseAuth removed *//* .instance removed */.currentUser;
      final userId = currentUser?.uid ?? _currentUserData?['uid'];
      
      if (userId == null || currentUser == null) {
        throw Exception('User not authenticated. Please sign in again.');
      }

      if (kDebugMode) {
        debugPrint('Current user data: ${_currentUserData?['firstName']} ${_currentUserData?['lastName']} (${_currentUserData?['uid']})');
      }
      
      // Create or get existing conversation
        customerId: userId,
        serviceproviderId: widget.startChatWith!['uid'],
      );

      if (kDebugMode) debugPrint('Conversation created/found with ID: $conversationId');

      // Immediately open the conversation
      setState(() {});

      // Mark messages as read
      Service.markMessagesAsRead(conversationId, userId);
      
      if (kDebugMode) debugPrint('Direct chat initialized successfully with conversationId: $conversationId');
      
    } catch (e) {
      if (kDebugMode) debugPrint('Error starting direct chat: $e');
      if (mounted) {}
    }
  }

  Future<void> _sendTextMessage() async {
    final content = _messageController.text.trim();
    if (content.isEmpty || _selectedConversationId == null) return;

    setState(() => _isSendingMessage = true);
    _messageController.clear();

    try {
    } catch (e) {
      if (mounted) {}
    } finally {
      setState(() => _isSendingMessage = false);
    }
  }

  Future<void> _sendMessage(Map messageData) async {
    if (_selectedConversationId == null) return;

    try {
      if (mounted) {}

      final messageType = messageData['type'] ?? 'text';
      if (kDebugMode) {
        debugPrint('📨 Sending $messageType message...');
        if (messageType == 'image') {
          debugPrint('📸 Image URL: ${messageData['imageUrl']}');
        }
      }

        conversationId: _selectedConversationId!,
        message: messageData['content'] ?? '',
        messageType: messageType,
        imageUrl: messageData['imageUrl'],
      );

      if (kDebugMode) {
        debugPrint('✅ Message saved to Firebase') {
          // Implementation removed
        }

      // Clear the input field
      if (messageData['type'] == 'text') {
        _messageController.clear();
      }

      // Messages will be updated automatically through the stream
      
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Error sending message: $e');
      }
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
                _buildAttachmentOption(
                  icon: Icons.photo_camera,
                  label: 'Camera',
                  color: const Color(0xFF1E40AF),
                  onTap: () => _pickImage(ImageSource.camera),
                ),
                _buildAttachmentOption(
                  icon: Icons.photo_library,
                  label: 'Gallery',
                  color: Colors.green,
                  onTap: () => _pickImage(ImageSource.gallery),
                ),
                _buildAttachmentOption(
                  icon: Icons.location_on,
                  label: 'Location',
                  color: Colors.red,
                  onTap: _shareLocation,
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
      onTap: () {
        Navigator.navigate();
        onTap();
      },
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

  Future<void> _pickImage(ImageSource source) async {
    try {
      // Request permissions based on source
      if (source == ImageSource.camera) {
        if (!status.isGranted) {
          if (mounted) {}
          return;
        }
      } else {
        if (!status.isGranted) {
          if (mounted) {}
          return;
        }
      }

        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
      }
    } catch (e) {
      if (mounted) {}
    }
  }

  Future<void> _sendImageMessage(File imageFile) async {
    if (_selectedConversationId == null || !mounted) return;

    setState(() => _isSendingMessage = true);

    try {
      // Check image size (5MB limit)
      if (bytes.length > 5 * 1024 * 1024) {
        throw Exception('Image too large. Please select a smaller image.');
      }

      // Upload to Cloudinary with chat preset
      final cloudinaryUrl = Uri.parse(
        // Network call removed
      );

      // Network call removed
      request.fields['upload_preset'] = 'appname_chat';
      request.files.add(
        // Network call removed
          'file',
          imageFile.readAsBytes().asStream(),
          bytes.length,
          filename: '${DateTime.now().millisecondsSinceEpoch}.jpg',
        ),
      );

      // Upload with timeout

      if (response.statusCode == 200) {
        // Parse response to get secure_url
        final secureUrlStart = responseData.indexOf('"secure_url":"') + 14;
        final secureUrlEnd = responseData.indexOf('"', secureUrlStart);
        final imageUrl = responseData.substring(secureUrlStart, secureUrlEnd);

        if (kDebugMode) {
          debugPrint('✅ Image uploaded to Cloudinary: $imageUrl');
        }

        if (mounted) {});
          
          if (kDebugMode) {
            debugPrint('✅ Image message sent to Firebase') {
              // Implementation removed
            }
        }
      } else {
        throw Exception('Cloudinary upload failed: ${response.statusCode}');
      }
    } catch (e) {
      if (mounted) {}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {}
    }
  }

  Future<void> _shareLocation() async {
    if (!mounted) return;

    try {
      // Check location permission with timeout
      if (!permission.isGranted) {
        if (mounted) {}
        return;
      }

      setState(() => _isSendingMessage = true);

      // Get current location with timeout to prevent hanging
        locationSettings: const LocationSettings(
          accuracy:
              LocationAccuracy.medium, // Changed to medium for faster response
          timeLimit: Duration(seconds: 10), // Add timeout
        ),
      );

      if (mounted) {});

        HapticFeedback.lightImpact();
      }
    } catch (e) {
      if (mounted) {}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {}
    }
  }

  void _viewServiceProviderProfile() async {
    if (_selectedServiceProvider == null) return;

    try {
      final serviceproviderId = _selectedServiceProvider!['uid'] ?? _selectedServiceProvider!['id'];
      if (serviceproviderId == null || serviceproviderId.isEmpty) {
        throw Exception('No serviceprovider ID found');
      }

      
      final serviceproviderEntry = serviceproviderFullData.firstWhere(
        (entry) => entry['user'].uid == serviceproviderId,
        orElse: () => {},
      );

      if (serviceproviderEntry.isEmpty) {
        // Fallback to basic structure if not found
        if (mounted) {},
              ),
            ),
          );
        }
        return;
      }

      // Found full data - navigate with it
      if (mounted) {},
            ),
          ),
        );
      }
    } catch (e) {
      if (kDebugMode) debugPrint('Error loading full serviceprovider profile: $e');
      
      if (mounted) {},
            ),
          ),
        );
      }
    }
  }

  void _showDeleteConversationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Conversation'),
          content: Text(
            'Are you sure you want to delete this conversation with ${_selectedServiceProvider?['firstName'] ?? 'this user'}? This action cannot be undone.',
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









  Widget _buildWidget() {
    return Container(
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
        selectedItemColor: const Color(0xFF1E40AF),
        unselectedItemColor: Colors.grey[600],
        currentIndex: 3, // Chat tab is selected
        onTap: (index) {
          switch (index) {
            case 0:
              // Navigate to home screen
              Navigator.navigate() =>
                      Screen(data: widget.data),
                ),
              );
              break;
            case 1:
              // Navigate to search screen
              Navigator.navigate() => SearchScreen(data: widget.data),
                ),
              );
              break;
            case 2:
              // Navigate to post job screen
              Navigator.navigate() =>
                      PostJobScreen(data: widget.data),
                ),
              );
              break;
            case 3:
              // Already on chat screen
              break;
            case 4:
              // Navigate to profile screen
              Navigator.navigate() =>
                      CustomerProfileScreen(data: _currentUserData ?? widget.data),
                ),
              );
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
    );
  }

  Map<String, String> _parseServiceProviderId(String serviceproviderId) {
    if (serviceproviderId.startsWith('mock_')) {
      final namesPart = serviceproviderId.substring(5); // Remove "mock_" prefix
      final parts = namesPart.split('_');
      
      if (parts.length >= 2) {
        // Capitalize first letters
        final firstName = parts[0][0].toUpperCase() + parts[0].substring(1);
        final lastName = parts.sublist(1).map((part) => 
          part[0].toUpperCase() + part.substring(1)).join(' ');
        
        return {'firstName': firstName, 'lastName': lastName};
      }
    }
    
    // Fallback for non-mock IDs
    return {'firstName': 'Data', 'lastName': 'User'};
  }
}
