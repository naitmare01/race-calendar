FROM mcr.microsoft.com/powershell:centos-7
RUN pwsh -c "Install-Module UniversalDashboard.Community -Acceptlicense -Force"
COPY . /var/www/racecalendar

CMD [ "pwsh","-command","& ./var/www/racecalendar/main.ps1" ]
