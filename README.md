# Take home test - Qwil

A developer at Qwil has been working on an app, for iOS and Android, called "Forever Alone".

The app simulate the generation of messages from three simulated users and display them in a dashboard inside the app.

Each user sends a message every 1-2 seconds, randomly.

The simulator then gather the last message from every user and create a summary, which encapsulate all the latest three messages, that is rendered in the app.

Given the constraints of the simulation, this summary object have the following requirements:

1) Summary object should not be emitted more often than every 1 second
2) Summary object should only be emitted when one of the users sends a new message
3) If a message is not received from a specific user for more than 10000ms, the reading (in the summary object) should be 'N/A'
4) All 3 users must emit at least one message before 1 summary object is ever sent to the app.

This summary object should be emitted by an observable when is subscribed to.

The application also display a button to start and stop the simulation. Upon stop, the latest summary object is displayed.
When the user starts again, the simulation starts from the beginning.

The project uses Flutter, redux and epics.

## Your job

You have inherited their project which is unfinished and the user interface definitely needs more work.

Also the tests are not completed.

Your job is to add the missing features specified in the previous section and adding any tests that you think is appropriate.

Feel free to edit any aspect of the codebase you are not happy with, within the bounds of the specification.

Please include a short note explaining your choices for your solution.

The app most run on both iOS and Android.

As an inspiration here is a link with a good example:

https://github.com/brianegan/flutter_redux/tree/master/example/github_search
