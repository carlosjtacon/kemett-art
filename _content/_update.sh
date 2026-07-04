#! /bin/bash
# usage ./_update.sh <category> <theme>

# - Creates posts from pictures
# - Moves pictures to assets -creates a new jpg- and creates thumbnails

THUMB_MAX=1024

category="$1"
    tags="$2"

posts_dir="../_posts/portfolio/$category"
images_dir="../assets/images/portfolio/$category"

last_post_number=$(ls $images_dir | grep 'jpg\|mp4' | sort -V | tail -n 1)
last_post_number=`echo "${last_post_number%.*}"`
last_post_number=`expr "$last_post_number"`

for f in *
do
    if [ "$f" = _update.sh ]
    then
        continue
    fi

    last_post_number=$(( $last_post_number + 1))

    input_filename="$f"
    output_filename=$(printf %04d $last_post_number)

    date=$(date +"%Y-%m-%d")
    filedate=$(date -r "$f" +"%Y-%m-%d %H:%M:%S")

    post_filename="$posts_dir/$date-$output_filename.md"


    if [[ "$f" == *.mp4 || "$f" == *.MP4 || "$f" == *.gif || "$f" == *.GIF ]]; then
        output_filename_thumb="$output_filename-thumb.webm"
        output_filename="$output_filename.mp4"
        # Encode mp4
        ffmpeg -i "$input_filename" -c:v libx264 "$images_dir/$output_filename"
         # Create thumbnail
        thumbpath="$images_dir/thumbs/$output_filename_thumb"
        ffmpeg -i "$images_dir/$output_filename" -vf scale="${THUMB_MAX}:-1" "$thumbpath"
    else
        output_filename_thumb="$output_filename-thumb.webp"
        output_filename="$output_filename.jpg"
        # Create full quality jpg
        magick "$input_filename" "$images_dir/$output_filename"

        # Create thumbnail
        thumbpath="$images_dir/thumbs/$output_filename_thumb"
        magick "$f" -thumbnail "${THUMB_MAX}>" "${thumbpath}"
    fi

    template="---
md5sum: "$(md5sum "$input_filename")"
filedate: "$filedate"
filename: "$output_filename"
thumbnail: "$output_filename_thumb"
category: $category
tags: $tags
title:
order: 0
---

"
    echo "$input_filename..."

    # Create post from template
    echo "$template" > $post_filename
done
