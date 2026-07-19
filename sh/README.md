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
