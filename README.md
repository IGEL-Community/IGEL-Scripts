# IGEL Scripts

***
## How-to use Scripts

***
### General
IGEL scripts are delivered as a zip archive. The archive has the following content:

| Folder | Description |
|--------|-------------|
|igel | folder containing UMS profiles|
|target | folder containing package script(s)|
|disclaimer.txt | disclaimer note|
|readme.txt | Short Installation guide|

***
## IGEL Disclaimer

The provided packages are without any warranty or support by IGEL Technology.
<br /> <br />
The files are not designed for production usage, use at your own risk. IGEL Technology will not provide any packages for production use and will not create or support any other packages or the implementation for other 3rd party software.
<br /> <br />
IGEL Technology is not responsible for any license violation created with the scripts or the provided technical demonstation packages.
<br /> <br />
The scripts can create permanent damage in the IGEL OS host system, services related to the wrong usage/misinstallation and are not covered by the warranty in any kind.
<br /> <br />
You will not get support as long the script is used on a system, to avoid conflicts you've to reset the device back to factory defaults before opening a support call.
<br /> <br />
All packages are designed as technical demonstration samples!
<br /> <br />
Use at your own risk!
<br /> <br />
Your IGEL Support/PreSales Team October 2020

***
***
### Revision Summary

| Element Version | Date | Change Owner | Description |
| ---- | ---- | ---- | ---- |
| 0.1 | 16-October-2020 | Ron Neher | Initial version |

***
***
### Outstanding Issues

| Ref  | Description |
| ---- | ----------- |
| OI.1 | NTR |

Zip file layout:
```{Zip file layout}
disclaimer.txt
profiles/
   profiles.zip (profile.xml, OS_VER.xml)
readme.txt   
target/
   <script1>.sh
   <scriptN>.sh
   <script>.inf
  ```
