#!/bin/sh

count=$(makoctl list | wc -l)

if [ "$count" -gt 0 ]; then
  echo "{"text":"$count 🔔","tooltip":"$count pending notifications","class":"unread"}"
else
  echo "{"text":"","tooltip":"No new notifications","class":"read"}"
fi

if [ "$BLOCK_BUTTON" = "1" ]; then
  makoctl restore
fi

if [ "$BLOCK_BUTTON" = "3" ]; then
  makoctl dismiss --all
fi