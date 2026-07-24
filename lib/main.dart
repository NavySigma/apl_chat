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
      // ==========================================
      // INDEX 0: SEARCH BAR + DAFTAR CHAT
      // ==========================================
      Column(
        children: [
          // 1. Kotak Input Pencarian (Search Bar)
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              color: Color(0xFF242F3D), // Warna box search khas Dark Mode Tele
              borderRadius: BorderRadius.circular(10), // Dibuat rounded
            ),
            child: TextField(
              style: TextStyle(color: Colors.white, fontSize: 16),
              decoration: InputDecoration(
                hintText: "Search",
                hintStyle: TextStyle(color: Colors.grey[500]),
                prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          
          // 2. Daftar Chat (Dibungkus Expanded agar tidak error ukurannya)
          Expanded(
            child: ListView.separated(
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
          ),
        ],
      ),
      Center(child: Text("Halaman Contacts", style: TextStyle(fontSize: 20, color: Colors.grey))),
      Center(child: Text("Halaman Settings", style: TextStyle(fontSize: 20, color: Colors.grey))),
      Center(child: Text("Halaman Profile", style: TextStyle(fontSize: 20, color: Colors.grey))),
    ];

    return Scaffold(
      backgroundColor: Color(0xFF1D2733),
      extendBody: true, 
      appBar: AppBar(
        backgroundColor: Color(0xFF242F3D),
        elevation: 0, // Dihilangkan agar menyatu mulus dengan layar bawahnya
        title: Text(
          _selectedIndex == 0 ? "Telegram" :
          _selectedIndex == 1 ? "Contacts" :
          _selectedIndex == 2 ? "Settings" : "Profile", 
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)
        ),
        iconTheme: IconThemeData(color: Colors.white),
        // BAGIAN ACTIONS (IKON SEARCH LAMA) SUDAH DIHAPUS DARI SINI
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
      
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 90.0, right: 5.0), 
        child: _selectedIndex == 0 ? Transform.translate(
          offset: Offset(0, 40), 
          child: SizedBox(
            width: 50, 
            height: 50, 
            child: FloatingActionButton(
              backgroundColor: Color(0xFF5288C1),
              shape: CircleBorder(), 
              child: Icon(Icons.add_comment, color: Colors.white, size: 22), 
              onPressed: () {},
            ),
          ),
        ) : null,
      ),

      bottomNavigationBar: Container(
        padding: EdgeInsets.only(left: 45, right: 45, bottom: 35, top: 40),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Color(0xFF1D2733).withOpacity(1.0), 
              Color(0xFF1D2733).withOpacity(0.8), 
              Color(0xFF1D2733).withOpacity(0.0), 
            ],
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(35), 
          child: SizedBox(
            height: 60, 
            child: MediaQuery.removePadding(
              context: context,
              removeBottom: true, 
              child: BottomNavigationBar(
                backgroundColor: Color(0xFF242F3D), 
                type: BottomNavigationBarType.fixed, 
                currentIndex: _selectedIndex, 
                selectedItemColor: Color(0xFF5288C1), 
                unselectedItemColor: Colors.grey[500], 
                showSelectedLabels: true, 
                showUnselectedLabels: true, 
                selectedFontSize: 10, 
                unselectedFontSize: 10, 
                elevation: 0, 
                onTap: (index) {
                  setState(() {
                    _selectedIndex = index; 
                  });
                },
                items: [
                  BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_rounded, size: 22), label: "Chats"),
                  BottomNavigationBarItem(icon: Icon(Icons.contacts_rounded, size: 22), label: "Contacts"),
                  BottomNavigationBarItem(icon: Icon(Icons.settings_rounded, size: 22), label: "Settings"),
                  BottomNavigationBarItem(icon: Icon(Icons.person_rounded, size: 22), label: "Profile"),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class RuangChat extends StatefulWidget {
  final String namaKontak;
  RuangChat({required this.namaKontak});

  @override
  _RuangChatState createState() => _RuangChatState();
}

class _RuangChatState extends State<RuangChat> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _controller = TextEditingController();

  List<Map<String, dynamic>> pesan = [];

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    String hariIni = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
    DateTime kmrn = now.subtract(Duration(days: 1));
    String kemarin = "${kmrn.year}-${kmrn.month.toString().padLeft(2, '0')}-${kmrn.day.toString().padLeft(2, '0')}";
    DateTime lama = now.subtract(Duration(days: 3));
    String hariLama = "${lama.year}-${lama.month.toString().padLeft(2, '0')}-${lama.day.toString().padLeft(2, '0')}";

    pesan = [
      {"teks": "Halo sayang, sibuk gak?", "waktu": "09:00", "tanggal": hariLama, "isMe": false},
      {"teks": "Ini aplikasi buatanmu?", "waktu": "10:00", "tanggal": kemarin, "isMe": false},
      {"teks": "Iya dong, Dark Mode Tele nih! 😎", "waktu": "10:01", "tanggal": kemarin, "isMe": true, "status": 2},
      {"teks": "Keren banget! 😍", "waktu": "10:02", "tanggal": hariIni, "isMe": false},
    ];
  }

  String _formatTanggalCapsule(String tglStr) {
    DateTime date = DateTime.parse(tglStr);
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime msgDate = DateTime(date.year, date.month, date.day);
    
    int selisihHari = today.difference(msgDate).inDays;
    
    if (selisihHari == 0) return "Hari ini";
    if (selisihHari == 1) return "Kemarin";
    
    List<String> namaBulan = ["", "Jan", "Feb", "Mar", "Apr", "Mei", "Jun", "Jul", "Ags", "Sep", "Okt", "Nov", "Des"];
    return "${date.day} ${namaBulan[date.month]}";
  }

  void _kirimPesan() {
    if (_controller.text.trim().isNotEmpty) {
      setState(() {
        DateTime now = DateTime.now();
        String jamSekarang = "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";
        String tanggalSekarang = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
        
        pesan.add({
          "teks": _controller.text,
          "waktu": jamSekarang,
          "tanggal": tanggalSekarang,
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

  void _tampilkanMenuMute(BuildContext context) {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    
    showMenu<String>(
      context: context,
      position: RelativeRect.fromRect(
        Rect.fromPoints(Offset(overlay.size.width, 80), Offset(overlay.size.width, 80)),
        Offset.zero & overlay.size,
      ),
      color: Color(0xFF242F3D),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      items: [
        PopupMenuItem(value: 'back', child: Row(children: [Icon(Icons.arrow_back, color: Colors.white, size: 22), SizedBox(width: 12), Text("Back", style: TextStyle(color: Colors.white, fontSize: 15))])),
        PopupMenuItem(value: 'disable', child: Row(children: [Icon(Icons.volume_off_outlined, color: Colors.white, size: 22), SizedBox(width: 12), Text("Disable Sound", style: TextStyle(color: Colors.white, fontSize: 15))])),
        PopupMenuItem(value: 'mutefor', child: Row(children: [Icon(Icons.access_time, color: Colors.white, size: 22), SizedBox(width: 12), Text("Mute for...", style: TextStyle(color: Colors.white, fontSize: 15))])),
        PopupMenuItem(value: 'customize', child: Row(children: [Icon(Icons.settings_outlined, color: Colors.white, size: 22), SizedBox(width: 12), Text("Customize", style: TextStyle(color: Colors.white, fontSize: 15))])),
        PopupMenuItem(value: 'muteforever', child: Row(children: [Icon(Icons.notifications_off, color: Colors.redAccent, size: 22), SizedBox(width: 12), Text("Mute Forever", style: TextStyle(color: Colors.redAccent, fontSize: 15))])),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0F1620), 
      appBar: AppBar(
        backgroundColor: Color(0xFF242F3D),
        leadingWidth: 30,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        // ==========================================
        // PROFIL DIJADIKAN TOMBOL DENGAN INKWELL
        // ==========================================
        title: InkWell(
          onTap: () {
            // Berpindah ke Halaman Profil
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HalamanProfil(namaKontak: widget.namaKontak)),
            );
          },
          child: Row(
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
        ),
        actions: [
          PopupMenuButton<String>(
            color: Color(0xFF242F3D),
            icon: Icon(Icons.more_vert, color: Colors.white),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            onSelected: (value) {
              if (value == 'mute') {
                Future.delayed(Duration(milliseconds: 100), () => _tampilkanMenuMute(context));
              }
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(value: 'mute', child: Row(children: [Icon(Icons.notifications_off_outlined, color: Colors.white, size: 22), SizedBox(width: 12), Text("Mute", style: TextStyle(color: Colors.white, fontSize: 15)), Spacer(), Icon(Icons.keyboard_arrow_right, color: Colors.grey, size: 20)])),
              PopupMenuItem(value: 'search', child: Row(children: [Icon(Icons.search, color: Colors.white, size: 22), SizedBox(width: 12), Text("Search", style: TextStyle(color: Colors.white, fontSize: 15))])),
              PopupMenuItem(value: 'wallpaper', child: Row(children: [Icon(Icons.wallpaper, color: Colors.white, size: 22), SizedBox(width: 12), Text("Change Wallpaper", style: TextStyle(color: Colors.white, fontSize: 15))])),
              PopupMenuItem(value: 'clear', child: Row(children: [Icon(Icons.cleaning_services_outlined, color: Colors.white, size: 22), SizedBox(width: 12), Text("Clear History", style: TextStyle(color: Colors.white, fontSize: 15))])),
              PopupMenuItem(value: 'delete', child: Row(children: [Icon(Icons.delete_outline, color: Colors.redAccent, size: 22), SizedBox(width: 12), Text("Delete Chat", style: TextStyle(color: Colors.redAccent, fontSize: 15))])),
            ],
          ),
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
                int realIndex = pesan.length - 1 - index;
                var chat = pesan[realIndex];
                
                bool tampilkanTanggal = false;
                if (realIndex == 0) {
                  tampilkanTanggal = true;
                } else {
                  if (chat["tanggal"] != pesan[realIndex - 1]["tanggal"]) tampilkanTanggal = true;
                }

                Widget balonPesan = Align(
                  alignment: chat["isMe"] ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                    padding: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                    decoration: BoxDecoration(
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
                        Padding(padding: EdgeInsets.only(right: 8.0, bottom: 2.0), child: Text(chat["teks"], style: TextStyle(fontSize: 16, color: Colors.white))),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(chat["waktu"], style: TextStyle(fontSize: 11, color: chat["isMe"] ? Color(0xFF64B5F6) : Colors.grey[500])),
                            if (chat["isMe"]) ...[
                              SizedBox(width: 4),
                              Icon(chat["status"] == 0 ? Icons.check : Icons.done_all, size: 15, color: chat["status"] == 2 ? Color(0xFF64B5F6) : Colors.grey[400]),
                            ]
                          ],
                        ),
                      ],
                    ),
                  ),
                );

                if (tampilkanTanggal) {
                  return Column(
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 15),
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(color: Color(0xFF1D2733).withOpacity(0.7), borderRadius: BorderRadius.circular(15)),
                        child: Text(_formatTanggalCapsule(chat["tanggal"]), style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500)),
                      ),
                      balonPesan, 
                    ],
                  );
                }
                return balonPesan;
              },
            ),
          ),
          
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

