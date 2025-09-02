# Dotfiles

- Dotfiles controls the configuration of your computer. The .dotfiles are the local settings stored on a user's computer. Dotfiles can be synced to ease moving from one computer to another. 

     	     	      	    	     GLOSSARY                               
		                1. How to Set up the Terminal
                        2. Using the Editor in the terminal 
                        3. Managing Files
                        4. Automating (Scripts) 
                        5. Saving 
                        6. Tools for Creating 

## 1. The Terminal
                the terminal is a text based way to run commands on your computer using text
- to use these .dotfiles you will need to use the terminal (you can use these without a terminal but it won't update without using the terminal and you won't be able to sync them or automatically set them up. A user would basically
have to drag and drop them, and then do that each time there is an update.)

### - Recommended Terminals
    to use dotfiles download one of these terminals, you can use your default one on apple that's already installed but I would recommend one of thse
-       if you are on windows use mingw64 or wsl (mingw64 > wsl) 
    -	   mingw64 (windows) - if you are on windows use this terminal
    -	   foot (linux/wsl) - if you are on linux and want a very quick lightweight terminal I would recommend this
    -	   ghostty (mac/linux/wsl) - if you want something very fresh, dynamic and customizeable with a growing community of users and editors I would recommend ghostty (you can use the command brew install ghostty) (to use homebrew use these instructions https://brew.sh/)
    -	   kitty (mac/linux/wsl) - if you want something very stable use kitty. (curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin)
## 1.2. Next install git
   -     pacman -S mingw-w64-x86_64-git
   -     kitty terminal - > /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   - 	 home brew - >      brew install git

## 1.4.  clone files (cl)
	 	  1.  open your terminal
          type "cd ~/" (without quotes)
		  - this is your home directory
		  2. mkdir .dotfiles
		  3. cd .dotfiles
		  4. git clone this repo
                	    git clone https://github.com/zackdraws/.dotfiles.git
		  ** to see your files cd into .dotfiles use these commands
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

# 3. Files
        3.1     Link files - (ln)
                        sudo ln -s /home/name/.dotfiles/file /usr/local/bin/ (for shell files)
    	 			    (this is to create a symlink)
	                    (symlinks are synthetic links between two files 
                        (when you update from .dotfiles it then updates the file in the usr local bin.)
		                *       sudo is the command to run a command as 'administrator'
	    3.2 -   Additional Note: from there you can go to .dotfiles run 'git add .' 
                        next run 'git commit -m "comment" and to 
                        run git push to publish to git
	    3.3 -   to update folder from github run 'git pull'
	                    3.3.1. Make Script files actionable from anywhere in the terminal - 
        3.4.1   cd - /usr/local/bin/ (changes the directory to usr/local/bin)
                        3.4.2  chmod +x file (this makes the sh follow usable)
        3.5     Shell - for command history and command line editing - is within the terminal
                    -Fish - for syntax highlights and autosuggestions and themes

### -  Navigating terminal -
    Yazi - to manage and look through files. eMacs in the terminal is used as the editor for the program.

    Broot - to manage and look through files, it's like Yazi but it is not.

    Zoxide - makes it insanely easier to find files

    FZF - is a fuzzy finder if you are in the directory use fzf to find your files

# Directories -
  	      different directories hold different dotfiles for configuration

## 4. Automating (Scripts)
    - cnv_mp4_gif.py
                        python mp4_to_gif.py your_input_file.mp4 output_file.gif
                        4.To change the frame duration, use the `-d` or `--duration` argument:
    examples -
                        python mp4_to_gif.py your_input_file.mp4 output_file.gif -d 0.2  # 0.2 seconds per frame
                        - opposite of that is cnv_gif_mp4.bash
                        - /create_gif.sh wUsers/myuser/Pictures/my_images output.gif
## SH - Shell Files 
      - these are my shell files they are located in my usr/local/bin using sudo chmod +x
### Make
    - Export_Org_To_pdf.sh	exports the org to pdf
    - to_latex.sh 	    	pipes a file into the correct format for pandoc
    - cnv_pdf_jpg.sh	     	convert pdf files to jpg
    - cnv_pdf__jpg.sh*    	convert pdf files to jpg
    - grep_thumbnails.sh     	extract image paths and then convert them to latex
    - grep_t.sh 	      		s/a grep_thumbnails but with a shorter name
    - syncthing_stop.sh     	stops syncthing
    - mkto.sh 		   	makes a todo with the date that the file is made
    - FI_^^.sh' 	   		moves file from the cild folder to the parent folder
    - copy_out.sh 	     	    
    - export_org_to_pdf_02.org
    - export_org_to_pdf_02.sh*
    - export_org_to_pdf.sh*
    - bracket_format.sh - formats brackets around files
### Formatting
    - Bracket_Format.sh			puts brackets around
### Convert Files - 			scripts to convert from one file format to another or change the size of files
    - cnv_pdf->jpg 			        - converts pdf file to jpeg files
    - cnv_jpg_pdf 			        - converts jpg files to pdf
    - convert_heic_to_jpeg.sh -		- to convert heic to jpeg
    - convert_heic_to_jpg.sh - 		- to convert heic to jpg
    - convert_png_j.sh -     		- to convert png to jpg
    - convert_webloc_jpeg -  		- to convert webloc to jpeg
    - convert_webp_jpeg - 		        to convert webp to jpeg
    - heic_jpeg.sh - 			    convert heic to jpeg
    - jfif_jpeg.sh -   			    convert jfif to jpeg
    - convert_webloc_to_jpeg.sh - 	 convert webloc to jpeg 
### convert- image files
    - psd_convert.sh -			convert psd to jpg
    - psd_jpeg.sh -  			 convert psd to jpeg
### Compress Files
    - tiny_vid.sh -			to make videos smaller - dependent on ffmpeg
### Move 
    - move_files_to_parent.sh -		moves files to the parent directory
### Rename - F2
    - F2_date_taken.sh -
    - rename.sh -			renames files
      - rename_date_taken.sh - 		renames files with date taken
      - rename_folder.sh -   		renames files in folder
### Delete - X
    - X.sh -				to delete a folder of files
    - clean.sh - 			deletes files
    - delete_all_heic - 		deletes all heic files
    - delete_all_jfif - 		deletes all jfif files
    - delete_duplicates - 		tried to get a script that deletes duplicate files but it doesn't work
    - delete_duplicate_images - 
    - delete_text_string - 
### PSD - scripts to change images
    - change-
	- psd_bright.py
	- psd_bw.py
    - psd_convert.sh - converts psd files - exports layers
    - output - 
    - psd_flat.sh - flattens layers and converts to psd
    - psd_flats.sh - adds colors randomly to closed contour areas
    - psd_jpeg.sh - converts psd to jpeg
    - keyout -
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

## 6. Saving

### TMUX - 
for tabs in the terminal and to save your place
- tmux plug ins

#7. For Work


# 7.1 Tools for Creating (still working on this part)
##  Photoshop
##  Clip Studio Paint -
##  TVPaint
##  Storyboard Pro
##  Toonboom Harmony

# 7.1.2 Time Tracking
## Excel

# 7.3 Compositing/Editing
# Premiere
# Blender
# After Effects

# 7.3.2 Sound
## Audacity
## Adobe Audition

# 7.4 Publishing/Posting

# 7.5 Storing/Backing up/File Management

# 7.2 Reviewing

