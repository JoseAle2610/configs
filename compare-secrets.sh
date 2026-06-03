#!/usr/bin/env bash
#
# compare-secrets.sh
# Compara secretos de AWS Secrets Manager entre ambientes.
# Usa Dev como fuente de verdad y detecta variables faltantes o vacías
# en Staging y/o Prod.
#
# Uso:
#   ./compare-secrets.sh --dev dev.json --staging staging.json --prod prod.json
#   ./compare-secrets.sh --dev dev.json --staging staging.json
#   ./compare-secrets.sh --dev dev.json --prod prod.json
#
# Requisitos: jq

set -euo pipefail

# ── Colores ──────────────────────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

# ── Parseo de argumentos ─────────────────────────────────────────────────────
DEV_FILE=""
STAGING_FILE=""
PROD_FILE=""

usage() {
  cat <<EOF
Uso: $(basename "$0") --dev <file.json> [--staging <file.json>] [--prod <file.json>]

Opciones:
  --dev      Archivo JSON del ambiente de desarrollo (obligatorio)
  --staging  Archivo JSON del ambiente de staging (opcional)
  --prod     Archivo JSON del ambiente de producción (opcional)
  --help     Mostrar esta ayuda

Ejemplos:
  $(basename "$0") --dev secrets-dev.json --staging secrets-staging.json --prod secrets-prod.json
  $(basename "$0") --dev secrets-dev.json --staging secrets-staging.json
EOF
  exit 0
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dev)
      DEV_FILE="$2"
      shift 2
      ;;
    --staging)
      STAGING_FILE="$2"
      shift 2
      ;;
    --prod)
      PROD_FILE="$2"
      shift 2
      ;;
    --help|-h)
      usage
      ;;
    *)
      echo -e "${RED}Error: opción desconocida '$1'${NC}"
      usage
      ;;
  esac
done

if [[ -z "$DEV_FILE" ]]; then
  echo -e "${RED}Error: --dev es obligatorio${NC}"
  usage
fi

if [[ ! -f "$DEV_FILE" ]]; then
  echo -e "${RED}Error: archivo no encontrado: $DEV_FILE${NC}"
  exit 1
fi

# ── Validación de JSON ───────────────────────────────────────────────────────
validate_json() {
  local file="$1"
  local label="$2"

  if ! jq empty "$file" 2>/dev/null; then
    echo -e "${RED}Error: $label no es un JSON válido: $file${NC}"
    exit 1
  fi
}

validate_json "$DEV_FILE" "Dev"

if [[ -n "$STAGING_FILE" ]]; then
  if [[ ! -f "$STAGING_FILE" ]]; then
    echo -e "${RED}Error: archivo no encontrado: $STAGING_FILE${NC}"
    exit 1
  fi
  validate_json "$STAGING_FILE" "Staging"
fi

if [[ -n "$PROD_FILE" ]]; then
  if [[ ! -f "$PROD_FILE" ]]; then
    echo -e "${RED}Error: archivo no encontrado: $PROD_FILE${NC}"
    exit 1
  fi
  validate_json "$PROD_FILE" "Prod"
fi

# ── Función de comparación ───────────────────────────────────────────────────
compare_env() {
  local reference="$1"
  local target="$2"
  local ref_label="$3"
  local tgt_label="$4"

  local missing=()
  local empty=()
  local present=0

  # Obtener todas las keys de referencia
  local keys
  keys=$(jq -r 'keys[]' "$reference")

  for key in $keys; do
    # Verificar si la key existe en el target
    if ! jq -e "has(\"$key\")" "$target" >/dev/null 2>&1; then
      missing+=("$key")
      continue
    fi

    # Verificar si el valor está vacío
    local value
    value=$(jq -r ".[\"$key\"]" "$target")
    if [[ -z "$value" ]]; then
      empty+=("$key")
      continue
    fi

    ((present++))
  done

  # ── Reporte ──────────────────────────────────────────────────────────────
  echo -e "\n${BOLD}${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo -e "${BOLD}${CYAN}  $tgt_label vs $ref_label${NC}"
  echo -e "${BOLD}${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

  if [[ ${#missing[@]} -eq 0 && ${#empty[@]} -eq 0 ]]; then
    echo -e "  ${GREEN}✓ Todos los secretos están presentes y con valor${NC}"
    echo -e "  ${GREEN}  $present variables verificadas${NC}"
    return 0
  fi

  if [[ ${#missing[@]} -gt 0 ]]; then
    echo -e "\n  ${RED}✗ FALTAN ${#missing[@]} variable(s):${NC}"
    for key in "${missing[@]}"; do
      echo -e "    ${RED}- $key${NC}"
    done
  fi

  if [[ ${#empty[@]} -gt 0 ]]; then
    echo -e "\n  ${YELLOW}⚠ ${#empty[@]} variable(s) con valor VACÍO:${NC}"
    for key in "${empty[@]}"; do
      echo -e "    ${YELLOW}- $key${NC}"
    done
  fi

  echo -e "\n  ${GREEN}✓ $present variables correctas${NC}"

  # Retornar 1 si hay problemas para el exit code final
  if [[ ${#missing[@]} -gt 0 || ${#empty[@]} -gt 0 ]]; then
    return 1
  fi
  return 0
}

# ── Ejecución ────────────────────────────────────────────────────────────────
echo -e "${BOLD}Comparación de Secretos AWS Secrets Manager${NC}"
echo -e "Referencia: ${GREEN}$DEV_FILE${NC}"

HAS_ERRORS=0

if [[ -n "$STAGING_FILE" ]]; then
  if ! compare_env "$DEV_FILE" "$STAGING_FILE" "Dev" "Staging"; then
    HAS_ERRORS=1
  fi
fi

if [[ -n "$PROD_FILE" ]]; then
  if ! compare_env "$DEV_FILE" "$PROD_FILE" "Dev" "Prod"; then
    HAS_ERRORS=1
  fi
fi

# ── Resumen final ────────────────────────────────────────────────────────────
echo -e "\n${BOLD}${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
if [[ $HAS_ERRORS -eq 0 ]]; then
  echo -e "${BOLD}${GREEN}✓ Todos los ambientes están sincronizados con Dev${NC}"
else
  echo -e "${BOLD}${RED}✗ Hay variables pendientes de crear o completar${NC}"
fi
echo -e "${BOLD}${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

exit $HAS_ERRORS
