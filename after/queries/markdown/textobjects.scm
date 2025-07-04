; extends

; Code block text objects for markdown
(fenced_code_block
  (fenced_code_block_delimiter) @_start
  (code_fence_content) @codeblock.inner
  (fenced_code_block_delimiter) @_end) @codeblock.outer
