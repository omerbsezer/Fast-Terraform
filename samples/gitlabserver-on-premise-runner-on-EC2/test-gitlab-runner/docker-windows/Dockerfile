# escape=`

FROM mcr.microsoft.com/windows/servercore:1809

# Restore the default Windows shell for correct batch processing.
SHELL ["cmd", "/S", "/C"]

# install choco (win package manager like apt-get)
RUN @"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"

# install python3.7
RUN choco install -y python --version=3.7.2 `
    && set PATH=%PATH%;C:\Python37\

RUN choco install pwsh --version=7.3.3  -y

CMD ["powershell.exe", "-NoLogo", "-ExecutionPolicy", "Bypass"]