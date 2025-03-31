;;; ready-player.el --- Open media files in ready-player major mode -*- lexical-binding: t; -*-

;; Copyright (C) 2024 Alvaro Ramirez

;; Author: Alvaro Ramirez https://xenodium.com
;; Package-Requires: ((emacs "28.1"))
;; URL: https://github.com/xenodium/ready-player
;; Version: 0.1.1

;; This package is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.

;; This package is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; Support this work https://github.com/sponsors/xenodium
;;
;; `ready-player-mode' is a lightweight media (audio/video) major mode for Emacs.
;;
;; Setup:
;;
;;   (require 'ready-player)
;;   (ready-player-mode)
;;
;; To customize supported media files, set `ready-player-supported-media'
;; before invoking `ready-player-add-to-auto-mode-alist'.
;;
;; `ready-player-mode' relies on command line utilities to play media.
;;  Customize `ready-player-open-playback-commands' to your preference.
;;
;; Note: This is a new package.  Please report issues or send
;; patches to https://github.com/xenodium/ready-player

(require 'cl-lib)
(require 'comint)
(require 'dired)
(require 'seq)
(require 'subr-x)
(require 'text-property-search)

;;; Code:

(defvar ready-player-major-mode-map
  (let ((map (make-sparse-keymap)))
    (set-keymap-parent map special-mode-map)
    (define-key map (kbd "SPC") #'ready-player-toggle-play-stop)
    (define-key map (kbd "TAB") #'ready-player-next-button)
    (define-key map (kbd "<backtab>") #'ready-player-previous-button)
    (define-key map (kbd "n") #'ready-player-next)
    (define-key map (kbd "p") #'ready-player-previous)
    (define-key map (kbd "e") #'ready-player-open-externally)
    (define-key map (kbd "o") #'ready-player-open-externally)
    (define-key map (kbd "q") #'ready-player-quit)
    (define-key map (kbd "g") #'ready-player-toggle-reload-buffer)
    (define-key map (kbd "m") #'ready-player-mark-dired-file)
    (define-key map (kbd "u") #'ready-player-unmark-dired-file)
    (define-key map (kbd "d") #'ready-player-view-dired-playback-buffer)
    map)
  "Keymap for `ready-player'.")

