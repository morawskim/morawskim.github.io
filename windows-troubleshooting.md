# Windows troubleshooting

## Jak pozbyć się AI z Windowsa 11?

Otwieramy okno PowerShell - klikamy na menu Start i wpisujemy PowerShell.
Wklejamy poniższe polecenia:

```
# Get the package full name of the Copilot app
$packageFullName = Get-AppxPackage -Name "Microsoft.Copilot" | Select-Object -ExpandProperty PackageFullName
# Remove the Copilot app
Remove-AppxPackage -Package $packageFullName
```

Wywołanie tego kodu ma wystarczyć do pozbycia się Copilota z naszego komputera – nie jest wymagane instalowanie podejrzanych programów ani grzebanie w systemowych plikach.
Gdybyśmy z jakiegoś powodu ponownie chcieli zainstalować asystenta AI, znajdziemy go w [Microsoft Store](https://apps.microsoft.com/detail/9nht9rb2f4hd?hl=pl-PL&gl=PL).

[Remove or prevent installation of the Microsoft Copilot app](https://learn.microsoft.com/en-au/windows/client-management/manage-windows-copilot#remove-or-prevent-installation-of-the-microsoft-copilot-app)

## Mikrofon

Po instalacji systemu mikrofon działał w aplikacji "Rejestrator dźwięku".
W przeglądarce Edge był widoczny, a strona miała do niego dostęp, jednak mimo to nie nagrywał dźwięku.

Aktualizacja sterowników za pomocą programu [Driver Booster](https://www.iobit.com/pl/driver-booster.php) nie przyniosła efektu.
Problem udało się rozwiązać dopiero po zainstalowaniu opcjonalnych aktualizacji sterowników dostępnych w Windows Update.

Otwórz "Settings" -> "Windows Update", a następnie wybierz "Advanced Options"

![](/images/windows-troubleshooting/windows-update.png)

W sekcji "Aditional options" przejdź do "Optional updates"

![](/images/windows-troubleshooting/windows-update-advanced-options.png)

Zaznacz wszystkie dostępne aktualizacje sterowników i zainstaluj je.

![](/images/windows-troubleshooting/windows-update-optional-updates.png)
