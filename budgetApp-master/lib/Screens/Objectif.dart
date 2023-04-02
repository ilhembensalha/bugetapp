import 'package:flutter/material.dart';
import 'package:login_with_signup/DatabaseHandler/DbHelper.dart';
import 'package:login_with_signup/Screens/CategoriePage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'HomeForm.dart';
import 'LoginForm.dart';
import 'homePage.dart';
import 'page.dart';


class ObjectifPage extends StatefulWidget {
  const ObjectifPage({Key key}) : super(key: key);

  @override
  _ObjectifPageState createState() => _ObjectifPageState();
}


class  _ObjectifPageState extends State<ObjectifPage>{
    DbHelper dbHelper;
  // All journals
  List<Map<String, dynamic>> _journals = [];
     Future<SharedPreferences> _pref = SharedPreferences.getInstance();
  

  bool _isLoading = true;
  // This function is used to fetch all data from the database
  void _refreshJournals() async {
    final data = await dbHelper.getObj();
    setState(() {
      _journals = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
        dbHelper = DbHelper();
    _refreshJournals(); // Loading the diary when the app starts
  }

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _sommeController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  // This function will be triggered when the floating button is pressed
  // It will also be triggered when you want to update an item
  void _showForm(int  id) async {
    if (id != null) {
      // id == null -> create new item
      // id != null -> update an existing item
      final existingJournal =
      _journals.firstWhere((element) => element['id'] == id);
      _nameController.text = existingJournal['name'];
      _typeController.text = existingJournal['type'];
      _sommeController.text = existingJournal['somme'].toString();
    }

    showModalBottomSheet(
        context: context,
        elevation: 5,
        isScrollControlled: true,
        builder: (_) => Container(
          padding: EdgeInsets.only(
            top: 15,
            left: 15,
            right: 15,
            // this will prevent the soft keyboard from covering the text fields
            bottom: MediaQuery.of(context).viewInsets.bottom + 120,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(hintText: 'name'),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: _sommeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(hintText: 'somme'),
              ),
              
              const SizedBox(
                height: 20,
              ), TextField(
                controller: _typeController,
                decoration: const InputDecoration(hintText: 'type'),
              ), 
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () async {
                  // Save new journal
                  if (id == null) {
                    await _addItem();
                  }

                  if (id != null) {
                    await _updateItem(id);
                  }

                  // Clear the text fields
                  _nameController.text = '';
                  _sommeController.text = '';
                  _typeController.text = '';

                  // Close the bottom sheet
                  Navigator.of(context).pop();
                },
                child: Text(id == null ? 'Create New' : 'Update'),
              )
            ],
          ),
        ));
  }

// Insert a new journal to the database
  Future<void> _addItem() async {
    await  dbHelper.createObj(
        _nameController.text,_typeController.text, _sommeController.text );
    _refreshJournals();
  }

  // Update an existing journal
  Future<void> _updateItem(int id) async {
    await dbHelper.updateCat(
        id,_nameController.text, _sommeController.text,_typeController.text);
    _refreshJournals();
  }

  // Delete an item
  void _deleteItem(int id) async {
   await dbHelper.deleteCat(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Successfully deleted a journal!'),
    ));
    _refreshJournals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Objectif'),
      ),
      body: _isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : ListView.builder(
        itemCount: _journals.length,
        itemBuilder: (context, index) => Card(
          color: Colors.orange[200],
          margin: const EdgeInsets.all(15),
          child: ListTile(
              title: Text(_journals[index]['name']),
               subtitle: Text(_journals[index]['type']),
              trailing: SizedBox(
                width: 100,
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _showForm(_journals[index]['id']),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () =>
                          _deleteItem(_journals[index]['id']),
                    ),
                  ],
                ),
              )),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showForm(null),
      ),
          drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'menu',
                style: TextStyle(fontSize: 20),
              ),
            ),
              ListTile(
              leading: Icon(Icons.workspace_premium),
              title: const Text(' Home '),
              onTap: () {
                 Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (_) => HomePage()),
                                (Route<dynamic> route) => false);
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: const Text(' My Profile '),
              onTap: () {
                  Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (_) => HomeForm()),
                                (Route<dynamic> route) => false);
              },
            ),
            ListTile(
              leading: Icon(Icons.book),
              title: const Text('tansactions'),
              onTap: () {
              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (_) => page()),
                                (Route<dynamic> route) => false);
              },
            ),
            ListTile(
              leading: Icon(Icons.workspace_premium),
              title: const Text(' categories '),
              onTap: () {
                 Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (_) => CategoriePage()),
                                (Route<dynamic> route) => false);
              },
            ),
            ListTile(
              leading: Icon(Icons.video_label),
              title: const Text(' objectif '),
              onTap: () {
                 Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (_) => ObjectifPage()),
                                (Route<dynamic> route) => false);
              },
            ),
          
            ListTile(
              leading: Icon(Icons.logout),
              title: const Text('LogOut'),
              onTap: () async {
                   final SharedPreferences sp = await _pref;
                 sp.remove('user_id');
      sp.remove('user_name');
      sp.remove('email');
      sp.remove('password');
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => LoginForm()),
              (Route<dynamic> route) => false);
              },
            ),
          ],
        ),
      ),
    );
  }
}