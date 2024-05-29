
import 'package:flutter/material.dart';
import 'package:get_api_sederhana/detail_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, String>> users = [];
  Map<String, String>? specificUser;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
    _loadSpecificUser();
  }

  Future<void> _loadData() async {
    var url = Uri.parse("https://reqres.in/api/users");
    var response = await http.get(url);
    var data = jsonDecode(response.body)['data'] as List;

    setState(() {
      users = data
          .map<Map<String, String>>((user) => {
                'id': user['id'].toString(),
                'first_name': user['first_name'],
                'last_name': user['last_name'],
                'avatar': user['avatar'],
                'email': user['email']
              })
          .toList();
      isLoading = false;
    });
  }

  Future<void> _loadSpecificUser() async {
    var url = Uri.parse("https://reqres.in/api/users/10");
    var response = await http.get(url);
    var data = jsonDecode(response.body)['data'];

    setState(() {
      specificUser = {
        'id': data['id'].toString(),
        'first_name': data['first_name'],
        'last_name': data['last_name'],
        'avatar': data['avatar'],
        'email': data['email']
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(widget.title),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "GET SEMUA PENGGUNA",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(child: UserListView(users: users)),
                if (specificUser != null) ...[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "GET SESUAI ID",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(specificUser!['avatar']!),
                    ),
                    title: Text(
                        '${specificUser!['first_name']} ${specificUser!['last_name']}'),
                    subtitle: Text('ID: ${specificUser!['id']}'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                DetailPage(user: specificUser!)),
                      );
                    },
                  ),
                ],
              ],
            ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(builder: (context) => const TambahPengguna()),
      //     );
      //   },
      //   tooltip: 'Tambah Pengguna',
      //   child: const Icon(Icons.add),
      // ),
    );
  }
}

class UserListView extends StatelessWidget {
  final List<Map<String, String>> users;

  const UserListView({Key? key, required this.users}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        return Card(
          elevation: 3,
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(users[index]['avatar']!),
            ),
            title: Text(
                '${users[index]['first_name']} ${users[index]['last_name']}'),
            subtitle: Text('ID: ${users[index]['id']}'),
            // onTap: () {
            //   Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //         builder: (context) => DetailPage(user: users[index])),
            //   );
            // },
          ),
        );
      },
    );
  }
}
