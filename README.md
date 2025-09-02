# Dotfiles
- these are my dotfiles which controls the configuration of my computer.
## open git bash, ghostty or other unix based terminal
-- git clone https://github.com/zackdraws/.dotfiles.git
### set up .dotfiles
  1.  - cd to .dotfiles (cd means change directory- directory is your 'folder')
  2.  - make file (to make a file you need and editor in the terminal like emacs -nw or nano)
  3.  - sudo ln -s /home/name/.dotfiles/file /usr/local/bin/ (for shell files) (this is to create a symlink which is a synthetic link between two files when you update from .dotfiles it then updates the file in the usr local bin.
  3.1 - sudo is the command to run as 'administrator'
  3.2 - Additional Note: from there you can go to .dotfiles run 'git add .' and then 'git commit -m "comment" and to publish to github run git push
  3.3 to update folder from github run 'git pull'
  4.  cd - /usr/local/bin/ (changes the directory to usr/local/bin)
  5.  chmod +x file (this makes the sh follow usable)
  6. use file within terminals
# Shell - for command history and command line editing - is within the terminal
## Fish - for syntax highlights and autosuggestions and themes
--- commands

### List Files
-ls
- ls -l
- ls -a
- ls -t -
- ls -r
- ls -t -r

## Multiplexer -
### TMUX - 
for tabs in the terminal and to save your place
- tmux plug ins

Yazi - to manage and look through files. eMacs in the terminal is used as the editor for the program.

Broot - to manage and look through files, it's like Yazi but it is not.

Zoxide - makes it insanely easier to find files

FZF - is a fuzzy finder if you are in the directory use fzf to find your files

# shell scripts
symlinks - for linux, mac and git bash

ln -s /home/name/.dotfiles/sh/ /usr/local/bin - for all  bash files and then go to /usr/local/bin

chmod +x files.sh

# Directories -
  	      different directories hold different dotfiles for configuration
## .bashrc
   - 
## .emacs
   - 
## .emacs.d
calfw-cal
catpuccin-them
dash
dired
dirvish
elfeed
eln
eshell
magit
org-download
org-persist
org-roam
hopscotch-theme.el
## .sh

## .zshrc

## ae
#bash

## PY - Python Files
- cnv_mp4_gif.py

bash
   python mp4_to_gif.py your_input_file.mp4 output_file.gif
4.To change the frame duration, use the `-d` or `--duration` argument:
examples -
   python mp4_to_gif.py your_input_file.mp4 output_file.gif -d 0.2  # 0.2 seconds per frame

   - opposite of that is cnv_gif_mp4.bash
   - /create_gif.sh wUsers/myuser/Pictures/my_images output.gif
-
-
-

## SH - Shell Files 
- these are my shell files they are located in my usr/local/bin using sudo chmod +x
### Make
- Export_Org_To_pdf.sh - this exports the org to pdf
 to_latex.sh - this pipes a file into the correct format for pandoc
cnv_pdf_jpg.sh - another sh script to convert pdf files to jpg
cnv_pdf__jpg.sh* - another sh script to convert pdf files to jpg
grep_thumbnails.sh - to extract image paths and then convert them to latex
grep_t.sh - this is the same folder as grep_thumbnails but with a shorter name
syncthing_stop.sh- simple script stops syncthing
mkto.sh - makes a todo with the date that the file is made
FI_^^.sh' - moves file from the cild folder to the parent folder
copy_out.sh - 
export_org_to_pdf_02.org
export_org_to_pdf_02.sh*
export_org_to_pdf.sh*
bracket_format.sh - formats brackets around files
### Formatting
- Bracket_Format.sh puts brackets around

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

*** Python - Scripts

these are the python scripts that I use - these are installed in linux
they are installed in

and they are on my path


rembg - for removing backgrounds 
numpy -
pymatting -
pooch -
scikit-image -
tqdm -
scipy - 
opencv - python headless
