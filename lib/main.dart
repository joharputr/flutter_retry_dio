import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dio_connectivity_request_retrier.dart';
import 'retry_interceptor.dart';

void main() => runApp(MainApp());

class MainApp extends StatefulWidget {
  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  Dio dio;
  String name;
  bool loading = false;

  @override
  void initState() {
    dio = Dio();
    dio.interceptors.add(
      RetryOnConnectionChangeInterceptor(
        requestRetrier: DioConnectivityRequestRetrier(
          dio: Dio(),
          connectivity: Connectivity(),
        ),
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Center(
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(name ?? "Null"),
                  Container(
                    child: FlatButton(
                      color: Colors.blue,
                      onPressed: () async {
                        loading = true;
                        setState(() {});
                        final response = await dio.get(
                            "https://jsonplaceholder.typicode.com/todos/1");
                        setState(() {
                          name = response.data["title"];
                          loading = false;
                          setState(() {});
                        });
                      },
                      child: Text("Retry"),
                    ),
                  ),
                ],
              )),
      ),
    );
  }
}
