#!/usr/bin/env bash
# Local pre-push check. Catches the two things that actually break this site:
# a malformed BibTeX entry (fails the Jekyll build) and a formatting drift
# (fails the Prettier workflow). Run from the repo root:  bash bin/check-content.sh
set -uo pipefail
cd "$(dirname "$0")/.."
fail=0

echo "== 1/3  BibTeX =="
GEMS="$HOME/.local/share/gem/ruby/3.0.0/gems"
BIBLIB=$(ls -d "$GEMS"/bibtex-ruby-*/lib 2>/dev/null | head -1)
LATEXLIB=$(ls -d "$GEMS"/latex-decode-*/lib 2>/dev/null | head -1)
if [ -n "$BIBLIB" ]; then
  ruby -I"$BIBLIB" -I"$LATEXLIB" -e '
    require "bibtex"
    begin
      b = BibTeX.open("_bibliography/papers.bib")
      n = b.count { |e| e.is_a?(BibTeX::Entry) }
      puts "   OK — #{n} entries"
    rescue => ex
      puts "   FAILED: #{ex.message[0, 200]}"
      exit 1
    end' || fail=1
else
  echo "   skipped (run: gem install --user-install --ignore-dependencies bibtex-ruby latex-decode)"
fi

echo "== 2/3  YAML and front matter =="
python3 - <<'PY' || fail=1
import yaml, glob, sys
bad = []
for f in glob.glob('_data/*.yml') + ['_config.yml'] + glob.glob('.github/workflows/*.yml'):
    try: yaml.safe_load(open(f, encoding='utf-8'))
    except Exception as e: bad.append((f, str(e)[:100]))
for f in glob.glob('_pages/*.md') + glob.glob('_news/*.md') + glob.glob('_posts/*.md'):
    try: yaml.safe_load(open(f, encoding='utf-8').read().split('---')[1])
    except Exception as e: bad.append((f, str(e)[:100]))
if bad:
    for f, e in bad: print(f"   FAILED {f}: {e}")
    sys.exit(1)
print("   OK")
PY

echo "== 3/3  Prettier =="
if [ -d node_modules ]; then
  npx prettier . --check >/dev/null 2>&1 \
    && echo "   OK" \
    || { echo "   FAILED — run: npx prettier . --write"; fail=1; }
else
  echo "   skipped (run: npm ci)"
fi

echo
[ "$fail" -eq 0 ] && echo "ALL GOOD — safe to push" || echo "FIX THE ABOVE BEFORE PUSHING"
exit $fail
