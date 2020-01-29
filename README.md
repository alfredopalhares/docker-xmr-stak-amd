# Docker XMRStack AMD

This is a docker container for running [xmr-stack](https://github.com/fireice-uk/xmr-stak) with AMD system.


## Requiriments

The host **needs to have** the AMD Pro Drivers installed.


## Usage


### Configuration

The suggested method to use the `docker-compose.yml` file, copy `xmr_stat.env.dist` to `xmr_stak.env.dist` and edit the variables:

```
XMRSTAK_POOL_ADDRESS="mypool"
XMRSTAK_WALLET_ADDRESS="mywallet"
XMRSTAK_RIG_ID="rig"
XMRSTAK_POOL_PASSWORD="x:my@email.com"
```

### Devices

You must pass `/dev/dri/` and `/dev/kfd` for the container


## Contributing

Please Open a Pull Request or an Issue, for any improvements or doubts :)

## Maintainer

[Alfredo Palhares](https://github.com/alfredopalhares)

## Support

I can give support for your miner and mining solutions, hit me via email:
```
alfredo <at> palhares <dot> me
```

Also, if you like this work, and would like to support it, you can done to this Monero Address:
```
47pqA6e7j5H64ohkvY7vq7AuYLHPHroQzMuhuaCdXVpzUBCT3x6MNnHY35NHuiDGMCF7NkQFy1P9jDrvh7bePAsJ1mWVf72
```