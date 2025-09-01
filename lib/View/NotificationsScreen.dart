import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notification"),
        actions: [
          TextButton(
            onPressed: () async {
              final query = await FirebaseFirestore.instance
                  .collection('notifications')
                  .get();

              for (var doc in query.docs) {
                doc.reference.delete();
              }
            },
            child: const Text(
              "Clear all",
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('notifications')
            .orderBy('time', descending: true) // FIXED HERE
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No notifications"));
          }

          var notifications = snapshot.data!.docs;

          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              var notif = notifications[index];
              var title = notif['title'] ?? '';
              var body = notif['body'] ?? '';
              var timestamp = (notif['time'] as Timestamp)
                  .toDate(); // FIXED HERE
              var read = notif['read'] ?? true;

              return ListTile(
                leading: Icon(
                  Icons.notifications,
                  color: read ? Colors.grey : Colors.blue,
                ),
                title: Text(
                  title,
                  style: TextStyle(
                    fontWeight: read ? FontWeight.normal : FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  body,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Text(
                  DateFormat('MMM dd, yyyy hh:mm a').format(timestamp),
                  style: const TextStyle(fontSize: 10),
                ),
                onTap: () {
                  notif.reference.update({'read': true});
                },
              );
            },
          );
        },
      ),
    );
  }
}
