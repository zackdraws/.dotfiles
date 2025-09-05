#!/usr/bin/env bash

set -euo pipefail



# Ensure /usr/local/bin exists

mkdir -p /usr/local/bin



# Core shell scripts

ln -s "${HOME}/.dotfiles/sh/convert/convert_webloc_jpeg.sh"           /usr/local/bin/convert_webloc_jpeg

ln -s "${HOME}/.dotfiles/sh/shell_files/webloc_jpeg.sh"               /usr/local/bin/webloc_jpeg

ln -s "${HOME}/.dotfiles/sh/shell_files/jpeg.sh"                      /usr/local/bin/jpeg

ln -s "${HOME}/.dotfiles/sh/file/filecopyimgmultiple_1.sh"           /usr/local/bin/filecopyimgmultiple_1

ln -s "${HOME}/.dotfiles/sh/move/FI_^.sh"                             /usr/local/bin/FI_^

ln -s "${HOME}/.dotfiles/sh/convert/cnv_jpg_pdf.sh"                   /usr/local/bin/cnv_jpg_pdf

ln -s "${HOME}/.dotfiles/sh/convert/convert_heic_to_jpeg.sh"          /usr/local/bin/convert_heic_to_jpeg

ln -s "${HOME}/.dotfiles/sh/convert/convert_heic_to_jpg.sh"           /usr/local/bin/convert_heic_to_jpg

ln -s "${HOME}/.dotfiles/sh/convert/convert_png_j.sh"                 /usr/local/bin/convert_png_j

ln -s "${HOME}/.dotfiles/sh/convert/convert_webloc_to_jpeg.sh"        /usr/local/bin/convert_webloc_to_jpeg

ln -s "${HOME}/.dotfiles/sh/convert/convert_webp_jpeg.sh"             /usr/local/bin/convert_webp_jpeg



ln -s "${HOME}/.dotfiles/sh/delete/clean.sh"                          /usr/local/bin/clean

ln -s "${HOME}/.dotfiles/sh/delete/X.sh"                              /usr/local/bin/X_delete



ln -s "${HOME}/.dotfiles/sh/export/F2_txt.sh"                         /usr/local/bin/F2_txt

ln -s "${HOME}/.dotfiles/sh/maketiny/compress_video.sh"               /usr/local/bin/compress_video

ln -s "${HOME}/.dotfiles/sh/maketiny/compress_video2.sh"              /usr/local/bin/compress_video2

ln -s "${HOME}/.dotfiles/sh/plan/0T5.sh"                              /usr/local/bin/0T5

ln -s "${HOME}/.dotfiles/sh/rename/F2_date_taken.sh"                  /usr/local/bin/F2_date_taken



ln -s "${HOME}/.dotfiles/sh/convert/heic_jpeg.sh"                     /usr/local/bin/heic_jpeg

ln -s "${HOME}/.dotfiles/sh/convert/jfif_jpeg.sh"                     /usr/local/bin/jfif_jpeg



ln -s "${HOME}/.dotfiles/sh/delete/deldoop.sh"                        /usr/local/bin/deldoop

ln -s "${HOME}/.dotfiles/sh/delete/deldoop2.sh"                       /usr/local/bin/deldoop2

ln -s "${HOME}/.dotfiles/sh/delete/delete_all_heic.sh"                /usr/local/bin/delete_all_heic

ln -s "${HOME}/.dotfiles/sh/delete/delete_all_jfif.sh"                /usr/local/bin/delete_all_jfif

ln -s "${HOME}/.dotfiles/sh/delete/delete_duplicate_images.sh"        /usr/local/bin/delete_duplicate_images

ln -s "${HOME}/.dotfiles/sh/delete/delete_duplicates.sh"              /usr/local/bin/delete_duplicates

ln -s "${HOME}/.dotfiles/sh/delete/delete_text_string.sh"             /usr/local/bin/delete_text_string



