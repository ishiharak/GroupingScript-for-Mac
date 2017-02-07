set inputFile to choose file with prompt "Please specify CSV file formatted in order of id, group and alias."
set csvText to repChar((read inputFile as string), ASCII character 13, "")
set users to textToTwoDArray(csvText, character id 10, ",")

tell application "Finder"
	repeat with user in users
		try
			set thePath to container of (path to me)
			set nameOfGroup to (item 2 of user)
			set nameOfAlias to (item 3 of user)
		on error
			return
		end try
		
		try
			make new folder at thePath with properties {name:nameOfGroup}
		end try
		
		try
			set pathOfUser to ((thePath as string) & item 1 of user) as alias
			set pathOfGroup to ((thePath as string) & item 2 of user) as alias
			
			if exists (pathOfGroup as string) & nameOfAlias then
				move ((pathOfGroup as string) & nameOfAlias) as alias to trash
			end if
			
			make new alias file at pathOfGroup to pathOfUser with properties {name:nameOfAlias}
		end try
	end repeat
end tell


on textToTwoDArray(theText, mainDelimiter, secondaryDelimiter)
	set {tids, text item delimiters} to {text item delimiters, mainDelimiter}
	set firstArray to text items of theText
	set text item delimiters to secondaryDelimiter
	set twoDArray to {}
	repeat with anItem in firstArray
		set end of twoDArray to text items of anItem
	end repeat
	set text item delimiters to tids
	return twoDArray
end textToTwoDArray

on repChar(origText, targStr, repStr)
	set {txdl, AppleScript's text item delimiters} to {AppleScript's text item delimiters, targStr}
	set temp to text items of origText
	set AppleScript's text item delimiters to repStr
	set res to temp as text
	set AppleScript's text item delimiters to txdl
	return res
end repChar