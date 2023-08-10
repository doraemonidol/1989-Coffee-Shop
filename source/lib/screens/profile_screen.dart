import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import '../providers/auth.dart';
import '../providers/user.dart';
import '../providers/music_player.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Future _profileFuture = Future.value();

  final label = [
    'Full name',
    'Email',
    'Phone number',
    'Address',
  ];

  @override
  void initState() {
    Provider.of<MusicPlayer>(context, listen: false)
        .playSong('sounds/WonderlandInstrumental.mp3');
    _profileFuture = Future.delayed(Duration.zero).then((_) {
      Provider.of<User>(context, listen: false).fetchAndSetUser(context);
    });
    super.initState();
  }

  Widget _buildEditField(
      BuildContext context, String title, String value, IconData icon) {
    final _deviceSize = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            padding: EdgeInsets.all(10),
            child: Icon(icon),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(100),
            ),
          ),
          const SizedBox(width: 15),
          Container(
            width: _deviceSize.width * 0.6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        color: Colors.grey,
                      ),
                ),
                Text(
                  value,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onBackground,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.edit_outlined),
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  content: TextField(
                    autofocus: true,
                    decoration: InputDecoration(
                      labelText: title,
                    ),
                    controller: TextEditingController(
                        text: (value == 'Unknown' || value == 'You Guys')
                            ? ''
                            : value),
                    onChanged: (newValue) => value = newValue,
                    keyboardType: title == label[2]
                        ? TextInputType.number
                        : TextInputType.text,
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                      child: Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        print(value);
                        if (title == label[0])
                          Provider.of<User>(context, listen: false)
                              .updateUser(newName: value);
                        else if (title == label[1])
                          Provider.of<User>(context, listen: false)
                              .updateUser(newEmail: value);
                        else if (title == label[2])
                          Provider.of<User>(context, listen: false)
                              .updateUser(newPhoneNumber: value);
                        else if (title == label[3])
                          Provider.of<User>(context, listen: false)
                              .updateUser(newAddress: value);
                        Navigator.of(ctx).pop();
                      },
                      child: Text('Save'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: _profileFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            print(snapshot.error);
            if (snapshot.error != null) {
              return Center(child: Text('An error occurred!'));
            } else {
              return Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  _buildEditField(context, label[0],
                      Provider.of<User>(context).name, Icons.person_outline),
                  _buildEditField(context, label[1],
                      Provider.of<User>(context).email, Icons.email_outlined),
                  _buildEditField(
                      context,
                      label[2],
                      Provider.of<User>(context).phoneNumber,
                      Icons.phone_outlined),
                  _buildEditField(
                      context,
                      label[3],
                      Provider.of<User>(context).address,
                      Icons.location_on_outlined),
                  TextButton(
                    onPressed: () {
                      Provider.of<Auth>(context, listen: false).logout();
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).colorScheme.error,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'Log out',
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  color: Theme.of(context).colorScheme.error,
                                ),
                      ),
                    ),
                  )
                ],
              );
            }
          }
        },
      ),
    );
  }
}
