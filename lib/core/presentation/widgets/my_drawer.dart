import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
           DrawerHeader(
            child: Center(
              child: Row (
                children:[
                  Image.asset('assets/logos/v_viveris_noir.png',height: 40),
                  SizedBox(width:8),
                  Text("Oikos Admin", style: TextStyle(fontSize: 20)),

                ]
              
              )
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text("Vue Globale"),
            onTap: () {
              context.go('/');
              Navigator.pop(context); // Ferme le drawer
            },
          ),
          ListTile(
            leading: const Icon(Icons.people),
            title: const Text("Communauté"),
            onTap: () {
              context.go('/community') ;
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
