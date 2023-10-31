# Acpid

Obecnie `system-logind` obsługuje zdarzenia związane z naciśnięciem przycisku zasilania, czy też otwarcia/zamknięcia pokrywy laptopa.

Jeśli mamy problemy z niektórymi klawiszami specjalnymi możemy zainstalować pakiet `acpid`.

Instalujemy pakiet acpid - `sudo zypper in acpid`
Włączamy usługę - `sudo systemctl enable --now acpid`
Uruchamiamy program nasłuchujący na zdarzenia ACPI `acpi_listen` i naciskamy klawisz specjalny. Powinniśmy zobaczyć kod klawisza np.

> cd/prev CDPREV 00000080 00000000 K

Następnie musimy [utworzyć regułę ACPI](https://linuxconfig.org/how-to-handle-acpi-events-on-linux).
