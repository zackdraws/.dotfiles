# Dotfiles
- these are my dotfiles which controls the configuration of my computer. the .dotfiles are just the local settings stored on the computer and then I sync them here and then when I have to move to another computer I just download these .dotfiles and sync them to the programs that I use.

- to use these .dotfiles you will need to use the terminal (you can use these without a terminal but it won't update without using the terminal and you won't be able to sync them or automatically set them up. A user would basically
have to drag and drop them, and then do that each time there is an update.)


## 1. The Terminal
### - recommended terminals
- if you are on windows use mingw64 or wsl 
- I would recommend mingw64 > wsl 
    -	   mingw64 (windows) - if you are on windows use this terminal
    -	   foot (linux/wsl) - if you are on linux and want a very quick lightweight terminal I would recommend this
    -	   ghostty (mac/linux/wsl) - if you want something very fresh, dynamic and customizeable with a growing community of users and editors I would recommend ghostty
    -	   kitty (mac/linux/wsl) - if you want something very stable use kitty.

## 1.2. Once you have a terminal picked out install git
   -     pacman -S mingw-w64-x86_64-git
   -     kitty terminal - > /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   - 	 home brew - >      brew install git

## 1.3.  open git bash, ghostty or another unix/linux based terminal. 
    	 -- git clone https://github.com/zackdraws/.dotfiles.git


## 1.4.  clone files (cl)
	 	  1.  - cd ~/
		  - this is your home directory
		  2. mkdir .dotfiles
		  3. cd .dotfiles
		  4 . git clone this repo

		  ** to see your files you can use these commands
		  -ls
		  - ls -l
		  - ls -a
		  - ls -t -
		  - ls -r
		  - ls -t -r

## 2. The Editor - to edit files you will need an editor
   - eMacs - install emacs
     pacman -S mingw-w64-x86_64-emacs

        - brew install emacs
     
		- now you can write into files in the terminal using the command 'emacs -nw file'
	

- Nano - I would also suggest installing nano - it's a very quick editor for fast editing text

# 3. Link files - (ln)
    sudo ln -s /home/name/.dotfiles/file /usr/local/bin/ (for shell files)
    	 			  (this is to create a symlink)
				 (symlinks are synthetic links between two files when you update from .dotfiles it then updates the file in the usr local bin.)
							   * sudo is the command to run a command as 'administrator'
	3.2 - Additional Note: from there you can go to .dotfiles run 'git add .' and then 'git commit -m "comment" and to publish to github run git push
	3.3 - to update folder from github run 'git pull'

## 4. Make Script files actionable from anywhere in the terminal - 
       4.1  cd - /usr/local/bin/ (changes the directory to usr/local/bin)
       4.2  chmod +x file (this makes the sh follow usable)

## 5. Shell - for command history and command line editing - is within the terminal
      -Fish - for syntax highlights and autosuggestions and themes

## 6. Multiplexer -
### TMUX - 
for tabs in the terminal and to save your place
- tmux plug ins

## 7. File Managemen in Terminal
Yazi - to manage and look through files. eMacs in the terminal is used as the editor for the program.

Broot - to manage and look through files, it's like Yazi but it is not.

Zoxide - makes it insanely easier to find files

FZF - is a fuzzy finder if you are in the directory use fzf to find your files

# Directories -
  	      different directories hold different dotfiles for configuration

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

## SH - Shell Files 
- these are my shell files they are located in my usr/local/bin using sudo chmod +x
### Make
    - Export_Org_To_pdf.sh - this exports the org to pdf
     to_latex.sh - this pipes a file into the correct format for pandoc
     - cnv_pdf_jpg.sh - another sh script to convert pdf files to jpg
     - cnv_pdf__jpg.sh* - another sh script to convert pdf files to jpg
     - grep_thumbnails.sh - to extract image paths and then convert them to latex
     - grep_t.sh - this is the same folder as grep_thumbnails but with a shorter name
     - syncthing_stop.sh- simple script stops syncthing
     - mkto.sh - makes a todo with the date that the file is made
     - FI_^^.sh' - moves file from the cild folder to the parent folder
     - copy_out.sh - 
     - export_org_to_pdf_02.org
     - export_org_to_pdf_02.sh*
     - export_org_to_pdf.sh*
     - bracket_format.sh - formats brackets around files

### Formatting
    - Bracket_Format.sh puts brackets around

### Convert Files - scripts to convert from one file format to another or change the size of files
    - cnv_pdf->jpg - converts pdf file to jpeg files
    - cnv_jpg_pdf - converts jpg files to pdf
    - convert_heic_to_jpeg.sh - to convert heic to jpeg
    - convert_heic_to_jpg.sh - to convert heic to jpg
    - convert_png_j.sh - to convert png to jpg
    - convert_webloc_jpeg - to convert webloc to jpeg
    - convert_webp_jpeg - to convert webp to jpeg
    - heic_jpeg.sh - convert heic to jpeg

- jfif_jpeg.sh - convert jfif to jpeg
    - convert_webloc_to_jpeg.sh - convert webloc to jpeg 

### convert- image files
    - psd_convert.sh - convert psd to jpg
    - psd_jpeg.sh -  convert psd to jpeg

### Compress Files
    - tiny_vid.sh - to make videos smaller - dependent on ffmpeg

### Move 
    - move_files_to_parent.sh - moves files to the parent directory


### Rename - F2
    - F2_date_taken.sh -
    - rename.sh - renames files
      - rename_date_taken.sh - renames files with date taken
      - rename_folder.sh - renames files in folder

### Delete - X
    - X.sh - to delete a folder of files
    - clean.sh - deletes files
    - delete_all_heic - deletes all heic files
    - delete_all_jfif - deletes all jfif files
    - delete_duplicates - tried to get a script that deletes duplicate files but it doesn't work
    - delete_duplicate_images - 
    - delete_text_string - 

### PSD - scripts to change images

change-
	- psd_bright.py
	- psd_bw.py

- psd_convert.sh - converts psd files - exports layers

output - 
       - psd_flat.sh - flattens layers and converts to psd
       - psd_flats.sh - adds colors randomly to closed contour areas
       - psd_jpeg.sh - converts psd to jpeg
keyout -
       - psd_key_matte_folder.sh - adds matte to files in a folder
       - psd_key_mate_folder_strong.sh - like psd key matte but stronger
       - psd_keyout.sh - takes out the white background
       - psd_keyout_w_matte.sh - adds white matte underneath drawings
       - psd_keyout_w_matte_soft.
       - psd_select_sub.sh - inverts subject and takes out background

       - crop.sh - to crop files

### Captioning
Caption.py - caption.py [image.jpg]
	   - asks for caption
	   - write in caption
	   - outputs with caption
## Compressing
      -Untar.sh - uncompresses files
# Editor
  ## emacs - emacs is the editor that I use inside my terminal, it's how I edit text files along with converting files and keeping track of my to-do's using org-mode
     - .emacs -
     - .emacs.d
     - .init.el
# Shell
	fish - (my default) fish is my default that I use, it offers syntax highlighting and smart auto-suggestions.




