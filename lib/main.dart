import 'package:flutter/material.dart';
import 'package:flutter_application_3/helper.dart';
import 'package:gap/gap.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<List<Todo>> fetchData() async {
    final d = await DBHelper.fetchData();
    return d.map((e) => Todo.fromMap(e)).toList();
  }

  void insertData(String t) {
    setState(() {
      print(DBHelper.insertTodo(t));
    });
  }

  @override
  Widget build(BuildContext context) {
    var input = TextEditingController();
    return Scaffold(
      appBar: AppBar(title: Text("TODO")),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: input,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            Gap(5),
            ElevatedButton(
              onPressed: () {
                insertData(input.text);
              },
              child: Text("ADD"),
            ),
            Gap(10),
            Expanded(
              child: FutureBuilder(
                  future: fetchData(),
                  builder: (_, data) {
                    if (data.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }

                    if (data.data == null) {
                      return const Center(
                        child: Text("No todo"),
                      );
                    }

                    return ListView.builder(
                      itemCount: data.data!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Dismissible(
                          key: Key(data.data![index].id.toString()),
                          onDismissed: (_) {
                            setState(() {
                              DBHelper.delTodo(data.data![index]);
                            });
                          },
                          child: Card(
                            child: ListTile(
                              title: Text(data.data![index].name),
                            ),
                          ),
                        );
                      },
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
