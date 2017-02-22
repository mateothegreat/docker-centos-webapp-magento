# Magento 2.1.4+/- @ CentOS & nginx + php70-fpm
![docker](./magento-2-development-docker-os-x.png)

### Download Magento Source into persistent volume
You should only have to do this once.

__WARNING:__ You run the risk of overwriting existing data & changes!

```sh
VERSION=2.1.4

curl -q https://codeload.github.com/magento/magento2/tar.gz/$VERSION \
    -o $VERSION.tar.gz &&
        
tar -xzf $VERSION.tar.gz -C src/www \
    --strip-components=1

```

### Launch docker container 

```sh
docker run  -i -d -p 80:80  \
            -v src:/www     \
            --name magento  \
            appsoa/docker-centos-webapp-magento:latest
```

### Create persistent disk in Google Cloud Platform

```sh
gcloud  compute disks create            \
        magento-persistent-disk-www     \
        --size 10GB                     \
        --zone us-central1-a            \
        --type pd-ssd                   \
        --description 'Persistent disk for /www volume including the magento source code.' 
```

_Example results:_
```sh
Created [https://www.googleapis.com/compute/v1/projects/hale-proposal-159523/zones/us-central1-a/disks/magento-persistent-disk-www].
NAME                         ZONE           SIZE_GB  TYPE    STATUS
magento-persistent-disk-www  us-central1-a  10       pd-ssd  READY
````