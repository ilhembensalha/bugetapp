
import 'package:flutter/material.dart';
import 'package:login_with_signup/DatabaseHandler/DbHelper.dart';
import 'package:login_with_signup/Screens/page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'CategoriePage.dart';
import 'HomeForm.dart';
import 'LoginForm.dart';



class HomePage extends StatefulWidget {

  const HomePage({key  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class  _HomePageState extends State<HomePage>{
 DbHelper dbHelper;
  // All journals
  List<Map<String, dynamic>> _journals = [];
     Future<SharedPreferences> _pref = SharedPreferences.getInstance();
  

  bool _isLoading = true;
  // This function is used to fetch all data from the database
  void _refreshJournals() async {
    final data = await dbHelper.getTran();
    setState(() {
      _journals = data;
      _isLoading = false;
    });
  }
    Future<double> total() async {
    final data = await dbHelper.getTotalMontant();
   return data ;
  }

  @override
  void initState() {
    super.initState();
        dbHelper = DbHelper();
    _refreshJournals(); // Loading the diary when the app starts
  }

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _prixController = TextEditingController();
  // This function will be triggered when the floating button is pressed
  // It will also be triggered when you want to update an item
  void _showForm(int  id) async {
    if (id != null) {
      // id == null -> create new item
      // id != null -> update an existing item
      final existingJournal =
      _journals.firstWhere((element) => element['id'] == id);
      _nameController.text = existingJournal['name'];
      _prixController.text = existingJournal['prix'];
      _descriptionController.text = existingJournal['description'];
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
                controller: _descriptionController,

                decoration: const InputDecoration(hintText: 'Description'),
              ),
              
              const SizedBox(
                height: 20,
              ), TextField(
                controller: _prixController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(hintText: 'prix'),
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
                  _descriptionController.text = '';
                  _prixController.text = '';

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
    await  dbHelper.createTran(
        _nameController.text, _descriptionController.text,_prixController.text );
    _refreshJournals();
  }

  // Update an existing journal
  Future<void> _updateItem(int id) async {
    await dbHelper.updateTran(
        id,_nameController.text, _descriptionController.text,_prixController.text  );
    _refreshJournals();
  }

  // Delete an item
  void _deleteItem(int id) async {
   await dbHelper.deleteTran(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Successfully deleted a journal!'),
    ));
    _refreshJournals();
  }




  @override

  Widget build(BuildContext context) {
     Future<SharedPreferences> _pref = SharedPreferences.getInstance();
    return Scaffold(
      appBar: AppBar(
        title: Text(' Home '),
      ),
     /* body: SafeArea(
          child:CustomScrollView(
           
                  slivers: [
                    SliverToBoxAdapter(
                      child: SizedBox(height: 340, child: _head()),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Transactions History',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 19,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              'See all',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),]
          )),*/
            body:_isLoading
               ? const Center(
             child: CircularProgressIndicator(),
           )
               :  
            ListView.builder(
             itemCount: _journals.length,
             itemBuilder: (context, index) => Card(
               color: Colors.orange[200],
               margin: const EdgeInsets.all(15),
               child: ListTile(
                   title: Text(_journals[index]['name']),
                    subtitle: Text(_journals[index]['description']),
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
                Navigator.pop(context);
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
    Widget _head() {
    return Stack(
      children: [
        Column(
          
          children: [
            Container(
              width: double.infinity,
              height: 240,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 47, 116, 226),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 35,
                    left: 340,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(7),
                      child: Container(
                        height: 40,
                        width: 40,
                        color: Color.fromRGBO(66, 60, 243, 0.951),
                        child: Icon(
                          Icons.notification_add_outlined,
                          size: 30,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 35, left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Good afternoon',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Color.fromARGB(255, 224, 223, 223),
                          ),
                        ),
                        Text(
                          'Dear User',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
        Positioned(
          top: 140,
          left: 37,
          child: Container(
            height: 170,
            width: 320,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(63, 63, 244, 1),
                  offset: Offset(0, 6),
                  blurRadius: 12,
                  spreadRadius: 6,
                ),
              ],
              color: Color.fromARGB(255, 8, 40, 222),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Balance',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      Icon(
                        Icons.more_horiz,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 7),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Row(
                    children: [
                      Text(
                        '\$ 2500',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 13,
                            backgroundColor: Color.fromARGB(255, 43, 50, 186),
                            child: Icon(
                              Icons.arrow_downward,
                              color: Colors.white,
                              size: 19,
                            ),
                          ),
                          SizedBox(width: 7),
                          Text(
                            'Income',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: Color.fromARGB(255, 216, 216, 216),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 13,
                            backgroundColor: Color.fromARGB(255, 43, 50, 186),
                            child: Icon(
                              Icons.arrow_upward,
                              color: Colors.white,
                              size: 19,
                            ),
                          ),
                          SizedBox(width: 7),
                          Text(
                            'Expenses',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: Color.fromARGB(255, 216, 216, 216),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 6),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$ 2500',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 17,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '\$ 1200',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 17,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        )
      ],
      
    );
    
  }
}

