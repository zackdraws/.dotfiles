# Glossary                 
  #### 1. Set up - Terminal
  #### 2. Using the Editor in the terminal 
  #### 3. Managing Files
  #### 4. Automating (Scripts) 
  #### 5. Saving 
  #### 6. Tools for Creating
# .dotfiles
   -  the purpose of these .dotfiles is to:
      - configure settings.
      - sync and back up settings.
# 1. Set up - Terminal
###  - Recommended Terminals
   -       mingw64 UCRT64 terminal (windows)   -
   - 	   windows terminal 	   (windows)   -
   [link](https://github.com/microsoft/terminal)
   -	   fooT terminal 	   (linux)     -
   	   [link](https://www.msys2.org/)
   -	   kitty 		   (mac/linux) -
   	   [link](https://sw.kovidgoyal.net/kitty/)  	   			   	       	 (curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh
	   /dev/stdin)
## 1.2.1   install git [(git notes)](/notes/terminal-notes/git.org)
   -       pacman -S mingw-w64-x86_64-git
   - 	   winget install --id Git.Git -e --source winget
   -       kitty terminal - >      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   - 	   home brew 	  - >      brew install git
## 1.2.2   install gh [[https://cli.github.com/][link]]
   -       this allows you to put in your credentials
## 1.4.    clone files (cl)
   -       git clone https://github.com/zackdraws/.dotfiles.git
   -       ** to see your files cd into .dotfiles use these commands
## 1.2.1   set your username git config --global user.name "Your Name"
   "youreemail@example.com"
### Additional Terminal add-ons	
   - 	   fzf	- helps to look through all the files
   - 	   ncdu	- disk utility - look at your disk
   - 	   btop - look at your settings
   - 	   zoxide - search for anything and snap to it in the terminal
   - 	   pastel - helps to pick out colors from the terminal
   - 	   syncthing - can be used to sync all of your files
   - 	   ffmpeg - use for mp4 editing
      	          - use this in terminal to export avi files to mp4 
		  
#### fzf - 
run fzf in the directory for what ever file you are looking for. Run nano "$(fzf)" or whatever editor you are using to open it inside that editor
#### ffmpeg -
           [[ ffmpeg -i filepath.avi filename.mp4]] ** to export to convert to mp4 file
             ffmpeg -i input.avi -r 24 output.mp4
	     	    -fs limit_size (output)
### 1.3 - File folders - set up common folders in your computer for your files to stay organized
    	  use ~ to point to the home directory
    	- ~/.dotfiles  	- config files
    	  ~/ok/		- notes
    	  ~/ref 	- where my reference folders are
	  ~/music       - music files 
	  ~/Videos 	- video files
	  ~/2026/	- files for 2026
# 2. The Editor - the editor is used to edit files from the terminal.
 - eMacs - eMacs stands for Editor Macros and can be used as editor for files.
 to install emacs 'pacman -S mingw-w64-x86_64-emacs'
    [[~/.dotfiles/notes/emacs/]]
## 2. Configure
   The configuration files for emacs are stored on your computer locally in [[~/.emacs.d/init.el]] 
   the configuration files are stored on git in the repo at this location [[~/.dotfiles/.config/emacs/.emacs-pc]]
   clone the repo to have the emacs file make sure it is configured in your home directory ~/
   confirm that you are inside your home directory by typing cd ~/
   type - git clone http://github.io/zackdraws/.dotfiles/ into your terminal
   run  ln -s command to create a synthetic link from the .dotfiles location to the .emacs location file
   'ln -s ~/.dotfiles/.config/emacs/.emacs-pc ~/.emacs.d/init.el
   now you have a symbolic link between the .dotfile and the init file
## Configuring Ivy-Mode     -	
## Configuring Agenda       -  
	make a folder on computer at ~/ok
	when you make a .org file inside the folder mark it with a date or set up reminders 
	org agenda will organize all of the files inside into an agenda view Hit alt-x org-agenda view 
## Extra
   remove all the blank lines in a file	
   M-x flush-lines RET ^$ RET
   M-x flush-lines RET ^[[:space:]]*$ RET
# 3.  Files
   3.1  Link files - (ln)
         sudo ln -s /home/name/.dotfiles/file /usr/local/bin/ (for shell files)
	     (this is to create a symlink)
	        (symlinks are synthetic links between two files 
		(when you update from .dotfiles it then updates the file in the usr local bin.)
    3.1.2 Linking files in windows 
	    - sudo ln -f //wsl.localhost/Ubuntu/home/zack/Music/ /e/Music
	           cd //wsl.localhost/Ubuntu/home/zack/Music/ /e/Music
   3.2    Adding changes: cd ~/.dotfiles/; git add <file changed>; git commit -m "message"; git push (this publishes changes)
   3.3    Recieving changes: git pull or git fetch
   3.3.1. Make Script files actionable from anywhere in the terminal - 
   3.4.1   cd - /usr/local/bin/ (changes the directory to usr/local/bin)
   3.4.2   chmod +x file (this makes the sh follow usable)
   3.5     Shell - for command history and command line editing - is within the terminal
           Fish - for syntax highlights and autosuggestions and themes
	   WINDOWS -  
	   WSL ->  sudo ln -s //wsl.localhost/Ubuntu/home/zack/.dotfiles/sh/p 1/cnvheic2j.ps1		/					c/users/user/Documents/WindowsPowerShell/Scripts/cnvheic2j.ps1
## -  Files: Navigating terminal -
    Yazi    - look through files in terminal. 
            - ~/.config/yazi/yazi.toml
              or c/users/zacha/Appdata/Roaming/yazi/config/yazi.toml
    Broot   - look through files in terminal
    Zoxide  - quick search for files
    FZF     - is a fuzzy finder if you are in the directory use fzf to find your files
# 4.  File Automation (Scripts) - scripts to automate tasks
## .py - Python Files
    cnv_mp4_gif.py
    python mp4_to_gif.py your_input_file.mp4 output_file.gif
4. To change the frame duration, use the `-d` or `--duration` argument:
###   Scripts for making things
      - Export_Org_To_pdf.sh
        converts .org file to pdf
      	$ need to change name from export to convert
      - to_latex.sh
      pipes a file into the correct format for pandoc
      - cnv_pdf_jpg.sh
	     		convert pdf files to jpg
      - this is for a specific file
      - cnv_pdf__jpg.sh* 
   	-- convert pdf files to jpg
    	- this is for all pdf files in a folder
      - grep_thumbnails.sh
     	-- extract image paths and then convert them to latex
      - grep_t.sh 	  
    	-- s/a grep_thumbnails but with a shorter name
      - syncthing_stop.sh 
    	-- stops syncthing
      - mkto.sh 	
	-- makes a todo with the date that the file is made
      - FI_^^.sh' 	
	-- moves file from the child folder to the parent folder
      - copy_out.sh 	     	    
### 4. Exporting    		
      - export_org_to_pdf_02.org
      -- another exporting org files to pdfs (need to check what is different about this one)
      - export_org_to_pdf_02.sh*
      -- another exporting of org files to pdfs (need to check what is different about this file)
      - export_org_to_pdf.sh*
      -- exports .org documents to pdf files (need to check what is different about this file)
### 4. Formating 
###   Scripts for Formatting
      - Bracket_Format.sh		puts brackets around file
### 4. Converting     
###   Scripts for converting Files -
      - cnv_jpg_pdf 		        convert jpg to pdf
      - psd_convert.sh -		convert psd to jpg     		     		
 	- this converts all visible layers to a jpg. Make sure to turn layers off that are in folders.
      - psd_jpeg.sh -  			convert psd to jpeg
      	- this is different then psd_convert.sh ?
      - cnv_pdf->jpg			convert pdf to jpg
      - convert_heic_to_jpeg.sh -	convert heic to jpeg
      - convert_heic_to_jpg.sh - 	convert heic to jpg
      - convert_png_j.sh -     		convert png to jpg
      - convert_webloc_jpeg -  		convert webloc to jpeg
      - convert_webp_jpeg - 		convert webp to jpeg
      - heic_jpeg.sh - 			convert heic to jpeg
      - jfif_jpeg.sh -   		convert jfif to jpeg
      - convert_webloc_to_jpeg.sh - 	convert webloc to jpeg 
      	 (doesn't always work)
### 4.   Compress Files
      - tiny_vid.sh -		        to make videos smaller     		  			
      - tiny_vid_split.sh
      - splits videos in to ten minute portions
      - cnv_org_doc		       converts org files to doc files
### 4.   Move 
          - move_files_to_parent.sh -		mv files to parent directory
### 4.   Rename - F2
    - F2_date_taken.sh -		renames files with the date taken
    - rename.sh -			renames file
    - rename_date_taken.sh - 		renames files with date taken
    - rename_folder.sh -   		renames files in folder
### 4.   Delete - X
    - X.sh -				deletes files inside folder
    - clean.sh - 			deletes files
    - delete_all_heic - 		deletes all heic files
    - delete_all_jfif - 		deletes all jfif files
    - delete_duplicates  		tried to get a script that deletes 
    - delete_duplicate_images - 	script to delete duplicate images
      			      		        (doesn't work well)
    - delete_text_string		can't remember what this one does
### 4. PSD - scripts to change images
    - change				
    - psd_bright.py			
      - psd_bw.py				
      - psd_bright.py			
      - psd_bw.py				
       - psd_convert.sh 		converts psd files - exports layers
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
###  Captioning - 			
- just a quick python script to add a caption to images like storyboards 
    - Caption.py			usage: caption.py [image.jpg]
	   				asks for caption
	   				write in caption
					outputs with caption
###   Compressing
         -Untar.sh -			unzips files from terminal
#   5.  Back-up and Save 
###  		Syncthing - 
     	       	  sync one computer to another
   	       	    1. - install on macos with homebrew - brew install syncthing
	   	    2. - run 'syncthing' in terminal
  		       	      loads syncthing in the terminal -
   	 	    3. - run
		    (on mac)
		    brew services start syncthing
		    for syncthing to start on start up
- Web interface
  5.1. access syncthing in web browser at 127.0.0.1:8384 
  5.2. Go to another computer to install Syncthing
  5.3. sync files by adding them to your folders
### TMUX - terminal multiplexer
    - https://github.com/omerxx/dotfiles 
    - https://github.com/tmux-plugins/tpm
    - https://github.com/omerxx/tmux-sessionx
    - https://github.com/tmux/tmux/wiki/Getting-Started
    - https://github.com/omerxx/go-blocksite
# 7. Work - tools for work
# 7.1 Creating
  ##  Photoshop - Photoshop is what I use for most painting.
      		- My brushes actions and scripts are in the folder marked ps ~/.dotfiles/ps
      Photoshop Actions
      Photoshop Brushes - folder is because most of the brushes I use are not made by me.
      Photoshop Scripts
##  Clip Studio Paint -
##  TVPaint
    - this folder holds my hotkeys, brushes, and home configuration.
      [(tvpaint)](/notes/terminal-notes/git.org)
##  Storyboard Pro
##  Toonboom Harmony
# 7.1.2 Time Tracking
  ## Excel
  ## Manictime 
     ### Manictime as well can be used for extreme time logging.
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
  - mpv	   - use for watching videos
  - ffmpeg - use for editing, converting and trimming videos
  	   use this in terminal to export avi files to mp4 
	       	       [[ ffmpeg -i filepath.avi filename.mp4]] ** to export to convert to mp4 file
		       	  ffmpeg -i input.avi -r 24 output.mp4
## Docs
   ### For PDFS
     - Adobe Acrobat	  - 
       - Zathura	  -		    https://github.com/pwmt/zathura.git 
       - Sioyek  	  - fast pdf viewer https://github.com/ahrm/sioyek
       - Mozilla FIrefox  - pdf/web browser
   ### For DocX
       - Word		  - 
       - OpenDocs	  - 
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
# 9. Setting up a Portfolio site
  * domain fixing
    https://www.youtube.com/watch?v=EX4w9hsduNA
* Github
  run git init in an empty repository
  this command initializes empty git 
  git add  
     [[ https://supersimpledev.github.io/references/git-github-reference.pdf]]
     	git config --global user.email ""
	git config --global user.name ""
	git commit - m "first commit"
# Setting up repeating tasks
  - do this to make a resetting action to repeat tasks
  - sudo nano /etc/systemd/system/restart-networkmanager.service
  - sudo nano /etc/systemd/system/restart-networkmanager.
    systemctl enable --now cronie.service
# 10. Linux - 
## Mounting Hard Drives
   	     to mount hard drives run lsblk 
	     sudo mount /dev/sdb1 /run/media/ok/where you want that file to go
## Searching for files
   ### Rofi is in linux for searching for files
   rofi is for searching for files in arch
   to config rofi -dump-config > ~/.config/rofi/config.rasi
   mkdir -p ~/.config/rofi
   alternative to rofi is wofi - 
## Audio fix (linux)
   try this if audio is not working systemctl --user restart pipewire wireplumber pipewire-pulse
## Wallpapers
   awww-daemon for wallpapers
   [[https://codeberg.org/LGFae/awww]]
## Broswer
# Copying
* Copy
** to copy to the clipboard
cat file.org | to_latex.sh | xclip -selection clipboard
* Write/Paste
*** to write text to a file
echo "text" >> filename.org
** to write text into file from terminal
echo "Your text here" > filename.org
** 
cat >> filename.org
echo "text"
** 
cat >> my_notes.org
echo "This is another line in the file."
cat
* Move
Moving around
- tab to move down
  - shift tab to move up
    alt tab - to move along windows
    alt shift tab -  to move along windows in the opposite direction
        - ctrl + k works a lot for searching
*** Search
  - ctrl + l usually works for searching as well
        - ctrl + g works a lot for entering
        - ctrl + j
        - ctrl + k also usually work a lot for entering along with the enter button itself
* View/Watch
** Videos
*** ffmpeg
for notes -> [[~/.dotfiles/notes/cmd-ffmpeg.org]]
*** MPV
** files 
*** syncing
**** syncthing
*** browsing
**** yazi [[~/.dotfiles/notes/yazi.org]]
**** ncdu 
**** btop
**** fzf
fzf is for fuzzy finding in the terminal. Search inside the directory by typing fzf in the directory that you are in.
**** zoxide
makes searching easy by typing in z it just goes right to the place
** misc
*** Pastel
for looking up colors
* oh-my-posh
** oh-my-posh in bash
 for using oh-my-posh in bash
eval "$(oh-my-posh init bash --config ~/jandedobbeleer.omp.json)"
add this in to either ~/.bashrc or ~/.profile or ~/.bash_profile
then reload using exec bash 
or
eval "$(oh-my-posh init bash)"
** oh my posh
oh-my-posh init pwsh --config "$env:C:\Posh\THemes\bubbles.omp.json"
(@(& 'C:/Users/zacha/scoop/apps/oh-my-posh/current/oh-my-posh.exe' init pwsh --config='C:\Posh\THemes\bubbles.omp.json' --print) -join "`n") | Invoke-Expression
