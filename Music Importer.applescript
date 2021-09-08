use AppleScript version "2.4" -- Yosemite (10.10) or later
use scripting additions

-- sources: https://discussions.apple.com/thread/536193
-- https://dougscripts.com/itunes/itinfo/info03.php
-- https://alvinalexander.com/blog/post/mac-os-x/search-for-song-in-itunes-library-using-applescript/
-- https://dougscripts.com/itunes/itinfo/spotlight.php

-- prompt user for ALBUM_DIRECTORY
set album_directory to choose folder with prompt "Please select album folder:"
set list_of_song_files to list folder album_directory
log "album directory: " & album_directory
log "list of song files: " & list_of_song_files

-- initialize loop variables
set number_of_songs to count list_of_song_files
log "number of songs: " & number_of_songs
set incrementor to 1 as integer
global timeout_interval
set timeout_interval to 0.1

-- initialize progress details
set progress total steps to number_of_songs
set progress completed steps to 0
set progress description to "Importing Songs..."
set progress additional description to "Preparing to import."

-- loop through all songs in ALBUM_DIRECTORY
repeat with song_file in list_of_song_files
	
	-- parse the integer prefix from the filename and song name
	set split_song_file to splitText(song_file, "- ")
	set song_num to (item 1 of split_song_file) as integer
	
	-- setup file_alias
	set file_path to (album_directory & item incrementor of list_of_song_files) as string
	set file_alias to alias file_path
	
	-- use mlds to retrieve the ALBUM_NAME, SONG_NAME using the FILE_PATH to the current song
	-- additional fields require an additional: "-name [property]"
	-- by passing only a filepath to mdls, it will display all available properties
	set mdls_command to ("mdls -name kMDItemAlbum -name kMDItemTitle")
	set file_name to (quoted form of POSIX path of (file_path as string))
	set the_meta_data to (do shell script mdls_command & " " & file_name)
	set the_meta_data_split to splitText(the_meta_data, "\"")
	set album_name to (item 2 of the_meta_data_split)
	set song_name to (item 4 of the_meta_data_split)
	
	-- update the progress details
	set progress description to "Song name: " & song_name
	set progress additional description to "Number: (" & incrementor & "/" & number_of_songs & "), Timeout Interval: " & timeout_interval & "s"
	
	tell application "Music"
		
		repeat while true
			
			try
				-- if song is already in library, don't add it again
				set search_result to (every track of playlist "Library" whose album is equal to album_name and name is equal to song_name)
				if search_result is {} then
					set track_ref to add file_alias
				else
					-- pop track reference from list
					set track_ref to item 1 of search_result
					log "track: " & song_name & " already exists..."
				end if
				
				-- file track album index information
				delay timeout_interval
				set track count of track_ref to number_of_songs
				delay timeout_interval
				set track number of track_ref to song_num
				
				-- decrement TIMEOUT_INTERVAL on success
				set timeout_interval to timeout_interval - 0.1
				if timeout_interval < 0 then
					set timeout_interval to 0
				end if
				
				exit repeat
				
			on error errStr number errorNumber
				-- Music.app will report a file permissions error (number 54), what does this mean?
				-- for the time being, increase the TIMEOUT_INTERVAL by a quarter second
				set timeout_interval to timeout_interval + 0.1
				log "track: " & song_name & " failure, timeout_interval: " & timeout_interval
				
			end try
			
		end repeat
		
	end tell
	
	-- increment the progress
	set incrementor to incrementor + 1
	set progress completed steps to incrementor - 1
	
end repeat

-- display notification that the script has finished
display notification "All songs have been imported." with title "Music Importer" subtitle "Importing is complete." sound name "Frog"


-- splits text into a list of tokens separated by theDelimiter
-- source: https://developer.apple.com/library/archive/documentation/LanguagesUtilities/Conceptual/MacAutomationScriptingGuide/ManipulateText.html
on splitText(theText, theDelimiter)
	set AppleScript's text item delimiters to theDelimiter
	set theTextItems to every text item of theText
	set AppleScript's text item delimiters to ""
	return theTextItems
end splitText
