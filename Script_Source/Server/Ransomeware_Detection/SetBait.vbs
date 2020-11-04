'*********************************************************
'
' Script to copy and icacl the BAIT file to the shares listed in the shares.txt file
'
'
' shares.txt should be of the form:
' \\foldername[,additionalemailaddress]
'
'*********************************************************


Const BAIT = "\_debug.docx"
const thisfolder = "\\folderwheretheBAITfileis"


set fso = CreateObject("Scripting.FileSystemObject")
set objshell = CreateObject("Wscript.Shell")

strfilename = "shares.txt"


if not fso.fileexists(strfilename) then
  wscript.echo "Couldn't find file:"&strfilename
  wscript.quit
end if

set readfile = fso.OpenTextFile(strfilename, 1, false)

While not readFile.AtEndOfStream
  thisline = readFile.ReadLine

  a = split(thisline,",")
  thisshare = a(0)


  if left(thisshare,1) <> "#" then
     cmd1 = "cmd /c copy """&thisfolder&"\"&BAIT&""" """&thisshare&""""
     cmd2 = "cmd /c icacls """&thisshare&"\"&BAIT&""" /grant ""domain users"":m"
     objshell.run cmd1,0,true
     objshell.run cmd2,0,true
  end if
wend



readfile.close

wscript.echo "done"
