import 'dart:convert' show JSON;

import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;

import './router.dart';
import './models.dart';
import './db.dart';

GoogleSignIn _googleSignIn = new GoogleSignIn(
  scopes: [
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);

class SideMenu extends StatelessWidget {
  Peer me;

  SideMenu(Peer me, {void setLoggedUser(Peer logged), void getPeers()}) {
    this.me = me;

    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) async {
      if (account == null) {
        setLoggedUser(null);
      } else {
        setLoggedUser(new Peer(id: account.id));

        final http.Response response = await http.get(
          'https://people.googleapis.com/v1/people/me/connections'
            '?personFields=names,emailAddresses',
          headers: await account.authHeaders,
        );

        if (response.statusCode != 200) {
          print('People API ${response.statusCode} response: ${response.body}');
          return;
        }

        final Map<String, dynamic> data = JSON.decode(response.body);
        print(data);

        final Database db = await getDB();

        try {
          await db.inTransaction(() async {
            data['connections']
              .where((Map<String, dynamic> contact) =>
                contact['emailAddresses'] != null
                  ? contact['emailAddresses'].length > 0
                  : false
              )
              .where((Map<String, dynamic> contact) =>
                contact['names'] != null
                  ? contact['names'].length > 0
                  : false
              )
              .forEach((Map<String, dynamic> contact) {
                db.insert('contacts', <String, dynamic>{
                  'account': contact['emailAddresses'][0]['value'],
                  'name': contact['names'][0]['displayName'],
                });
              });
          });
        } catch (err) {
          print(err);
        }

        getPeers();
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
