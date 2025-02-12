# Adobe-DC-ADMX
A combined Adobe Reader and Acrobat DC ADMX template for both Group Policy and importing into Intune.

Based off the files linked below, which was for Adobe Reader v7-DC only (not Acrobat), and has not been updated for 7+ years.
https://github.com/nsacyber/Windows-Secure-Host-Baseline/tree/master/Adobe%20Reader/Group%20Policy%20Templates

Recommend configuring settings for both products, unless you are 100% sure your environment only has 1 product.

Adobe Reader DC (x64) is actually a feature limited version of Acrobat DC - and may use the Acrobat settings rather 
than Reader settings (havent tested).

# INTUNE SPECIFIC:
If importing to Intune you first need to import "Windows.admx" (and Windows.adml) - found in "C:\Windows\PolicyDefinitions\" 
on any Windows 10/11 PC.

You can configure both Reader and Acrobat settings in same Intune profile - or split them into separate profiles.

If you wish to upgrade the Adobe ADMX version in Intune, you must first delete any profiles that use this ADMX (take note of 
all the settings first!), delete the ADMX, import new ADMX, and then re-create the profile(s) again. 
ADMX support in Intune is still a bit clunky but will hopefully improve over time. 

# Help
Adobe has implemented some later features/regkeys that are not yet present in this ADMX profile.
I'd like to add them but not sure if/when I will get a chance.   Community assistance to continue to develop this ADMX template
will be greatly appreciated. 

# Screenshots from Intune:

![image](https://github.com/user-attachments/assets/54ac98e3-da2c-4d19-8f78-f49c689227e3)

![image](https://github.com/user-attachments/assets/a1438060-d7b5-40df-acad-89beba0b60b0)

![image](https://github.com/user-attachments/assets/619e347f-98cf-4e4b-9cb2-d0e6e75e4c2d)

![image](https://github.com/user-attachments/assets/e056c2e6-c7cb-4c1a-9742-996df740252a)

![image](https://github.com/user-attachments/assets/efb50605-a773-4f82-b28a-39a75d8316a2)

![image](https://github.com/user-attachments/assets/9349b830-7f45-47f3-8444-c015b3341ec5)

![image](https://github.com/user-attachments/assets/e035c781-a191-4205-b6ae-bfeea5796865)

![image](https://github.com/user-attachments/assets/57555224-a664-456c-abf0-83425827896b)

![image](https://github.com/user-attachments/assets/4dd918f9-c0ca-425b-a152-28348cc5c087)
