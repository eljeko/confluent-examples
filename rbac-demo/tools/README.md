# Local build
docker build -f Dockerfile-tools -t cnfldemos/tools:<tag> --no-cache .

# Remote
https://hub.docker.com/r/cnfldemos/tools


## Prepare udpated tools container

From the project root run the docker build for new tools container:

```docker build -f tools/Dockerfile-tools -t cnfldemos/tools:3.0.1 --no-cache . ```
