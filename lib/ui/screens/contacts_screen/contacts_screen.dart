import 'package:flutter/material.dart';
import 'package:flutter_chat_app/data/repos/contacts_repo.dart';
import 'package:flutter_chat_app/data/services/db_service.dart';
import 'package:flutter_chat_app/ui/custom_widgets/search_text_field.dart';
import 'package:flutter_chat_app/ui/components/themes/themes.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:get/get.dart';

class Contacts extends StatefulWidget {
  const Contacts({super.key});

  @override
  State<Contacts> createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  bool isSelected = false;
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.kscaffoldColor,
      appBar: AppBar(
        backgroundColor: CustomColors.kscaffoldColor,
        toolbarHeight: 80,
        elevation: 0,
        notificationPredicate: ((notification) => notification.depth == 0),
        centerTitle: true,
        title: isSelected == false
            ? const Text(
                'Select Contacts',
                style: TextStyle(color: CustomColors.kblackcolor, fontSize: 18),
              )
            : SearchTextFiled(
                hintText: 'Search Contacts',
                controller: controller,
                onchanged: (value) {
                  setState(() {});
                },
              ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isSelected = !isSelected;
                });
              },
              child: const Icon(
                Icons.search,
                color: CustomColors.kblackcolor,
              ),
            ),
          ),
          SizedBox(
            width: Get.width * 0.03,
          )
        ],
      ),
      body: Container(
        margin: const EdgeInsets.all(15),
        child: Column(
          children: [
            FutureBuilder(
                future: ContactsRepo().getContacts(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<Contact>? mycontacts = snapshot.data;
                    mycontacts = mycontacts!
                        .where((element) => element.displayName
                            .toLowerCase()
                            .replaceAll(' ', '')
                            .startsWith(controller.text))
                        .toList();
                    return Flexible(
                        child: ListView.builder(
                            itemCount: mycontacts.length,
                            itemBuilder: ((context, index) {
                              var contacts = mycontacts![index];
                              return InkWell(
                                onTap: (() {
                                  ContactsRepo()
                                      .selectContacts(contacts, context);
                                }),
                                child: ListTile(
                                  leading: contacts.photo != null
                                      ? CircleAvatar(
                                          backgroundColor:
                                              const Color(0xFF87C8EE),
                                          child: Image.memory(contacts.photo!))
                                      : const CircleAvatar(
                                          backgroundColor: Color(0xFF87C8EE),
                                          child: Icon(
                                            Icons.person,
                                            color: CustomColors.kwhiteColor,
                                          ),
                                        ),
                                  subtitle: Title(
                                      color: CustomColors.kblackcolor,
                                      child: const Text('')),
                                  title: Title(
                                      color: CustomColors.ktextColor2,
                                      child: Text(contacts.displayName)),
                                  contentPadding: const EdgeInsets.all(10),
                                  trailing: FutureBuilder(
                                      future: DBservice().checkIfNumberExists(
                                          contacts.phones[0].number),
                                      builder: (context, snapshot) {
                                        return snapshot.data == true
                                            ? const Icon(Icons.message)
                                            : const Text('INVITE');
                                      }),
                                ),
                              );
                            })));
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                })
          ],
        ),
      ),
    );
  }
}
