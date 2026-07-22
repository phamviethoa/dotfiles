; extends

; dbt / SQL support:
; When the `jinja` parser is used as the root language for `sql`-filetype
; buffers (see `vim.treesitter.language.register('jinja', 'sql')`), the literal
; text between Jinja tags is captured as `words` nodes. Inject the `sql` parser
; into those regions so SQL keywords, strings, and numbers are highlighted while
; the surrounding `{{ ... }}` / `{% ... %}` keep their Jinja highlighting.
;
; Not `injection.combined`: each SQL fragment is highlighted independently.
; A combined tree would concatenate fragments with the Jinja tags removed,
; producing broken SQL; per-fragment highlighting still colours every token.
((words) @injection.content
  (#set! injection.language "sql"))
