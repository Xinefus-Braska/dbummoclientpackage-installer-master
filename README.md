# dbummoclientpackage-installer
NSIS installer creation scripts for https://github.com/Xinefus-Braska/DBUMMOMUSH. This is run automatically with AppVeyor to build release installers whenever code is pushed to the main branch.


Directions for running manually:

1. Put these files above a freshly cloned MUSHclient directory
2. Run MakeNSIS on dbumush_installer.nsi

In GNU/Linux with Wine on my machine, the invocation for MakeNSIS is:

`wine ~/.wine/drive_c/Program\ Files/NSIS/makensis.exe dbumush_installer.nsi`

I imagine the Windows invocation is not strikingly dissimilar.

Sample use:
```
git clone -b MUSHclient --depth 1 git@github.com:Xinefus-Braska/DBUMMOMUSH.git NEW_DBUMUSH_RELEASE
cd NEW_DBUMUSH_RELEASE
wget https://raw.githubusercontent.com/Xinefus-Braska/dbummoclientpackage-installer-master/master/dbumush_installer.nsi
wget https://raw.githubusercontent.com/Xinefus-Braska/dbummoclientpackage-installer-master/master/get_version.nsi
wget https://raw.githubusercontent.com/Xinefus-Braska/dbummoclientpackage-installer/master/hello.rtf
wine ~/.wine/drive_c/Program\ Files\ \(x86\)/NSIS/makensis.exe dbumush_installer.nsi
```