// ==========================================
// HALAMAN 3: PROFIL KONTAK (UPDATE TOMBOL BAWAH)
// ==========================================
class HalamanProfil extends StatelessWidget {
  final String namaKontak;
  HalamanProfil({required this.namaKontak});

  // Fungsi bantuan untuk mencetak tombol aksi (biar kodenya nggak berulang)
  Widget _buildIkonAksi(IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Color(0xFF182533), // Warna lingkaran sedikit lebih gelap dari header
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Color(0xFF5288C1), size: 26), // Ikon warna biru Tele
        ),
        SizedBox(height: 8),
        Text(
          label, 
          style: TextStyle(color: Color(0xFF5288C1), fontSize: 13, fontWeight: FontWeight.w500)
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0F1620), 
      appBar: AppBar(
        backgroundColor: Color(0xFF242F3D),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          // Ikon Call dan VC di atas sudah dihapus, sisa titik tiga saja
          IconButton(icon: Icon(Icons.more_vert, color: Colors.white), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          // Header Profil (Foto, Nama, Status, Tombol)
          Container(
            width: double.infinity,
            color: Color(0xFF242F3D), 
            padding: EdgeInsets.only(bottom: 20),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Color(0xFF5288C1),
                  child: Text(
                    namaKontak[0], 
                    style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold)
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  namaKontak,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                SizedBox(height: 5),
                Text(
                  "online",
                  style: TextStyle(fontSize: 16, color: Color(0xFF5288C1)),
                ),
                
                SizedBox(height: 25), // Jarak antara "online" dan deretan tombol
                
                // ==========================================
                // DERETAN TOMBOL AKSI: MESSAGE, MUTE, CALL, VC
                // ==========================================
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Jarak dibagi rata
                  children: [
                    _buildIkonAksi(Icons.chat_bubble_outline, "Message"),
                    _buildIkonAksi(Icons.notifications_off_outlined, "Mute"),
                    _buildIkonAksi(Icons.call_outlined, "Call"),
                    _buildIkonAksi(Icons.videocam_outlined, "Video"),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 10), 
          
          // Bagian Info (Nomor HP, Bio, dll)
          Container(
            color: Color(0xFF242F3D),
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.info_outline, color: Colors.grey[400]),
                  title: Text("+62 812-3456-7890", style: TextStyle(color: Colors.white, fontSize: 16)),
                  subtitle: Text("Mobile", style: TextStyle(color: Colors.grey[500], fontSize: 13)),
                ),
                Divider(height: 1, indent: 70, color: Colors.black26),
                ListTile(
                  leading: SizedBox(width: 24), 
                  title: Text("Lagi sibuk ngoding Flutter nih 🚀", style: TextStyle(color: Colors.white, fontSize: 16)),
                  subtitle: Text("Bio", style: TextStyle(color: Colors.grey[500], fontSize: 13)),
                ),
                Divider(height: 1, indent: 70, color: Colors.black26),
                ListTile(
                  leading: Icon(Icons.notifications_none, color: Colors.grey[400]),
                  title: Text("Notifications", style: TextStyle(color: Colors.white, fontSize: 16)),
                  trailing: Text("On", style: TextStyle(color: Color(0xFF5288C1), fontSize: 16)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}