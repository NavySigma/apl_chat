import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart'; // 1. Ini yang bikin tersambung

void main() {
  runApp(
    // 2. Ini yang membungkus aplikasimu jadi bingkai HP
    DevicePreview(
      enabled: true,
      builder: (context) => ChatApp(),
    ),
  );
}

class ChatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // 3. Dua baris ini wajib ada di dalam MaterialApp
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      
      debugShowCheckedModeBanner: false, 
      title: 'Chat Eksklusif',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: RuangChat(),
    );
  }
}

class RuangChat extends StatefulWidget {
  @override
  _RuangChatState createState() => _RuangChatState();
}

class _RuangChatState extends State<RuangChat> {
  // Data sementara (Nanti ini diganti dengan data dari database MySQL Laravel-mu)
  List<Map<String, dynamic>> pesan = [
  ];

  // Controller untuk menangkap teks yang diketik di TextField
  final TextEditingController _controller = TextEditingController();

  // Fungsi untuk menambahkan pesan ke layar saat tombol kirim ditekan
  void _kirimPesan() {
    if (_controller.text.trim().isNotEmpty) {
      setState(() {
        pesan.add({"teks": _controller.text, "isMe": true});
      });
      _controller.clear(); // Mengosongkan kolom input setelah terkirim
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat Eksklusif"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          // Area Daftar Chat
          Expanded(
            child: ListView.builder(
              reverse:
                  true, // Membalik urutan agar pesan terbaru muncul dari bawah
              itemCount: pesan.length,
              itemBuilder: (context, index) {
                var chat = pesan[pesan.length - 1 - index];
                return Align(
                  alignment: chat["isMe"]
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: chat["isMe"] ? Colors.blue[100] : Colors.grey[300],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(chat["teks"], style: TextStyle(fontSize: 16)),
                  ),
                );
              },
            ),
          ),

          // Area Input Teks dan Tombol Kirim
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Ketik pesan...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 10,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: Colors.blueAccent,
                  child: IconButton(
                    icon: Icon(Icons.send, color: Colors.white),
                    onPressed: _kirimPesan,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
