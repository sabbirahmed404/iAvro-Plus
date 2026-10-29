# iAvro-Plus

**Avro phonetic Bangla keyboard for macOS that leaves your English words alone.**

Type `ami ajke DMRC er meeting e achhi` and get আমি আজকে DMRC এর meeting এ আছি, without switching keyboards mid-sentence.

An unofficial fork of [torifat/iAvro](https://github.com/torifat/iAvro), the Swift port of OmicronLab's Avro Keyboard for Mac.

## Why this fork

Bangla written today is full of English: names, brands, tech words, abbreviations. Stock Avro transliterates all of it (`meeting` → মীটিং), so you keep switching input sources. This fork offers the English word as typed, and puts it first when that's what you most likely meant:

| You type | First suggestion | Why |
|---|---|---|
| `meeting`, `deadline`, `facebook` | meeting | Common English word |
| `DMRC`, `NASA`, `TV` | DMRC | All caps, so it's an abbreviation |
| `2026`, `12.5`, `10:30` | 2026, then ২০২৬ | A number |
| `good`, `logo` | good | English loanword Avro already knows |
| `hate`, `rate` | হাতে, then hate | Also a real Bangla word, so Bangla stays first |
| `ami`, `kemon` | আমি | Plain Bangla, unchanged |

Space commits the first suggestion.

## Features

- **English words stay English.** About 40,000 common words are bundled, including chat and tech words like `readme`, `tech`, `api` and `btw`, and you can add your own.
- **Abbreviations stay English.** Any all-caps word of two or more letters.
- **Numbers stay English.** `2026` gives 2026 first and ২০২৬ second. While you type a number, digit keys keep typing instead of picking a candidate.
- **Esc commits exactly what you typed, and remembers it.** For anything the lists miss, like a company name, press Esc once; from then on that word is offered as typed, first. Stock iAvro throws the word away.
- **Remembers your picks.** Choose a candidate once, with the arrow keys or a number key, and it's preselected next time.
- **Custom candidate panel by default**, with fixes: Space no longer re-commits the previous word, and the selection no longer carries over to the next keystroke.
- **One switch** turns the English behaviour off: Preferences → General → *Keep English words in English*.

## Install

You need macOS 13 or later, an Apple Silicon Mac, and the Xcode Command Line Tools (`xcode-select --install`). Full Xcode isn't required.

```sh
git clone https://github.com/sabbirahmed404/iAvro-Plus.git
cd iAvro-Plus
./scripts/build.sh --install
```

Then:

1. Open System Settings → Keyboard → Text Input → Input Sources → Edit, click **+**, choose **Bangla**, and add **Avro Keyboard**.
2. Switch to another input source and back (or log out and in) so macOS loads the new build.

To update, `git pull` and run `./scripts/build.sh --install` again.

### Typing does nothing?

macOS remembers an input method by its bundle ID. If you used another Avro build before, the new build must use the same ID, or the input method never connects. Find the ID macOS has registered:

```sh
defaults read com.apple.HIToolbox | grep -i avrokeyboard
```

Then build with that ID, for example:

```sh
BUNDLE_ID=com.omicronlab.inputmethod.AvroKeyboard ./scripts/build.sh --install
```

## Typing tips

Avro is case-sensitive, and a few letters are easy to mix up:

| Type | Get | Example |
|---|---|---|
| `z` | য | `zeno` → যেন |
| `j` | জ | `jol` → জল |
| `jh` | ঝ | `bujhte` → বুঝতে |
| `T`, `D`, `N` | ট, ড, ণ | `kaTa` → কাটা |
| `Sh` | ষ | |
| `R` | ড় | |
| `OI` | ঐ | `kOI` → কৈ |

A word typed entirely in capitals now offers English first, so `OI` shows OI before ঐ. Pick ঐ once and it's remembered.

### Adding your own English words

For a single word, pressing Esc once is enough. To add many words at once, put one word per line in:

```
~/Library/Application Support/OmicronLab/Avro Keyboard/english-words.txt
```

Lines starting with `#` are ignored. Avro reads the file at launch, so run `killall "Avro Keyboard"` and switch back to Avro to pick up changes.

## Development

```
Sources/
  App/           App delegate and preferences window
  Controllers/   AvroKeyboardController (the IMKInputController) and CandidatesPanel
  Parsers/       Avro phonetic parser (data.json) and dictionary regex (regex.json)
  Services/      SuggestionEngine, Database (database.db3), AutoCorrect (autodict.plist),
                 EnglishWords (english.txt), CacheManager (learned picks)
  Views/         SwiftUI candidate panel and preferences
scripts/
  build.sh               Build and install without Xcode
  gen-english-words.sh   Regenerate english.txt from SCOWL plus english-extra.txt
  english-extra.txt      Chat and tech words SCOWL lacks; add new ones here
```

- `./scripts/build.sh` builds `build/Avro Keyboard.app`. You can also open `AvroKeyboard.xcodeproj` in Xcode.
- The rule that places the English candidate is `englishCandidateIndex` in [AvroKeyboardController.swift](Sources/Controllers/AvroKeyboardController.swift). It relies on `SuggestionEngine.suggestions(for:)` reporting whether the term also reads as a Bangla word.
- To see logs, run `/usr/bin/log stream --predicate 'process == "Avro Keyboard"'`. Use the full path, because zsh has a builtin named `log`.
- The XCTest suite in `Tests/` needs full Xcode; the Command Line Tools don't include XCTest.

## Contributing

Issues and pull requests are welcome. A missing English word is the easiest contribution: add it to `scripts/english-extra.txt` and run `./scripts/gen-english-words.sh`. Changes that would help every Avro user are also proposed upstream, for example [torifat/iAvro#42](https://github.com/torifat/iAvro/issues/42).

## Credits and license

- [Avro Keyboard](https://www.omicronlab.com/avro-keyboard.html) by OmicronLab, and [iAvro](https://github.com/torifat/iAvro) by torifat and its contributors.
- Licensed under the [Mozilla Public License 1.1](http://www.mozilla.org/MPL/1.1/index.txt), like upstream.
- The English word list comes from [SCOWL](http://wordlist.aspell.net/) (size 35). Its license notice is kept at the top of `english.txt`.
