#! /bin/bash
# usage ./_update.sh <category> <theme>

# - Creates posts from pictures
# - Moves pictures to assets -creates a new jpg- and creates thumbnails

THUMB_MAX=1024

category="$1"
    tags="$2"

posts_dir="../_posts/portfolio/$category"
images_dir="../assets/images/portfolio/$category"

for f in *
do
    if [ "$f" = _update.sh ]
    then
        continue
    fi

    input_filename="$f"
    output_filename=$(date -r "$f" +"%Y%m%d%H%M%S")

    date=$(date -r "$f" +"%Y-%m-%d")
    datetime=$(date -r "$f" +"%Y-%m-%d %H:%M:%S")

    post_filename="$posts_dir/$date-$output_filename.md"

    template="---
date: $datetime
filename: $output_filename.jpg
thumbnail: $output_filename-thumb.webp
category: $category
tags: $tags
---

"
    echo "$input_filename..."

    # Create post from template
    echo "$template" > $post_filename

    # Create full quality jpg
    magick "$input_filename" "$images_dir/$output_filename.jpg"

    # Create thumbnail
    thumbpath="$images_dir/thumbs/$output_filename-thumb.webp"
    magick "$f" -thumbnail "${THUMB_MAX}>" "${thumbpath}"

done
