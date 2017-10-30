import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

import './router.dart';
import './models.dart';

GoogleSignIn _googleSignIn = new GoogleSignIn(
  scopes: [
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);

class SideMenu extends StatelessWidget {
  Peer me;

  SideMenu(Peer me, {void setLoggedUser(Peer logged)}) {
    this.me = me;

    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      if (account == null) {
        setLoggedUser(null);
      } else {
        setLoggedUser(new Peer(id: account.id));
      }
    });
    _googleSignIn.signInSilently();
  }

  @override
  Widget build(BuildContext context) {
    Widget body;

    if (me == null) {
      body = new ListView(
        children: <Widget>[
          new DrawerHeader(
            child: new Text('anonymous'),
          ),
          new ListTile(
            leading: new Icon(FontAwesomeIcons.google),
            title: new Text('Login with your Google account'),
            onTap: () async {
              try {
                await _googleSignIn.signIn();
              } catch (err) {
                print(err);
              }
            },
          ),
        ],
      );
    } else {
      body = new ListView(
        children: <Widget>[
          new DrawerHeader(
            child: new Text('Logged in as ' + me.id),
          ),
          new ListTile(
            leading: new Icon(FontAwesomeIcons.google),
            title: new Text('Logout'),
            onTap: () async {
              try {
                await _googleSignIn.disconnect();
              } catch (err) {
                print(err);
              }
            },
          ),
        ],
      );
    }

    return new Drawer(child: body);
  }
}
