#!/usr/bin/bash

# Script to convert Password Agent's file (exported to XML)
# to format of KeePass XML

PA_FILE="$1"
if test -z "$PA_FILE"
then
    PA_FILE="-"
fi

xmllint --format "$PA_FILE" --output - | \
iconv --from-code Windows-1251 --to-code utf-8 | \
sed -r -e '1d' \
    -e '2i<!DOCTYPE KEEPASSX_DATABASE>' \
    -e 's#^(</?)data.*>#\1database>#' \
    -e 's#(</?)name>#\1title>#g' \
    -e 's#(</?)account>#\1username>#g' \
    -e 's#(</?)link(/?>)#\1url\2#g' \
    -e 's#(</?)note(/?>)#\1comment\2#g' \
    -e 's#(<date_.+?>)([0-9]+)\.([0-9]+)\.([0-9]+)#\1\4-\3-\2#' \
    -e 's#(</?)date_added>#\1creation>#g' \
    -e 's#(</?)date_modified>#\1last_mod>#g' \
    -e 's#<date_expire/>#<expire>Never</expire>#' \
    -e 's#(</?)date_expire(/?>)#\1expire\2#g' \
