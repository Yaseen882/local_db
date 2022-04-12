import 'package:database_practise_flutter/domain/model/product.dart';
import 'package:database_practise_flutter/presentation/conception.dart';
import 'package:database_practise_flutter/repository/product_db_client.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

import '../main.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  TextEditingController? _controllerId;
  TextEditingController? _controllerName;
  TextEditingController? _controllerPrice;
  int id = 0;
  String name = '';
  String hintName = 'Name';
  int hintId = 0;
  String hintConception = 'Conception';
  String flowText = '';
  String conception = '';
  double price = 0.0;
  Widget appBar = const Text('Product');
  Icon? _icon = const Icon(Icons.search);
  List<Product> searchList = [];
  final TextEditingController _controller = TextEditingController();
  String _searchText = '';

  _MyAppState() {
    _controller.addListener(() {
      if (_controller.text.isEmpty) {
        setState(() {
          _searchText = "";
        });
      } else {
        setState(() {
          _searchText = _controller.text;
          print(
              '..............MyHomePage Called.....................$_searchText');
        });
      }
    });
  }

  String searchText = '';

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print(
          '..............................Search Text Build ...................$searchText');
    }
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.grey,
        appBar: buildAppBar(context),
        body: searchText.isNotEmpty
            ? FutureBuilder<List<Product>>(
                future: ProductDBClient().fetchProducts(),
                builder: (context, snapshot) {
                  searchList.clear();
                  if (kDebugMode) {
                    print(
                        '..............................future builder is called ...................${searchList.length}');
                  }
                  for (int i = 0; i < snapshot.data!.length; i++) {

                    Product data = snapshot.data![i];
                    if (data.toString().toLowerCase().contains(searchText.toLowerCase())) {
                      searchList.add(data);
                      if (kDebugMode) {
                        print('..............................searchList ...................${searchList.length}');
                      }

                    } /*else {
                      if(data.toString().toLowerCase() != data.toString().toLowerCase().contains(searchText.toLowerCase()) ){
                        return const Center(child: Text('Does not match'));
                      }

                    }*/
                  }
                  return ListView.builder(
                    itemBuilder: (context, index) {
                      Product item = searchList[index];
                      return GestureDetector(
                        onLongPress: () {
                          setState(() {
                            hintName = item.name;
                            hintConception = item.conception;
                            hintId = item.id;
                          });
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Column(
                                  children: [
                                    TextField(
                                      keyboardType: TextInputType.number,
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      controller: _controllerId,
                                      onChanged: (value) {
                                        id = int.parse(value);
                                      },
                                      decoration:  InputDecoration(hintText: '$hintId'),
                                    ),
                                    TextField(
                                      keyboardType: TextInputType.text,
                                      controller: _controllerName,
                                      autofocus: true,
                                      decoration:  InputDecoration(hintText: hintName),
                                      onChanged: (value) {
                                        name = value;
                                      },
                                    ),
                                    TextField(
                                      controller: _controllerPrice,
                                      keyboardType: TextInputType.text,
                                      autofocus: true,
                                      //inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.allow(filterPattern)],
                                      decoration:  InputDecoration(hintText: hintConception),
                                      onChanged: (value) {
                                        conception = value;
                                      },
                                    ),
                                  ],
                                ),
                                actions: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      print('..........._controllerId.........$id');
                                      ProductDBClient().updateProduct(
                                        Product(
                                          id: id,
                                          name: name,
                                          conception: conception,
                                        ),
                                      );
                                      Navigator.pop(context);

                                      setState(() {});
                                    },
                                    child: const Text('Update'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        onTap: () {
                          flowText = item.name;
                          conception = item.conception;
                          debugPrint('..........................Flow Text..........................$flowText');
                          Navigator.push(context, MaterialPageRoute(builder: (context) =>  Prediction(txt: flowText,conception: conception),));
                        },
                        child: Card(
                          child: ListTile(
                            leading: const CircleAvatar(child: Icon(Icons.person)),
                            title: Text(item.name),
                           // subtitle: Text(item.conception.toString()),
                            trailing: TextButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text('Alert!'),
                                        content: const Text('You Want To Delete'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              ProductDBClient()
                                                  .deleteProduct(item);
                                              Navigator.pop(context);
                                              setState(() {

                                              });

                                            },
                                            child: const Text('Yes'),
                                          ),
                                        ],
                                      );

                                    },
                                  );
                                },
                                child: const Icon(Icons.delete)),
                          ),
                        ),
                      );
                    },
                    itemCount: searchList.length,
                  );
                },
              )
            : FutureBuilder<List<Product>>(
                future: ProductDBClient().fetchProducts(),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemBuilder: (context, index) {
                        Product item = snapshot.data[index];

                        return GestureDetector(
                          onLongPress: () {
                           setState(() {
                             hintName = item.name;
                             hintConception = item.conception;
                             hintId = item.id;
                           });
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Column(
                                    children: [
                                      TextField(
                                        keyboardType: TextInputType.number,
                                        inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                        controller: _controllerId,
                                        onChanged: (value) {
                                          id = int.parse(value);
                                        },
                                        decoration:  InputDecoration(hintText: '$hintId'),
                                      ),
                                      TextField(
                                        keyboardType: TextInputType.text,
                                        controller: _controllerName,
                                        autofocus: true,
                                        decoration:  InputDecoration(hintText: hintName),
                                        onChanged: (value) {
                                          name = value;
                                        },
                                      ),
                                      TextField(
                                        controller: _controllerPrice,
                                        keyboardType: TextInputType.text,
                                        autofocus: true,
                                        //inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.allow(filterPattern)],
                                        decoration:  InputDecoration(hintText: hintConception),
                                        onChanged: (value) {
                                          conception = value;
                                        },
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Cancel'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        print('..........._controllerId.........$id');
                                        ProductDBClient().updateProduct(
                                          Product(
                                            id: id,
                                            name: name,
                                            conception: conception,
                                          ),
                                        );
                                        Navigator.pop(context);

                                        setState(() {});
                                      },
                                      child: const Text('Update'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          onTap: () {
                            flowText = item.name;
                            conception = item.conception;
                            debugPrint('..........................Flow Text..........................$flowText');
                            Navigator.push(context, MaterialPageRoute(builder: (context) =>  Prediction(txt: flowText,conception: conception),));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              child: ListTile(
                                leading: const CircleAvatar(child: Icon(Icons.person)),
                                title: Text(item.name),
                                //subtitle: Text(item.price.toString()),
                                trailing: TextButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: const Text('Alert!'),
                                            content:
                                                const Text('You Want To Delete'),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('Cancel'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  ProductDBClient()
                                                      .deleteProduct(item);
                                                  setState(() {});
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('Yes'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: const Icon(Icons.delete)),
                              ),
                            ),
                          ),
                        );
                      },
                      itemCount: snapshot.data?.length,
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            dialogShow();
          },
          child: const Icon(Icons.add),
          tooltip: 'Insert',
        ),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: appBar,
      actions: [
        IconButton(
            onPressed: () {
              setState(() {
                if (_icon?.icon == Icons.search) {
                  _icon = const Icon(
                    Icons.close,
                    color: Colors.white,
                  );
                  appBar = TextField(
                    onChanged: (value) {
                      searchOperation(value);
                    },
                    showCursor: true,
                    cursorColor: Colors.white,
                    autofocus: true,
                    decoration: const InputDecoration(
                      hintText: 'Search...',
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(32.0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.lightBlueAccent, width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(32.0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.lightBlueAccent, width: 2.0),
                        borderRadius: BorderRadius.all(Radius.circular(32.0)),
                      ),
                    ),
                  );
                } else {
                  _handleSearch();
                  Phoenix.rebirth(context);
                }
              });
            },
            icon: _icon!),
      ],
    );
  }

  void _handleSearch() {
    setState(() {
      _icon = const Icon(Icons.search);
      appBar = const Text('Products');

    });
    _controller.clear();
  }

  void searchOperation(String searchTextValue) {
    if (kDebugMode) {
      print(
          '..............................product ...................$searchText');
    }
    setState(() {
      searchText = searchTextValue;
    });
  }

  void dialogShow() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Column(
            children: [
              TextField(
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                controller: _controllerId,
                onChanged: (value) {
                  id = int.parse(value);
                },
                decoration: const InputDecoration(hintText: 'CLIENT ID'),
              ),
              TextField(
                keyboardType: TextInputType.text,
                controller: _controllerName,
                decoration: const InputDecoration(hintText: 'Name'),
                onChanged: (value) {
                  name = value;
                },
              ),
              TextField(
                controller: _controllerPrice,
                keyboardType: TextInputType.text,
                //inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.allow(filterPattern)],
                decoration: const InputDecoration(hintText: 'Conception'),
                onChanged: (value) {
                  conception = value;
                },
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                print('..........._controllerId.........$id');
               setState(() {
                 ProductDBClient().insertProduct(
                   Product(
                     id: id,
                     name: name,
                     conception: conception,
                   ),
                 );
               });
                print('..................inserted..............');
                Navigator.pop(context);
              },
              child: const Text('Insert'),
            ),
            ElevatedButton(
              onPressed: () {
                print('..........._controllerId.........$id');
                ProductDBClient().updateProduct(
                  Product(
                    id: id,
                    name: name,
                    conception: conception,
                  ),
                );
                Navigator.pop(context);

                setState(() {});
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }
}
