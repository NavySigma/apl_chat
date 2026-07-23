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
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _controller = TextEditingController();

  // Menambahkan atribut "status" untuk pesan yang kita kirim (isMe: true)
  List<Map<String, dynamic>> pesan = [
    {"teks": "Halo sayang, ini aplikasi buatanmu?", "waktu": "10:00", "isMe": false},
    // status 2 = centang dua biru
    {"teks": "Iya dong, ringan banget kan dipakainya? 😎", "waktu": "10:01", "isMe": true, "status": 2},
    {"teks": "Keren banget! 😍", "waktu": "10:02", "isMe": false},
  ];

  void _kirimPesan() {
    if (_controller.text.trim().isNotEmpty) {
      setState(() {
        String jamSekarang = "${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}";
        
        pesan.add({
          "teks": _controller.text, 
          "waktu": jamSekarang, 
          "isMe": true,
          "status": 0 // Status 0 = centang satu (baru terkirim)
        });
      });
      _controller.clear(); 

      Future.delayed(Duration(milliseconds: 100), () {
        _scrollController.animateTo(
          0.0, 
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });

      // (OPSIONAL) Simulasi centang berubah otomatis biar terlihat hidup
      // Ini cuma buat efek UI sementara sebelum disambung ke database
      int indexPesanBaru = pesan.length - 1;
      
      // Ubah ke centang 2 abu-abu setelah 2 detik
      Future.delayed(Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            pesan[indexPesanBaru]["status"] = 1; 
          });
        }
      });

      // Ubah ke centang 2 biru setelah 4 detik
      Future.delayed(Duration(seconds: 4), () {
        if (mounted) {
          setState(() {
            pesan[indexPesanBaru]["status"] = 2; 
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, color: Colors.blueAccent),
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Si Ayang", style: TextStyle(fontSize: 18)),
                Text("Online", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400)),
              ],
            ),
          ],
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController, 
              reverse: true, 
              itemCount: pesan.length,
              itemBuilder: (context, index) {
                var chat = pesan[pesan.length - 1 - index];
                return Align(
                  alignment: chat["isMe"] ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    decoration: BoxDecoration(
                      color: chat["isMe"] ? Colors.blue[100] : Colors.grey[300],
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                        bottomLeft: chat["isMe"] ? Radius.circular(15) : Radius.circular(0),
                        bottomRight: chat["isMe"] ? Radius.circular(0) : Radius.circular(15),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(chat["teks"], style: TextStyle(fontSize: 16)),
                        SizedBox(height: 4),
                        
                        // --- BARIS UNTUK JAM DAN TANDA CENTANG ---
                        Row(
                          mainAxisSize: MainAxisSize.min, // Biar nggak selebar layar
                          children: [
                            Text(
                              chat["waktu"], 
                              style: TextStyle(fontSize: 10, color: Colors.black54)
                            ),
                            
                            // Hanya tampilkan centang kalau pesannya "isMe" (kita yang kirim)
                            if (chat["isMe"]) ...[
                              SizedBox(width: 4),
                              Icon(
                                // Logika penentuan ikon:
                                // Jika status 0 (Centang 1), jika selain 0 (Centang 2)
                                chat["status"] == 0 ? Icons.check : Icons.done_all,
                                size: 14,
                                // Logika penentuan warna:
                                // Jika status 2 (Biru), selain itu (Abu-abu)
                                color: chat["status"] == 2 ? Colors.blue : Colors.black54,
                              ),
                            ]
                          ],
                        ),
                        // ----------------------------------------
                        
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
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
                      contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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