# hatecisco
Script to download the latest packet tracer for linux.
You know why this is needed if you had to use packet tracer on arch linux.

This uses a headless selenium firefox driver to log in and fetch the file into `$HOME/.cache/paru/clone/packettracer/`


## requirements

gecko webdriver (it is in the repos) installed and probably firefox

```
gem install selenium-webdriver
gem install json
```

## how to use

fill your login credentials in the credentials.json

```
ruby fuckcisco.rb
```


