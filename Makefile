run:
	mkdir -p build
	pandoc docs/intro.md \
               docs/spelling.md \
               docs/grammar.md \
               docs/style.md \
               docs/expressions.md \
               docs/common-problems.md \
               docs/tools.md \
               --metadata title="Fordítás HOGYAN" \
               -s --toc \
               -f markdown-tex_math_dollars \
               -o build/forditas-hogyan.html

