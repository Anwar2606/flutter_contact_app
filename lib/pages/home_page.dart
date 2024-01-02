// import 'package:contact_manager/pages/add_contact_page.dart';
// import 'package:flutter/material.dart';
// import 'package:iconly/iconly.dart';

// class HomePage extends StatelessWidget {
//   const HomePage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Contact Manager"),
//       ),
//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: () {
//           Navigator.push(context,
//               MaterialPageRoute(builder: (context) => const AddContactPage()));
//         },
//         label: const Text("Add contact"),
//         icon: const Icon(IconlyBroken.document),
//       ),
//     );
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contact_manager/main.dart';
import 'package:contact_manager/pages/add_contact_page.dart';
import 'package:contact_manager/pages/edit_contact_page.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final contactsCollectio =
      FirebaseFirestore.instance.collection("contacts").snapshots();

  void deleteContact(String id) async {
    await FirebaseFirestore.instance.collection("contacts").doc(id).delete();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Contact deleted'),
        backgroundColor: Colors.red[300],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Contacts"),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: contactsCollectio,
          builder: (BuildContext context, snapshot) {
            if (snapshot.hasData) {
              final List<QueryDocumentSnapshot> documents = snapshot.data!.docs;
              if (documents.isEmpty) {
                return Center(
                  child: Text(
                    "No Contact Yet!",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                );
              }
              return ListView.builder(
                itemCount: documents.length,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  final contactId = documents[index].id;
                  final contact =
                      documents[index].data() as Map<String, dynamic>;
                  final String name = contact['name'];
                  final String phone = contact['phone'];
                  final String email = contact['email'];
                  final String avatar =
                      "https://avatars.dicebear.com/api/avataaars/$name.png";
                  return ListTile(
                    onTap: () {},
                    leading: Hero(
                      tag: contactId,
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(
                            "https://images.unsplash.com/photo-1597466765990-64ad1c35dafc"),

                        // NetworkImage('https://via.placeholder.com/150'),
                        //  NetworkImage("${snapshot.data.hitsL[index].previewUrl}"),
                        // child: Image.asset("assets/images/avatar3.jpg"),
                      ),
                    ),
                    title: Text(name),
                    subtitle: Text("$phone \n$email"),
                    isThreeLine: true,
                    //  trailing should be delete and edit button
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditContactPage(
                                  id: contactId,
                                  name: name,
                                  phone: phone,
                                  email: email,
                                ),
                              ),
                            );
                          },
                          splashRadius: 24,
                          icon: const Icon(IconlyBroken.edit),
                        ),
                        IconButton(
                          onPressed: () {
                            deleteContact(contactId);
                          },
                          splashRadius: 24,
                          icon: const Icon(IconlyBroken.delete),
                        ),
                      ],
                    ),
                  );
                },
              );
            }
            if (snapshot.hasError) {
              return const Center(
                child: Text("An Error Occured"),
              );
            }
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddContactPage(),
            ),
          );
        },
        label: const Text("Add Contact"),
        icon: const Icon(IconlyBroken.document),
      ),
    );
  }
}
