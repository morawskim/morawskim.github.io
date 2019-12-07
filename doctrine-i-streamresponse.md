# Doctrine i StreamResponse

Pobierając dużą ilość rekordów z bazy danych stosujemy podejście strumieni. W przypadku próby pobrania wszystkich danych naraz, zabraknie nam pamięci.
Zwiększanie limitu dostępnej pamięci do alokacji może pomóc (https://www.php.net/manual/en/ini.core.php#ini.memory-limit), jest to jednak rozwiązanie tymczasowe. Wcześniej czy później musimy przejść na rozwiązanie strumieniowe. Zunifikowany interfejs dostępu do bazy danych PDO dostarcza niezbędne API, dzięki czemu jest to proste zadanie.

W tym uproszczonym przypadku korzystamy z biblioteki Doctrine. I to za jej pomocą tworzymy `PDOStatement`.
Klasa `PDOStatement` implementuje interfejs `\Traversable`, dzięki temu możemy podstawić obiekt implementujący ten interfejs do konstrukcji `foreach` (https://www.php.net/manual/en/class.pdostatement.php). Dzięki temu alokowana jest tylko pamięć niezbędna do przechowania jednego wiersza. Otwieramy także strumień `stdout`, gdzie będziemy wyświetlać dane pobrane z bazy danych.

``` php
/** @var EntityManager $em */
$em = $this->getDoctrine()->getManager();
$conn = $em->getConnection();
$stmt = $conn->prepare('SELECT uuid from audience_users au WHERE au.audience_id = :audienceId');
$stmt->execute(['audienceId' => $audience->getId()]);

$response = new StreamedResponse();
$response->setCallback(function () use ($stmt) {
    $handle = fopen('php://output', 'wb');
    foreach ($stmt as $row) {
        fputcsv($handle, $row);
    }
    fclose($handle);
});


$response->headers->set('Content-Type', 'text/csv');
$dispositionHeader = $response->headers->makeDisposition(ResponseHeaderBag::DISPOSITION_ATTACHMENT, sprintf('audience%d.csv', $audience->getId()));
$response->headers->set('Content-Disposition', $dispositionHeader);
$response->setStatusCode(Response::HTTP_OK);
return $response;
```
