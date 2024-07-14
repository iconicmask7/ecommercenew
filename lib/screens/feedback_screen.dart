import 'package:flutter/material.dart';

class FeedbackScreen extends StatelessWidget {
  final TextEditingController _feedbackController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feedback'),
        backgroundColor: Colors.yellow[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Send us your feedback or support requests:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _feedbackController,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: 'Your Feedback',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                String feedback = _feedbackController.text.trim();

                // Basic validation
                if (feedback.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please enter your feedback')),
                  );
                  return;
                }

                // Send feedback (dummy implementation)
                _sendFeedback(feedback);

                // Clear the text field
                _feedbackController.clear();

                // Show confirmation or navigate to previous screen
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Feedback sent successfully')),
                );
              },
              child: Text('Send Feedback'),
            ),
          ],
        ),
      ),
    );
  }

  void _sendFeedback(String feedback) {
    // Implement logic to send feedback (e.g., API call)
    print('Sending feedback: $feedback');
    // Simulated delay for feedback submission
    Future.delayed(Duration(seconds: 2));
  }
}

