import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';

void main() {
  runApp(
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
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      debugShowCheckedModeBanner: false,
      title: 'Telegram Clone Dark',
      // Mengubah tema dasar menjadi Dark Mode
      theme: ThemeData.dark().copyWith(
        primaryColor: Color(0xFF5288C1),
        scaffoldBackgroundColor: Color(0xFF1D2733), // Warna background gelap Tele
      ),
      home: BerandaTelegram(),
    );
  }
}

// ==========================================
// HALAMAN 1: BERANDA (DARK MODE + ROUNDED NAV)
// ==========================================
class BerandaTelegram extends StatefulWidget {
  @override
  _BerandaTelegramState createState() => _BerandaTelegramState();
}

class _BerandaTelegramState extends State<BerandaTelegram> {
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> daftarChat = [
    {"nama": "Si Ayang", "pesanTerkahir": "Keren banget! 😍", "waktu": "10:02", "unread": 0, "warnaProfil": Colors.pinkAccent},
    {"nama": "Grup Projek Mabar", "pesanTerkahir": "Nanti malam gas jam 8 ya", "waktu": "09:15", "unread": 3, "warnaProfil": Colors.orangeAccent},
    {"nama": "Pak Dosen", "pesanTerkahir": "Tugasnya tolong direvisi bagian bab 2.", "waktu": "Kemarin", "unread": 0, "warnaProfil": Colors.blueGrey},
  ];

  @override
  Widget build(BuildContext context) {
    final List<Widget> _halaman = [
      ListView.separated(
        // Menambahkan padding bawah agar pesan terbawah tidak tertutup navbar melayang
        padding: EdgeInsets.only(bottom: 100),
        itemCount: daftarChat.length,
        separatorBuilder: (context, index) => Divider(height: 1, indent: 70, color: Colors.black26),
        itemBuilder: (context, index) {
          var chat = daftarChat[index];
          return ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
            leading: CircleAvatar(
              radius: 25,
              backgroundColor: chat["warnaProfil"],
              child: Text(chat["nama"][0], style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            title: Text(chat["nama"], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
            subtitle: Text(
              chat["pesanTerkahir"],
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.grey[400]),
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(chat["waktu"], style: TextStyle(color: chat["unread"] > 0 ? Color(0xFF5288C1) : Colors.grey, fontSize: 12)),
                SizedBox(height: 5),
                if (chat["unread"] > 0)
                  Container(
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(color: Color(0xFF5288C1), shape: BoxShape.circle),
                    child: Text(chat["unread"].toString(), style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                  ),
              ],
            ),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => RuangChat(namaKontak: chat["nama"])));
            },
          );
        },
      ),
      Center(child: Text("Halaman Contacts", style: TextStyle(fontSize: 20, color: Colors.grey))),
      Center(child: Text("Halaman Settings", style: TextStyle(fontSize: 20, color: Colors.grey))),
      Center(child: Text("Halaman Profile", style: TextStyle(fontSize: 20, color: Colors.grey))),
    ];

    return Scaffold(
      backgroundColor: Color(0xFF1D2733),
      // Wajib true agar background bisa tembus ke bawah navbar
      extendBody: true, 
      appBar: AppBar(
        backgroundColor: Color(0xFF242F3D), // Warna header dark Tele
        title: Text(
          _selectedIndex == 0 ? "Telegram" :
          _selectedIndex == 1 ? "Contacts" :
          _selectedIndex == 2 ? "Settings" : "Profile", 
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)
        ),
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(icon: Icon(Icons.search, color: Colors.white), onPressed: () {}),
        ],
      ),
      
      drawer: Drawer(
        backgroundColor: Color(0xFF1D2733),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Color(0xFF242F3D)),
              accountName: Text("Developer", style: TextStyle(fontWeight: FontWeight.bold)),
              accountEmail: Text("+62 812-3456-7890"),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Color(0xFF5288C1),
                child: Text("D", style: TextStyle(fontSize: 24, color: Colors.white)),
              ),
            ),
            ListTile(leading: Icon(Icons.group, color: Colors.grey[400]), title: Text("New Group", style: TextStyle(color: Colors.white)), onTap: () {}),
            ListTile(leading: Icon(Icons.person, color: Colors.grey[400]), title: Text("Contacts", style: TextStyle(color: Colors.white)), onTap: () {}),
            ListTile(leading: Icon(Icons.settings, color: Colors.grey[400]), title: Text("Settings", style: TextStyle(color: Colors.white)), onTap: () {}),
          ],
        ),
      ),

      body: _halaman[_selectedIndex],
      
      // Menggeser tombol pensil agar tidak tertutup navbar yang membesar
      // Menggeser tombol pensil lebih ke atas agar tidak tertabrak navbar
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 95.0), // Padding bawah dinaikkan jadi 95
        child: _selectedIndex == 0 ? FloatingActionButton(
          backgroundColor: Color(0xFF5288C1),
          child: Icon(Icons.edit, color: Colors.white),
          onPressed: () {},
        ) : null,
      ),

      // ==========================================
      // ROUNDED NAVBAR DENGAN GRADASI OPACITY
      // ==========================================
      bottomNavigationBar: Container(
        // Memberikan tinggi fix pada area gradasi agar bayangannya lebih panjang ke atas
        height: 130, 
        alignment: Alignment.bottomCenter,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1D2733).withOpacity(0.0), 
              Color(0xFF1D2733).withOpacity(0.8), 
              Color(0xFF1D2733), // Bagian paling bawah solid agar rapi
            ],
          ),
        ),
        // bottom diubah jadi 40 biar navbar naik
        padding: EdgeInsets.only(left: 20, right: 20, bottom: 40),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BottomNavigationBar(
            backgroundColor: Color(0xFF242F3D), 
            type: BottomNavigationBarType.fixed, 
            currentIndex: _selectedIndex, 
            selectedItemColor: Color(0xFF5288C1), 
            unselectedItemColor: Colors.grey[500], 
            
            // --- DUA BARIS INI KUNCI BIAR KAPSULNYA RAPAT ---
            showSelectedLabels: false, 
            showUnselectedLabels: false, 
            // ------------------------------------------------
            
            onTap: (index) {
              setState(() {
                _selectedIndex = index; 
              });
            },
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_rounded), label: "Chats"),
              BottomNavigationBarItem(icon: Icon(Icons.contacts_rounded), label: "Contacts"),
              BottomNavigationBarItem(icon: Icon(Icons.settings_rounded), label: "Settings"),
              BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: "Profile"),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// HALAMAN 2: RUANG CHAT (DARK MODE)
