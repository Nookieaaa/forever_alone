//TODO
//1) Summary object should not be emitted more often than every 1 second
//2) Summary object should only be emitted when one of the users sends a new message
//3) If a message is not received from a specific user for more than 10000ms, the reading (in the summary object) should be 'N/A'
//4) All 3 users must emit at least one message before 1 summary object is ever sent to the app.