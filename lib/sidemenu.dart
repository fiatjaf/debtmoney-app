import 'dart:convert' show JSON;
import 'dart:async';

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

  SideMenu(Peer me, {void getLoggedUser(), void getPeers()}) {
    this.me = me;

    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) async {
      if (account != null) {
        final Database db = await getDB();

        await db.execute(
          'UPDATE OR IGNORE peers SET account = ? WHERE idx = 0', [account.email]);

        getLoggedUser();

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

        try {
          await db.inTransaction(() async {
            await Future.wait(
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
                .map((Map<String, dynamic> contact) {
                  try {
                    return db.rawInsert(
                      'INSERT OR IGNORE INTO peers (account, name) VALUES (?, ?)', [
                      contact['emailAddresses'][0]['value'],
                      contact['names'][0]['displayName']
                    ]);
                  } catch (err) {
                    print('insert exception: ${err}');
                  }
                })
            );
          });
        } catch (err) {
          print('transaction exception: ${err}');
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
                print('google sign-in exception: ${err}');
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
        ],
      );
    }

    return new Drawer(child: body);
  }
}
