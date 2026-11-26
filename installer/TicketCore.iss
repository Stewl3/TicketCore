#ifndef AppVersion
  #error AppVersion must be supplied using /DAppVersion=...
#endif
#ifndef Executable
  #error Executable must be supplied using /DExecutable=...
#endif
#ifndef OutputDir
  #error OutputDir must be supplied using /DOutputDir=...
#endif

[Setup]
AppId={{36E783B1-8974-4637-99A1-08DB3E34F221}
AppName=TicketCore
AppVersion={#AppVersion}
DefaultDirName={localappdata}\Programs\TicketCore
DefaultGroupName=TicketCore
DisableProgramGroupPage=yes
PrivilegesRequired=lowest
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
OutputDir={#OutputDir}
OutputBaseFilename=TicketCore-Setup-{#AppVersion}
SetupIconFile=..\icon.ico
UninstallDisplayIcon={app}\ticketcore.exe
Compression=lzma2
SolidCompression=yes

[Tasks]
Name: "desktopicon"; Description: "Create a desktop shortcut"

[Files]
Source: "{#Executable}"; DestDir: "{app}"; Flags: ignoreversion

[Dirs]
Name: "{localappdata}\TicketCore\output\data\Tickets"; Flags: uninsneveruninstall

[Icons]
Name: "{group}\TicketCore"; Filename: "{app}\ticketcore.exe"; WorkingDir: "{app}"
Name: "{autodesktop}\TicketCore"; Filename: "{app}\ticketcore.exe"; WorkingDir: "{app}"; Tasks: desktopicon
