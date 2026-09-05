# Kemett Art Portfolio

### Stuff
- Thumbnails are 4:3 vertical .webp images, with the resolution capped to 1k or so.

### To add new content to the portfolio:
- Add folders with `number_title` under the `content` folder
- exec `./_update.sh digital|traditional|sketchbook|animation`
- Available themes on portfolio pages are none/default, cover, fullwidth, col2
- Template for portfolio posts
```
---
number: '0000'
title: My title
category: digital|traditional|sketchbook|animation
tags: anything
featured: 0/1
theme:none/default|cover|fullwidth|col2
related_posts: ['digital/0003', 'sketchbook/0010']
---
```



### Git LFS
- `.gitattributes` drives what's LFS by default
- `git lfs fsck` to check if LFS is ducked
- `git lfs checkout` to download the original files offline
- `git lfs migrate import --include="*.png,*.jpeg,*.webp" --everything` to add a new extensions to LFS and rewrite the history
- `git lfs status` to check the status of git and also LFS
- `git lfs ls-files --all` to check what's part of LFS

**! Reminder to myself Nova kind of messes up git LFS, use Github desktop app instead.**

Hi there I'm Alix
