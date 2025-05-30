import 'dart:convert';
import 'package:app/model/chat_preview.dart';
import 'package:app/utils/api_constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:app/model/chat_message.dart';

class ChatService {
  // Replace with your backend URL
  final String baseUrl = chatUrl;

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  /// ✅ Send message (text or image)
  Future<bool> sendMessage({
    required String receiverId,
    String? text,
    File? imageFile,
  }) async {
    final uri = Uri.parse(baseUrl);
    final token = await _getToken();

    final request = http.MultipartRequest('POST', uri);
    request.headers['Authorization'] = '$token';

    request.fields['receiverId'] = receiverId;
    if (text != null && text.isNotEmpty) {
      request.fields['text'] = text;
    }

    if (imageFile != null) {
      request.files.add(
        await http.MultipartFile.fromPath('image', imageFile.path),
      );
    }

    final response = await request.send();

    return response.statusCode == 201;
  }

  /// ✅ Fetch messages with a specific user
  Future<List<ChatMessage>> getMessagesWithUser(String otherUserId) async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/$otherUserId'),
      headers: {'Authorization': '$token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => ChatMessage.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load messages');
    }
  }

  /// ✅ Get all chat summaries (chat list)
  Future<List<ChatPreview>> getChatSummaries() async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/summary/me'),
      headers: {'Authorization': '$token'},
    );

    // print('📡 GET $url → ${response.statusCode}');
    print('📦 Response: ${response.body}');

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => ChatPreview.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load chat summaries');
    }
  }
}
