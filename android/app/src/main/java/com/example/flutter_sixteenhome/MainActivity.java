package com.example.flutter_sixteenhome;

import android.os.Bundle;
import io.flutter.app.FlutterActivity;
import io.flutter.plugins.CustomFlutterPlugins;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    // setContentView(R.layout.activity_main);
    GeneratedPluginRegistrant.registerWith(this);
    CustomFlutterPlugins.registerLogger(getFlutterView());
  }
}
