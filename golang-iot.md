# Golang Internet rzeczy

## Mniejszy pliki wynikowy

Pliki wykonywalne Go są "ciężkie" i prosty program może zajmować parę megabajtów.
Generuje to problemy, gdy taki program chcemy wrzucić na urządzenia wbudowane.
Możemy zbudować lżejszy program ustawiając flagę dla ld - `go build -ldflags="-s"`.

Wywołując polecenie `man ld` możemy się dowiedzieć że flaga `-s` pomija wszystkie informacje o symbolach z pliku wyjściowego.

W jednym z projektów wielkość pliku wynikowego spadła z 12Mb do 7,7Mb.

## Gobot Bluetooth LE

Pakiet [Gobot Bluetooth LE](https://gobot.io/documentation/platforms/ble/) pozwala nam podłączyć się do 
urządzenia poprzez Bluetooth LE.

Podczas korzystania z ich przykładów otrzymywałem błąd:

> Field not found: Bonded

Po prześledzeniu wykonywanego kodu, doszedłem do problemu z biblioteką go-bluetooth - [Ignore fields that are not found in MapToStruct](https://github.com/muka/go-bluetooth/pull/170/files). 
W pliku `go.sum` możemy znaleźć zainstalowaną wersję pakietu, albo poprzez wywołanie polecenia `go  list -m all | grep 'go-bluetooth'`.
Mój system operacyjny korzystał z wersji bluez 5.66, więc zdecydowałem się na najnowsza wersję pakietu 5.65 - `go get github.com/muka/go-bluetooth@bluez-5.65`.
Powiniśmy otrzymać komunikat:
> go: upgraded github.com/muka/go-bluetooth v0.0.0-20200928120822-44d49b402aee => v0.0.0-20221213043940-892e7e1fdc02

Po zbudowaniu aplikacji demo błąd zniknął.

```
package main

import (
	"fmt"
	"gobot.io/x/gobot"
	"gobot.io/x/gobot/platforms/ble"
    "os"
)

func main() {
    bleAdaptor := ble.NewClientAdaptor(os.Args[1])
	info := ble.NewDeviceInformationDriver(bleAdaptor)
	battery := ble.NewBatteryDriver(bleAdaptor)
	access := ble.NewGenericAccessDriver(bleAdaptor)

	work := func() {
		fmt.Println("Model number:", info.GetModelNumber())
		fmt.Println("Firmware rev:", info.GetFirmwareRevision())
		fmt.Println("Hardware rev:", info.GetHardwareRevision())
		fmt.Println("Manufacturer name:", info.GetManufacturerName())
		fmt.Println("PnPId:", info.GetPnPId())

		fmt.Println("Battery level:", battery.GetBatteryLevel())

		fmt.Println("Device name:", access.GetDeviceName())
		fmt.Println("Appearance:", access.GetAppearance())
	}

	robot := gobot.NewRobot("bleBot",
		[]gobot.Connection{bleAdaptor},
		[]gobot.Device{info, battery, access},
		work,
	)

	robot.Start()
}
```
