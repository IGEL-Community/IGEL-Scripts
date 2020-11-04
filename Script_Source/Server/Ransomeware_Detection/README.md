# Ransomeware Detection

***
## Method to monitor file shares for Ransomeware

| Name | Description |
|------|-------------|
|[Ransomware_detect.vbs](Ransomeware_detect.vbs)|Script to check for the existence / validity of files on shares to catch ransomware before it causes major issues. Sends an email notifying people if there was a problem. |
|[SetBait.vbs](SetBait.vbs)| Script to copy and icacl the BAIT file to the shares listed in the shares.txt file.<br /><br /> shares.txt should be of the form:<br /><br /> \\foldername[,additionalemailaddress]|
|[shares.txt](shares.txt)|File shares to monitor|
|[_debug.docx](_debug.docx)|File to place into shares|
|[log.txt](log.txt)|Log file|


A simple addition to commercial products can help stop a ransomware attack that may have gotten past your fortifications before it requires the pain and downtime of restoring from backup or the cost of paying a ransom.  Every piece of ransomware has a zero day, after all.

The concept is simple:  you place dummy files in various locations on your file system to act as an early warning system for a ransomware attack.  Once the files are in place, you have a scheduled task that runs every few minutes to verify that the dummy file has not been modified, and, if it has been (and the location is reachable) sends a warning to the user or a sysadmin about potential ransomware in that specific location.  

What can a sysadmin do with this information?

When ransomware has run, it will not just have encrypted the dummy file, it will also have dropped a file (typically an .html) that explains how to make a payment to decrypt the files.  If ACLs on a folder / directory are set such that the file retains the ownership of its creator, the owner of this file will be the user in your organization that has gotten a ransomware infection.  You can then quickly shut down their virtual desktop session (endpoint) or disable their account to stop the ransomware.  You could also, if the culprit cannot be quickly discovered, just shut down your file systems to protect them from a greater infection, substituting a little downtime today for an extended downtime in the following days.

Specifically, to implement this method, create a dummy file, a config file and two scripts.  

The dummy file can be anything, though most ransomware tends to work in alphabetical order, so something that shows up at the top of the file list is helpful.  If you are placing these in shared locations, you might be wise to let users know to ignore these files.  The file should have the same permissions as other files in the folder, which can mean users could modify or delete the file.  For example, create a text file but name it with a .docx extension to make it less likely to be modified.  

The config file is just a text list of locations in which to place the file.  For example:

\\\\shared\Finance\2019\
\\\\shared\Finance\2020\
\\\\userdata\Tom\Desktop\
c:\users\Tom\Documents\aacme\

The first script is the SetBait script which copies the dummy file to each location listed in the config file.

The second script is the DetectRansonware script, which is a light-weight script that can be scheduled to run every few minutes with very little system impact.  This script loops through each folder location in the config file, and checks the following:

Does the dummy file exist in the location?

- Yes: is it still identical to the local dummy file?

   - Yes: no worries!

   - No: Ransomware?? An email is sent immediately to the assigned user(s) with the threat warning and the location.  (“11/2/2020 3:03 pm POTENTIAL Ransomware detected in folder \\\\shared\Finance\2019”)

-	No: does the location exist?

   - Yes: copy the dummy file back to the location and add that action to a warning string (“11/2/2020 3:03 pm  Dummy file did not exist in folder \\\\shared\Finance\2019.  Copied”)

   - No: verify that the root of the listed location exists, e.g. \\\\shared and add that to a warning string (“11/2/2020 3:05 pm Could not reach location \\\\userdata”

When finished with each location, if the warning string is not empty, then email it with a lesser warning, as these could just be artifacts from temporary outages or user interference, but it could signal the need for investigation or changing the bait locations.

This method may require a little baby sitting to check on false positives but those are easy to dismiss, and catching even one infection before any noticeable damage?  Priceless.
