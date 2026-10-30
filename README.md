# MP3 Tag Reader

A command-line C tool that reads, edits and deletes ID3 metadata tags
(ID3v1/v1.1 and ID3v2.3) from MP3 files, per the Emertxe MP3 Tag Reader
SRS.

## Build

```
make
```

## Usage

```
mp3_tag_reader -h                     Show help
mp3_tag_reader -v <file>              Show ID3 tag version(s) present
mp3_tag_reader -a <file>              Show all tag metadata
mp3_tag_reader -t <text> <file>       Edit Title
mp3_tag_reader -A <text> <file>       Edit Artist
mp3_tag_reader -l <text> <file>       Edit Album
mp3_tag_reader -y <text> <file>       Edit Year
mp3_tag_reader -c <text> <file>       Edit Comment
mp3_tag_reader -e <file>              Extract embedded album art (cover.jpg/png)
mp3_tag_reader -D <file>              Delete ALL tag data (v1 + v2)
mp3_tag_reader -d <FRAMEID> <file>    Delete one ID3v2 frame, e.g. TIT2
```

## Design

- `id3v1.c/.h` - reads/writes the fixed-size 128 byte ID3v1/v1.1 tag at
  the end of the file (title/artist/album/year/comment/track/genre).
- `id3v2.c/.h` - parses the ID3v2.3 header + frame list at the start of
  the file, supports text frames (TIT2/TPE1/TALB/...), COMM comments, and
  the APIC embedded-picture frame (type, size, and extraction to disk).
- Editing/deleting frames rebuilds the whole tag block and rewrites the
  file (new header + frames + the original untouched audio bytes that
  followed the old tag), rather than shuffling bytes in place - this
  keeps the implementation correct regardless of how a field's size
  changes.
- `main.c` handles argument parsing/dispatch and prints proper error
  messages (missing file, no tag found, frame not found, etc.) per the
  SRS's mandatory error-handling requirement.

## Corrupt and damaged files

If the ID3v2 tag is inconsistent with the file (for example a tag or frame
that claims to be bigger than the file), the tag is reported as corrupt and
ignored, and edit commands refuse to touch the file. Editing and deleting
rewrite the MP3, so keep a backup of files you care about.

## Mandatory SRS features covered

1. Reads ID3v1 and ID3v2.3 (not v2.4, per spec).
2. Displays which version(s) of ID3 tag are present (`-v`).
3. Displays all metadata (`-a`).
4. Lets the user edit tags (`-t/-A/-l/-y/-c`).
5. Help screen on request (`-h`).
6. Displays embedded image details - type, path, size (`-e`).
7. Proper error messages when no tag is found.

## Extra-credit features included

- Album art extraction to disk (`-e`).
- Delete all tag data (`-D`).
- Delete a specific tag/frame (`-d <FRAMEID>`).

## Not implemented (documented as scope decisions)

- ID3v2.4 support - explicitly excluded by the SRS's mandatory
  requirements ("Except v2.4").
- UTF-16 text frames are copied byte-for-byte but not decoded/re-encoded
  for display; ISO-8859-1/UTF-8 text frames are fully supported.
