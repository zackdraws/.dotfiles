function fish_mode_prompt -d 'Display vi mode in prompt if using vi-like bindings'
    if test "$theme_display_vi" != "no"
        if test "$fish_key_bindings" = "fish_vi_key_bindings"
            or test "$fish_key_bindings" = "hybrid_bindings"
            or test "$fish_key_bindings" = "fish_hybrid_key_bindings"
            or test "$theme_display_vi" = "yes"

            # Fallbacks
            set -q color_vi_mode_default; or set color_vi_mode_default blue
            set -q color_vi_mode_insert; or set color_vi_mode_insert green
            set -q color_vi_mode_visual; or set color_vi_mode_visual magenta

            # Clean any bad quotes or characters from values
            function __clean_color --argument color
                set cleaned (string replace -r "[\"']" '' $color)
                if string match -rq '^#?[0-9a-fA-F]{6}$' -- $cleaned
                    echo $cleaned
                else if string match -rq '^[a-zA-Z]+$' -- $cleaned
                    echo $cleaned
                else
                    echo normal
                end
            end

            set default_color (__clean_color $color_vi_mode_default)
            set insert_color (__clean_color $color_vi_mode_insert)
            set visual_color (__clean_color $color_vi_mode_visual)

            set_color normal

            switch $fish_bind_mode
                case default
                    set_color -b $default_color
                    echo -n ' N '
                case insert
                    set_color -b $insert_color
                    echo -n ' I '
                case replace replace_one replace-one
                    set_color -b $insert_color
                    echo -n ' R '
                case visual
                    set_color -b $visual_color
                    echo -n ' V '
            end

            set_color normal
        end
    end
end
