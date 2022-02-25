awk '!/Pixell./' precompile_statements.jl > tmpfile && mv tmpfile precompile_statements.jl
