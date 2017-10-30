  GoogleSignInAccount _currentUser;
  }

  Future<Null> _handleSignIn() async {
  }

  Future<Null> _handleSignOut() async {
    _googleSignIn.disconnect();
  }

  Widget _buildBody() {
    if (_currentUser != null) {
      return new Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          new ListTile(
            leading: new GoogleUserCircleAvatar(
              identity: _currentUser,
            ),
            title: new Text(_currentUser.displayName),
            subtitle: new Text(_currentUser.email),
          ),
          const Text("Signed in successfully."),
          new Text(_contactText),
          new RaisedButton(
            child: const Text('SIGN OUT'),
            onPressed: _handleSignOut,
          ),
        ],
      );
    } else {
      return new Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          const Text("You are not currently signed in."),
          new RaisedButton(
            child: const Text('SIGN IN'),
            onPressed: _handleSignIn,
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: const Text('Google Sign In'),
        ),
        body: new ConstrainedBox(
          constraints: const BoxConstraints.expand(),
          child: _buildBody(),
        ));
  }
}
