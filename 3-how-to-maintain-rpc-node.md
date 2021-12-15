# RPC Maintenance

More to this section coming soon.



Healthcheck
```
curl http://localhost:8899 -k -X POST -H "Content-Type: application/json" -d '
  {"jsonrpc":"2.0","id":1, "method":"getHealth"}
'
```

Tracking root slot
```
timeout 120 solana catchup --our-localhost=8899 --log --follow --commitment root
```

curl for getBlockProduction
```
curl http://localhost:8899 -k -X POST -H "Content-Type: application/json" -H "Referer: GGLabs" -d '{"jsonrpc":"2.0","id":1, "method":"getBlockProduction"}
'
```

Grafana Dashboard


Discord Integration (Shadow Ops Channel)


Alerts


Useful server commands for running system checks:

