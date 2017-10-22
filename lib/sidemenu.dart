import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import './router.dart';
import './models.dart';

class SideMenu extends StatelessWidget {
  Peer me;

  SideMenu(this.me);

  @override
  Widget build(BuildContext context) {
    if (me == null) {
      return new ListView(
        children: <Widget>[
          new DrawerHeader(
            child: new Text('anonymous'),
          ),
          new ListTile(
            leading: new Icon(FontAwesomeIcons.google),
            title: new Text('login with your Google account'),
            onTap: () {
              R.navigateTo(
                context,
                "/login",
                transition: TransitionType.fadeIn,
              );
            },
          ),
        ],
      );
    }

    return new ListView(
      children: <Widget>[
        new DrawerHeader(
          child: new Text('logged in as ' + me.id),
        ),
      ],
    );
  }
}
