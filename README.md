# Dotfiles
- these are my dotfiles which controls the configuration of my computer.

## setting up .dotfiles
  1.  - cd to .dotfiles
  2.  - make file
  3.   - sudo ln -s /home/name/.dotfiles/file /usr/local/bin/ (for shell files)
  this makes a symlink so you can edit the file in .dotfiles and that will edit the file in the usr local bin
  
  4.  cd - /usr/local/bin/ (changes the directory to usr/local/bin)
  5.  chmod +x file (this makes the sh follow usable)


# Directories -
  	      different directories hold different dotfiles for configuration
## .bashrc
## .emacs
## .emacs.d
## .sh
## .zshrc

## ae
#bash

## SH - Shell Files 
- these are my shell files they are located in my usr/local/bin using sudo chmod +x

### Convert Files - scripts to convert from one file format to another or change the size of files
cnv_pdf->jpg - converts pdf file to jpeg files
cnv_jpg_pdf - converts jpg files to pdf
convert_heic_to_jpeg.sh - to convert heic to jpeg
convert_heic_to_jpg.sh - to convert heic to jpg
convert_png_j.sh - to convert png to jpg
convert_webloc_jpeg - to convert webloc to jpeg
convert_webp_jpeg - to convert webp to jpeg
psd_convert.sh - convert psd to jpg
psd_jpeg.sh -  convert psd to jpeg
heic_jpeg.sh - convert heic to jpeg
jfif_jpeg.sh - convert jfif to jpeg
convert_webloc_to_jpeg.sh - convert webloc to jpeg 

### Compress Files
tiny_vid.sh - to make videos smaller - dependent on ffmpeg

### Move 
move_files_to_parent.sh - moves files to the parent directory

### Delete - scripts to delete files
delete_all_heic - deletes all heic files
delete_all_jfif - deletes all jfif files
delete_duplicates - tried to get a script that deletes duplicate files but it doesn't work
delete_duplicate_images - 
delete_text_string - 

### Rename
F2_date_taken.sh -
rename.sh - renames files
rename_date_taken.sh - renames files with date taken
rename_folder.sh - renames files in folder

### Delete
X.sh - to delete a folder of files
clean.sh - deletes files

### PSD - scripts to change images
psd_bright.py
psd_bw.py
psd_convert.sh - converts psd files - exports layers
psd_flat.sh - flattens layers and converts to psd
psd_flats.sh - adds colors randomly to closed contour areas
psd_jpeg.sh - converts psd to jpeg
psd_key_matte_folder.sh - adds matte to files in a folder
psd_key_mate_folder_strong.sh - like psd key matte but stronger
psd_keyout.sh - takes out the white background
psd_keyout_w_matte.sh - adds white matte underneath drawings
psd_keyout_w_matte_soft.
psd_select_sub.sh - inverts subject and takes out background
crop.sh - to crop files

### Captioning
Caption.py - caption.py [image.jpg]
	   - asks for caption
	   - write in caption
	   - outputs with caption







## Compressing

Untar.sh - uncompresses files

# Moving Around the Terminal

# emacs -
# fish -
# ghostty -
# kitty -
# marp -
# marp_template.md -
# sh -
# shell_files -
# terminal_file_yazi -
# terminal_kitty -
# terminal_zellij -
# tvp -
# yazi - to look through files in terminal

