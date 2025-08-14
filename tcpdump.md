# tcpdump

`tcpdump -i eth0 'tcp port 22 and tcp[tcpflags] & tcp-syn != 0'` - pokaż wszystkie pakiety TCP na porcie 22 (na interfejsie eth0), które mają ustawioną flagę SYN (czyli próby rozpoczęcia połączenia SSH).
