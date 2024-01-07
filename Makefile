run:
	mkdir -p build
	{ echo "<link rel='shortcut icon' type=image/x-icon href=data:image/x-icon;,><style>"; cat style/pandoc.css; echo "</style>"; } > build/pandoc.html
	pandoc docs/intro.md \
               docs/spelling.md \
               docs/grammar.md \
               docs/style.md \
               docs/expressions.md \
               docs/common-problems.md \
               docs/tools.md \
               docs/references.md \
               --metadata title="Fordítás HOGYAN" \
               -s --toc \
               --include-in-header=build/pandoc.html \
               -f markdown-smart+ascii_identifiers+gfm_auto_identifiers \
               -o build/forditas-hogyan.html

pdf:
	mkdir -p build
	pandoc docs/intro.md \
               docs/spelling.md \
               docs/grammar.md \
               docs/style.md \
               docs/expressions.md \
               docs/common-problems.md \
               docs/tools.md \
               docs/references.md \
               --metadata title="Fordítás HOGYAN" \
               -s --pdf-engine=xelatex \
               -f markdown-tex_math_dollars-smart+ascii_identifiers+gfm_auto_identifiers \
               -o build/forditas-hogyan.pdf

