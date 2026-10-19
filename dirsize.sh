#!/usr/bin/env bash

DIR="${1:-.}"

AMARELO="$(tput setaf 3)"
NEGRITO="$(tput bold)"
SUBLINHADO="$(tput smul)"
VERMELHO="$(tput setaf 1)"
RESET="$(tput sgr0)"

#---------------------------------------------------------------#
#                           FUNÇÕES                             #
#---------------------------------------------------------------#

# Verifica se o diretório informado existe
validar() {
    [ -d "$DIR" ] && return 0
    echo "${VERMELHO}Diretório não encontrado:${RESET} $DIR"
    exit 1
}

# Lista os diretórios com unidade automática, do maior para o menor
listar() {
    echo "${NEGRITO}${SUBLINHADO}Analisando:${RESET} $(realpath "$DIR")"
    echo
    du -xk --max-depth=1 "$DIR" 2>/dev/null | sort -rn | awk -F'\t' -v c="$AMARELO" -v n="$NEGRITO" -v r="$RESET" '{
        k = $1
        if (k >= 1073741824) { v = k/1073741824; u = "TB" }
        else if (k >= 1048576) { v = k/1048576; u = "GB" }
        else if (k >= 1024) { v = k/1024; u = "MB" }
        else { v = k; u = "KB" }
        printf "%s%s%8.2f %s%s  %s\n", n, c, v, u, r, $2 }'
}

validar && listar
