# crux-midi

MIDI devices for [Crux](https://github.com/redbadger/crux) apps: the shell does the I/O, and the core decides what to connect.

- `effects`: the operations a shell performs. It lists MIDI devices (`WatchDevices`), connects to them (`ConnectMidi`, a stream of `Connected`, `Bytes`, then `Failed` or `Lost`), disconnects and forgets them, scans for Bluetooth LE MIDI (`ScanBluetooth`, or `OpenBluetoothSettings` where the system pairs), and sends bytes (`SendMidi`).
- `Connections`: the part of your model that decides what to connect. It connects every listed device (or only those `auto_connect_only` accepts), except those the user disconnected or that failed to connect, and reconnects after a dropped link. Why the last connection or scan failed is kept as a `MidiError` (`status()`) for your app to word; its `Display` gives plain English if that's enough. Attempt numbers make it ignore late news from connections and scans it gave up on, and it stops scanning once something connects.

Your app keeps a `Connections` in its model, wraps `MidiEvent` in one of its own events, and acts on the `Notice`s it gets back (`Connected`, `Bytes`, `Released`):

```rust,ignore
Event::Midi(event) => {
    let Update { command, changed, notices } = model.midi.update(event);
    for notice in notices { /* feed bytes, release notes, send a program change … */ }
    if changed { command.and(render()) } else { command }
}
```

`no_std` with `alloc` (`default-features = false`).

## Using it

It isn't on crates.io yet: it needs Crux's `no_std` work (redbadger/crux#627), pinned from git. Depend on it from git, with the same `crux_core` pin:

```toml
crux_midi = { package = "crux-midi", git = "https://github.com/tszarzynski/crux-midi", tag = "v0.1.0", default-features = false }
```

## Checks

```sh
cargo fmt --check && cargo clippy --all-targets -- -D warnings && cargo test
cargo build --no-default-features --features crux_core/critical-section --target thumbv7em-none-eabihf   # stays no_std
```

## Licence

MIT OR Apache-2.0.
