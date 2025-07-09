import 'package:flutter/material.dart'; // Make sure to import Flutter Material package
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class PostService extends ChangeNotifier {
  Future<void> postJsonMethod(
      BuildContext context,
      String apiUrl,
      dynamic postData,
      bool addAuthHeader,
      Function executionMethod,
      ) async {
    // Log the request details
    print('POST JSON method API: $apiUrl');
    print('POST JSON data: $postData');

    try {
      // Check for internet connectivity
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        // Prepare the headers
        Map<String, String> headers = {
          'Content-Type': 'application/json',
        };

        // Add authorization header if needed
        if (addAuthHeader) {
          String authToken = ''; // Replace with your token retrieval logic
          if (authToken.isNotEmpty) {
            headers['Authorization'] = 'Bearer $authToken';
          }
        }

        // Make the POST request
        final response = await http.post(
          Uri.parse(apiUrl),
          headers: headers,
          body: jsonEncode(postData),
        );

        // Handle the response
        if (response.statusCode == 200) {
          executionMethod(context, true, jsonDecode(response.body));
        } else {
          executionMethod(context, false, {'status': null});
        }
      }
    } on SocketException catch (_) {
      // Handle no internet connection
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Please Try Again"),
            content: const Text('Internet Not Connected!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Ok"),
              ),
            ],
          );
        },
      );
    } catch (error) {
      // Handle any other errors
      print('Error: $error');
      executionMethod(context, false, {'status': null});
    }
  } // Closing bracket for postJsonMethod

  Future<void> postFormMethod(
      BuildContext context,
      String apiUrl,
      Map<String, String> postData,
      bool addAuthHeader,
      Function executionMethod,
      ) async {
    // Log the request details
    print('POST Form method API: $apiUrl');
    print('POST Form data: $postData');

    try {
      // Check for internet connectivity
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        // Prepare the headers
        Map<String, String> headers = {
          'Content-Type': 'application/x-www-form-urlencoded',
        };

        // Add authorization header if needed
        if (addAuthHeader) {
          String authToken = ''; // Replace with your token retrieval logic
          if (authToken.isNotEmpty) {
            headers['Authorization'] = 'Bearer $authToken';
          }
        }

        // Make the POST request
        final response = await http.post(
          Uri.parse(apiUrl),
          headers: headers,
          body: postData,
        );

        // Handle the response
        if (response.statusCode == 200) {
          executionMethod(context, true, jsonDecode(response.body));
        } else {
          executionMethod(context, false, {'status': null});
        }
      }
    } on SocketException catch (_) {
      // Handle no internet connection
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Please Try Again"),
            content: const Text('Internet Not Connected!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Ok"),
              ),
            ],
          );
        },
      );
    } catch (error) {
      // Handle any other errors
      print('Error: $error');
      executionMethod(context, false, {'status': null});
    }
  } // Closing bracket for postFormMethod
} // Closing bracket for PostService class
