import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groceteria/viewmodel.dart';
import 'package:provider/provider.dart';
import 'additem.dart';
import 'firebase_options.dart';


Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [

        ChangeNotifierProvider<ItemViewModel>(create: (_) => ItemViewModel()),


      ],

      child:
      GetMaterialApp(

        debugShowCheckedModeBanner: false,
        initialRoute: "AdminAddItems",
        routes: {
          "AdminAddItems": (context) => AdminAddItems(),
        }
      ),
    );


  }
}
