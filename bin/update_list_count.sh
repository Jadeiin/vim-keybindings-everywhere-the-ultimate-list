#!/usr/bin/env bash
# Update the count of listed programs / extension in the README.md

set -o errexit
set -o nounset
set -o pipefail
[[ "${TRACE-0}" =~ ^1|t|y|true|yes$ ]] && set -o xtrace

FILE="README.md"

MARKER_NATIVE="<magic-marker-nbr-native>"
MARKER_EXTENSIONS="<magic-marker-nbr-extensions>"

TEMPLATE_NATIVE="[![${MARKER_NATIVE}](https://img.shields.io/badge/Native%%20programs%%20listed-%d-brightgreen)](#)"
TEMPLATE_EXTENSIONS="[![${MARKER_EXTENSIONS}](https://img.shields.io/badge/Extensions%%20listed-%d-blue)](#)"

SIGN_NATIVE=:white_check_mark:
SIGN_EXTENSIONS=:heavy_plus_sign:

count_occurences() {
	local sign="$1"
	c=$(grep --count "$sign" "$FILE")
	echo $(($c-1))  # Listed in explanation - does not count!
}

update_count() {
	local count="$1"
	local template="$2"
	local search="$3"

	img_tag=$(printf "$template" "$count")
	sed -i.bak -e "s|^.*${search}.*$|${img_tag}|" "$FILE"
	test -e "${FILE}.bak" && rm "${FILE}.bak"
}

count_native=$(count_occurences $SIGN_NATIVE)
count_extensions=$(count_occurences $SIGN_EXTENSIONS)

printf "Found %d native entries\n" "$count_native"
printf "Found %d extension entries\n" "$count_extensions"

update_count "$count_native" "$TEMPLATE_NATIVE" "$MARKER_NATIVE"
update_count "$count_extensions" "$TEMPLATE_EXTENSIONS" "$MARKER_EXTENSIONS"
