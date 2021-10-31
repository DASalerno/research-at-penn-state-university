# This is a script for a speech analysis software called Praat. My task
# was to write a script that merged our "original" TextGrid files with
# their corresponding "aligned" TextGrid files to create the final
# "merged" TextGrids that would be used in our analysis.

# Form requests three inputs from user: path to original files, path to
# aligned files, and path to merged files. 
form Merge multiple TextGrids
   comment Where are the original TextGrids located?
   # The argument following 'text' designates the variable name.
   text originPath AlignedTestFiles\Unaligned\
   comment Where are the aligned TextGrids located?
   text alignedPath AlignedTestFiles\Aligned\
   comment Where to save the merged grids?
   text mergedPath merged\
endform

# Creates list of files using the original TextGrid files. Then, the
# number of files is extracted as a new variable.
Create Strings as file list... listOfFiles 'originPath$'\*.TextGrid
numberOfFiles = Get number of strings
select Strings listOfFiles
Sort

# For loop performs the following operations, which I have divided into
# three segments for simplicity's sake: (1) reads the aligned TextGrid
# into the program; (2) renames it so it does not conflict with its
# corresponding original TextGrid, which is then read into the program;
# (3) selects both TextGrids, merges them, and saves the product as a
# new, "merged" TextGrid file in the designated directory. This process
# is then repeated for every TextGrid file.
for i to numberOfFiles
   select Strings listOfFiles
   gridName$ = Get string... i
   if fileReadable ("'alignedPath$'\'gridName$'")
	Read from file... 'alignedPath$'\'gridName$'
	alignedName$ = gridName$ - ".TextGrid"
	alignedreName$ = alignedName$ + "_aligned"
	select TextGrid 'alignedName$'
 	Rename: alignedreName$
	Read from file... 'originPath$'\'gridName$'
	select TextGrid 'alignedreName$'
	plus TextGrid 'alignedName$'
	Merge
	select TextGrid merged
	Save as text file: "'mergedPath$'\'gridName$'"
	select all
	minus Strings listOfFiles
	Remove
   else
	# This 'echo' function displays a list of any missing or
	# unreadable TextGrids for troubleshooting purposes.
	echo Aligned 'gridName$' not found.
   endif
endfor

# Clears unnecessary stored info and displays the number of files
# merged to verify the success of the operation.
select Strings listOfFiles
Remove
clearinfo
echo Done. 'numberOfFiles' files merged.
