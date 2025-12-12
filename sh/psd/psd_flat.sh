shopt -s nullglob nocaseglob
for psd in *.psd; do
    basename="${psd%.*}"
    jpg="${basename}.jpg"

    echo "Converting: $psd -> $jpg"
    convert "$psd[0]" -flatten -quality 90 "$jpg"

    if [ $? -eq 0 ]; then
        echo "✅ Successfully created: $jpg"
    else
        echo "❌ Error converting: $psd"
    fi
done

echo "Done."
