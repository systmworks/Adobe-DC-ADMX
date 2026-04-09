This Adobe ADMX template can be added to Group Policy store, or imported into Intune.

Supports Adobe Reader DC and Adobe Acrobat DC.  Recommend configuring settings for both products.

Adobe Reader DC (x64) is actually a feature limited version of Acrobat DC - and may use the Acrobat settings rather 
than Reader settings.


INTUNE SPECIFIC:
If importing to Intune you first need to import "Windows.admx" (and Windows.adml) - found in "C:\Windows\PolicyDefinitions\" 
on any Windows 10/11 PC.

You can configure both Reader and Acrobat settings in same Intune profile - or split them into 2 profiles.

If you wish to upgrade the Adobe ADMX version in Intune, you must first delete any profiles that use this ADMX (take note of 
all the settings first!), delete the ADMX, import new ADMX, and then re-create the profile(s) again.
