'*********************************************************
'
' Script to check for the existence/validity of files on shares
'  hopefully to catch ransomware before it causes major issues
'
' Sends an email notifying people if there was a problem.
'
'*********************************************************

Const SENDEMAILTOERRORS ="adminuser@thiscorp.org;helpdesk@thiscorp.org"
Const SENDEMAILTOWARNINGS="adminuser@thiscorp.org"
Const BAIT = "\_debug.docx"
Const BAITLINE = "Do not delete me or modify me."
Const THISFOLDER = "\\WhereIPutthisScript"
Const MAILSENDER = "Possible_Ransomware@thisorg.org"
Const SMTP = "smtp.thiscorp.org"
Const MAXEMAILS = 12 'maximum number of emails to send with each run

Dim numEmails
Dim WarningStr

numEmails = 0
WarningStr = ""

set fso = CreateObject("Scripting.FileSystemObject")
set objshell = CreateObject("Wscript.Shell")

strConfigFilename = "shares.txt"
strLogFilename = "log.txt"

if not fso.fileexists(strConfigFilename) then
  sendRWemail SENDEMAILTOWARNINGS,"File " & strConfigFilename& " is missing from "& thisfolder,"Ransomware_Detect did not run","warning"
  wscript.quit
end if
set ConfigFile = fso.OpenTextFile(strConfigFilename, 1, false)
set writefile = fso.OpenTextFile(strLogFilename, 8, true)

'If you want to log every run, even without warnings/errors:
' writefile.writeline "Running: "&date&" "&time

' Read the config file with a shared location, one per line (optional email address can be added after a comma)
While not ConfigFile.AtEndOfStream
  thisline = ConfigFile.ReadLine

  a = split(thisline,",")  'we can add a sendmail person after a comma in the input file
  if ubound(a) < 1 then
     thismail = ""
  else
     thismail = a(1)&";"
  end if
  thisshare = a(0)


  if left(thisshare,1) <> "#" then  'ignore commented lines

    if not file_is_ok(thisshare) then
      svr = split(thisshare,"\")(2)
      if pingable(svr) or instr(this share,":")<>0 then  'don't bother people if the server is down

        if not fso.folderexists(thisshare) then   'if the folder is gone, let people know
          WarningStr = WarningStr & date &" "&time&" Folder: " &thisshare& " has apparently been deleted"&chr(13)
          writefile.writeline & date &" "&time&" Folder: " &thisshare& " has apparently been deleted"

        else

          if not fso.fileexists(thisshare&BAIT) then  'if the file is gone, just put it back!
            WarningStr = WarningStr & date &" "&time&" File " &BAIT& " has been deleted on "&thisshare&".  Fixing that."&chr(13)
            writefile.writeline & date &" "&time&" File " &BAIT& " has been deleted on "&thisshare&".  Fixing that."
            fixbait thisshare

          else 'Actual corruption of the file
            sendRWemail thismail & SENDEMAILTOERRORS, date &" "&time&" Possible ransomware on "&thisshare&" file exists and is corrupt!",thisshare,"error"
            writefile.writeline date &" "&time&" Possible ransomware on "&thisshare&" file exists and is corrupt!"
          end if
        end if
      end if
    end if
  end if
wend


' writefile.writeline "Finished: "&date&" "&time

If WarningStr <> "" then 'there were warnings
  sendRWemail SENDEMAILTOERRORS, date &" "&time&" Warnings from Ransonware_detect",WarningStr,"warning"
End if

writefile.close
ConfigFile.close

sub fixbait(thisshare)

     cmd1 = "cmd /c copy """&thisfolder&"\_debug.docx"" """&thisshare&""""
     cmd2 = "cmd /c icacls """&thisshare&"\_debug.docx"" /grant ""domain users"":m"
     objshell.run cmd1,0,true
     objshell.run cmd2,0,true

end sub

sub sendRWemail(strTo,strSub,strBody,strLevel)

numEmails = numEmails + 1
if numEmails < MAXEMAILS then

  set objEmail = CreateObject("CDO.Message")
  objEmail.From = MAILSENDER
  objEmail.To = strTo
  objEmail.Subject = strSub
  If strLevel = "warning" then
   objEmail.Textbody = strBody
  Else
   objEmail.Textbody = "This email means that the bait file "&BAIT&" in "&strBody&" is missing or changed."&chr(13)&_
                   "This could indicate an active Ransomware Attack or that the file has been modified."&chr(13)&_
                   "Investigate immediately.  If you find this is a false alarm:"&chr(13)&_
                   "  a) copy the file "&BAIT&" from "&THISFOLDER&" to "&strBODY&chr(13)&_
                   "  b) remove or comment out this share in "&CONFIGFILENAME&" in "&THISFOLDER&"."
  End if
  objEmail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendusing") = 2
  objEmail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserver") = SMTP
  objEmail.Configuration.Fields.Update
  objEmail.Send

end if

end sub


function file_is_ok(machine)
 dim objfso,readfile
 on error resume next

    if machine = "" then
      file_is_ok = true
    else
      file_is_ok = false
      set objfso = CreateObject("Scripting.FileSystemObject")
      if objfso.fileexists(machine & BAIT) then
         set readfile = objfso.OpenTextFile(machine & BAIT, 1, false)
         linecheck = readfile.readline
         if linecheck = BAITLINE then
           file_is_ok = true
         end if
         readfile.close
      end if
    end if

end function


function pingable(machine)
 dim objPing, objStatus

    if machine = "" then
      pingable = false
    else
      pingable = true
    Set objPing = GetObject("winmgmts:{impersonationLevel=impersonate}")._
        ExecQuery("select * from Win32_PingStatus where address = '"_
            & machine & "'")
    For Each objStatus in objPing
        If IsNull(objStatus.StatusCode) or objStatus.StatusCode<>0 Then
            pingable = false
        End If
    Next
    end if
end function
