# Setup todo file
set todoFilePattern to (path to desktop as Unicode text) & "Things - todo - " & dateISOformat(current date) & " " & replaceChars(timeISOformat(current date), ":", "-")
set todoFilePath to todoFilePattern & " 0.xml"
set todoFile to (open for access file todoFilePath with write permission)
set eof of todoFile to 0
write "<xml><title>Toodledo :: to-do list</title><link>http://www.toodledo.com/</link><toodledoversion>6</toodledoversion><description>Your to-do list</description>" & linefeed to todoFile

tell application "Things"
	
	set counter to 0
	set fileCounter to 0
	repeat with toDo in to dos
		set toDoName to my escapeTextToXml(my trimLine(my formatEmptyValue(name of toDo as Unicode text), " ", 2))
		set toDoStatus to my formatEmptyValue(status of toDo)
		set toDoTags to my escapeTextToXml(my formatEmptyValue(tag names of toDo))
		
		set toDoCancellation to my dateISOformat(cancellation date of toDo)
		set toDoCancellationTime to my timeISOformat(cancellation date of toDo)
		
		set toDoDue to my dateISOformat(due date of toDo)
		set toDoDueTime to my timeISOformat(due date of toDo)
		
		
		set toDoModification to my dateISOformat(modification date of toDo)
		set toDoModificationTime to my timeISOformat(modification date of toDo)
		
		set toDoProject to project of toDo
		set toDoProjectName to ""
		#set toDoProjectId to ""
		if (toDoProject is not missing value) then
			set toDoProjectName to my escapeTextToXml(name of toDoProject as Unicode text)
		else if ((area of toDo) is not missing value) then
			set toDoArea to (area of toDo)
			set toDoProjectName to (name of toDoArea)
		end if
		
		set toDoAreaName to ""
		
		set toDoActivation to my dateISOformat(activation date of toDo)
		set toDoActivationTime to my timeISOformat(activation date of toDo)
		#set toDoId to id of toDo
		set toDoCompletion to my dateISOformat(completion date of toDo)
		set toDoCompletionTime to my timeISOformat(completion date of toDo)
		set toDoCreation to my dateISOformat(creation date of toDo)
		set toDoCreationTime to my timeISOformat(creation date of toDo)
		set toDoNotes to my escapeTextToXml(my trimLine(my formatEmptyValue(notes of toDo as Unicode text), " ", 2))
		
		write "<item><parent>0</parent><order>0</order><title>" & toDoName & "</title><tag>" & toDoTags & "</tag><folder>" & toDoProjectName & "</folder><context></context><goal></goal><location></location><startdate>" & toDoActivation & "</startdate><starttime>" & toDoActivationTime & "</starttime><duedate>" & toDoDue & "</duedate><duedatemodifier>0</duedatemodifier><duetime>" & toDoDueTime & "</duetime><completed>" & toDoCompletion & "</completed><repeat>None</repeat><repeatfrom>0</repeatfrom><priority>Low</priority><length></length><timer>0</timer><status>" & toDoStatus & "</status><star>0</star><note>" & toDoNotes & "</note></item>" & linefeed to todoFile
		
		get properties of toDo
		set counter to 1 + (counter)
		if (counter) is 500 then
			set fileCounter to 1 + (fileCounter)
			if (fileCounter) is 1 then
				exit repeat
			end if
			write "</xml>" & linefeed to todoFile
			close access todoFile
			set todoFilePath to todoFilePattern & " " & fileCounter & ".xml"
			set todoFile to (open for access file todoFilePath with write permission)
			set eof of todoFile to 0
			write "<xml><title>Toodledo :: to-do list</title><link>http://www.toodledo.com/</link><toodledoversion>6</toodledoversion><description>Your to-do list</description>" & linefeed to todoFile
			set counter to 0
		end if
		
	end repeat
	
	write "</xml>" & linefeed to todoFile
	close access todoFile
end tell

on formatEmptyValue(theValue)
	if theValue is missing value then
		set theValue to ""
	end if
	return theValue
end formatEmptyValue

on dateISOformat(theDate)
	if theDate is missing value then
		set theDate to ""
	else
		set y to text -4 thru -1 of ("0000" & (year of theDate))
		set m to text -2 thru -1 of ("00" & ((month of theDate) as integer))
		set d to text -2 thru -1 of ("00" & (day of theDate))
		set theDate to y & "-" & m & "-" & d
	end if
	return theDate
end dateISOformat

on timeISOformat(theDate)
	if theDate is missing value then
		set t to ""
	else
		set t to time string of theDate
	end if
	return t
end timeISOformat

on escapeTextToXml(theText)
	set the result to the escapeString(theText)
	return result
end escapeTextToXml

on escapeString(toEscape)
	set res to replaceChars(toEscape, "\"", "&quot;")
	set res to replaceChars(res, "'", "&apos;")
	set res to replaceChars(res, "&", "&amp;")
	set res to replaceChars(res, ">", "&gt;")
	set res to replaceChars(res, "<", "&lt;")
	return res
end escapeString

on replaceChars(this_text, search_string, replacement_string)
	set AppleScript's text item delimiters to the search_string
	set the item_list to every text item of this_text
	set AppleScript's text item delimiters to the replacement_string
	set this_text to the item_list as string
	set AppleScript's text item delimiters to ""
	return this_text
end replaceChars

on trimLine(this_text, trim_chars, trim_indicator)
	-- 0 = beginning, 1 = end, 2 = both
	set x to the length of the trim_chars
	-- TRIM BEGINNING
	if the trim_indicator is in {0, 2} then
		repeat while this_text begins with the trim_chars
			try
				set this_text to characters (x + 1) thru -1 of this_text as string
			on error
				-- the text contains nothing but the trim characters
				return ""
			end try
		end repeat
	end if
	-- TRIM ENDING
	if the trim_indicator is in {1, 2} then
		repeat while this_text ends with the trim_chars
			try
				set this_text to characters 1 thru -(x + 1) of this_text as string
			on error
				-- the text contains nothing but the trim characters
				return ""
			end try
		end repeat
	end if
	return this_text
end trimLine