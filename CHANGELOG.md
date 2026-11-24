# Changelog

## Unreleased

- First version, extracted from chord-detector: MIDI effects, `Connections`, and `SendMidi` for output.
- `Connections::auto_connect_only`: connect only the devices the app wants by themselves (from go-voices).
- `Connections::status` is the `MidiError` itself, for the app to word, rather than a message.
