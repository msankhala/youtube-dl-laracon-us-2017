#!/bin/sh
# Linux users have to change $8 to $9
desiredFormat='960x540';
read formatName <<< $(awk '{
  if (($3 ~ /'$desiredFormat'/) && ($NF !~ /only/)) {
    print $1; exit;
  }
}');
echo $formatName;
