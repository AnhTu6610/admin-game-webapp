import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:trival_admin/data_source/network_data/config/apisubdomain.dart';
import 'package:trival_admin/data_source/network_data/config/restclient.dart';

class CreateProductScreen extends StatefulWidget {
  const CreateProductScreen({Key? key}) : super(key: key);

  @override
  _CreateProductScreenState createState() => _CreateProductScreenState();
}

class _CreateProductScreenState extends State<CreateProductScreen> {
  RestClient rest = new RestClient(new Dio(), baseUrl: domainServer);
  GlobalKey<FormState> _keyForm = new GlobalKey<FormState>();
  TextEditingController _cateText = new TextEditingController();
  TextEditingController _nameText = new TextEditingController();
  TextEditingController _desText = new TextEditingController();
  bool _isLoadding = false;

  List<PlatformFile> _images = [];

  Future getImage() async {
    FilePickerResult? pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.any,
      allowMultiple: true,
    );

    setState(() {
      if (pickedFile?.files.first != null) {
        for (var i = 0; i < pickedFile!.files.length; i++) {
          _images.add(pickedFile.files[i]);
        }
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Form(
            key: _keyForm,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Text("Create product", style: Theme.of(context).textTheme.headline6),
                      Spacer(),
                      CloseButton(),
                    ],
                  ),
                  Divider(),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Flexible(
                        flex: 1,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _cateText,
                              decoration: InputDecoration(labelText: "Category"),
                            ),
                            TextFormField(
                              controller: _nameText,
                              decoration: InputDecoration(labelText: "Name"),
                            ),
                            TextFormField(
                              controller: _desText,
                              decoration: InputDecoration(labelText: "description"),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 20),
                      Flexible(
                        flex: 1,
                        child: Center(
                          child: Column(
                            children: [
                              Column(
                                children: List.generate(
                                  _images.length,
                                  (index) => Stack(
                                    alignment: Alignment.topRight,
                                    children: [
                                      Image.memory(
                                        _images[index].bytes!,
                                        height: 200,
                                      ),
                                      Container(
                                        color: Colors.white,
                                        margin: EdgeInsets.all(5),
                                        child: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              _images.removeAt(index);
                                            });
                                          },
                                          icon: Icon(Icons.delete_outline_outlined),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  getImage();
                                },
                                child: Container(
                                  color: Colors.grey.shade200,
                                  width: 160,
                                  height: 90,
                                  child: Icon(Icons.image_outlined),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        _isLoadding = true;
                      });
                      await rest
                          .createProduct(
                        category: _cateText.text,
                        name: _nameText.text,
                        description: _desText.text,
                        status: "success",
                        img: _images.map((e) => e.bytes!.toList()).toList(),
                      )
                          .catchError(
                        (Object obj) {
                          switch (obj.runtimeType) {
                            case DioError:
                              final res = (obj as DioError).response;
                              Logger().e("Got error : ${res?.statusCode} -> ${res?.statusMessage}");
                              break;
                            default:
                          }
                        },
                      ).then((value) {
                        if (value?.response.statusCode == 200) Navigator.pop(context, true);
                      });

                      setState(() {
                        _isLoadding = false;
                      });
                    },
                    child: Text("Submit"),
                  ),
                ],
              ),
            ),
          ),
        ),
        Visibility(
          visible: _isLoadding,
          child: Container(
            color: Colors.white30,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ),
      ],
    );
  }
}
