#FROM mcr.microsoft.com/powershell:6.1.0-rc.1-ubuntu-18.04
FROM mcr.microsoft.com/powershell:centos-7
RUN pwsh -c "Install-Module UniversalDashboard.Community -Acceptlicense -Force"
COPY . /var/www/racecalendar

CMD [ "pwsh","-command","& ./var/www/racecalendar/main.ps1" ]
