#!/usr/bin/env bash
# RIEMANN_LOG_PRODUCT_HOLOGRAM_TM resident loop — default 1s
set -u
INTERVAL="${1:-${RLPH_INTERVAL:-1}}"
LOG="${RLPH_LOG:-riemann_log_product_hologram_tm_daemon.log}"
DIR="$(cd "$(dirname "$0")" 2>/dev/null && pwd || pwd)"
SCRIPT="${RLPH_SCRIPT:-$DIR/RIEMANN_LOG_PRODUCT_HOLOGRAM_TM.sh}"
RAW_URL="https://raw.githubusercontent.com/letsgo0226/RIEMANN_LOG_PRODUCT_HOLOGRAM_TM.sh/main/RIEMANN_LOG_PRODUCT_HOLOGRAM_TM.sh"
WORKDIR="${RLPH_WORKDIR:-$DIR/run}"
mkdir -p "$WORKDIR"
if [[ ! -f "$SCRIPT" ]]; then
  command -v curl >/dev/null || exit 127
  SCRIPT="${TMPDIR:-/tmp}/RIEMANN_LOG_PRODUCT_HOLOGRAM_TM.sh"
  curl -fsSL "$RAW_URL" -o "$SCRIPT" || exit 1
fi
command -v python3 >/dev/null || exit 127
echo "{\"daemon\":\"RIEMANN_LOG_PRODUCT_HOLOGRAM_TM\",\"interval\":$INTERVAL,\"ts\":\"$(date -u +%Y-%m-%dT%H:%M:%SZ)\"}" | tee -a "$LOG"
while true; do
  TS=$(date -u +%Y-%m-%dT%H:%M:%SZ)
  OUT=$(mktemp)
  if (cd "$WORKDIR" && bash "$SCRIPT" >"$OUT" 2>"${OUT}.err"); then
    if python3 - "$OUT" <<'PY'
import json,sys
o=json.load(open(sys.argv[1]))
ex=o.get("exact") or {}
cl=o.get("claims") or {}
ok=(o.get("model")=="RIEMANN_LOG_PRODUCT_HOLOGRAM_TM"
    and ex.get("float") is False and ex.get("sha") is False
    and cl.get("RH_proved") is False
    and isinstance(o.get("tick"), int) and o.get("tick")>=1
    and o.get("x")==[1,2] and o.get("s")==[3,4])
sys.exit(0 if ok else 2)
PY
    then echo "{\"ts\":\"$TS\",\"status\":\"pass\"} $(python3 -c 'import json,sys;o=json.load(open(sys.argv[1]));print(json.dumps({"model":o["model"],"tick":o["tick"],"exact":o.get("exact"),"RH_proved":(o.get("claims") or {}).get("RH_proved")},separators=(",",":")))' "$OUT")" >>"$LOG"
    else echo "{\"ts\":\"$TS\",\"status\":\"assert_fail\"}" >>"$LOG"
    fi
  else echo "{\"ts\":\"$TS\",\"status\":\"run_fail\"}" >>"$LOG"
  fi
  rm -f "$OUT" "${OUT}.err"
  sleep "$INTERVAL"
done
