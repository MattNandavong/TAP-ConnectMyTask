import 'dart:convert';
import 'dart:io';
import 'package:app/model/user.dart';
import 'package:app/utils/api_constants.dart';
import 'package:app/utils/auth_service.dart';
import 'package:app/utils/chat_service.dart';
import 'package:app/utils/connection_helper.dart';
import 'package:app/utils/task_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

class ChatScreen extends StatefulWidget {
  final String userId;
  final String receiverId;

  ChatScreen({required this.userId, required this.receiverId});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late IO.Socket socket;
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, dynamic>> messages = [];
  final List<Map<String, dynamic>> _pendingImages = [];
  final ImagePicker _picker = ImagePicker();
  bool _isSending = false;

  User? partner;

  @override
  void initState() {
    super.initState();
    _initialize();
  }
    Future<void> _initialize() async {
  final isConnected = await ConnectionHelper.hasConnection();
  if (!isConnected && mounted) {
    await ConnectionHelper.showNoConnectionDialog(context);
    return;
  }

  setState(() {
    _loadChatHistory();
    _connectToSocket();
    // markMessagesAsRead();
    _loadChatPartner();
  });
}

  Future<void> _loadChatHistory() async {
    try {
      final chatService = ChatService();
      final result = await chatService.getMessagesWithUser(widget.receiverId);

      if (!mounted) return;

      setState(() {
        messages.clear();
        messages.addAll(
          result.map(
            (m) => {
              'sender': m.sender,
              'receiver': m.receiver,
              'text': m.text,
              'image': m.image,
              'timestamp': m.timestamp.toIso8601String(),
            },
          ),
        );
      });

      _scrollToBottom();
    } catch (e) {
      print('❌ Error loading chat history: $e');
    }
  }

