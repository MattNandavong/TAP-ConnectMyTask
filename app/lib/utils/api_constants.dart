// iOS simulator:
// final String baseUrl = 'http://localhost:3300/api';

// Android emulator:
// final String baseUrl = 'http://10.0.2.2:3300/api';

//Real device
// final String baseUrl = 'http://192.168.1.101:3300/api';

// final String serverIp = 'https://api.connectmytask.xyz';

final String serverIp = 'http://10.0.2.2:3300';

//publish server
final String baseUrl = '$serverIp/api';

final String authUrl = '$baseUrl/auth';

final String registerUrl = '$authUrl/register';

final String loginUrl = '$authUrl/login';

final String googleLogin = '$authUrl/google';

final String chatUrl = '$baseUrl/messages';

final String taskUrl = '$baseUrl/tasks';

