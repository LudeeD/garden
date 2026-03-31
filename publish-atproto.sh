#!/usr/bin/env bash
set -euo pipefail

PUB="at://did:plc:xz7cghm6nkufwscryfzfjcsh/site.standard.publication/3miezvn4ji32k"

files=$(git ls-files content/ | grep '\.md$' | grep -v '_index\.md')

for file in $files; do
  if grep -q 'atproto_uri' "$file"; then
    continue
  fi

  title=$(grep -m1 '^title' "$file" | sed 's/^title\s*=\s*"\(.*\)"$/\1/')
  now=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
  path="/$(echo "$file" | sed 's|^content/||; s|\.md$||' | tr '[:upper:]' '[:lower:]')"

  sed -i "s|^date\s*=.*|date = $now|" "$file"

  echo "Publishing: $title ($path)"

  cat > /tmp/doc.json << EOF
{
  "\$type": "site.standard.document",
  "publishedAt": "$now",
  "site": {"uri": "$PUB"},
  "path": "$path",
  "title": "$title"
}
EOF

  uri=$(goat record create --no-validate /tmp/doc.json | cut -f1)
  echo "  -> $uri"

  if grep -q '^\[extra\]' "$file"; then
    sed -i "s|^\[extra\]$|[extra]\natproto_uri = \"$uri\"|" "$file"
  else
    echo "  WARNING: no [extra] section in $file — add atproto_uri manually"
  fi
done

echo "Done."
