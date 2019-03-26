library openid_client_implicit_flow;
import 'dart:async';

import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

import 'openid_client.dart';

class AuthenticatorImplicitFlow {

  Flow flow;
  FlutterWebviewPlugin flutterWebviewPlugin = new FlutterWebviewPlugin();

  AuthenticatorImplicitFlow(Client client, {
    Uri redirectUri
    }){
    var f = Flow.implicit(client);
    f.redirectUri = redirectUri;
    this.flow = f;
  }

  Future<Credential> authorize() async {
    
    flutterWebviewPlugin.onUrlChanged.listen((String url) async {
      
      if (url.contains(flow.redirectUri.toString()+"#")) {
        flutterWebviewPlugin.close();
        Uri uri = Uri.parse(url);
        Map<String,String> resp = Map<String,String>();

        List<String> l = uri.fragment.split("&");
        for (var item in l) {
          resp[item.split("=")[0]] = item.split("=")[1];
        }
        
        return flow.callback(resp);
      }

    });

    flutterWebviewPlugin.launch(flow.authenticationUri.toString(), hidden: false);
    return null;
  }
  
}