  void _connectToSocket() {
    socket = IO.io(
      serverIp,
      IO.OptionBuilder().setTransports(['websocket']).build(),
    );

    socket.onConnect((_) {
      print("✅ Socket connected. Joining room...");
      socket.emit('joinUserRoom', widget.userId);
    });

    socket.on('receiveMessage', (data) {
      print("📥 Received message: $data");
      print("👤 I am ${widget.userId}, message is for ${data['receiver']}");

      // Ensure this matches your current user ID
      if (data['receiver'] != widget.userId &&
          data['sender'] != widget.userId) {
        print("🚫 Message not relevant to this user. Ignored.");
        return;
      }

      final msg = {
        'sender': data['sender'],
        'receiver': data['receiver'],
        'text': data['text'],
        'image': data['image'],
        'timestamp': data['timestamp'],
      };

      setState(() {
        messages.add(msg);
      });

      _scrollToBottom();
    });

    socket.connect();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  Future<void> _selectImages() async {
    final pickedFiles = await _picker.pickMultiImage(imageQuality: 75);

    final tempDir = await getTemporaryDirectory();

    for (var xfile in pickedFiles) {
      final targetPath =
          '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
      final result = await FlutterImageCompress.compressAndGetFile(
        xfile.path,
        targetPath,
        quality: 70,
      );
      if (result != null) {
        setState(() {
          _pendingImages.add({'file': File(result.path), 'caption': ''});
        });
      }
    }
  }

  Future<void> _loadChatPartner() async {
    try {
      // final task = await TaskService().getTask(widget.taskId);
      final partnerId = widget.receiverId;

      if (partnerId.isEmpty) return;

      final partnerData = await AuthService().getUserProfile(partnerId);
      if (!mounted) return;

      setState(() => partner = partnerData);
    } catch (e) {
      print('❌ Failed to load chat partner: $e');
    }
  }

  Future<void> _sendMessage() async {
    if (_isSending) return;
    setState(() => _isSending = true);

    final text = _controller.text.trim();
    final receiverId = widget.receiverId;

    final chatService = ChatService();

    // Send text message
    if (text.isNotEmpty) {
      try {
        final success = await chatService.sendMessage(
          receiverId: receiverId,
          text: text,
        );

        if (success) {
          print('📨 Text message sent successfully.');
          _controller.clear();
        } else {
          print('❌ Failed to send text message.');
        }
      } catch (e) {
        print('❌ Error sending text message: $e');
      } finally {
        setState(() => _isSending = false); // Allow next send
      }
    }

    // Send pending images
    for (var img in _pendingImages) {
      try {
        final success = await chatService.sendMessage(
          receiverId: receiverId,
          imageFile: img['file'],
        );

        if (success) {
          print('🖼️ Image sent successfully.');
        } else {
          print('❌ Failed to send image.');
        }
      } catch (e) {
        print('❌ Error sending image: $e');
      }
    }

    setState(() => _pendingImages.clear());
    _scrollToBottom();
  }

  String _formatTime(String iso) {
    final time = DateTime.parse(iso);
    final now = DateTime.now();
    final diff = now.difference(time);
    if (diff.inMinutes < 1) return 'justNow'.tr();
    if (diff.inMinutes < 60) return '${diff.inMinutes} ${'minutesAgo'.tr()}';
    if (diff.inHours < 24) return '${diff.inHours} ${'hoursAgo'.tr()}';
    return '${diff.inDays} ${'daysAgo'.tr()}';
  }

  @override
  void dispose() {
    socket.dispose();
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        // backgroundColor: Color(0xFFF5F7FA),
        elevation: 1,
        leading: BackButton(),
        title:
            partner == null
                ? Text('loading'.tr())
                : Row(
                  children: [
                    partner!.buildAvatar(radius: 18),
                    SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          partner!.name,
                          style: GoogleFonts.figtree(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'online'.tr(),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                final senderId =
                    msg['sender'] is Map ? msg['sender']['_id'] : msg['sender'];
                final isMe = senderId == widget.userId;

                return Container(
                  margin: EdgeInsets.symmetric(vertical: 4),
                  alignment:
                      isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment:
                        isMe
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.7,
                        ),
                        decoration: BoxDecoration(
                          color:
                              isMe
                                  ? Theme.of(context).colorScheme.secondary
                                  : Theme.of(
                                    context,
                                  ).colorScheme.inverseSurface,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (msg['image'] != null &&
                                msg['image'].toString().isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Builder(
                                  builder: (context) {
                                    print(
                                      '🖼️ Trying to load image: ${msg['image']}',
                                    ); // <== Add this
                                    return Image.network(
                                      msg['image'],
                                      width: 200,
                                      fit: BoxFit.cover,
                                      errorBuilder: (
                                        context,
                                        error,
                                        stackTrace,
                                      ) {
                                        print('❌ Image load failed: $error');
                                        return Text('Failed to load image');
                                      },
                                    );
                                  },
                                ),
                              ),

                            if ((msg['text'] ?? '').trim().isNotEmpty &&
                                msg['text'] != '[Image]')
                              Text(
                                msg['text'],
                                style: TextStyle(
                                  color: isMe ? Colors.white : Colors.black87,
                                  fontSize: 14,
                                ),
                              ),
                          ],
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        _formatTime(msg['timestamp']),
                        style: TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          //  Message input + image preview
          Container(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),

            child: Column(
              children: [
                if (_pendingImages.isNotEmpty)
                  Container(
                    height: 110,
                    // margin: EdgeInsets.only(bottom: 8),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _pendingImages.length,
                      itemBuilder: (context, index) {
                        final item = _pendingImages[index];
                        return Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Column(
                            children: [
                              Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.file(
                                      item['file'],
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: GestureDetector(
                                      onTap:
                                          () => setState(
                                            () =>
                                                _pendingImages.removeAt(index),
                                          ),
                                      child: CircleAvatar(
                                        radius: 12,
                                        backgroundColor: Colors.black54,
                                        child: Icon(
                                          FluentIcons.dismiss_20_filled,
                                          size: 14,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                             
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        FluentIcons.image_add_20_filled,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      onPressed: _selectImages,
                    ),
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          hintText: 'typeYourMessage'.tr(),

                          contentPadding: EdgeInsets.symmetric(horizontal: 12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      child: IconButton(
                        icon: Icon(
                          FluentIcons.send_20_filled,
                          color: Theme.of(context).colorScheme.onInverseSurface,
                        ),
                        onPressed: _sendMessage,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