ln -s "${HOME}/.dotfiles/sh/file/copy_clip2.sh"                       /usr/local/bin/copy_clip2

ln -s "${HOME}/.dotfiles/sh/file/filecopyimg.sh"                      /usr/local/bin/filecopyimg

ln -s "${HOME}/.dotfiles/sh/file/filecopyimgmultiple.sh"              /usr/local/bin/filecopyimgmultiple

ln -s "${HOME}/.dotfiles/sh/file/filecopyimgmultiple02.sh"            /usr/local/bin/filecopyimgmultiple02

ln -s "${HOME}/.dotfiles/sh/file/filecopyimgmultiple03.sh"            /usr/local/bin/filecopyimgmultiple03

ln -s "${HOME}/.dotfiles/sh/file/filepath.sh"                         /usr/local/bin/filepath

ln -s "${HOME}/.dotfiles/sh/file/filepathcopy.sh"                     /usr/local/bin/filepathcopy



ln -s "${HOME}/.dotfiles/sh/launch/ghostty-launcher.sh"               /usr/local/bin/ghostty-launcher



ln -s "${HOME}/.dotfiles/sh/make/mkdup.sh"                            /usr/local/bin/mkdup

ln -s "${HOME}/.dotfiles/sh/psd/crop.sh"                              /usr/local/bin/psd_crop

ln -s "${HOME}/.dotfiles/sh/rename/f2.sh"                             /usr/local/bin/f2

ln -s "${HOME}/.dotfiles/sh/rename/iph.sh"                            /usr/local/bin/iph



ln -s "${HOME}/.dotfiles/sh/convert/mp4_frames.sh"                    /usr/local/bin/mp4_frames

ln -s "${HOME}/.dotfiles/sh/convert/psd_convert.sh"                   /usr/local/bin/psd_convert



# Properly quoted due to parentheses:

ln -s "${HOME}/.dotfiles/sh/launch/open_tvpaint (2).sh"               "/usr/local/bin/open_tvpaint_2"



ln -s "${HOME}/.dotfiles/sh/launch/open_tvpaint.sh"                   /usr/local/bin/open_tvpaint

ln -s "${HOME}/.dotfiles/sh/launch/syncthing.sh"                      /usr/local/bin/syncthing

ln -s "${HOME}/.dotfiles/sh/make/mkpdf.sh"                            /usr/local/bin/mkpdf



ln -s "${HOME}/.dotfiles/sh/make/screen_record"                       /usr/local/bin/screen_record



ln -s "${HOME}/.dotfiles/sh/psd/psd_fill.sh"                          /usr/local/bin/psd_fill

ln -s "${HOME}/.dotfiles/sh/psd/psd_fill_extra.sh"                    /usr/local/bin/psd_fill_extra

ln -s "${HOME}/.dotfiles/sh/psd/psd_flat.sh"                          /usr/local/bin/psd_flat

ln -s "${HOME}/.dotfiles/sh/psd/psd_flats.sh"                         /usr/local/bin/psd_flats

ln -s "${HOME}/.dotfiles/sh/psd/psd_jpeg.sh"                          /usr/local/bin/psd_jpeg

ln -s "${HOME}/.dotfiles/sh/psd/psd_jpeg_w_gimp.sh"                   /usr/local/bin/psd_jpeg_w_gimp

ln -s "${HOME}/.dotfiles/sh/psd/psd_key_matte_folder_strong.sh"       /usr/local/bin/psd_key_matte_folder_strong

ln -s "${HOME}/.dotfiles/sh/psd/psd_keyout_soft.sh"                   /usr/local/bin/psd_keyout_soft

ln -s "${HOME}/.dotfiles/sh/psd/psd_keyout_w_matte.sh"                /usr/local/bin/psd_keyout_w_matte

ln -s "${HOME}/.dotfiles/sh/psd/psd_keyout_w_matte_soft.sh"           /usr/local/bin/psd_keyout_w_matte_soft

