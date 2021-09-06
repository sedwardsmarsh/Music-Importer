-- sources: https://discussions.apple.com/thread/536193
-- https://dougscripts.com/itunes/itinfo/info03.php

-- source: https://developer.apple.com/library/archive/documentation/LanguagesUtilities/Conceptual/MacAutomationScriptingGuide/ManipulateText.html
on splitText(theText, theDelimiter)
	set AppleScript's text item delimiters to theDelimiter
	set theTextItems to every text item of theText
	set AppleScript's text item delimiters to ""
	return theTextItems
end splitText

tell application "Music"
	
	-- choose working folder
	set song_file_list to list folder (choose folder)
	
	-- constant variable for total number of songs
	set num_songs to count song_file_list
	
	-- init loop incrementor variable
	set incrementor to 1 as integer
	
	-- loop through all songs and set their track number
	repeat with song_file in song_file_list


set theText to "083- Earthbound - Rough Landing.mp3"

-- get the first 
set split_msg to splitText(theText, "-")
	end repeat
	
end tell