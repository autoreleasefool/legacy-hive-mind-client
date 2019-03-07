# HiveAI - Client

An iOS app to interact with the HiveAI AI (and others).

## Getting started

1. First, you'll need to grab a couple other repos to build the entire system and play a game of Hive against the HiveMind.
    * [Hive Client](https://github.com/josephroqueca/hive-client)
    * [Hive Server](https://github.com/josephroqueca/hive-server)
    * [HiveMind](https://github.com/josephroqueca/hivemind)
2. After cloning, ensure you have the submodule dependencies cloned: `git submodule update --init --recursive`
3. If you want to add your own AI, simply update `HiveAI/HiveAI/Resources/APIs.plist` with the appropriate details.
    * If you are running [HiveMind](https://github.com/josephroqueca/hivemind) locally, the server endpoint should be updated to `http://localhost:3000/hivemind`
4. That's it! You're ready to start playing Hive.

### Requirements

* Swift 4.2+

## Contributing

1. Install SwiftLint for styling conformance:
    * `brew install swiftlint`
    * Run `swiftlint` from the root of the repository.
    * There should be no errors or violations. If there are, please fix them before opening a PR.
2. If you've added new assets, generate them with SwiftGen:
    * `brew install swiftgen`
    * `cd HiveAI`
    * Run `swiftgen` from this directory and commit the changes
3. Open a PR with your changes 👍
