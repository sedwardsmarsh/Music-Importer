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
	set song_name to item 1 of splitText((item 3 of split_song_file), ".")

	-- update the track count (# songs on track's album) and track number
	set file_path to (album_directory & item incrementor of list_of_song_files) as string
	set file_alias to alias file_path
	tell application "Music"
		set track_ref to add file_alias
		delay 0.5
		set track count of track_ref to number_of_songs
		delay 0.5
		set track number of track_ref to song_num
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




-- -- Type “EarthBound_Music_Archive” into the text field.
-- delay 1.367496
-- set timeoutSeconds to 2.000000
-- set uiScript to "click text field 1 of UI Element 1 of row 116 of outline 1 of scroll area 1 of splitter group 1 of splitter group 1 of window \"Downloads\" of application process \"Finder\""
-- my doWithTimeout( uiScript, timeoutSeconds )

-- -- Type “EarthBound_Music_Archive” into the text field.
-- delay 0.112258
-- set timeoutSeconds to 2.000000
-- set uiScript to "click text field 1 of UI Element 1 of row 116 of outline 1 of scroll area 1 of splitter group 1 of splitter group 1 of window \"Downloads\" of application process \"Finder\""
-- my doWithTimeout( uiScript, timeoutSeconds )

-- -- Type “001- EarthBound - Burp.mp3” into the text field.
-- delay 1.451982
-- set timeoutSeconds to 2.000000
-- set uiScript to "click text field 1 of UI Element 1 of row 2 of outline 1 of scroll area 1 of splitter group 1 of splitter group 1 of window \"EarthBound_Music_Archive\" of application process \"Finder\""
-- my doWithTimeout( uiScript, timeoutSeconds )

-- -- Type “001- EarthBound - Burp.mp3” into the text field.
-- delay 2.605870
-- set timeoutSeconds to 2.000000
-- set uiScript to "click text field 1 of UI Element 1 of row 2 of outline 1 of scroll area 1 of splitter group 1 of splitter group 1 of window \"(choose folder)\" of application process \"Finder\""
-- my doWithTimeout( uiScript, timeoutSeconds )

-- -- Music.app (default)
-- delay 1.682165
-- set timeoutSeconds to 2.000000
-- set uiScript to "click menu item \"Music.app (default)\" of menu 1 of menu item \"Open With\" of menu 1 of outline 1 of scroll area 1 of splitter group 1 of splitter group 1 of window \"EarthBound_Music_Archive\" of application process \"Finder\""
-- my doWithTimeout( uiScript, timeoutSeconds )

-- -- Click the “<fill in title>” button.
-- delay 4.830811
-- set timeoutSeconds to 2.000000
-- set uiScript to "click UI Element 2 of group 4 of splitter group 1 of window \"Music\" of application process \"Music\""
-- my doWithTimeout( uiScript, timeoutSeconds )

-- -- Mouse Clicked
-- delay 2.150301
-- set timeoutSeconds to 2.000000
-- set uiScript to "click UI Element 5 of group 2 of scroll area 1 of group 1 of splitter group 1 of window \"Music\" of application process \"Music\""
-- my doWithTimeout( uiScript, timeoutSeconds )

-- -- Get Info
-- delay 2.793192
-- set timeoutSeconds to 2.000000
-- set uiScript to "click menu item \"Get Info\" of menu 1 of window \"Music\" of application process \"Music\""
-- my doWithTimeout( uiScript, timeoutSeconds )

-- -- Click the text field.
-- delay 3.955044
-- set timeoutSeconds to 2.000000
-- set uiScript to "click text field 8 of scroll area 1 of window \"Song Info\" of application process \"Music\""
-- my doWithTimeout( uiScript, timeoutSeconds )

-- -- Type '1'
-- delay 3.720253
-- set timeoutSeconds to 2.000000
-- set uiScript to "keystroke \"1\""
-- my doWithTimeout( uiScript, timeoutSeconds )

-- -- Click the text field.
-- delay 0.463624
-- set timeoutSeconds to 2.000000
-- set uiScript to "click text field 9 of scroll area 1 of window \"Song Info\" of application process \"Music\""
-- my doWithTimeout( uiScript, timeoutSeconds )

-- -- Type '170'
-- delay 0.868145
-- set timeoutSeconds to 2.000000
-- set uiScript to "keystroke \"170\""
-- my doWithTimeout( uiScript, timeoutSeconds )

-- -- Click the “OK” button.
-- delay 1.114058
-- set timeoutSeconds to 2.000000
-- set uiScript to "click UI Element \"OK\" of window \"Song Info\" of application process \"Music\""
-- my doWithTimeout( uiScript, timeoutSeconds )

-- on doWithTimeout(uiScript, timeoutSeconds)
-- 	set endDate to (current date) + timeoutSeconds
-- 	repeat
-- 		try
-- 			run script "tell application \"System Events\"
-- " & uiScript & "
-- end tell"
-- 			exit repeat
-- 		on error errorMessage
-- 			if ((current date) > endDate) then
-- 				error "Can not " & uiScript
-- 			end if
-- 		end try
-- 	end repeat
-- end doWithTimeout