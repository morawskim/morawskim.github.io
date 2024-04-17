# Traefik i OpenID Connect

Traefik zawiera middleawre [ForwardAuth](https://doc.traefik.io/traefik/middlewares/http/forwardauth/), który deleguje autentykacje do zewnętrznej usługi.

Za pomocą narzędzia `mkcert` wygenerowałem klucz i certyfikat wildcard dla domeny - `mkcert "*.i.morawskim.pl"`
Skonfigurowałem Traefik, aby korzystał z tego klucza i certyfikatu.

Tworzymy nowy deployment i usługę w klastrze k8s. Wykorzystujemy obraz [mesosphere/traefik-forward-auth](https://github.com/mesosphere/traefik-forward-auth), który obsługuje uniwersalnych dostawców OIDC takich jak Auth0.

Przykładowa konfiguracja kontenera dla deploymentu:

```
#...
containers:
- image: mesosphere/traefik-forward-auth
  name: forward-auth
  envFrom:
  - secretRef:
      name: openid-auth-forward
  ports:
  - containerPort: 4181
```

Tworzymy także zasób Secret "openid-auth-forward" z kluczami `CLIENT_ID`, `CLIENT_SECRET`, `ENCRYPTION_KEY` i `SECRET`.
CLIENT_ID i CLIENT_SECRET uzyskamy od naszego dostawcy OIDC.
Wartości dla ENCRYPTION_KEY i SECRET generujemy losowo.


Następnie konfigurujemy middleware ForwardAuth, który deleguje autentykacje do "mesosphere/traefik-forward-auth",

```
apiVersion: traefik.io/v1alpha1
kind: Middleware
metadata:
  name: openid-auth
spec:
  forwardAuth:
    address: http://traefik-forward-auth.traefik:4181
```

Modyfikujemy istniejący zasób "IngressRoute" i dodajemy do niego utworzony middleware:

```
apiVersion: traefik.io/v1alpha1
kind: IngressRoute
metadata:
  name: foo
spec:
  entryPoints:
    - internal
  routes:
    - kind: Rule
      # ....
      middlewares:
        - name: openid-auth
```

Możemy wykorzystać także ansible, który doda certyfikat mkcert do zaufanych w przeglądarce Chrome i Firefox.

```
- name: Find Firefox default profile directory
    find:
    paths: "{{ ansible_env.HOME }}/.mozilla/firefox"
    patterns: "*.default-release"
    file_type: directory
    register: firefox_profile
- name: Add  root-mkcert cert
    shell: |
    certutil -A -d {{item}} -t C,, -n root-mkcert
    args:
    stdin: |
        -----BEGIN CERTIFICATE-----
        .........
        -----END CERTIFICATE-----
    with_items:
    - "{{ firefox_profile.files.0.path }}"
    - "{{ ansible_env.HOME }}/.pki/nssdb"
```
