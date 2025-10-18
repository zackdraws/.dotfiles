#	     	    	     GLOSSARY                 
 1. Set up your terminal
 2. Using the Editor in the terminal 
 3. Managing Files
 4. Automating (Scripts) 
 5. Saving 
 6. Tools for Creating 
# .dotfiles
  - .dotfiles controls the configuration of your computer. - they are the local settings stored on your 
  computer in the home directory. - sync from your dotfiles folder to the correct locations - changes can be 
  updated and synced.
## 1. Set up your Terminal
   - Use the terminal to edit dotfiles.
###  	 - Recommended Terminals
    -	   mingw64 UCRT64 terminal (windows) -
    -	   fooT terminal (linux/wsl) - 
    -	   ghostty terminal (mac/linux/wsl) - new, user friendly
    	   (you can use the command brew install ghostty)
	   	    (to use homebrew use these instructions [[https://brew.sh/]])
    -	   kitty (https://sw.kovidgoyal.net/kitty/) (mac/linux/wsl) - stable and fast
    	   (curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh	/dev/stdin)
    -      if you are on windows use mingw64 UCRT64 or wsl (mingw64 > wsl) 
## 1.2.1   install git
   -       pacman -S mingw-w64-x86_64-git
   -       kitty terminal - >      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   - 	   home brew 	- >      brew install git
## 1.2.2   After that install gh [[https://cli.github.com/][link]]
## 1.4.    clone files (cl)
  git clone https://github.com/zackdraws/.dotfiles.git
  ** to see your files cd into .dotfiles use these commands
### Additional Terminal add-ons	
    - fzf 	       	  - helps to look through all the files
    - ncdu 	      	  - disk utility - look at your disk
    - btop 	      	  - look at your settings
    - zoxide      	  - search for anything and snap to it in the terminal
    - pastel   	  	  - helps to pick out colors from the terminal
    - syncthing 	  - can be used to sync all of your files
    - ffmpeg    	  - use for mp4 editing
 			  - use this in terminal to export avi files to mp4 
** fzf - 
run fzf in the directory for what ever file you are looking for. Run nano "$(fzf)" or whatever editor you are using to open it inside that editor
** ffmpeg -
           [[ ffmpeg -i filepath.avi filename.mp4]] ** to export to convert to mp4 file
             ffmpeg -i input.avi -r 24 output.mp4
	     	    -fs limit_size (output)
** Set the file size limit, expressed in bytes. No further chunk of bytes is written after the limit is exceeded. The size of the output file is slightly more than the requested file size
# 2. The Editor - the editor is used to edit files from the terminal.
      - eMacs - eMacs stands for Editor Macros and can be used as editor for files.
	install emacs
        		 pacman -S mingw-w64-x86_64-emacs
        - brew install emacs
		- now you can write into files in the terminal using the command 'emacs -nw file'
        - Nano - small quick editor.
# 3. Files
            3.1     Link files - (ln)
                        sudo ln -s /home/name/.dotfiles/file /usr/local/bin/ (for shell files)
    	 			    (this is to create a symlink)
	                    (symlinks are synthetic links between two files 
                        (when you update from .dotfiles it then updates the file in the usr local bin.)
			- sudo ln -f //wsl.localhost/Ubuntu/home/zack/Music/ /e/Music
			       cd //wsl.localhost/Ubuntu/home/zack/Music/ /e/Music
		                *       sudo is the command to run a command as 'administrator'
	    3.2    Additional Note: from there you can go to .dotfiles run 'git add .' 
                        next run 'git commit -m "comment" and to 
                        run git push to publish to git
	    3.3    to update folder from github run 'git pull'
            3.3.1.  Make Script files actionable from anywhere in the terminal - 
            3.4.1   cd - /usr/local/bin/ (changes the directory to usr/local/bin)
            3.4.2  chmod +x file (this makes the sh follow usable)
	    3.5     Shell - for command history and command line editing - is within the terminal
                    Fish - for syntax highlights and autosuggestions and themes
		    WINDOWS - 
			WSL
		    sudo ln -s //wsl.localhost/Ubuntu/home/zack/.dotfiles/sh/p 1/cnvheic2j.ps1 /c/users/user/Documents/WindowsPowerShell/Scripts/cnvheic2j.ps1

## -  Navigating terminal -
       Yazi - this terminal app can be used to manage and look through files. 
       - your yazi can be found at either
       ~/.config/yazi/yazi.toml
       or c/users/zacha/Appdata/Roaming/yazi/config/yazi.toml
       Broot - to manage and look through files, it's like Yazi but it is not.
       Zoxide - quick search for files
       FZF - is a fuzzy finder if you are in the directory use fzf to find your files
# 4. Automating (Scripts)
####      -- these are the scripts that I use to automate my tasks
## .py - Python Files
    cnv_mp4_gif.py
                        python mp4_to_gif.py your_input_file.mp4 output_file.gif
                        4.To change the frame duration, use the `-d` or `--duration` argument:
    examples -
                        python mp4_to_gif.py your_input_file.mp4 output_file.gif -d 0.2  # 0.2 seconds per frame
10;rgb:c8c8/bebe/c8c811;rgb:3232/2929/3131- opposite of that is cnv_gif_mp4.bash
                        - /create_gif.sh wUsers/myuser/Pictures/my_images output.gif
## .sh - Shell Files/Fish Files 
      - these are my shell files
      - located in /sh in .dotfiles
      - sync (ln -s)  to /usr/local/bin/
      - sudo chmod +x to use from anywhere
      - used for automating tasks
###   Scripts for making things
      - Export_Org_To_pdf.sh		converts .org file to pdf
      					$ need to change name from export to convert
      - to_latex.sh 	    	    	pipes a file into the correct format for pandoc
      - cnv_pdf_jpg.sh	     		convert pdf files to jpg
      - cnv_pdf__jpg.sh*    		convert pdf files to jpg
      - grep_thumbnails.sh     		extract image paths and then convert them to latex
      - grep_t.sh 	      		s/a grep_thumbnails but with a shorter name
      - syncthing_stop.sh     		stops syncthing
      - mkto.sh 		   	makes a todo with the date that the file is made
      - FI_^^.sh' 	   		moves file from the child folder to the parent folder
      - copy_out.sh 	     	    
      				    export-
      - export_org_to_pdf_02.org	another exporting org files to pdfs (need to check what is different about this one)
      - export_org_to_pdf_02.sh*	another exporting of org files to pdfs (need to check what is different about this file)
      - export_org_to_pdf.sh*		exports .org documents to pdf files (need to check what is different about this file)

      			  	    format
###   Scripts for Formatting
      - Bracket_Format.sh		puts brackets around file

      				    converting     

###   Scripts for converting Files -
      - cnv_pdf->jpg			converts pdf file to jpeg files
      - cnv_jpg_pdf 		        converts jpg files to pdf
      - convert_heic_to_jpeg.sh -	convert heic to jpeg
      - convert_heic_to_jpg.sh - 	convert heic to jpg
      - convert_png_j.sh -     		convert png to jpg
      - convert_webloc_jpeg -  		convert webloc to jpeg
      - convert_webp_jpeg - 		convert webp to jpeg
      - heic_jpeg.sh - 			convert heic to jpeg
      - jfif_jpeg.sh -   		convert jfif to jpeg
      - convert_webloc_to_jpeg.sh - 	convert webloc to jpeg
      					                    (doesn't always work)
### Convert image files
      - psd_convert.sh -		convert psd to jpg     		     			
      - psd_jpeg.sh -  			convert psd to jpeg
### Compress Files
      - tiny_vid.sh -		        to make videos smaller     		  			
      - tiny_vid_split.sh
      - splits videos in to ten minute portions
### Move 
    - move_files_to_parent.sh -		mv files to parent directory
### Rename - F2
    - F2_date_taken.sh -		renames files with the date taken
    - rename.sh -			renames file
    - rename_date_taken.sh - 		renames files with date taken
    - rename_folder.sh -   		renames files in folder
### Delete - X
    - X.sh -				deletes files inside folder
    - clean.sh - 			deletes files
    - delete_all_heic - 		deletes all heic files
    - delete_all_jfif - 		deletes all jfif files
    - delete_duplicates  		tried to get a script that deletes 
    - delete_duplicate_images - 	script to delete duplicate images
      			      		        (doesn't work well)
    - delete_text_string		can't remember what this one does
### PSD - scripts to change images
    - change				
          - psd_bright.py			
    	  - psd_bw.py				
          - psd_convert.sh 			converts psd files - exports layers
	    - output -      
    	    - psd_flat.sh			flattens layers and converts to psd
	    - psd_flats.sh 			adds colors randomly to closed contour areas
	    - psd_jpeg.sh 			converts psd to jpeg
	    - keyout -
	    - psd_key_matte_folder.sh		adds matte to files in a folder
	    - psd_key_mate_folder_strong.sh 	like psd key matte but stronger
	    - psd_keyout.sh 			takes out the white background
	    - psd_keyout_w_matte.sh 		adds white matte underneath drawings
	    - psd_keyout_w_matte_soft.		 
	    - psd_select_sub.sh 		inverts subject and takes out background
	    - crop.sh 				to crop files
### Captioning - 			just a quick python script to add a caption to images like storyboards 
    - Caption.py			usage: caption.py [image.jpg]
	   				asks for caption
	   				write in caption
					outputs with caption
## Compressing
         -Untar.sh -			unzips files from terminal
# 5. Back-up and Save 
###  Syncthing - 
     	       with syncthing you can sync one computer to another
   	       	    1. - install on macos with homebrew - brew install syncthing
	   	    2. - run 'syncthing' in terminal
  		       	      loads syncthing in the terminal -
   	 	    3. - run
		    (on mac)
		    brew services start syncthing
		    for syncthing to start on start up
- Web interface
  4. access syncthing by in web browser it should be at 127.0.0.1:8384 
  5. Go to another computer to install Syncthing
  6. sync files by adding them to your folders
### TMUX - terminal multiplexer
    - https://github.com/omerxx/dotfiles 
    - https://github.com/tmux-plugins/tpm
    - https://github.com/omerxx/tmux-sessionx
    - https://github.com/tmux/tmux/wiki/Getting-Started
    - https://github.com/omerxx/go-blocksite
# 7. Work - tools for work
# 7.1 Creating
##  Photoshop
Photoshop is what I used for most painting. My brushes actions and scripts are in the folder marked ps ~/.dotfiles/ps
Photoshop Actions

Photoshop Brushes - this folder is empty right now because most of the brushes I use are not made by me.

Photoshop Scripts

##  Clip Studio Paint -
##  TVPaint
- this folder holds my hotkeys, brushes, and home configuration.
##  Storyboard Pro

##  Toonboom Harmony

# 7.1.2 Time Tracking
x## Excel

## Manictime 

# 7.3 Compositing/Editing
## Premiere - For editing reels and animation scenes.
## Blender - For editing reels and animation scenes, it's similar to Premiere, most things can be done in Blender but they just require a bit more research and time.
## After Effects
# 7.3.2 Sound
## Audacity
## Adobe Audition
# 7.4 Publishing/Posting
# 7.5 Storing/Backing up/File Management
# 7.2 Reviewing
- mpv - use for watching videos
- ffmpeg - use for editing, converting and trimming videos
  	   use this in terminal to export avi files to mp4 
	       	       [[ ffmpeg -i filepath.avi filename.mp4]] ** to export to convert to mp4 file
		       	  ffmpeg -i input.avi -r 24 output.mp4
			  -fs limit_size (output)

## Docs
### For PDFS
- Adobe Acrobat	  -
- Zathura	  - https://github.com/pwmt/zathura.git 
- Sioyek  	  - fast pdf viewer
- Mozilla FIrefox - firefox also has a pdf viewer
### For DocX
- Word		- 
- OpenDocs	-
- Drive

# Where files can usually be found
   
# Photoshop config locations
$photoshopConfigDir = "$env:APPDATA\Adobe\Adobe Photoshop <version>\Adobe Photoshop <version> Settings"
New-Item -ItemType SymbolicLink -Path $photoshopConfigDir -Target "$dotfilesDir\photoshop\Settings" -Force

$photoshopPresetsDir = "$env:APPDATA\Adobe\Adobe Photoshop <version>\Presets"
New-Item -ItemType SymbolicLink -Path $photoshopPresetsDir -Target "$dotfilesDir\photoshop\Presets" -Force

# TVPaint config location
$tvpaintConfigDir = "$env:APPDATA\TVPaint Animation"
New-Item -ItemType SymbolicLink -Path $tvpaintConfigDir -Target "$dotfilesDir\tvpaint\Animation" -Force

# Screen Recordings
  if you are on windows you can use Win+G and set the location I set mine to c/P/Captures

### Summary
- **Photoshop and TVPaint Configuration Files** are usually located in the `AppData` folder (Roaming or Local)
- **Symlinks** allow you to point these configuration files to their expected locations, making it easy to synchronize settings across multiple machines.
### 5. **Alternative Syncing Options**


# 9. Setting up a Portfolio site
* domain fixing
https://www.youtube.com/watch?v=EX4w9hsduNA
* Github
- terminal
--  https://www.youtube.com/watch?v=hrTQipWp6co
-- open in your code editor
-- git
config.js
index.js
- git setup
ls shows list of current folder
- the terminal is to control the computer
it is running at first in the home folder
make sure to go into your own folder
cd = change directory
---> cd ~/Desktop/git-tutorial
ls - shows the files in the folder
config.s 
src
it restarts in your home folder make sure to go into your git folder first
now learning git 
creating a version
git init
initializes empty git 
git status
- this shows the commits
- untracked files
git add  
https://supersimpledev.github.io/references/git-github-reference.pdf 
git config --global user.email ""
git config --global user.name ""
git commit - m "Version 1"
git log 
- git restore <file>
git restore .
unstage 







