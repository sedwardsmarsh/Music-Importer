-- sources: https://discussions.apple.com/thread/536193
-- https://dougscripts.com/itunes/itinfo/info03.php

-- prompt user for ALBUM_DIRECTORY
set album_directory to choose folder with prompt "Please select album folder:"
set list_of_song_files to list folder album_directory
log album_directory
log list_of_song_files

-- open ALBUM_DIRECTORY
tell application "Finder"
	open album_directory
end tell

-- loop through all songs and set their track number
set number_of_songs to count list_of_song_files
set incrementor to 1 as integer
repeat with song_file in list_of_song_files
	
	-- parse the integer prefix from the filename and song name
	set split_song_file to splitText(song_file, "-")
	set song_num to (item 1 of split_song_file) as integer
	set song_name to (item 1 of splitText((item 3 of split_song_file), "."))
	
	-- update the track count (# songs on track's album) and track number
	set file_path to (album_directory & item incrementor of list_of_song_files) as string
	set file_alias to alias file_path
	tell application "Music"
		
		-- check that song isn't already added
		set track_exists to (search library playlist 1 for song_name)
		if track_exists is not {} then
			the track_exists
		end if
		
		set track_ref to add file_alias
		--delay 1.5
		-- set track count of track_ref to number_of_songs
		--delay 1.5
		-- set track number of track_ref to song_num
	end tell
	
	log "imported:" & song_name & ", with track id: " & song_num
	set incrementor to incrementor + 1
	
end repeat


-- helper function for splitting text
-- source: https://developer.apple.com/library/archive/documentation/LanguagesUtilities/Conceptual/MacAutomationScriptingGuide/ManipulateText.html
on splitText(theText, theDelimiter)
	set AppleScript's text item delimiters to theDelimiter
	set theTextItems to every text item of theText
	set AppleScript's text item delimiters to ""
	return theTextItems
end splitText