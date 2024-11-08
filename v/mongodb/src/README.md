## Import

```v
import mongo

uri := mongo.uri('mongodb://localhost:27017/')
```

## Driver requirements

### Debian or Ubuntu

```bash
sudo apt update -y && sudo apt upgrade -y
# DEV
sudo apt install -y libmongoc-dev

# CLI
sudo apt install -y libbson-1.0-0 libmongoc-1.0-0
```

### Alpine

```bash
apk update && apk upgrade
# DEV
apk add --no-cache build-base mongo-c-driver-dev

# CLI
apk add --no-cache gcompat openssl libatomic
apk add --no-cache mongo-c-driver
```

### Windows

It is necessary to specify the path to the [DLLs](https://github.com/moixllik/v-mongo/tree/main/thirdparty/win64/bin) (`bson-1.0` and `mongoc-1.0`) or have them in the same folder as the executable, also install [Microsoft Visual C++ Redistributable](https://learn.microsoft.com/en-us/cpp/windows/latest-supported-vc-redist).
