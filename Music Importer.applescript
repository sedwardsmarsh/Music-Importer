-- sources: https://discussions.apple.com/thread/536193
-- https://dougscripts.com/itunes/itinfo/info03.php
-- https://alvinalexander.com/blog/post/mac-os-x/search-for-song-in-itunes-library-using-applescript/

-- prompt user for ALBUM_DIRECTORY
set album_directory to choose folder with prompt "Please select album folder:"
set list_of_song_files to list folder album_directory
log "album directory: " & album_directory
log "list of song files: " & list_of_song_files

-- open ALBUM_DIRECTORY
tell application "Finder"
	open album_directory
end tell

-- loop through all songs in ALBUM_DIRECTORY, initialize loop variables
set number_of_songs to count list_of_song_files
log "number of songs: " & number_of_songs
set incrementor to 1 as integer
local timeout_interval
set timeout_interval to 1
repeat with song_file in list_of_song_files
	
	-- parse the integer prefix from the filename and song name
	set split_song_file to splitText(song_file, "-")
	set song_num to (item 1 of split_song_file) as integer
	set song_name to (item 1 of splitText((item 3 of split_song_file), "."))

	-- setup file_alias and get album name of song
	set file_path to (album_directory & item incrementor of list_of_song_files) as string
	set file_alias to alias file_path
	log "file info"
	log (get properties of alias file file_alias)

	tell application "Music"
		
		-- dynamically throttle TIMEOUT_INTERVAL
		repeat while true
			log "track: " & song_name & " being processed!"
			try
				-- check that song isn't already added
				-- set search_results to (search library playlist 1 for song_name only names)
				set search_results to (every track of playlist "Library" whose album is equal to album_name and name is equal to song_name)
				log search_results
				repeat with result in search_results
					considering case, diacriticals, hyphens, numeric strings and punctuation
						set track_exists to (song_name is equal to (get name of result))
						log "result is: " & (get name of result)
						log "song_name: " & song_name
						log "track_exists: " & track_exists
						if track_exists is true then
							log "track: " & song_name & " already exists"
							exit repeat
						end if
					end considering
				end repeat
				
				if track_exists is false then
					log "track: " & song_name & " doesn't exist, adding..."
					set track_ref to add file_alias
				end if
				
				delay timeout_interval
				set track count of track_ref to number_of_songs
				delay timeout_interval
				set track number of track_ref to song_num
				
				-- decrement TIMEOUT_INTERVAL on success
				set timeout_interval to timeout_interval - 0.25
				if timeout_interval < 0 then
					set timeout_interval to 0
				end if
				exit repeat
			on error errStr number errorNumber
				set timeout_interval to timeout_interval + 0.25
				log "track: " & song_name & " failure, timeout_interval: " & timeout_interval
			end try
		end repeat
	end tell
	
	log "track: " & song_name & ", track id: " & song_num & ", timeout interval: " & timeout_interval & " imported ---"
	set incrementor to incrementor + 1
	
end repeat


-- splits text into a list of tokens separated by theDelimiter
-- source: https://developer.apple.com/library/archive/documentation/LanguagesUtilities/Conceptual/MacAutomationScriptingGuide/ManipulateText.html
on splitText(theText, theDelimiter)
	set AppleScript's text item delimiters to theDelimiter
	set theTextItems to every text item of theText
	set AppleScript's text item delimiters to ""
	return theTextItems
end splitText