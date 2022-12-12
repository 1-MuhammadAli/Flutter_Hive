import 'package:flutter/material.dart';
import 'package:flutter_hive/models/notes_model.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

import 'boxes/boxes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hive Database'),
      ),
      body: ValueListenableBuilder<Box<NotesModel>>(
        valueListenable: Boxes.getData().listenable(),
        builder: (context,box,_){
          var data = box.values.toList().cast<NotesModel>();
          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index){
              return Card(
                child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 15,horizontal: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(data[index].title.toString()),
                            Spacer(),
                            InkWell(
                              onTap: () {
                                delete(data[index]);
                              },
                                child: Icon(Icons.delete,color: Colors.red,)
                            ),
                            SizedBox(width: 15,),
                            InkWell(
                                onTap: () {
                                  _editDialog(data[index],
                                      data[index].title.toString(),
                                      data[index].description.toString(),
                                  );
                                },
                                child: Icon(Icons.edit,)),
                          ],
                        ),

                        Text(data[index].description.toString()),
                      ],
                    )
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async{
          _showMyDialog();

          // var box = await Hive.openBox('Ali');
          //
          // box.put('name', 'Ali');
          // box.put('age', 27);
          // box.put('detail', {
          //   'pro' : 'developer',
          //   'kash' : 'asdfasdf',
          // });
          //
          // print(box.get('name'));
          // print(box.get('age'));
          // print(box.get('detail')['pro']);

        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void delete(NotesModel notesModel) async{
    await notesModel.delete();
  }

   Future<void> _showMyDialog() async {

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(

            title: Text('Add NOTES'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: titleController,
                    decoration: InputDecoration(
                      hintText: 'Enter title',
                      border: OutlineInputBorder()
                    ),
                  ),
                  SizedBox(height: 20,),
                  TextFormField(
                    controller: descriptionController,
                    decoration: InputDecoration(
                        hintText: 'Enter description',
                        border: OutlineInputBorder()
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
              }, child: Text('Cancel')),
              TextButton(
                onPressed: () {
                  final data = NotesModel(
                      title: titleController.text,
                      description: descriptionController.text,
                  );

                  final box = Boxes.getData();
                  box.add(data);

                  //data.save();
                  titleController.clear();
                  descriptionController.clear();

                  print(box);

                  Navigator.pop(context);
                },
                child: Text('Add'),
              ),
            ],
          );
        },
    );
   }

  Future<void> _editDialog(NotesModel notesModel, String title,String description) async {

    titleController.text=title;
    descriptionController.text=description;

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(

          title: Text('Edit NOTES'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: titleController,
                  decoration: InputDecoration(
                      hintText: 'Enter title',
                      border: OutlineInputBorder()
                  ),
                ),
                SizedBox(height: 20,),
                TextFormField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                      hintText: 'Enter description',
                      border: OutlineInputBorder()
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                }, child: Text('Cancel')),
            TextButton(
              onPressed: () {

                notesModel.title=titleController.text.toString();
                notesModel.description=descriptionController.text.toString();

                notesModel.save();

                Navigator.pop(context);
              },
              child: Text('Edit'),
            ),
          ],
        );
      },
    );
  }
}
