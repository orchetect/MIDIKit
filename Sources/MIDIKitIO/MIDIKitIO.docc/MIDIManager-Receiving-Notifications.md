# Receiving Notifications

Specify a handler to receive Core MIDI system notifications.

## Overview

Core MIDI generates notifications when the system MIDI configuration changes. These notifications can be safely ignored.

However, a handler closure is provided on the ``MIDIManager`` instance in order to receive the notifications.

## Topics

### MIDIManager Properties

- ``MIDIManager/notificationHandler``

### Types

- ``MIDIIONotification``
