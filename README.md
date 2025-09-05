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
    to use dotfiles download one of these terminals, you can use your default one on apple that's already installed but I would recommend one of these
    
    -	   mingw64 (windows) - use on windows
    -	   foot (linux/wsl) - fast terminal, weird name
    -	   ghostty (mac/linux/wsl) - new, user friendly
    	   (you can use the command brew install ghostty)
	   	    (to use homebrew use these instructions [[https://brew.sh/]])
    -	   kitty (mac/linux/wsl) - stable and fast
    	   (curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh	/dev/stdin)
    -      if you are on windows use mingw64 or wsl (mingw64 > wsl) 

## 1.2. Next install git
   -     pacman -S mingw-w64-x86_64-git
   -     kitty terminal - > /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   - 	 home brew - >      brew install git



then install git here
git config --global user.name "Your Name"
git config --global user.email 
"your.email@example.com"
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

# 2. The Editor - to edit files you will need an editor
      - eMacs - install emacs
     pacman -S mingw-w64-x86_64-emacs

        - brew install emacs
     
		- now you can write into files in the terminal using the command 'emacs -nw file'

        - Nano - I would also suggest installing nano - it's a very quick editor for fast editing text

	- * autosuggestions - the plug-in company is installed you (ctrl-m to select from the dropdownlist) 




# 3. Files
        3.1     Link files - (ln)
                        sudo ln -s /home/name/.dotfiles/file /usr/local/bin/ (for shell files)
    	 			    (this is to create a symlink)
	                    (symlinks are synthetic links between two files 
                        (when you update from .dotfiles it then updates the file in the usr local bin.)


			- sudo ln -f //wsl.localhost/Ubuntu/home/zack/Music/ /e/Music
			       cd //wsl.localhost/Ubuntu/home/zack/Music/ /e/Music



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


		    WINDOWS - 
		    	    - do not use wsl but if you do and you have your dotfiles in wsl you would have to do this to link them
		    sudo ln -s //wsl.localhost/Ubuntu/home/zack/.dotfiles/sh/p 1/cnvheic2j.ps1 /c/users/user/Documents/WindowsPowerShell/Scripts/cnvheic2j.ps1


## -  Navigating terminal -

       Yazi - to manage and look through files. 

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
                        - opposite of that is cnv_gif_mp4.bash
                        - /create_gif.sh wUsers/myuser/Pictures/my_images output.gif
## .sh - Shell Files/Fish Files 
      - these are my shell files
      - located in /sh in .dotfiles
      - sync (ln -s)  to /usr/local/bin/
      - sudo chmod +x to use from anywhere
      - used for automating tasks
### Scripts for making things
    - Export_Org_To_pdf.sh		converts .org file to pdf
      					        $ need to change name from export to convert
    - to_latex.sh 	    	    pipes a file into the correct format for pandoc
    - cnv_pdf_jpg.sh	     	convert pdf files to jpg
    - cnv_pdf__jpg.sh*    		convert pdf files to jpg
    - grep_thumbnails.sh     	extract image paths and then convert them to latex
    - grep_t.sh 	      		s/a grep_thumbnails but with a shorter name
    - syncthing_stop.sh     	stops syncthing
    - mkto.sh 		   		    makes a todo with the date that the file is made
    - FI_^^.sh' 	   		    moves file from the child folder to the parent folder
    - copy_out.sh 	     	    
    - export_org_to_pdf_02.org
    - export_org_to_pdf_02.sh*
    - export_org_to_pdf.sh*
    - bracket_format.sh -       formats brackets around files
### Scripts for Formatting
    - Bracket_Format.sh			puts brackets around file
      					-       tempermental doesn't work well
### Scripts for converting Files -
    - cnv_pdf->jpg 		                - converts pdf file to jpeg files
    - cnv_jpg_pdf 		                - converts jpg files to pdf
    - convert_heic_to_jpeg.sh -		    - convert heic to jpeg
    - convert_heic_to_jpg.sh - 		    - convert heic to jpg
    - convert_png_j.sh -     		    - convert png to jpg
    - convert_webloc_jpeg -  		    - convert webloc to jpeg
    - convert_webp_jpeg - 		        - convert webp to jpeg
    - heic_jpeg.sh - 			        - convert heic to jpeg
    - jfif_jpeg.sh -   			        - convert jfif to jpeg
    - convert_webloc_to_jpeg.sh - 	    - convert webloc to jpeg
      					                    (doesn't always work)
### convert- image files
    - psd_convert.sh -			    - convert psd to jpg
      		     			
    - psd_jpeg.sh -  			     convert psd to jpeg
### Compress Files
    - tiny_vid.sh -		        	- to make videos smaller
      		  			
### Move 
    - move_files_to_parent.sh -		mv files to parent directory
### Rename - F2
    - F2_date_taken.sh -
    - rename.sh -			        renames file
      					-
    - rename_date_taken.sh - 		renames files with date taken
      			   		-
    - rename_folder.sh -   		    renames files in folder
      		       			-
### Delete - X
    - X.sh -				        deletes files inside folder
    - clean.sh - 			        deletes files
    - delete_all_heic - 		    deletes all heic files
    - delete_all_jfif - 		    deletes all jfif files
    - delete_duplicates - 		    tried to get a script that deletes 
    - delete_duplicate_images - 	script to delete duplicate images
      			      		        doesn't work well
    - delete_text_string - 		    $$ can't remember what this one does
### PSD - scripts to change images
    - change				-
    - psd_bright.py			-
    - psd_bw.py				-
    - psd_convert.sh 			             - converts psd files - exports layers
    - output -      
    - psd_flat.sh			                - flattens layers and converts to psd
    - psd_flats.sh 			                - adds colors randomly to closed contour areas
    - psd_jpeg.sh 			                - converts psd to jpeg
    - keyout -
    - psd_key_matte_folder.sh		        - adds matte to files in a folder
    - psd_key_mate_folder_strong.sh 	    - like psd key matte but stronger
    - psd_keyout.sh 			            - takes out the white background
    - psd_keyout_w_matte.sh 		        - adds white matte underneath drawings
    - psd_keyout_w_matte_soft.		 
    - psd_select_sub.sh 		            - inverts subject and takes out background
    - crop.sh 				                - to crop files
### Captioning - just a quick python script to add a caption to images like storyboards 
Caption.py				- usage: caption.py [image.jpg]
	   				- asks for caption
	   				- write in caption
					- outputs with caption
## Compressing
         -Untar.sh -			unzips files from terminal
# 5. Back-up and Save 
### Syncthing - 
-   with syncthing you can sync one computer to another
1. - install on macos with homebrew - brew install syncthing
2. - run 'syncthing' in terminal
loads syncthing in the terminal -
3. - run
brew services start syncthing
for syncthing to start on start up

4. access syncthing by going to 127.0.0.1:8384 in your web browser

5. Go to another computer to install Syncthing

6. sync files by adding them to your folders

### TMUX -
- https://github.com/omerxx/dotfiles 
- https://github.com/tmux-plugins/tpm
- https://github.com/omerxx/tmux-sessionx
- https://github.com/tmux/tmux/wiki/Getting-Started
- https://github.com/omerxx/go-blocksite

# 7. For Work


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

## Docs
### For PDFS
- Adobe Acrobat-
- Zathura - https://github.com/pwmt/zathura.git 
- Mozilla FIrefox - 
### For DocX
- Word -
- OpenDocs -
- Drive

# 8
├── #mp4_frames.sh#
├── 0T5.sh
├── 16x9.sh
├── 16x92.sh
├── autocaption.sh
├── autocaption.sh:Zone.Identifier
├── autocaption_1.sh
├── backup.txt
├── bracket_format.sh
├── bracket_format.sh~
├── caption.py
├── clean.sh
├── cnv_jpg_pdf.sh
├── cnv_pdf__jpg.sh
├── cnv_pdf_jpg.sh
├── compress_video.sh
├── compress_video2.sh
├── convert
│   ├── cnv_jpg_pdf.sh
│   ├── cnv_pdf__jpg.sh
│   ├── cnv_pdf_jpg.sh
│   ├── convert-path
│   ├── convert_heic_to_jpeg.sh
│   ├── convert_heic_to_jpg.sh
- cnvheicj.sh - this one works

│   ├── convert_png_j.sh
│   ├── convert_webloc_jpeg.sh
│   ├── convert_webloc_jpeg.sh~
│   ├── convert_webloc_to_jpeg.sh
│   ├── convert_webp_jpeg.sh
│   ├── heic_jpeg.sh
│   ├── jfif_jpeg.sh
│   ├── mp4_frames.sh
│   ├── psd_convert.sh
│   ├── untar.sh
│   └── webloc_jpeg.sh
├── convert-path
├── convert_heic_to_jpeg.sh
├── convert_heic_to_jpg.sh
├── convert_png_j.sh
├── convert_webloc_jpeg.sh
├── convert_webloc_to_jpeg.sh
├── convert_webp_jpeg.sh
├── copy_clip2.sh
├── copy_out.sh
├── crop.sh
├── deldoop.sh
├── deldoop2.sh
├── delete
│   ├── clean.sh
│   ├── deldoop.sh
│   ├── deldoop2.sh
│   ├── delete_all_heic.sh
│   ├── delete_all_jfif.sh
│   ├── delete_duplicate_images.sh
│   ├── delete_duplicates.sh
│   ├── delete_text_string.sh
│   ├── X.fish
│   ├── X.fish~
│   └── X.sh
├── delete_all_heic.sh
├── delete_all_jfif.sh
├── delete_duplicate_images.sh
├── delete_duplicates.sh
├── delete_text_string.sh
├── document
├── export
│   ├── copy_out.sh
│   ├── export_org_to_pdf.sh
│   ├── export_org_to_pdf.sh~
│   ├── export_org_to_pdf_02.org
│   ├── export_org_to_pdf_02.sh
│   ├── export_org_to_pdf_02.sh~
│   ├── F2_txt.sh
│   └── sequence_.sh
├── export_org_to_pdf.sh
├── export_org_to_pdf.sh~
├── export_org_to_pdf_02.org
├── export_org_to_pdf_02.sh
├── export_org_to_pdf_02.sh~
├── f2.sh
├── F2_date_taken.sh
├── F2_txt.sh
├── FI_^.sh
├── FI_^^.sh
├── file
│   ├── copy_clip2.sh
│   ├── FI_^^.sh
│   ├── filecopyimg.sh
│   ├── filecopyimgmultiple.sh
│   ├── filecopyimgmultiple02.sh
│   ├── filecopyimgmultiple03.sh
│   ├── filecopyimgmultiple_1.sh
│   ├── filepath.sh
│   └── filepathcopy.sh
├── filecopyimg.sh
├── filecopyimgmultiple.sh
├── filecopyimgmultiple02.sh
├── filecopyimgmultiple03.sh
├── filecopyimgmultiple_1.sh
├── filepath.sh
├── filepathcopy.sh
├── fix
│   ├── #fix.sh#
│   ├── #fixfix.sh#
│   ├── fix.sh
│   ├── fix.sh~
│   ├── list.sh
│   ├── list.sh~
│   ├── listlist.sh
│   └── listlist.sh~
├── format
│   ├── bracket_format.sh
│   ├── bracket_format.sh~
│   ├── grep_t.sh
│   ├── grep_thumbnails.sh
│   ├── grep_thumbnails.sh~
│   ├── to_latex.sh
│   └── to_latex.sh~
├── ghostty-launcher.sh
├── grep_t.sh
├── grep_thumbnails.sh
├── grep_thumbnails.sh~
├── heic_jpeg.sh
├── iph.sh
├── jfif_jpeg.sh
├── jpeg.sh
├── launch
│   ├── ghostty-launcher.sh
│   ├── 'open_tvpaint (2).sh'
│   ├── open_tvpaint.sh
│   ├── syncthing.sh
│   ├── syncthing_stop.sh
│   └── syncthing_stop.sh~
├── list.txt
├── make
│   ├── autocaption.sh
│   ├── autocaption_1.sh
│   ├── merge_mp3.bash
│   ├── mkdup.sh
│   ├── mkpdf.sh
│   ├── mkto.sh
│   ├── mkto.sh~
│   ├── save_screen.sh
│   ├── save_screen.sh~
│   ├── screen_record
│   └── yt-dl.sh
├── maketiny
│   ├── compress_video.sh
│   ├── compress_video2.sh
│   └── tiny_vid_split.sh
├── merge_mp3.bash
├── mkdup.sh
├── mkpdf.sh
├── mkto.sh
├── mkto.sh~
├── move
│   └── FI_^.sh
├── mp4_frames.sh
├── open
├── 'open_tvpaint (2).sh'
├── plan
│   └── 0T5.sh
├── psd
│   ├── 16x9.sh
│   ├── 16x92.sh
│   ├── crop.sh
│   ├── psd_bright.py
│   ├── psd_bright_pencil.py
│   ├── psd_bw.py
│   ├── psd_fill.py
│   ├── psd_fill.py~
│   ├── psd_fill.sh
│   ├── psd_fill.sh~
│   ├── psd_fill_extra.sh
│   ├── psd_fill_working.py
│   ├── psd_flat.sh
│   ├── psd_flats.sh
│   ├── psd_flats.sh~
│   ├── psd_jpeg.sh
│   ├── psd_jpeg_w_gimp.sh
│   ├── psd_key_matte_folder.sh
│   ├── psd_key_matte_folder.sh~
│   ├── psd_key_matte_folder_strong.sh
│   ├── psd_keyout.sh
│   ├── psd_keyout.sh~
│   ├── psd_keyout_soft.sh
│   ├── psd_keyout_w_matte.sh
│   ├── psd_keyout_w_matte.sh~
│   ├── psd_keyout_w_matte_soft.sh
│   ├── psd_keyout_w_matte_soft.sh~
│   └── psd_select_sub.sh
├── psd_bright.py
├── psd_bright_pencil.py
├── psd_bw.py
├── psd_convert.sh
├── psd_fill.py
├── psd_fill.py~
├── psd_fill.sh
├── psd_fill.sh~
├── psd_fill_extra.sh
├── psd_fill_working.py
├── psd_flat.sh
├── psd_flats.sh
├── psd_flats.sh~
├── psd_jpeg.sh
├── psd_jpeg_w_gimp.sh
├── psd_key_matte_folder.sh
├── psd_key_matte_folder.sh~
├── psd_key_matte_folder_strong.sh
├── psd_keyout.sh
├── psd_keyout.sh~
├── psd_keyout_soft.sh
├── psd_keyout_w_matte.sh
├── psd_keyout_w_matte.sh~
├── psd_keyout_w_matte_soft.sh
├── psd_keyout_w_matte_soft.sh~
├── psd_select_sub.sh
├── rename
│   ├── f2.sh
│   ├── F2_date_taken.sh
│   ├── iph.sh
│   ├── rename.sh
│   ├── rename_blank.sh
│   ├── rename_date_taken.sh
│   ├── rename_folder.sh
│   ├── rename_still_life.sh
│   └── rm_not_cropped.sh
├── rename.sh
├── rename_blank.sh
├── rename_date_taken.sh
├── rename_folder.sh
├── rename_still_life.sh
├── rm_not_cropped.sh
├── save_screen.sh
├── save_screen.sh~
├── screen_record
├── sequence_.sh
├── shell_files
│   ├── F2.sh
│   ├── F2.sh~
│   ├── F2_date_taken.sh
│   ├── F2_date_taken_1.sh
│   ├── F2_date_taken_1.sh~
│   ├── F2_folder.sh
│   ├── F2_folder.sh~
│   ├── F2iph.sh
│   ├── F2iph.sh~
│   ├── filecopyimg.sh
│   ├── filecopyimgmultiple.sh
│   ├── filecopyimgmultiple02.sh
│   ├── filecopyimgmultiple03.sh
│   ├── filepath.sh
│   ├── filepathcopy.sh
│   ├── forward_slashes-to-backward_slashes.sh
│   ├── ghostty-launcher.sh
│   ├── heic__jpg.sh
│   ├── heic_jpeg.sh
│   ├── jfif_jpeg.sh
│   ├── jfif_jpeg.sh~
│   ├── jpeg.sh
│   ├── move_files_to_parent.sh
│   ├── png-j.sh
│   ├── png-recursive.ps1
│   ├── psd2jpeg.sh
│   ├── psd_convert.sh
│   ├── psd_jpeg_w_gimp.sh
│   ├── syncthing.sh
│   ├── tiny_vid.sh
│   ├── UTO.sh
│   ├── webloc_jpeg.sh
│   ├── webloc_jpeg_02.sh
│   ├── webloc_jpeg_1.sh
│   ├── webloc_jpeg_1.sh~
│   ├── webp_jpeg.sh
│   ├── X.sh
│   ├── X_all_heic.sh
│   ├── X_all_jfif.sh
│   ├── X_duplicate_images.sh
│   ├── X_duplicates.sh
│   ├── X_text_string.sh
│   ├── Xdoop.sh
│   ├── Xdoop.sh~
│   └── Xdoop_1.sh
├── syncthing.sh
├── syncthing_stop.sh
├── syncthing_stop.sh~
├── tiny_vid_split.sh
├── to_latex.sh
├── to_latex.sh~
├── untar.sh
├── webloc_jpeg.sh
├── X.fish
├── X.fish~
├── X.sh
└── yt-dl.sh
 