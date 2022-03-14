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
               -f markdown-tex_math_dollars \
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
               -s --toc --pdf-engine=xelatex \
               -V toc-title:"Tartalomjegyzék" \
               -V mainfont:"Linux Libertine O" \
               -V geometry:"margin=1in" \
               -f markdown-tex_math_dollars \
               -o build/forditas-hogyan.pdf

