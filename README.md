# RIEMANN_LOG_PRODUCT_HOLOGRAM_TM.sh

Riemann log-product hologram TM (`x=1/2`, symbolic channels).

| Artifact | Role |
|----------|------|
| `RIEMANN_LOG_PRODUCT_HOLOGRAM_TM.sh` | One-liner (~1325B) |
| `RIEMANN_LOG_PRODUCT_HOLOGRAM_TM_DAEMON.sh` | Resident loop (default 1s) |
| `.github/workflows/riemann-log-product-hologram-tm.yml` | Actions `*/5` |

```sh
curl -fsSL https://raw.githubusercontent.com/letsgo0226/RIEMANN_LOG_PRODUCT_HOLOGRAM_TM.sh/main/RIEMANN_LOG_PRODUCT_HOLOGRAM_TM.sh | bash
nohup bash RIEMANN_LOG_PRODUCT_HOLOGRAM_TM_DAEMON.sh 1 >> riemann_log_product_hologram_tm_daemon.log 2>&1 &
```

Bound: formal / symbolic only — `RH_proved=false`; not an RH proof.
