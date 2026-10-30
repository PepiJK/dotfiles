#!/bin/sh
# lazygit extDiff renderer: git hands file paths to GNU diff instead of mmapping worktree files,
# so a lazygit diff view that is not fully read cannot block editor writes (Windows error 1224).
# args: context, then git's diff.external args: path old-file old-hex old-mode new-file new-hex new-mode
context=$1
shift
path=$1
[ "$path" = /dev/null ] && path=$5
old_label="a/$path"
new_label="b/$path"
[ "$2" = /dev/null ] && old_label=/dev/null
[ "$5" = /dev/null ] && new_label=/dev/null
diff -U"$context" --color=always --label "$old_label" --label "$new_label" "$2" "$5"
exit 0
