# FlyFaaSt

A quick hacky Phoenix FaaS running off of Fly.io's infrastructure.

To deploy your Fly Function as a Service:

1. Set up your machine: `flyctl apps create fly-faast --machines`
2. Allocate some IP's so we can chat with it:
  ```
  flyctl ips allocate-v4 -a fly-faast
  flyctl ips allocate-v6 -a fly-faast
  ```
3. Generate a secret and set it up as an environment variable in Fly.io
  ```
  key=$(mix phx.gen.secret)
  flyctl secrets -a fly-faast SECRET_KEY_BASE=$key
  # Optional configure a different timeout
  flyctl -a fly-faast secrets set FLY_FAAST_TIMEOUT=15000
  ```
4. Deploy: `fly machine run . --app fly-faast --port 443:4000/tcp:tls`
5. Update your server with: `fly machine update MACHINE_ID --dockerfile Dockerfile`

Inspired by [Scale to Zero with Fly.io Machines](https://benjohnson.ca/2022/11/20/scale-to-zero.html)
