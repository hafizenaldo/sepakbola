import 'package:flutter/material.dart';
import 'package:sepakbola/screen_page/page_bola_service.dart';


import '../model/model.dart';

void main() {
  runApp(SoccerApp());
}

class SoccerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Soccer App',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      home: EventListScreen(),
    );
  }
}

class EventListScreen extends StatefulWidget {
  @override
  _EventListScreenState createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreen> {
  late Future<List<Event>> futureEvents;

  @override
  void initState() {
    super.initState();
    futureEvents = ApiService().fetchEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Laga Sepak Bola Eropa 2024 - 2025'),
      ),
      body: FutureBuilder<List<Event>>(
        future: futureEvents,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No events found'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final event = snapshot.data![index];
                return ListTile(
                  leading: event.strPoster != null
                      ? Image.network(
                    event.strPoster!,
                    width: 50,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.error);
                    },
                  )
                      : Image.asset(
                    'assets/bola.jpeg', // Ganti dengan path gambar bola default Anda
                    width: 50,
                  ),
                  title: Text(event.strEvent ?? 'No event name'),
                  subtitle: Text(
                      '${event.dateEvent ?? 'No date'} - ${event.strTime ?? 'No time'}'),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EventDetailScreen(event: event),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}


class EventDetailScreen extends StatelessWidget {
  final Event event;

  EventDetailScreen({required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(event.strEvent ?? 'Event Details'),
        ),
        body: SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                event.strPoster != null
                    ? Image.network(
                  event.strPoster!,
                  width: 150,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(Icons.error, size: 150);
                  },
                )
                    : Icon(Icons.image_not_supported, size: 150),
                SizedBox(height: 16.0),
                Text(
                  event.strEvent ?? 'No event name',
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('League: ${event.strLeague ?? 'No league'}'),
                    SizedBox(width: 16.0),
                    Text('Season: ${event.strSeason ?? 'No season'}'),
                  ],
                ),
                SizedBox(height: 8.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Date: ${event.dateEvent ?? 'No date'}'),
                    SizedBox(width: 16.0),
                    Text('Time: ${event.strTime ?? 'No time'}'),
                  ],
                ),
              ],
            ),
            ),
        );
    }
}
