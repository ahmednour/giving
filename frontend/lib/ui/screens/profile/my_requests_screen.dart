import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:giving_bridge/models/request.dart';
import 'package:giving_bridge/services/request_service.dart';

class MyRequestsScreen extends StatefulWidget {
  const MyRequestsScreen({super.key});

  @override
  State<MyRequestsScreen> createState() => _MyRequestsScreenState();
}

class _MyRequestsScreenState extends State<MyRequestsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RequestService>().getMyRequests();
    });
  }

  @override
  Widget build(BuildContext context) {
    final requestService = context.watch<RequestService>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Requests'),
      ),
      body: requestService.isLoading
          ? const Center(child: CircularProgressIndicator())
          : requestService.myRequests.isEmpty
              ? const Center(
                  child: Text('You have not made any requests yet.'),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: requestService.myRequests.length,
                  itemBuilder: (context, index) {
                    final request = requestService.myRequests[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        title: Text(request.donation?.title ?? 'Donation'),
                        subtitle: Text('Status: ${request.status}'),
                        trailing: Text(
                          request.createdAt != null
                              ? '${request.createdAt!.day}/${request.createdAt!.month}/${request.createdAt!.year}'
                              : 'No date',
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
