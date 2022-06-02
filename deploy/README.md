# Deploying
* export a private key, `main.go` expects it as `PRIVATE_KEY` available to `os.Getenv`
* export a URL that `ethclient` can connect with, `main.go` expects it as `CLIENT_URL` available to `os.Getenv`
* edit cmd/main.go for the `chainId` you want to deploy to
* `cd cmd && go run main.go` (or cd into cmd then `./cmd`)

### Notes
* You may want to adjust the `auth.GasLimit`.
* Will always deploy the latest version of the protocol.