ln -s "${HOME}/.dotfiles/sh/psd/psd_select_sub.sh"                    /usr/local/bin/psd_select_sub



ln -s "${HOME}/.dotfiles/sh/rename/rename.sh"                         /usr/local/bin/rename

ln -s "${HOME}/.dotfiles/sh/rename/rename_blank.sh"                   /usr/local/bin/rename_blank

ln -s "${HOME}/.dotfiles/sh/rename/rename_date_taken.sh"              /usr/local/bin/rename_date_taken

ln -s "${HOME}/.dotfiles/sh/rename/rename_folder.sh"                  /usr/local/bin/rename_folder

ln -s "${HOME}/.dotfiles/sh/rename/rename_still_life.sh"              /usr/local/bin/rename_still_life

ln -s "${HOME}/.dotfiles/sh/rename/rm_not_cropped.sh"                  /usr/local/bin/rm_not_cropped



ln -s "${HOME}/.dotfiles/sh/convert/untar.sh"                         /usr/local/bin/untar

ln -s "${HOME}/.dotfiles/sh/convert/webloc_jpeg.sh"                   /usr/local/bin/webloc_jpeg_2

ln -s "${HOME}/.dotfiles/sh/make/yt-dl.sh"                            /usr/local/bin/yt-dl



ln -s "${HOME}/.dotfiles/sh/shell_files/F2.sh"                        /usr/local/bin/F2

ln -s "${HOME}/.dotfiles/sh/shell_files/F2_date_taken_1.sh"           /usr/local/bin/F2_date_taken_1

ln -s "${HOME}/.dotfiles/sh/shell_files/F2_folder.sh"                 /usr/local/bin/F2_folder

ln -s "${HOME}/.dotfiles/sh/shell_files/F2iph.sh"                     /usr/local/bin/F2iph

ln -s "${HOME}/.dotfiles/sh/shell_files/filecopyimg.sh"               /usr/local/bin/filecopyimg_sf

ln -s "${HOME}/.dotfiles/sh/shell_files/filecopyimgmultiple.sh"       /usr/local/bin/filecopyimgmultiple_sf

ln -s "${HOME}/.dotfiles/sh/shell_files/filecopyimgmultiple02.sh"     /usr/local/bin/filecopyimgmultiple02_sf

ln -s "${HOME}/.dotfiles/sh/shell_files/filecopyimgmultiple03.sh"     /usr/local/bin/filecopyimgmultiple03_sf

ln -s "${HOME}/.dotfiles/sh/shell_files/filepath.sh"                   /usr/local/bin/filepath_sf

ln -s "${HOME}/.dotfiles/sh/shell_files/filepathcopy.sh"              /usr/local/bin/filepathcopy_sf

ln -s "${HOME}/.dotfiles/sh/shell_files/forward_slashes-to-backward_slashes.sh"  /usr/local/bin/forward_slashes_to_backslashes

ln -s "${HOME}/.dotfiles/sh/shell_files/heic__jpg.sh"                  /usr/local/bin/heic__jpg

ln -s "${HOME}/.dotfiles/sh/shell_files/heic_jpeg.sh"                  /usr/local/bin/heic_jpeg_sf

ln -s "${HOME}/.dotfiles/sh/shell_files/jfif_jpeg.sh"                  /usr/local/bin/jfif_jpeg_sf

ln -s "${HOME}/.dotfiles/sh/shell_files/move_files_to_parent.sh"      /usr/local/bin/move_files_to_parent

ln -s "${HOME}/.dotfiles/sh/shell_files/png-j.sh"                      /usr/local/bin/png-j

ln -s "${HOME}/.dotfiles/sh/shell_files/psd2jpeg.sh"                   /usr/local/bin/psd2jpeg

ln -s "${HOME}/.dotfiles/sh/shell_files/psd_convert.sh"               /usr/local/bin/psd_convert_sf

