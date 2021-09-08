# Music Importer

I wasn't satisifed with the lack of filtering and sorting for Music on MacOS 11.5.2 (20G95).

I made this script so I could import songs in their album-order. By default, Music imports songs in their lexicographical order and ignores song number prefixes.

## Instruction

The script requires file names to be in **exactly** the following format:
* `track_number_in_album- album_title - track_title`

Additionally: 
* **Only include audio files** in the album directory
* All song files you want to import are in the root directory you point the script to
  * Don't include nested folders containing song files

## TODO

* Remove duplicates from album, perhaps by performing a second pass
* Add a progress indication of some kind
* Improve script efficiency, perhaps by tuning `timeout_interval`