// ==========================================
class RuangChat extends StatefulWidget {
  final String namaKontak;
  RuangChat({required this.namaKontak});

  @override
  _RuangChatState createState() => _RuangChatState();
}

class _RuangChatState extends State<RuangChat> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _controller = TextEditingController();

  List<Map<String, dynamic>> pesan = [
    {"teks": "Halo sayang, ini aplikasi buatanmu?", "waktu": "10:00", "isMe": false},
    {"teks": "Iya dong, Dark Mode Tele nih! 😎", "waktu": "10:01", "isMe": true, "status": 2},
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
          "status": 0
        });
      });
      _controller.clear();

      Future.delayed(Duration(milliseconds: 100), () {
        _scrollController.animateTo(0.0, duration: Duration(milliseconds: 300), curve: Curves.easeOut);
      });

      int indexPesanBaru = pesan.length - 1;
      Future.delayed(Duration(seconds: 2), () {
        if (mounted) setState(() { pesan[indexPesanBaru]["status"] = 1; });
      });
      Future.delayed(Duration(seconds: 4), () {
        if (mounted) setState(() { pesan[indexPesanBaru]["status"] = 2; });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0F1620), // Warna background chat room sangat gelap
      appBar: AppBar(
        backgroundColor: Color(0xFF242F3D),
        leadingWidth: 30,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: Color(0xFF5288C1),
              child: Text(widget.namaKontak[0], style: TextStyle(color: Colors.white)),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.namaKontak, style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
                  Text("online", style: TextStyle(fontSize: 14, color: Color(0xFF5288C1), fontWeight: FontWeight.w400)),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(icon: Icon(Icons.more_vert, color: Colors.white), onPressed: () {}),
        ],
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
                    margin: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                    padding: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                    decoration: BoxDecoration(
                      // Warna bubble chat Dark Mode
                      color: chat["isMe"] ? Color(0xFF2B5278) : Color(0xFF182533),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                        bottomLeft: chat["isMe"] ? Radius.circular(12) : Radius.circular(0),
                        bottomRight: chat["isMe"] ? Radius.circular(0) : Radius.circular(12),
                      ),
                    ),
                    child: Wrap(
                      alignment: WrapAlignment.end,
                      crossAxisAlignment: WrapCrossAlignment.end,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 8.0, bottom: 2.0),
                          child: Text(chat["teks"], style: TextStyle(fontSize: 16, color: Colors.white)),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              chat["waktu"],
                              style: TextStyle(
                                fontSize: 11,
                                color: chat["isMe"] ? Color(0xFF64B5F6) : Colors.grey[500]
                              )
                            ),
                            if (chat["isMe"]) ...[
                              SizedBox(width: 4),
                              Icon(
                                chat["status"] == 0 ? Icons.check : Icons.done_all,
                                size: 15,
                                color: chat["status"] == 2 ? Color(0xFF64B5F6) : Colors.grey[400], // Biru terang saat dibaca
                              ),
                            ]
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          
          // Input Bawah Dark Mode
          Container(
            color: Color(0xFF242F3D),
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
            child: Row(
              children: [
                Icon(Icons.sentiment_satisfied_alt, color: Colors.grey[400], size: 28),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: TextStyle(color: Colors.white),
                    onChanged: (text) => setState(() {}),
                    decoration: InputDecoration(
                      hintText: "Message",
                      hintStyle: TextStyle(color: Colors.grey[500], fontSize: 17),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
                Icon(Icons.attach_file, color: Colors.grey[400], size: 26),
                SizedBox(width: 15),
                GestureDetector(
                  onTap: _controller.text.trim().isEmpty ? null : _kirimPesan,
                  child: Icon(
                    _controller.text.trim().isEmpty ? Icons.mic : Icons.send,
                    color: _controller.text.trim().isEmpty ? Colors.grey[400] : Color(0xFF5288C1),
                    size: 28,
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