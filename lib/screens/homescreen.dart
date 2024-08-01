import 'package:flutter/material.dart';
import 'package:itumes/screens/homemodel.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {

  bool isConnected = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkConnectivity((value) => setState(() => isConnected = value));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      bottomSheet: isConnected ? notFound(context) : null,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leadingWidth: 0,
        toolbarHeight: 100,
        title: TextFormField(
          controller: controller,
          cursorColor: Colors.white,
          onChanged: (_){
            setState(() {});
          },
          decoration: const InputDecoration(
            hintText: " search song/movie...",
            hintStyle: TextStyle(color: Colors.white),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white)
            ),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white)
            ),
          ),
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [

            FutureBuilder<Map<String,dynamic>>(
              future: get(controller.text,"song"),
              builder: (context,snap){
                if(!(snap.data != null && snap.data!.isNotEmpty)){
                  return const Center(child: Text("Type some thing"));
                }
                return Column(
                  children: [
                    tag(context, "Song"),
                    suggestionWidget(snap.data ?? {})
                  ],
                );
              },
            ),

            FutureBuilder<Map<String,dynamic>>(
              future: get(controller.text,"movie"),
              builder: (context,snap){
                if(!(snap.data != null && snap.data!.isNotEmpty)){
                  return const Center(child: Text("Type some thing"));
                }
                return Column(
                  children: [
                    tag(context, "Movie"),
                    suggestionWidget(snap.data ?? {})
                  ],
                );
              },
            ),

          ],
        ),
      ),
    );
  }

  TextEditingController controller = TextEditingController();

}