ln -s "${HOME}/.dotfiles/sh/shell_files/psd_jpeg_w_gimp.sh"           /usr/local/bin/psd_jpeg_w_gimp_sf

ln -s "${HOME}/.dotfiles/sh/shell_files/syncthing.sh"                  /usr/local/bin/syncthing_sf

ln -s "${HOME}/.dotfiles/sh/shell_files/tiny_vid.sh"                   /usr/local/bin/tiny_vid

ln -s "${HOME}/.dotfiles/sh/shell_files/UTO.sh"                        /usr/local/bin/UTO

ln -s "${HOME}/.dotfiles/sh/shell_files/webloc_jpeg_02.sh"            /usr/local/bin/webloc_jpeg_02

ln -s "${HOME}/.dotfiles/sh/shell_files/webloc_jpeg_1.sh"             /usr/local/bin/webloc_jpeg_1

ln -s "${HOME}/.dotfiles/sh/shell_files/webp_jpeg.sh"                  /usr/local/bin/webp_jpeg

ln -s "${HOME}/.dotfiles/sh/shell_files/X.sh"                         /usr/local/bin/X_sf

ln -s "${HOME}/.dotfiles/sh/shell_files/X_all_heic.sh"                /usr/local/bin/X_all_heic

ln -s "${HOME}/.dotfiles/sh/shell_files/X_all_jfif.sh"                /usr/local/bin/X_all_jfif

ln -s "${HOME}/.dotfiles/sh/shell_files/X_duplicate_images.sh"        /usr/local/bin/X_duplicate_images

ln -s "${HOME}/.dotfiles/sh/shell_files/X_duplicates.sh"              /usr/local/bin/X_duplicates

ln -s "${HOME}/.dotfiles/sh/shell_files/X_text_string.sh"             /usr/local/bin/X_text_string

ln -s "${HOME}/.dotfiles/sh/shell_files/Xdoop_1.sh"                    /usr/local/bin/Xdoop_1



ln -s "${HOME}/.dotfiles/sh/format/to_latex.sh"                        /usr/local/bin/to_latex

ln -s "${HOME}/.dotfiles/sh/format/grep_thumbnails.sh"                /usr/local/bin/grep_thumbnails

ln -s "${HOME}/.dotfiles/sh/format/grep_t.sh"                         /usr/local/bin/grep_t

ln -s "${HOME}/.dotfiles/sh/file/FI_^^.sh"                            /usr/local/bin/FI_^^

ln -s "${HOME}/.dotfiles/sh/launch/syncthing_stop.sh"                 /usr/local/bin/syncthing_stop

ln -s "${HOME}/.dotfiles/sh/export/copy_out.sh"                        /usr/local/bin/copy_out

ln -s "${HOME}/.dotfiles/sh/export/export_org_to_pdf_02.sh"           /usr/local/bin/export_org_to_pdf_02

ln -s "${HOME}/.dotfiles/sh/format/bracket_format.sh"                 /usr/local/bin/bracket_format

ln -s "${HOME}/.dotfiles/sh/psd/16x9.sh"                              /usr/local/bin/16x9

ln -s "${HOME}/.dotfiles/sh/psd/16x92.sh"                             /usr/local/bin/16x92

ln -s "${HOME}/.dotfiles/sh/make/autocaption.sh"                      /usr/local/bin/autocaption

ln -s "${HOME}/.dotfiles/sh/maketiny/tiny_vid_split.sh"               /usr/local/bin/tiny_vid_split

ln -s "${HOME}/.dotfiles/sh/make/autocaption_1.sh"                    /usr/local/bin/autocaption_1

ln -s "${HOME}/.dotfiles/sh/make/save_screen.sh"                      /usr/local/bin/save_screen

ln -s "${HOME}/.dotfiles/sh/shell_files/F2_date_taken.sh"             /usr/local/bin/F2_date_taken_sf

ln -s "${HOME}/.dotfiles/sh/export/sequence_.sh"                      /usr/local/bin/sequence
