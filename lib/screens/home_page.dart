import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:stem_club/api/post_Service/api_post_service.dart';
import 'package:stem_club/colors/app_colors.dart';
import 'package:stem_club/constants.dart';
import 'package:stem_club/widgets/custom_card.dart';
import 'package:stem_club/utils/dialog_utils.dart'; // Import the utility class
import 'dart:developer' as developer;

import 'package:stem_club/widgets/loading_indicator.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> posts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPosts(); // Fetch posts when the widget is initialized
  }

  Future<void> _fetchPosts() async {
    try {
      Map<String, dynamic>? result = await ApiPostService.getAllPost();
      // Check if the result is null or status code is not 200
      if (result == null) {
        developer.log('No result received from API');
        _handleEmptyState(); // Handle empty case
        return;
      }

      // Check if body exists
      if (result['body'] is String) {
        // If body is a string (raw JSON), parse it
        final bodyDecoded = json.decode(result['body']);

        if (bodyDecoded is List) {
          final postData = List<Map<String, dynamic>>.from(bodyDecoded);
          setState(() {
            posts = postData;
            isLoading = false;
          });
        } else {
          _handleEmptyState();
        }
      } else if (result['body'] is List) {
        // If body is already a List
        final postData = List<Map<String, dynamic>>.from(result['body']);
        setState(() {
          posts = postData;
          isLoading = false;
        });
      } else {
        _handleEmptyState();
      }
    } catch (e) {
      _handleEmptyState();
    }
  }

  void _handleEmptyState() {
    if (!mounted) return; // Prevent setState if the widget is not mounted
    setState(() {
      isLoading = false; // Stop loading
      posts = []; // Ensure posts are empty if there's an error or no data
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isWeb = MediaQuery.of(context).size.width > 600;

    return MaterialApp(
      title: 'Welcome ${AppConstants.appName}',
      home: Scaffold(
        body: Center(
          child: SizedBox(
            width: isWeb ? 700 : double.infinity,
            child: Stack(
              children: [
                isLoading
                    ? const Center(child: LoadingIndicator())
                    : posts.isEmpty // Check if posts list is empty
                        ? const Center(child: Text("No posts available"))
                        : ListView.builder(
                            padding: const EdgeInsets.only(top: 80),
                            itemCount: posts.length,
                            itemBuilder: (context, index) {
                              final post = posts[index];
                              return CustomCard(
                                title: post['title'], // Post title
                                description: post['description'] ??
                                    '', // Post description
                                username: post['username'],
                                isImage: post['postType'] == AppConstants.image
                                    ? true
                                    : false,
                                mediaUrl: post['postUrl'],
                              );
                            },
                          ),
                if (isWeb)
                  Positioned(
                    top: 20,
                    left: 0,
                    right: 0,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 16.0, top: 8.0),
                        child: ElevatedButton.icon(
                          onPressed: () {
                            DialogUtils.showCreatePostDialog(
                                context); // Use the utility method
                          },
                          icon: const Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                          label: const Text(
                            'Create Post',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                            elevation: 5,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
