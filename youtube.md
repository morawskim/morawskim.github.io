# YouTube

## Osadzenie filmu na stronie

YouTube udostępnia API do osadzenia filmów na stronie poprzez mechanizm [iframe](https://developers.google.com/youtube/iframe_api_reference?hl=pl). Musimy ustawić atrybut `src` ramki iframe na wartość `https://www.youtube.com/embed/<videoId>`. Parametr `videoId` możemy wyciągnąć z linku YT za pomocą funkcji:

```
function getVideoId(url) {
    const regExp = /^.*(youtu.be\/|v\/|u\/\w\/|embed\/|watch\?v=|&v=)([^#&?]*).*/;
    const match = url.match(regExp);

    return match && match[2].length === 11 ? match[2] : null;
}
```

Dodatkowo chcąc, aby nasz odtwarzacz był responsywny i dostosowywał się do szerokości strony z zachowaniem proporcji tworzymy regułę CSS:

```
iframe {
    width: 100%;
    height: 100%;
    aspect-ratio: 16 / 9;
}
```
