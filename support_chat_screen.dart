class SupportChatScreen extends StatefulWidget {
  final String conversationId;

  const SupportChatScreen({
    super.key,
    required this.conversationId,
  });

  @override
  State<SupportChatScreen> createState() => _SupportChatScreenState();
}

class _SupportChatScreenState extends State<SupportChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final /* FirebaseFirestore removed */ _firestore = /* FirebaseFirestore removed *//* .instance removed */;
  final // Image utility removed _imagePicker = // Image utility removed();
  late Stream</* QuerySnapshot removed */> _messagesStream;
  bool _isLoading = false;
  XFile? _selectedImage;

  @override
  void initState() {
    super.initState();
    _messagesStream = _firestore
        // Database operation removed
        // Database operation removed
        // Database operation removed
        /* .orderBy removed */('timestamp', descending: true)
        .snapshots();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image != null && mounted) {
        setState(() {});
      }
    } catch (e) {
      if (mounted) {}
    }
  }

  Future<String?> _uploadImageToCloudinary(XFile image) async {
    try {
      setState(() => _isLoading = true);

      final File imageFile = File(image.path);

      // Get Cloudinary configuration from .env
      final cloudinaryCloudName = dotenv.env['cloudinary_cloud_name'];
      final uploadPreset = dotenv.env['CLOUDINARY_UPLOAD_PRESET_CHAT'];
      
      if (cloudinaryCloudName == null || cloudinaryCloudName.isEmpty) {
        throw Exception('Cloudinary cloud name not configured in .env');
      }
      
      if (uploadPreset == null || uploadPreset.isEmpty) {
        throw Exception('Cloudinary upload preset not configured in .env');
      }

      // Initialize Cloudinary Public
      final cloudinary = CloudinaryPublic(
        cloudinaryCloudName,
        uploadPreset, // Use appname_chat preset
        cache: false,
      );

      // Upload to Cloudinary with chat preset
        CloudinaryFile.fromFile(
          imageFile.path,
          folder: 'support_chats',
          resourceType: CloudinaryResourceType.Image,
        ),
      );

      // CloudinaryResponse has 'secureUrl' property
      return response.secureUrl;
    } catch (e) {
      if (mounted) {}
      return null;
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty && _selectedImage == null) return;

    final currentUser = /* FirebaseAuth removed *//* .instance removed */.currentUser;
    if (currentUser == null) return;

    setState(() => _isLoading = true);

    try {
      String? imageUrl;

      // Upload image if selected
      if (_selectedImage != null) {
        if (imageUrl == null) {
          setState(() => _isLoading = false);
          return;
        }
      }

      // Send message with optional image
        conversationId: widget.conversationId,
        userId: currentUser.uid,
        message: _messageController.text.trim(),
        isAdmin: false,
        imageUrl: imageUrl,
      );

      _messageController.clear();
      setState(() {});
    } catch (e) {
      if (mounted) {}
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Support Chat'),
        centerTitle: true,
        elevation: 1,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          // Messages List
          Expanded(
            child: StreamBuilder</* QuerySnapshot removed */>(
              stream: _messagesStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }

                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final messages = snapshot.data!/* .doc removed */s;

                if (messages.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.message,
                          size: 64,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No messages yet',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  reverse: true,
                  padding: const EdgeInsets.all(16),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final messageData =
                        messages[index].data() as Map;
                    final isAdmin = messageData['senderType'] == 'admin';
                    final currentUser = /* FirebaseAuth removed *//* .instance removed */.currentUser;
                    final isCurrentUser = messageData['senderId'] == currentUser?.uid;
                    final senderName = messageData['senderName'] ?? 'Unknown';
                    final senderAvatar = messageData['senderAvatar'] ?? '';

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: isCurrentUser
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // Avatar for other users (left side)
                          if (!isCurrentUser)
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: _buildAvatar(
                                senderAvatar,
                                senderName,
                                isAdmin,
                              ),
                            ),
                          // Message bubble
                          Flexible(
                            child: Column(
                              crossAxisAlignment: isCurrentUser
                                  ? CrossAxisAlignment.end
                                  : CrossAxisAlignment.start,
                              children: [
                                // Sender name (for admin messages)
                                if (isAdmin && !isCurrentUser)
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 12.0,
                                      bottom: 4.0,
                                    ),
                                    child: Text(
                                      '🛡️ Admin Support',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.orange[800],
                                      ),
                                    ),
                                  ),
                                // Message bubble
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isCurrentUser
                                        ? Colors.blue[500]
                                        : (isAdmin
                                            ? Colors.orange[100]
                                            : Colors.grey[200]),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  constraints: BoxConstraints(
                                    maxWidth: MediaQuery.of(context).size.width *
                                        0.65,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Display image if present
                                      if (messageData['imageUrl'] != null &&
                                          (messageData['imageUrl'] as String).isNotEmpty)
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 8.0),
                                          child: GestureDetector(
                                            onTap: () {
                                              // Show full image dialog
                                              showDialog(
                                                context: context,
                                                builder: (context) => Dialog(
                                                  child: CachedNetworkImage(
                                                    imageUrl: messageData['imageUrl'],
                                                    fit: BoxFit.contain,
                                                  ),
                                                ),
                                              );
                                            },
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    messageData['imageUrl'],
                                                width: 200,
                                                height: 200,
                                                fit: BoxFit.cover,
                                                placeholder: (context, url) =>
                                                    Container(
                                                  width: 200,
                                                  height: 200,
                                                  color: Colors.grey[300],
                                                  child: const Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  ),
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Container(
                                                  width: 200,
                                                  height: 200,
                                                  color: Colors.grey[300],
                                                  child: const Center(
                                                    child: Icon(Icons.error),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      // Display text message if present
                                      if (messageData['message'] != null &&
                                          (messageData['message'] as String)
                                              .isNotEmpty)
                                        Text(
                                          messageData['message'] ?? '',
                                          style: TextStyle(
                                            color: isCurrentUser
                                                ? Colors.white
                                                : Colors.black87,
                                          ),
                                        ),
                                      const SizedBox(height: 4),
                                      Text(
                                        _formatTime(messageData['timestamp']),
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: isCurrentUser
                                              ? Colors.white70
                                              : Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Avatar for current user (right side)
                          if (isCurrentUser)
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: _buildAvatar(
                                senderAvatar,
                                senderName,
                                false,
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
          // Message Input
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(
                  color: Colors.grey[300]!,
                  width: 1,
                ),
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // Image Preview (if selected)
                  if (_selectedImage != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              // ignore: deprecated_member_use
                              File(_selectedImage!.path),
                              height: 120,
                              width: 120,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: 4,
                            right: 4,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {});
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                padding: const EdgeInsets.all(4),
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  // Input row
                  Row(
                    children: [
                      // Image picker button
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          onPressed: _isLoading ? null : _pickImage,
                          icon: const Icon(
                            Icons.attach_file,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Text input
                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          decoration: InputDecoration(
                            hintText: _selectedImage != null
                                ? 'Add caption (optional)...'
                                : 'Type your message...',
                            hintStyle: TextStyle(color: Colors.grey[400]),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                              borderSide: BorderSide(
                                color: Colors.grey[300]!,
                                width: 1,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                              borderSide: BorderSide(
                                color: Colors.blue[500]!,
                                width: 2,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                          maxLines: null,
                          enabled: !_isLoading,
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Send button
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.blue[500],
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          onPressed: _isLoading ? null : _sendMessage,
                          icon: _isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                )
                              : const Icon(
                                  Icons.send,
                                  color: Colors.white,
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

  String _formatTime(dynamic timestamp) {
    if (timestamp == null) return '';
    try {
      final dateTime = (timestamp as /* Timestamp removed */).toDate();
      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inMinutes < 1) {
        return 'just now';
      } else if (difference.inMinutes < 60) {
        return '${difference.inMinutes}m ago';
      } else if (difference.inHours < 24) {
        return '${difference.inHours}h ago';
      } else {
        return '${dateTime.month}/${dateTime.day} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
      }
    } catch (e) {
      return '';
    }
  }

  Widget _buildAvatar(String avatarUrl, String name, bool isAdmin) {
    // Get initials from name
    final initials = name
        .split(' ')
        .take(2)
        .map((part) => part.isNotEmpty ? part[0].toUpperCase() : '')
        .join();

    // Avatar background colors
    final adminColor = Colors.orange;
    final userColor = Colors.blue;
    final backgroundColor = isAdmin ? adminColor : userColor;

    if (avatarUrl.isNotEmpty) {
      return Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: isAdmin ? Border.all(color: Colors.orange, width: 2) : null,
          boxShadow: [
            BoxShadow(
              color: backgroundColor.withValues(alpha: 0.3),
              blurRadius: 4,
              spreadRadius: 1,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: CachedNetworkImage(
            imageUrl: avatarUrl,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              decoration: BoxDecoration(
                color: backgroundColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  initials,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            errorWidget: (context, url, error) => Container(
              decoration: BoxDecoration(
                color: backgroundColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  initials,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      // Default avatar with initials
      return Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
          border: isAdmin ? Border.all(color: Colors.orange, width: 2) : null,
          boxShadow: [
            BoxShadow(
              color: backgroundColor.withValues(alpha: 0.3),
              blurRadius: 4,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Center(
          child: Text(
            initials.isEmpty ? '?' : initials,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      );
    }
  }
}