(defgroup ready-player nil
  "Settings for Ready Player mode."
  :group 'media)

(defcustom ready-player-multi-buffer nil
  "When non-nil, enable opening multiple buffers with parallel playback."
  :type 'boolean
  :group 'ready-player)

(defcustom ready-player-show-thumbnail t
  "When non-nil, display file's thumbnail if available."
  :type 'boolean
  :group 'ready-player)

(defcustom ready-player-repeat nil
  "Continue playing if there's more media in current directory.

Repeats and starts over from the beginning of the directory."
  :type 'boolean
  :group 'ready-player)

(defcustom ready-player-autoplay nil
  "When non-nil, automatically start playing when media file opens."
  :type 'boolean
  :group 'ready-player)

(defcustom ready-player-shuffle nil
  "Next media item is selected at random within current directory.

Repeats and starts over from the beginning of the directory."
  :type 'boolean
  :group 'ready-player)

(defcustom ready-player-cache-thumbnails t
  "When non-nil, cache thumbnail."
  :type 'boolean
  :group 'ready-player)

(defcustom ready-player-cache-metadata t
  "When non-nil, cache metadata."
  :type 'boolean
  :group 'ready-player)

(defcustom ready-player-hide-modeline nil
  "If non-nil, hides mode line in buffer.

File information is already displayed in the buffer,
so users can opt to hide the mode line."
  :type 'boolean
  :group 'ready-player)

;; TODO: Find a better way of checking for SF rendeing.
(defun ready-player-displays-as-sf-symbol-p (text)
  "Return t if TEXT can be displayed as macoOS SF symbols.  nil otherwise."
  (let ((result t)
        (displayable)
        (char))
    (dotimes (i (length text))
      (setq char (aref text i))
      (setq displayable (char-displayable-p char))
      (when (or (eq displayable t)
                (not (and (fontp displayable)
                          (string-match-p
                           "SF"
                           (font-get (char-displayable-p char) :name)))))
        (setq result nil)))
    result))

(defcustom ready-player-previous-icon
  (if (ready-player-displays-as-sf-symbol-p "􀊉")
      "􀊉"
    "<<")
  "Previous button icon string, for example: \"<<\"."
  :type 'string
  :group 'ready-player)

(defcustom ready-player-play-icon
  (if (ready-player-displays-as-sf-symbol-p "􀊄")
      "􀊄"
    "⏵")
  "Play button icon string, for example: \"⏵\"."
  :type 'string
  :group 'ready-player)

(defcustom ready-player-next-icon
  (if (ready-player-displays-as-sf-symbol-p "􀊋")
      "􀊋"
    ">>")
  "Next button icon string, for example: \">>\"."
  :type 'string
  :group 'ready-player)

(defcustom ready-player-open-externally-icon
  (if (ready-player-displays-as-sf-symbol-p "􀉐")
      "􀉐"
    "➦")
  "Open externally button icon string, for example: \"➦\"."
  :type 'string
  :group 'ready-player)

(defcustom ready-player-stop-icon
  (if (ready-player-displays-as-sf-symbol-p "􀛷")
      "􀛷"
    "■")
  "Stop icon string, for example: \"■\"."
  :type 'string
  :group 'ready-player)

(defcustom ready-player-repeat-icon
  (if (ready-player-displays-as-sf-symbol-p "􀊞")
      "􀊞"
    "⇆")
  "Repeat icon string, for example: \"⇆\"."
  :type 'string
  :group 'ready-player)

(defcustom ready-player-shuffle-icon
  (if (ready-player-displays-as-sf-symbol-p "􀊝")
      "􀊝"
    "⤮")
  "Shuffle icon string, for example: \"⤮\"."
  :type 'string
  :group 'ready-player)

(defcustom ready-player-autoplay-icon
  (if (ready-player-displays-as-sf-symbol-p "􀋦")
      "􀋦"
    "⚡")
  "Autoplay icon string, for example: \"⚡\"."
  :type 'string
  :group 'ready-player)

(defcustom ready-player-thumbnail-max-pixel-height
  400
  "Maximum thumbnail pixel height."
  :type 'integer
  :group 'ready-player)

(defcustom ready-player-open-playback-commands
  '(("mpv" "--audio-display=no")
    ("vlc")
    ("ffplay")
    ("mplayer"))
  "Command line utilities to try for playback.

Note each entry is a list, in case additional flags are needed.

Omit the file path, as it will be automatically appended."
  :type '(repeat (list string))
  :group 'ready-player)

(defcustom ready-player-display-dired-playback-buffer-display-action
  '((display-buffer-reuse-window
     display-buffer-in-direction)
    (reusable-frames . visible)
    (direction . right)
    (window-width . 0.60))
  "Choose how to display the associated playback `dired' buffer.

Same format as a the action in a `display-buffer-alist' entry."
  :type (plist-get (cdr (get 'display-buffer-alist 'custom-type)) :value-type)
  :group 'ready-player)

(defcustom ready-player-supported-media
  '("3g2" "3gp" "aac" "ac3" "aiff" "amr" "ape" "asf" "asx" "avi"
    "cue" "divx" "drc" "dts" "dvb" "evo" "f4a" "f4b" "f4p" "f4v"
    "flac" "flv" "gif" "gsm" "h264" "h265" "hevc" "isma" "ismv"
    "jspf" "m2ts" "m2v" "m3u" "m3u8" "m4a" "midi" "mjpeg" "mlp"
    "mka" "mkv" "mlp" "mov" "mp2" "mp3" "mp4" "mpg" "mpeg" "mts"
    "mxf" "oga" "ogg" "ogm" "ogv" "opus" "pls" "pva" "qt" "ra"
    "ram" "raw" "rf64" "rm" "rmvb" "sami" "spx" "tta" "vob" "wav"
    "wavpack" "webm" "wma" "wmv" "wpl" "wv" "xspf")
  "Supported media types."
  :group 'play-mode
  :type '(repeat string))

(defvar-local ready-player--process nil "Media-playing process.")

(defvar ready-player--active-buffer nil "Buffer to interact with.")

(defvar-local ready-player--metadata nil "Metadata as per ffprobe.")

(defvar-local ready-player--thumbnail nil "Thumbnail as per ffmpeg.")

(defvar ready-player--last-button-focus 'play-stop
  "Last button focused.

Could be one of:

=next= =previous= =play-stop= =open-externally= =repeat= =shuffle= or
=autoplay.=

Used to remember button position across files in continuous playback.")

(defvar-local ready-player--dired-playback-buffer nil
  "`dired' buffer used when determining next/previous file.")

;;;###autoload
(define-minor-mode ready-player-mode
  "Toggle Ready Player mode media file recognition.

See `ready-player-supported-media' for recognized types."
  :global t
  (let ((called-interactively (called-interactively-p #'interactive)))
    (if ready-player-mode
        (progn
          (ready-player-add-to-auto-mode-alist)
          (when (and called-interactively
                     (string-match-p "no-conversion"
                                     (symbol-name buffer-file-coding-system)))
            (revert-buffer nil t)))
      (ready-player-remove-from-auto-mode-alist)
      (when (and called-interactively
                 (derived-mode-p 'ready-player-major-mode))
        (revert-buffer nil t)))))

;;;###autoload
(defun ready-player-add-to-auto-mode-alist ()
  "Add media recognized by `ready-player-mode'."
  (add-to-list 'auto-mode-alist
               (cons (concat "\\." (regexp-opt ready-player-supported-media t) "\\'")
                     #'ready-player-major-mode))
  ;; Suppress unnecessary buffer loading via file-name-handler-alist.
  (add-to-list
   'file-name-handler-alist
   (cons
    (concat "\\." (regexp-opt (ready-player--supported-media-with-uppercase) t) "\\'")
    #'ready-player-file-name-handler)))

(defun ready-player--supported-media-with-uppercase ()
  "Duplicate `ready-player-supported-media' with uppercase equivalents."
  (append ready-player-supported-media
          ;; Also include uppercase extensions.
          ;; APFS (Apple File System) is case-insensitive.
          (mapcar #'upcase ready-player-supported-media)))

(defun ready-player-remove-from-auto-mode-alist ()
  "Remove media recognized by `ready-player-mode'."
  (setq auto-mode-alist
        (seq-remove (lambda (entry)
                      (and (symbolp (cdr entry))
                           (string-match "ready-player-major-mode" (symbol-name (cdr entry)))))
                    auto-mode-alist))
  (setq file-name-handler-alist
        (seq-remove (lambda (entry)
                      (equal #'ready-player-file-name-handler (cdr entry)))
                    file-name-handler-alist)))

(defun ready-player-file-name-handler (operation &rest args)
  "Suppress `insert-file-contents' OPERATION with ARGS.

`ready-player-mode' doesn't need to load files into the buffer.

Note: This function needs to be added to `file-name-handler-alist'."
  (pcase operation
    ('insert-file-contents
     (cl-destructuring-bind (filename visit _beg _end _replace) args
       (when visit
         (setq buffer-file-name filename))
       (list buffer-file-name (point-max))))
    ('file-attributes
     (let* ((file-name-handler-alist nil)
	    (attributes (apply #'file-name-non-special
                               (append (list operation) args))))
       ;; 7 is file size location
       ;; as per `file-attributes'.
       (setf (nth 7 attributes) 0)
       attributes))
    (_ (let ((inhibit-file-name-handlers
              (cons #'ready-player-file-name-handler
                    (and (eq inhibit-file-name-operation operation)
                         inhibit-file-name-handlers)))
             (inhibit-file-name-operation operation))
         (apply operation args)))))

(define-derived-mode ready-player-major-mode special-mode "Ready Player"
  "Major mode to preview and play media files."
  :after-hook (progn
                (unless ready-player-multi-buffer
                  (let ((buffer (current-buffer)))
                    ;; Execute after current run loop to allow `find-file' completion.
                    (run-at-time 0.1 nil
                                 (lambda ()
                                   (ready-player--keep-only-this-buffer buffer)))))
               (when ready-player-autoplay
                  (ready-player--start-playback-process))
                (ready-player--goto-button ready-player--last-button-focus))
  :keymap ready-player-major-mode-map
  (set-buffer-multibyte t)
  (setq buffer-read-only t)
  (setq buffer-undo-list t)
  (when ready-player-hide-modeline
    (setq mode-line-format nil))

  (let* ((buffer (current-buffer))
         (fpath (buffer-file-name))
         (cached-metadata (ready-player--cached-metadata fpath))
         (local-thumbnail (ready-player--local-thumbnail-in-directory default-directory))
         (cached-thumbnail (or (ready-player--cached-thumbnail fpath)
                               local-thumbnail))
         (cached-dired-buffer (ready-player--resolve-file-dired-buffer fpath))
         (thumbnailer (if (executable-find "ffmpegthumbnailer")
                          #'ready-player--load-file-thumbnail-via-ffmpegthumbnailer
                        #'ready-player--load-file-thumbnail-via-ffmpeg)))
    (ready-player--update-buffer-name buffer nil)
    ;; Sets default related dired buffer.
    (if cached-dired-buffer
        (setq ready-player--dired-playback-buffer
              cached-dired-buffer)
      (setq ready-player--dired-playback-buffer
            (find-file-noselect default-directory)))
    (setq ready-player--active-buffer buffer)
    (ready-player--update-buffer buffer fpath
                                 ready-player--process
                                 ready-player-repeat
                                 ready-player-shuffle
                                 ready-player-autoplay)
    (if cached-thumbnail
        (progn
          (setq ready-player--thumbnail cached-thumbnail)
          (ready-player--update-buffer
           buffer fpath
           ready-player--process
           ready-player-repeat
           ready-player-shuffle
           ready-player-autoplay
           cached-thumbnail ready-player--metadata))
      (funcall thumbnailer
               fpath (lambda (thumbnail)
                       (when (buffer-live-p buffer)
                         (with-current-buffer buffer
                           (when thumbnail
                             (setq ready-player--thumbnail thumbnail)
                             (ready-player--update-buffer
                              buffer fpath
                              ready-player--process
                              ready-player-repeat
                              ready-player-shuffle
                              ready-player-autoplay
                              thumbnail ready-player--metadata)
                             (ready-player--goto-button
                              ready-player--last-button-focus)))))))

    ;; Also attempt to extract embedded thumbnail to give it preference if found.
    (when local-thumbnail
      (funcall thumbnailer
               fpath (lambda (thumbnail)
                       (when (buffer-live-p buffer)
                         (with-current-buffer buffer
                           (when thumbnail
                             (setq ready-player--thumbnail thumbnail)
                             (ready-player--update-buffer
                              buffer fpath
                              ready-player--process
                              ready-player-repeat
                              ready-player-shuffle
                              ready-player-autoplay
                              thumbnail ready-player--metadata)
                             (ready-player--goto-button
                              ready-player--last-button-focus)))))))

    (if cached-metadata
        (progn
          (setq ready-player--metadata cached-metadata)
          (ready-player--update-buffer
           buffer fpath
           ready-player--process
           ready-player-repeat
           ready-player-shuffle
           ready-player-autoplay
           cached-thumbnail ready-player--metadata))
      (ready-player--load-file-metadata
       fpath (lambda (metadata)
               (when (buffer-live-p buffer)
                 (with-current-buffer buffer
                   (when metadata
                     (setq ready-player--metadata metadata)
                     (ready-player--update-buffer
                      buffer fpath
                      ready-player--process
                      ready-player-repeat
                      ready-player-shuffle
                      ready-player-autoplay
                      ready-player--thumbnail metadata)
                     (ready-player--goto-button
                      ready-player--last-button-focus))))))))
  (add-hook 'kill-buffer-hook #'ready-player--clean-up nil t))

(defun ready-player--update-buffer (buffer fpath busy repeat shuffle autoplay &optional thumbnail metadata)
  "Update entire BUFFER content.

Render state from FPATH BUSY REPEAT SHUFFLE AUTOPLAY THUMBNAIL and METADATA."
  (save-excursion
    (let ((fname (file-name-nondirectory fpath))
          (buffer-read-only nil))
      (when (buffer-live-p buffer)
        (with-current-buffer buffer
          (erase-buffer)
          (goto-char (point-min))
          (when (and ready-player-show-thumbnail thumbnail)
            (let ((inhibit-read-only t))
              (when thumbnail
                (insert "\n ")
                (insert-image (create-image
                               thumbnail nil nil
                               :max-height ready-player-thumbnail-max-pixel-height))
                (insert "\n"))
              (set-buffer-modified-p nil)))
          (insert "\n")
          (insert (format " %s" (propertize fname 'face 'info-title-2)))
          (insert " ")
          (insert (propertize "(playing)"
                              'face `(:foreground ,(face-foreground 'font-lock-comment-face) :inherit info-title-2)
                              'invisible (not busy)
                              'playing-status t))
          (insert "\n")
          (insert "\n")
          (insert (ready-player--make-file-button-line busy repeat
                                                       shuffle autoplay))
          (insert "\n")
          (insert "\n")
          (when metadata
            (insert (ready-player--format-metadata-rows
                     (ready-player--make-metadata-rows metadata))))
          (set-buffer-modified-p nil))))))

(defun ready-player--make-metadata-mp3-rows (metadata)
  "Make METADATA row data from an mp3 file."
  (let ((metadata-rows))
    (let-alist metadata
      (when .format.tags.title
        (setq metadata-rows
              (append metadata-rows
                      (list
                       (list (cons 'label "Title:")
                             (cons 'value .format.tags.title))))))
      (when .format.tags.artist
        (setq metadata-rows
              (append metadata-rows
                      (list
                       (list (cons 'label "Artist:")
                             (cons 'value .format.tags.artist))))))
      (when .format.tags.album
        (setq metadata-rows
              (append metadata-rows
                      (list
                       (list (cons 'label "Album:")
                             (cons 'value .format.tags.album)))))))
    metadata-rows))

(defun ready-player--make-metadata-core-rows (metadata)
  "Make core METADATA row data."
  (let ((metadata-rows))
    (let-alist metadata
      (when .format.format_long_name
        (setq metadata-rows
              (append metadata-rows
                      (list
                       (list (cons 'label "Format:")
                             (cons 'value .format.format_long_name))))))
      (when .format.duration
        (setq metadata-rows
              (append metadata-rows
                      (list
                       (list (cons 'label "Duration:")
                             (cons 'value (ready-player--format-duration .format.duration)))))))
      (when .format.size
        (setq metadata-rows
              (append metadata-rows
                      (list
                       (list (cons 'label "Size:")
                             (cons 'value (ready-player--readable-size .format.size))))))))))

(defun ready-player--make-metadata-ogg-rows (metadata)
  "Make METADATA row data from an ogg file."
  (let ((metadata-rows)
        (stream))
    (let-alist metadata
      (setq stream (seq-first .streams))
      (let-alist stream
        (when (or .tags.title .tags.TITLE)
          (setq metadata-rows
                (append metadata-rows
                        (list
                         (list (cons 'label "Title:")
                               (cons 'value (or .tags.title .tags.TITLE)))))))
        (when (or .tags.artist .tags.ARTIST)
          (setq metadata-rows
                (append metadata-rows
                        (list
                         (list (cons 'label "Artist:")
                               (cons 'value (or .tags.artist .tags.ARTIST)))))))
        (when (or .tags.album .tags.ALBUM)
          (setq metadata-rows
                (append metadata-rows
                        (list
                         (list (cons 'label "Album:")
                               (cons 'value (or .tags.album .tags.ALBUM)))))))))))

(defun ready-player--make-metadata-rows (metadata)
  "Make METADATA row data."
  (let ((metadata-rows))
    (setq metadata-rows
          (append metadata-rows
                  (ready-player--make-metadata-mp3-rows metadata)))
    (setq metadata-rows
          (append metadata-rows
                  (ready-player--make-metadata-ogg-rows metadata)))
    (setq metadata-rows
          (append metadata-rows
                  (ready-player--make-metadata-core-rows metadata)))
    metadata-rows))

(defun ready-player--goto-button (button)
  "Goto BUTTON (see \=`ready-player--last-button-focus'\= for values)."
  (ready-player--ensure-mode)
  (when-let* ((match (save-excursion
                       (goto-char (point-min))
                       (text-property-search-forward 'button button)))
              (button-pos (prop-match-end match)))
    (if-let ((window (get-buffer-window (current-buffer))))
        ;; Attempt to focus unfocused window so point actually moves.
        (with-selected-window window
          (goto-char button-pos))
      (goto-char button-pos))))

(defun ready-player-next-button ()
  "Navigate to next button."
  (interactive)
  (ready-player--ensure-mode)
  (if-let ((result (text-property-search-forward 'button nil nil t)))
      (progn
        (goto-char (prop-match-beginning result))
        (setq ready-player--last-button-focus
              (or (get-text-property (point) 'button)
                  ready-player--last-button-focus)))
    (goto-char (point-min))
    (ready-player-next-button)))

(defmacro ready-player--with-buffer-focused (buffer &rest body)
  "Like `with-current-buffer' executing BODY with BUFFER and WINDOW focused."
  `(with-current-buffer ,buffer
     (if-let ((win (get-buffer-window ,buffer)))
         (with-selected-window win
           ,@body)
       ,@body)))

(defun ready-player-previous-button ()
  "Navigate to previous button."
  (interactive)
  (ready-player--ensure-mode)
  (if-let ((result (text-property-search-backward 'button)))
      (setq ready-player--last-button-focus
            (or (get-text-property (point) 'button)
                ready-player--last-button-focus))
    (goto-char (point-max))
    (ready-player-previous-button)))

(defun ready-player-quit ()
  "Quit `ready-player-major-mode' window and kill buffer."
  (interactive)
  (ready-player--ensure-mode)
  (quit-window t))

;; Based on `crux-open-with'.
(defun ready-player-open-externally (arg)
  "Open visited file in default external program.
When in `dired' mode, open file under the cursor.

With a prefix ARG always prompt for command to use."
  (interactive "P")
  (ready-player--ensure-mode)
  (ready-player-stop)
  (let* ((current-file-name
          (if (derived-mode-p 'dired-mode)
              (dired-get-file-for-visit)
            buffer-file-name))
         (open (pcase system-type
                 (`darwin "open")
                 ((or `gnu `gnu/linux `gnu/kfreebsd) "xdg-open")))
         (program (if (or arg (not open))
                      (read-shell-command "Open current file with: ")
                    open)))
    (call-process program nil 0 nil current-file-name)))

(defun ready-player-previous (&optional n)
  "Open the previous media file in the same directory.

With optional argument N, visit the Nth file before the current one."
  (interactive "p" ready-player)
  (with-current-buffer (ready-player--active-buffer)
    (ready-player--open-file-at-offset (- n) t)))

(defun ready-player-next (&optional n)
  "Open the next media file in the same directory.

With optional argument N, visit the Nth file after the current one."
  (interactive "p" ready-player)
  (with-current-buffer (ready-player--active-buffer)
    (ready-player--open-file-at-offset n t)))

(defun ready-player--open-file (fpath buffer start-playing)
  "Open file at FPATH in BUFFER.

If START-PLAYING is non-nil, start playing the media file."
  (let ((old-buffer buffer)
        ;; Auto-played files should not be added to recentf.
        ;; Temporarily override `recentf-exclude'.
        (new-buffer (let ((recentf-exclude (list (concat (regexp-quote (file-name-nondirectory fpath)) "\\'"))))
                      (ignore recentf-exclude)
                      (find-file-noselect fpath))))
    (with-current-buffer new-buffer
      (when (get-buffer-window-list old-buffer nil t)
        (set-window-buffer (car (get-buffer-window-list old-buffer nil t)) new-buffer))
      (unless (eq new-buffer old-buffer)
        (kill-buffer old-buffer))
      (when start-playing
        (ready-player--start-playback-process)))
    new-buffer))

(defun ready-player--open-file-at-offset (n feedback)
  "Open the next media file in the same directory.

With optional argument N offset, visit the Nth file after the current
one.  Negative values move backwards.

With FEEDBACK, provide user feedback of the interaction."
  (interactive "p" ready-player)
  (ready-player--ensure-mode)
  (when feedback
    (ready-player--goto-button (if (> n 0) 'next 'previous))
    (setq ready-player--last-button-focus (if (> n 0) 'next 'previous)))

  (let* ((sticky-dired-buffer (ready-player--dired-playback-buffer))
         (playing ready-player--process)
         (new-file (or (ready-player--next-dired-file-from
                        buffer-file-name n nil ready-player-shuffle sticky-dired-buffer)
                       (when ready-player-repeat
                         (ready-player--next-dired-file-from
                          buffer-file-name n t ready-player-shuffle sticky-dired-buffer))))
         (new-buffer))
    (if new-file
        (progn
          (setq new-buffer (ready-player--open-file new-file (current-buffer) playing))
          (with-current-buffer new-buffer
            (setq ready-player--dired-playback-buffer sticky-dired-buffer)))
      (if playing
          (progn
            (message "No more media to play"))
        (message "No more media")))
    new-file))


(defun ready-player--dired-playback-buffer ()
  "Resolve the associated `dired' buffer, creating it if needed."
  (ready-player--ensure-mode)
  (cond ((and ready-player--dired-playback-buffer
              (buffer-live-p ready-player--dired-playback-buffer))
         ;; Dired set in buffer?
         ready-player--dired-playback-buffer)
        ((and ready-player--active-buffer
              (buffer-live-p ready-player--active-buffer)
              (buffer-local-value 'ready-player--dired-playback-buffer
                                  ready-player--active-buffer)
              (buffer-live-p (buffer-local-value 'ready-player--dired-playback-buffer
                                                 ready-player--active-buffer)))
         ;; Dired set in active buffer?
         (setq ready-player--dired-playback-buffer
               (buffer-local-value 'ready-player--dired-playback-buffer
                                   ready-player--active-buffer))
         ready-player--dired-playback-buffer)
        (t
         ;; Fall back to dired in current directory.
         (setq ready-player--dired-playback-buffer
               (find-file-noselect (file-name-directory (buffer-file-name))))
         ready-player--dired-playback-buffer)))

;; Based on `image-next-file'.
(defun ready-player--next-dired-file-from (file offset &optional from-top random dired-buffer)
  "Get the next available file from a `dired' buffer.

`dired' buffers are either derived from `file' or function
`ready-player--dired-playback-buffer'.

Start at the FILE's location in buffer and move to OFFSET.
If FROM-TOP is non-nil, offset is from top of the buffer.

With RANDOM set, choose next file at random.

Override DIRED-BUFFER, otherwise resolve internally."
  (let* ((regexp (regexp-opt (ready-player--supported-media-with-uppercase) t))
         (dired-buffers  (if (or dired-buffer (ready-player--dired-playback-buffer))
                             (list (or dired-buffer (ready-player--dired-playback-buffer)))
                           (when-let ((non-nil file)
                                      ;; Auto-played files should not be added to recentf.
                                      ;; Temporarily override `recentf-exclude'.
                                      (recentf-exclude (list (concat (regexp-quote (file-name-nondirectory file)) "\\'"))))
                             (ignore recentf-exclude)
                             (find-file-noselect (file-name-directory file))
                             (dired-buffers-for-dir (file-name-directory file)))))
         (next))
    ;; Move point in all relevant dired buffers.
    (dolist (buffer dired-buffers)
      (ready-player--with-buffer-focused
       buffer
       (if random
           (progn
             (goto-char (point-min))
             ;; Goto random line.
             (forward-line (+ (point-min)
                              (random (count-lines (point-min)
                                                   (point-max))))))
         (if (or from-top (not file))
             (goto-char (point-min))
           (dired-goto-file file)))
       (let (found)
         (while (and (not found)
                     (if (> offset 0)
                         (not (eobp))
                       (not (bobp))))
           (dired-next-line offset)
           ;; Ensure (eobp) or (bobp) are reached.
           (if (> offset 0)
               (end-of-line)
             (beginning-of-line))
           (when-let* ((candidate (dired-get-filename nil t))
                       (extension (file-name-extension candidate))
                       (match-p (string-match-p regexp extension)))
             (setq found candidate)))
         (if found
             (progn
               (setq next found)
               (forward-line 0))
           ;; No next match. Restore point.
           (when file
             (dired-goto-file file))))))
    next))

;; Based on `image-mode-mark-file'.
(defun ready-player-mark-dired-file ()
  "Mark the current file in the appropriate `dired' buffer(s)."
  (interactive nil ready-player-major-mode)
  (unless buffer-file-name
    (user-error "No media file in this buffer"))
  (if-let* ((file buffer-file-name)
            (marked-buffer
             (ready-player--apply-dired-function
              #'dired-mark file)))
      (progn
        (switch-to-buffer-other-window marked-buffer)
        (dired-goto-file file))
    (message "Couldn't find file to mark")))

;; Based on `image-mode-unmark-file'.
(defun ready-player-unmark-dired-file ()
  "Unmark the current file in the appropriate `dired' buffer(s)."
  (interactive nil ready-player-major-mode)
  (unless buffer-file-name
    (user-error "No media file in this buffer"))
  (if-let* ((file buffer-file-name)
            (marked-buffer
             (ready-player--apply-dired-function
              #'dired-unmark file)))
      (progn
        (switch-to-buffer-other-window marked-buffer)
        (dired-goto-file file))
    (message "Couldn't find file to unmark")))

(defun ready-player--apply-dired-function (function file)
  "Apply `dired' FUNCTION to FILE."
  (let* ((dir (file-name-directory file))
         (found)
	 (buffers (append
                   (seq-filter (lambda (buffer)
                                 (with-current-buffer buffer
                                   (and (derived-mode-p 'dired-mode)
                                        (equal (file-truename dir)
                                               (file-truename default-directory)))))
                               (dired-buffers-for-dir dir))
                   (list (ready-player--dired-playback-buffer)))))
    (unless buffers
      (save-excursion
        (setq buffers (list (find-file-noselect dir)))))
    (mapc
     (lambda (buffer)
       (with-current-buffer buffer
	 (when (dired-goto-file file)
	   (funcall function 1)
           (setq found buffer)))) buffers)
    found))

(defun ready-player-stop ()
  "Stop media playback."
  (interactive)
  (with-current-buffer (ready-player--active-buffer)
    (setq ready-player--last-button-focus 'play-stop)
    (ready-player--stop-playback-process))
  (message "Stopped")
  (run-with-timer 3 nil
                  (lambda ()
                    (message ""))))

(defun ready-player-play ()
  "Start media playback."
  (interactive)
  (with-current-buffer (ready-player--active-buffer)
    (setq ready-player--last-button-focus 'play-stop)
    (ready-player--start-playback-process)))

(defun ready-player--ensure-mode ()
  "Ensure current buffer is running in `ready-player-major-mode'."
  (unless (derived-mode-p 'ready-player-major-mode)
    (user-error "Not in a ready-player-major-mode buffer (%s)" major-mode)))

(defun ready-player--stop-playback-process ()
  "Stop playback process."
  ;; Only kill the process.
  ;; The process sentinel updates the buffer status.
  (when ready-player--process
    (let ((buffer (process-buffer ready-player--process)))
      (delete-process ready-player--process)
      (kill-buffer buffer))
    (setq ready-player--process nil)))

(defun ready-player--start-playback-process ()
  "Start playback process."
  (ready-player--ensure-mode)
  (ready-player--stop-playback-process)
  (when-let* ((fpath (buffer-file-name))
              (command (append
                        (list (format "*ready player mode '%s'*" (file-name-nondirectory fpath))
                              (ready-player--playback-process-buffer fpath))
                        (ready-player--playback-command) (list fpath)))
              (buffer (current-buffer)))
    (setq ready-player--process (apply #'start-process
                                       command))
    (set-process-query-on-exit-flag ready-player--process nil)
    (ready-player--refresh-buffer-status
     buffer
     ready-player--process
     ready-player-repeat
     ready-player-shuffle
     ready-player-autoplay)
    (set-process-sentinel
     ready-player--process
     (lambda (process _)
       (when (and (memq (process-status process) '(exit signal))
                  (buffer-live-p buffer))
         (with-current-buffer buffer
           (if (and ready-player-repeat
                    (eq (process-exit-status process) 0))
               (unless (ready-player--open-file-at-offset 1 nil)
                 (ready-player--refresh-buffer-status
                  buffer
                  ready-player--process
                  ready-player-repeat
                  ready-player-shuffle
                  ready-player-autoplay))
             (setq ready-player--process nil)
             (ready-player--refresh-buffer-status
              buffer
              ready-player--process
              ready-player-repeat
              ready-player-shuffle
              ready-player-autoplay))))))
    (set-process-filter ready-player--process #'comint-output-filter)))

(defun ready-player-toggle-play-stop ()
  "Toggle play/stop of media."
  (interactive)
  (with-current-buffer (ready-player--active-buffer)
    (ready-player--goto-button 'play-stop)
    (if-let ((fpath (buffer-file-name)))
        (if ready-player--process
            (ready-player-stop)
          (ready-player-play))
      (error "No file to play/stop"))))

(defun ready-player-toggle-modeline ()
  "Toggle displaying the mode line."
  (interactive)
  (ready-player--ensure-mode)
  (if mode-line-format
      (progn
        (setq mode-line-format nil)
        (setq ready-player-hide-modeline t))
    (setq mode-line-format (default-value 'mode-line-format))
    (setq ready-player-hide-modeline nil)))

(defun ready-player-toggle-repeat ()
  "Toggle repeat setting."
  (interactive)
  (setq ready-player-repeat (not ready-player-repeat))
  (when-let ((buffer (ready-player--active-buffer)))
    (ready-player--refresh-buffer-status
     buffer
     ready-player--process
     ready-player-repeat
     ready-player-shuffle
     ready-player-autoplay))
  (message "Repeat: %s" (if ready-player-repeat
                            "ON"
                          "OFF"))
  (run-with-timer 1 nil
                  (lambda ()
                    (message ""))))

(defun ready-player-toggle-shuffle ()
  "Toggle shuffle setting."
  (interactive)
  (setq ready-player-shuffle (not ready-player-shuffle))
  (when-let ((buffer (ready-player--active-buffer)))
    (ready-player--refresh-buffer-status
     buffer
     ready-player--process
     ready-player-repeat
     ready-player-shuffle
     ready-player-autoplay))
  (message "Shuffle: %s" (if ready-player-shuffle
                            "ON"
                          "OFF"))
  (run-with-timer 1 nil
                  (lambda ()
                    (message ""))))

(defun ready-player-toggle-autoplay ()
  "Toggle autoplay setting."
  (interactive)
  (setq ready-player-autoplay (not ready-player-autoplay))
  (when-let ((buffer (ready-player--active-buffer)))
    (ready-player--refresh-buffer-status
     buffer
     ready-player--process
     ready-player-repeat
     ready-player-shuffle
     ready-player-autoplay))
  (message "Autoplay: %s" (if ready-player-autoplay
                            "ON"
                          "OFF"))
  (run-with-timer 1 nil
                  (lambda ()
                    (message ""))))

(defun ready-player-toggle-reload-buffer ()
  "Reload media from file."
  (interactive)
  (ready-player--ensure-mode)
  (when (equal ready-player--thumbnail
               (ready-player--cached-thumbnail-path buffer-file-name))
    (condition-case nil
        (delete-file ready-player--thumbnail)
      (file-error nil)))
  (when (equal ready-player--metadata
               (ready-player--cached-metadata-path buffer-file-name))
    (condition-case nil
        (delete-file ready-player--metadata)
      (file-error nil)))
  (let ((playing ready-player--process))
    (ready-player--stop-playback-process)
    (revert-buffer nil t)
    (when playing
      (ready-player-play)))
  (message "Reloaded")
  (run-with-timer 1 nil
                  (lambda ()
                    (message ""))))

(defun ready-player--playback-command ()
  "Craft a playback command from the first utility found on system."
  (if-let ((command (seq-find (lambda (command)
                                (when (seq-first command)
                                  (executable-find (seq-first command))))
                              ready-player-open-playback-commands)))
      command
    (user-error "No player found: %s"
                (mapconcat
                 #'identity (seq-map #'seq-first ready-player-open-playback-commands) " "))))

(defun ready-player--make-file-button-line (busy repeat shuffle autoplay)
  "Create button line with BUSY, REPEAT, AUTOPLAY, and SHUFFLE."
  (format " %s %s %s %s %s %s %s"
          (ready-player--make-button ready-player-previous-icon
                                     'previous
                                     #'ready-player-previous)
          (ready-player--make-button (if busy
                                         ready-player-stop-icon
                                       ready-player-play-icon)
                                     'play-stop
                                     #'ready-player-toggle-play-stop)
          (ready-player--make-button ready-player-next-icon
                                     'next
                                     #'ready-player-next)
          (ready-player--make-button ready-player-open-externally-icon
                                     'open-externally
                                     #'ready-player-open-externally)
          (ready-player--make-checkbox-button ready-player-repeat-icon repeat
                                              'repeat
                                              #'ready-player-toggle-repeat)
          (ready-player--make-checkbox-button ready-player-shuffle-icon shuffle
                                              'shuffle
                                              #'ready-player-toggle-shuffle)
          (ready-player--make-checkbox-button ready-player-autoplay-icon autoplay
                                              'autoplay
                                              #'ready-player-toggle-autoplay)))

(defun ready-player--make-checkbox-button (text checked kind action)
  "Make a checkbox button with TEXT, CHECKED state, KIND, and ACTION."
  (propertize
   (format "%s%s"
           text
           (if checked
               "*"
             ""))
   'pointer 'hand
   'keymap (let ((map (make-sparse-keymap)))
             (define-key map [mouse-1] action)
             (define-key map (kbd "RET") action)
             (define-key map [remap self-insert-command] 'ignore)
             map)
   'button kind))

(defun ready-player--make-button (text kind action)
  "Make button with TEXT, KIND, and ACTION."
  (propertize
   (format " %s " text)
   ;; TODO: Investigate why 'face is not enough.
   'font-lock-face '(:box t)
   'pointer 'hand
   'keymap (let ((map (make-sparse-keymap)))
             (define-key map [mouse-1] action)
             (define-key map (kbd "RET") action)
             (define-key map [remap self-insert-command] 'ignore)
             map)
   'button kind))

(defun ready-player--update-buffer-name (buffer busy)
  "Rename BUFFER reflecting if BUSY playing."
  (with-current-buffer buffer
    (let ((base-name (string-remove-prefix "ready-player: "
                                           (string-remove-suffix " (playing)" (string-trim (buffer-name))))))
      (rename-buffer (if busy
                         (concat "ready-player: " base-name " (playing)")
                       (concat "ready-player: " base-name))))))

(defun ready-player--refresh-buffer-status (buffer busy repeat shuffle autoplay)
  "Refresh and render status in buffer in BUFFER.

Render FNAME, BUSY, REPEAT, SHUFFLE, and AUTOPLAY."
  (when-let ((inhibit-read-only t)
             (saved-point (point))
             (live-buffer (buffer-live-p buffer)))
    (with-current-buffer buffer
      (save-excursion
        (goto-char (point-min))

        ;; Toggle (playing) next to file name.
        (when-let* ((match (text-property-search-forward 'playing-status))
                    (start (prop-match-beginning match))
                    (end (prop-match-end match)))
          (if busy
              (remove-text-properties start end '(invisible t))
            (add-text-properties start end '(invisible t))))

        (goto-char (point-min))

        (when (text-property-search-forward 'button)
          (delete-region (line-beginning-position) (line-end-position))
          (insert (ready-player--make-file-button-line busy repeat shuffle autoplay))))
      (goto-char saved-point)

      (ready-player--update-buffer-name buffer busy)

      (set-buffer-modified-p nil))))

(defun ready-player--cached-thumbnail-path (fpath)
  "Generate thumbnail path for media at FPATH."
  (ready-player--cached-item-path-for fpath ".png"))

(defun ready-player--cached-metadata-path (fpath)
  "Generate thumbnail path for media at FPATH."
  (ready-player--cached-item-path-for fpath ".json"))

(defun ready-player--cached-item-path-for (fpath suffix)
  "Generate cached item path for media at FPATH, appending SUFFIX."
  (let* ((temp-dir (concat (file-name-as-directory temporary-file-directory) "ready-player"))
         (temp-fpath (concat (file-name-as-directory temp-dir)
                             (md5 fpath) suffix)))
    (make-directory temp-dir t)
    temp-fpath))

(defun ready-player--load-file-thumbnail-via-ffmpegthumbnailer (media-fpath on-loaded)
  "Load media thumbnail at MEDIA-FPATH and invoke ON-LOADED.

Note: This needs the ffmpegthumbnailer command line utility."
  (if (executable-find "ffmpegthumbnailer")
      (let* ((thumbnail-fpath (ready-player--cached-thumbnail-path media-fpath)))
        (make-process
         :name "ffmpegthumbnailer-process"
         :buffer (get-buffer-create "*ffmpegthumbnailer-output*")
         :command (list "ffmpegthumbnailer" "-i" media-fpath "-s" "0" "-m" "-o" thumbnail-fpath)
         :sentinel
         (lambda (process _)
           (if (eq (process-exit-status process) 0)
               (funcall on-loaded thumbnail-fpath)
             (condition-case nil
                 (delete-file thumbnail-fpath)
               (file-error nil))))))
    (message "Metadata not available (ffmpegthumbnailer not found)")))

(defun ready-player--cached-thumbnail (fpath)
  "Get cached thumbnail for media at FPATH."
  (let ((cache-fpath (ready-player--cached-thumbnail-path fpath)))
    (when (and (file-exists-p cache-fpath)
               (> (file-attribute-size (file-attributes cache-fpath)) 0))
      cache-fpath)))

(defun ready-player--local-thumbnail-in-directory (dir)
  "Return local thumbnail if found in DIR."
  (let ((candidates '("cover.jpg" "cover.png"
                      "front.jpg" "front.png"
                      "folder.jpg" "folder.png"
                      "album.jpg" "album.png"
                      "artwork.jpg" "artwork.png"))
        thumbnail)
    (catch 'found
      (dolist (candidate candidates)
        (setq candidate (expand-file-name candidate dir))
        (when (and (file-exists-p candidate)
                   (> (file-attribute-size (file-attributes candidate)) 0))
          (setq thumbnail candidate)
          (throw 'found thumbnail))))
    thumbnail))

(defun ready-player--cached-metadata (fpath)
  "Get cached thumbnail for media at FPATH."
  (let ((cache-fpath (ready-player--cached-metadata-path fpath)))
    (when (and (file-exists-p cache-fpath)
               (> (file-attribute-size (file-attributes cache-fpath)) 0))
      (with-temp-buffer
        (insert-file-contents cache-fpath)
        (goto-char (point-min))
        (json-parse-buffer :object-type 'alist)))))

(defun ready-player--load-file-thumbnail-via-ffmpeg (media-fpath on-loaded)
  "Load media thumbnail at MEDIA-FPATH and invoke ON-LOADED.

Note: This needs the ffmpeg command line utility."
  (if (executable-find "ffmpeg")
      (let* ((thumbnail-fpath (ready-player--cached-thumbnail-path media-fpath)))
        (make-process
         :name "ffmpeg-process"
         :buffer (get-buffer-create "*ffmpeg-output*")
         :command (list "ffmpeg" "-i" media-fpath "-vf" "thumbnail" "-frames:v" "1" thumbnail-fpath)
         :sentinel
         (lambda (process _)
           (if (eq (process-exit-status process) 0)
               (funcall on-loaded thumbnail-fpath)
             (condition-case nil
                 (delete-file thumbnail-fpath)
               (file-error nil))))))
    (message "Metadata not available (ffmpeg not found)")))

(defun ready-player--load-file-metadata (fpath on-loaded)
  "Load media metadata at FPATH and invoke ON-LOADED."
  (if (executable-find "ffprobe")
      (when-let* ((buffer (generate-new-buffer "*ffprobe-output*"))
                  (buffer-live (buffer-live-p buffer))
                  (metadata-fpath (ready-player--cached-metadata-path fpath)))
        (with-current-buffer buffer
          (erase-buffer))
        (make-process
         :name "ffprobe-process"
         :buffer buffer
         :command (list "ffprobe" "-v" "quiet" "-print_format" "json" "-show_format" "-show_streams" fpath)
         :sentinel
         (lambda (process _)
           (condition-case _
               (when (and (eq (process-exit-status process) 0)
                          (buffer-live-p (process-buffer process)))
                 (with-current-buffer (process-buffer process)
                   ;; Using write-region to avoid "Wrote" echo message.
                   (write-region (point-min) (point-max) metadata-fpath nil 'noprint)
                   (goto-char (point-min))
                   (funcall on-loaded (json-parse-buffer :object-type 'alist))))
             (error nil))
           (kill-buffer (process-buffer process)))))
    (message "Metadata not available (ffprobe not found)")))

(defun ready-player--playback-process-buffer (fpath)
  "Get the process playback buffer for FPATH."
  (when-let* ((buffer (get-buffer-create
                       (format "*%s %s* (ready-player)"
                               (nth 0 (ready-player--playback-command))
                               (file-name-nondirectory fpath))))
              (buffer-live (buffer-live-p buffer)))
    (with-current-buffer buffer
      (let ((inhibit-read-only t))
        (erase-buffer))
      (comint-mode))
    buffer))

(defun ready-player--format-metadata-rows (rows)
  "Format metadata ROWS for rendering."
  (if rows
      (let ((max-label-length (+ 1 (apply #'max (mapcar (lambda (row) (length (cdr (assoc 'label row)))) rows)))))
        (mapconcat (lambda (row)
                     (let ((label (cdr (assoc 'label row)))
                           (value (cdr (assoc 'value row))))
                       (format " %s%s %s\n\n"
                               (propertize label 'face 'font-lock-comment-face)
                               (make-string (- max-label-length (length label)) ?\s)
                               value)))
                   rows))
    ""))

(defun ready-player--format-duration (duration)
  "Format DURATION in a human-readable format."
  (setq duration (string-to-number duration))
  (let* ((hours   (/ duration 3600))
         (minutes (/ (mod duration 3600) 60))
         (seconds (mod duration 60)))
    (format "%d:%02d:%02d" hours minutes seconds)))

(defun ready-player--readable-size (size)
  "Format SIZE in a human-readable format."
  (setq size (string-to-number size))
  (cond
   ((> size (* 1024 1024 1024))
    (format "%.2f GB" (/ (float size) (* 1024 1024 1024))))
   ((> size (* 1024 1024))
    (format "%.2f MB" (/ (float size) (* 1024 1024))))
   ((> size 1024)
    (format "%.2f KB" (/ (float size) 1024)))
   (t
    (format "%d bytes" size))))

(defun ready-player-view-dired-playback-buffer ()
  "View associated `dired' playback buffer."
  (interactive)
  (ready-player--ensure-mode)
  (display-buffer (ready-player--dired-playback-buffer)
                  ready-player-display-dired-playback-buffer-display-action)
  (switch-to-buffer-other-window (ready-player--dired-playback-buffer)))

(defun ready-player-load-dired-playback-buffer ()
  "Open a `dired' buffer.

`dired' buffers typically show a directory's content, but they can
also show the output of a shell command.  For example, `find-dired'.

`ready-player-load-dired-playback-buffer' can open any `dired' buffer for
playback."
  (interactive)
  (let* ((candidates (seq-map
                      (lambda (buffer)
                        (buffer-name buffer))
                      (seq-filter (lambda (buffer)
                                    (with-current-buffer buffer
                                      (derived-mode-p 'dired-mode)))
                                  (buffer-list))))
         (dired-buffer (if (seq-empty-p candidates)
                           (error "No `dired' buffers available")
                         (completing-read "Open 'dired' buffer: " candidates nil t)))
         (media-file (if (buffer-live-p (get-buffer dired-buffer))
                         (ready-player--next-dired-file-from
                          nil 1 t ready-player-shuffle (get-buffer dired-buffer))
                       (error "dired buffer not found")))
         (media-buffer (if media-file
                           (find-file-noselect media-file)
                         (error "No media found"))))
    (unless media-buffer
      (error "No media found"))
    (with-current-buffer media-buffer
      ;; Override buffer-local dired buffer's to use chosen one.
      (setq ready-player--dired-playback-buffer (get-buffer dired-buffer)))
    (unless (eq (current-buffer) media-buffer)
      (switch-to-buffer media-buffer))))

(defun ready-player--clean-up ()
  "Kill playback process."
  (ready-player--ensure-mode)
  (when-let ((delete-cached-file (not ready-player-cache-thumbnails)))
    (condition-case nil
        (delete-file ready-player--thumbnail)
      (file-error nil)))
  (when-let* ((delete-cached-file (not ready-player-cache-metadata))
              (metadata-path (ready-player--cached-metadata-path (buffer-file-name))))
    (condition-case nil
        (delete-file metadata-path)
      (file-error nil)))
  (kill-buffer (ready-player--playback-process-buffer (buffer-file-name)))
  (when ready-player--process
    (delete-process ready-player--process)
    (setq ready-player--process nil)))

(defun ready-player--buffers ()
  "Get all `ready-player-major-mode' buffers."
  (seq-filter (lambda (buffer)
                (eq (buffer-local-value 'major-mode buffer)
                    'ready-player-major-mode))
              (buffer-list)))

(defun ready-player--dired-buffers ()
  "Get all `ready-player-major-mode' buffers."
  (seq-mapcat
   (lambda (buffer)
     (with-current-buffer buffer
       (when (buffer-live-p ready-player--dired-playback-buffer)
         (list ready-player--dired-playback-buffer))))
   (ready-player--buffers)))

(defun ready-player--resolve-file-dired-buffer (file)
  "Return a known `dired' buffer containing FILE or nil otherwise."
  (seq-find
   (lambda (buffer)
     (with-current-buffer buffer
       (dired-goto-file file)))
   (ready-player--dired-buffers)))

(defun ready-player--keep-only-this-buffer (buffer)
  "Keep this BUFFER and kill all other `ready-player-mode' buffers."
  (mapc (lambda (other-buffer)
          (when (not (eq buffer other-buffer))
            (when (get-buffer-window-list other-buffer nil t)
              (set-window-buffer
               (car (get-buffer-window-list other-buffer nil t))
               buffer))
            (kill-buffer other-buffer)))
        (ready-player--buffers)))

(defun ready-player--active-buffer (&optional no-error)
  "Get the active buffer.

Fails if none available unless NO-ERROR is non-nil."
  (cond ((eq major-mode #'ready-player-major-mode)
         (setq ready-player--active-buffer (current-buffer))
         ready-player--active-buffer)
        ((and ready-player--active-buffer
              (buffer-live-p ready-player--active-buffer))
         ready-player--active-buffer)
        (t
         (error "No ready-player buffer available")))
  (if (and ready-player--active-buffer
           (buffer-live-p ready-player--active-buffer))
      ready-player--active-buffer
    (unless no-error
      (error "No ready-player buffer available"))))

(provide 'ready-player)

;;; ready-player.el ends here
