#! /bin/bash
# usage ./_update.sh <category> <theme>

# - Creates posts from pictures
# - Moves pictures to assets -creates a new jpg- and creates thumbnails

THUMB_MAX=1280

category="$1"
    tags="$2"

date=$(date +"%Y-%m-%d")
posts_dir="../../_posts/portfolio/$category"
images_dir="../../assets/images/portfolio/$category"


for d in * ; do
    if [ "$d" = _update.sh ]
    then
        continue
    fi

    (
        cd "$d"
        arr=(${d//"_"/ })
        number="${arr[0]}"
        title="${arr[1]}"
        post_filename="$posts_dir/$date-$number.md"
        curr_images_dir="$images_dir/$number"
        echo Creating directory "$curr_images_dir"
        mkdir "$curr_images_dir"
        counter=0
        for f in * ; do
            if [ "$f" = thumb.* ] ; then
                if [[ "$f" == *.mp4 || "$f" == *.MP4 || "$f" == *.gif || "$f" == *.GIF ]]; then
                    thumbpath="$curr_images_dir/thumb.webm"
                    echo Creating thumbnail "$f" "$thumbpath"
                    ffmpeg -i "$f" -vf scale="${THUMB_MAX}:-1" "$thumbpath"
                else
                    thumbpath="$curr_images_dir/thumb.webp"
                    echo Creating thumbnail "$f" "$thumbpath"
                    magick "$f" -thumbnail "${THUMB_MAX}>" "${thumbpath}"
                fi
                continue
            fi
            counter=$((counter+1))
            input_filename="$f"
            output_filename=$(printf %04d $counter)

            if [[ "$f" == *.mp4 || "$f" == *.MP4 || "$f" == *.gif || "$f" == *.GIF ]]; then
                output_filename="$output_filename.mp4"
                echo Creating file "$curr_images_dir/$output_filename"
                ffmpeg -i "$f" -c:v libx264 "$curr_images_dir/$output_filename"
            else
                output_filename="$output_filename.jpg"
                echo Creating file "$curr_images_dir/$output_filename"
                magick "$f" "$curr_images_dir/$output_filename"
            fi
        done

        template="---
number: '"$number"'
title: "$title"
category: $category
tags: $tags
featured: 0
---

"
        echo Creating post "$post_filename"

        # Create post from template
        echo "$template" > $post_filename

        # Delete ingested files
        cd ..
        rm -r "$d"
    );
done
