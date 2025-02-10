# Adobe-DC-ADMX
A combined Adobe Reader and Acrobat DC ADMX template for both Group Policy and importing into Intune.

Based off the files linked below, which was for Adobe Reader v7-DC only (not Acrobat), and has not been updated for 7+ years.
https://github.com/nsacyber/Windows-Secure-Host-Baseline/tree/master/Adobe%20Reader/Group%20Policy%20Templates

Recommend configuring settings for both products, unless you are 100% sure your environment only has 1 product.

Adobe Reader DC (x64) is actually a feature limited version of Acrobat DC - and may use the Acrobat settings rather 
than Reader settings (havent tested).

NOTE: Adobe has implemented some new features/regkeys that are not yet present in this ADMX profile (but its still a lot better 
than the sample ADMX Adobe provide).  Community assistance to make this ADMX template better will be appreciated. 


# INTUNE SPECIFIC:
If importing to Intune you first need to import "Windows.admx" (and Windows.adml) - found in "C:\Windows\PolicyDefinitions\" 
on any Windows 10/11 PC.

You can configure both Reader and Acrobat settings in same Intune profile - or split them into separate profiles.

If you wish to upgrade the Adobe ADMX version in Intune, you must first delete any profiles that use this ADMX (take note of 
all the settings first!), delete the ADMX, import new ADMX, and then re-create the profile(s) again.
