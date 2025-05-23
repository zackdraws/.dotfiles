;;; emms-player-simple-mpv-autoloads.el --- automatically extracted autoloads (do not edit)   -*- lexical-binding: t -*-
;; Generated by the `loaddefs-generate' function.

;; This file is part of GNU Emacs.

;;; Code:

(add-to-list 'load-path (or (and load-file-name (directory-file-name (file-name-directory load-file-name))) (car load-path)))



;;; Generated autoloads from emms-player-simple-mpv.el

(autoload 'emms-player-simple-mpv-get-version "emms-player-simple-mpv" "\
Return mpv version.")
(autoload 'define-emms-simple-player-mpv "emms-player-simple-mpv" "\
Extension of `define-emms-simple-player' for mpv JSON IPC.

(fn NAME TYPES REGEX COMMAND &rest ARGS)" nil t)
(autoload 'emms-player-simple-mpv-tq-clear "emms-player-simple-mpv" "\
Clear tq-enque if it remains." t)
(autoload 'emms-player-simple-mpv-tq-enqueue "emms-player-simple-mpv" "\
Work like `tq-enqueue' except for using a hash table.
and return the request_id.
COM-LS is a list of a command name and params.
CLOSURE will be used as a first arg for FN.
FN will take CLOSURE and a parsed json object (alist) after receiving a reply.

(fn COM-LS CLOSURE FN)")
(autoload 'emms-player-simple-mpv-tq-data-message "emms-player-simple-mpv" "\
Return function to display a data message by FORM.
FORM can include a format specification for data.
:FN takes data as an argument.
:ERR-FORM can include a format specification %s.

(fn FORM &key (FN #\\='identity) (ERR-FORM form))")
(autoload 'emms-player-simple-mpv-tq-error-message "emms-player-simple-mpv" "\
Return function to display an error message by FORM.
FORM can include a format specification %s.

(fn FORM)")
(autoload 'emms-player-simple-mpv-add-to-converters "emms-player-simple-mpv" "\
Add a converter to PLAYER's mpv-track-name-converters like `add-to-list'.
Converter is  (list REGEXP TYPES FN).
If APPENDP is no-nil,add converter to last.
TYPES is type list or t.
FN takes track-name as an argument.

(fn PLAYER REGEXP TYPES FN &optional APPENDP)")
(autoload 'emms-player-simple-mpv-remove-converter "emms-player-simple-mpv" "\
Remove the converter from PLAYER's mpv-track-name-converters which has REGEXP.

(fn PLAYER REGEXP)")
(autoload 'emms-player-simple-mpv-start "emms-player-simple-mpv" "\
Emulate `emms-player-simple-start' but the first arg.

(fn TRACK PLAYER CMDNAME PARAMS)")
(autoload 'emms-player-simple-mpv-observe_property "emms-player-simple-mpv" "\
Set observe_property of NAME.

(fn NAME)")
(autoload 'emms-player-simple-mpv-set_property "emms-player-simple-mpv" "\
Set PROPERTY to VALUE via set_property.
:SPEC is a format specification for VALUE.
:MSG is displayed when command succeeds. If nil, it will be ignored.
:ERR-MSG is displayed when command fails. If nil, it will be ignored.
:FN takes VALUE as an argument. Its returned value will be used for :SPEC if :MSG is non-nil.

(fn PROPERTY VALUE &key (SPEC \"%s\") (MSG property) (ERR-MSG property) (FN #\\='identity))")
(autoload 'emms-player-simple-mpv-set_property_string "emms-player-simple-mpv" "\
Set PROPERTY to VALUE via property_string.
:SPEC is a format specification for VALUE.
:MSG is displayed when command succeeds. If nil, it will be ignored.
:ERR-MSG is displayed when command fails. If nil, it will be ignored.
:FN takes VALUE as an argument. Its returned value will be used for :SPEC if :MSG is non-nil.

(fn PROPERTY VALUE &key (SPEC \"%s\") (MSG property) (ERR-MSG property) (FN #\\='identity))")
(autoload 'emms-player-simple-mpv-pause "emms-player-simple-mpv" "\
Pause.")
(autoload 'emms-player-simple-mpv-unpause "emms-player-simple-mpv" "\
Unpause.")
(autoload 'emms-player-simple-mpv-seek "emms-player-simple-mpv" "\
Seek by SEC.

(fn SEC)")
(autoload 'emms-player-simple-mpv-seek-to "emms-player-simple-mpv" "\
Seek to SEC.

(fn SEC)" t)
(autoload 'emms-player-simple-mpv-volume-change "emms-player-simple-mpv" "\
Change volume by V.

(fn V)")
(register-definition-prefixes "emms-player-simple-mpv" '("emms-player-simple-mpv-"))


;;; Generated autoloads from emms-player-simple-mpv-control-functions.el

(autoload 'emms-player-simple-mpv-cycle "emms-player-simple-mpv-control-functions" "\
Cycle PROPERTY.

(fn PROPERTY)")
(autoload 'emms-player-simple-mpv-seek-to-% "emms-player-simple-mpv-control-functions" "\
Seek to PER(percent position).

(fn PER)" t)
(autoload 'emms-player-simple-mpv-volume-to "emms-player-simple-mpv-control-functions" "\
Set volume to V.

(fn V)" t)
(autoload 'emms-player-simple-mpv-mute-on "emms-player-simple-mpv-control-functions" "\
Mute on.")
(autoload 'emms-player-simple-mpv-mute-off "emms-player-simple-mpv-control-functions" "\
Mute off.")
(autoload 'emms-player-simple-mpv-mute "emms-player-simple-mpv-control-functions" "\
Cycle mute." t)
(autoload 'emms-player-simple-mpv-time-pos "emms-player-simple-mpv-control-functions" "\
Display position in current file." t)
(autoload 'emms-player-simple-mpv-time-pos-% "emms-player-simple-mpv-control-functions" "\
Display position (0-100) in current file." t)
(autoload 'emms-player-simple-mpv-playlist-next "emms-player-simple-mpv-control-functions" "\
Go to the next entry on the playlist." t)
(autoload 'emms-player-simple-mpv-playlist-prev "emms-player-simple-mpv-control-functions" "\
Go to the previous entry on the playlist." t)
(autoload 'emms-player-simple-mpv-playlist-to "emms-player-simple-mpv-control-functions" "\
Go to the Nth entry on the playlist.

(fn &optional N)" t)
(autoload 'emms-player-simple-mpv-playlist-pos "emms-player-simple-mpv-control-functions" "\
Display current position on the playlist." t)
(autoload 'emms-player-simple-mpv-playlist-nth-title "emms-player-simple-mpv-control-functions" "\
Display title of N th entry.
N is 0-base

(fn N)" t)
(autoload 'emms-player-simple-mpv-playlist-current-title "emms-player-simple-mpv-control-functions" "\
Display title of the current entry." t)
(autoload 'emms-player-simple-mpv-playlist-nth-filename "emms-player-simple-mpv-control-functions" "\
Display filename of N th entry.
N is 0-base.

(fn N)" t)
(autoload 'emms-player-simple-mpv-playlist-current-filename "emms-player-simple-mpv-control-functions" "\
Display title current entry." t)
(autoload 'emms-player-simple-mpv-playlist-move "emms-player-simple-mpv-control-functions" "\
Run playlist-move INDEX1 INDEX2.

(fn INDEX1 INDEX2)" t)
(autoload 'emms-player-simple-mpv-playlist-shuffle "emms-player-simple-mpv-control-functions" "\
Run playlist-shuffle." t)
(autoload 'emms-player-simple-mpv-playlist-remove-current "emms-player-simple-mpv-control-functions" "\
Run playlist-remove current." t)
(autoload 'emms-player-simple-mpv-playlist-remove-index "emms-player-simple-mpv-control-functions" "\
Run playlist-remove INDEX.

(fn INDEX)" t)
(autoload 'emms-player-simple-mpv-speed-to "emms-player-simple-mpv-control-functions" "\
Set speed to V.

(fn V)" t)
(autoload 'emms-player-simple-mpv-speed-normal "emms-player-simple-mpv-control-functions" "\
Change speed to normal." t)
(autoload 'emms-player-simple-mpv-speed "emms-player-simple-mpv-control-functions" "\
Change speed by V.

(fn V)" t)
(autoload 'emms-player-simple-mpv-speed-% "emms-player-simple-mpv-control-functions" "\
N % times speed.

(fn N)")
(autoload 'emms-player-simple-mpv-speed-increase "emms-player-simple-mpv-control-functions" "\
Increase speed by 10%." t)
(autoload 'emms-player-simple-mpv-speed-decrease "emms-player-simple-mpv-control-functions" "\
Decrease speed by 10%." t)
(autoload 'emms-player-simple-mpv-speed-double "emms-player-simple-mpv-control-functions" "\
Double speed." t)
(autoload 'emms-player-simple-mpv-speed-halve "emms-player-simple-mpv-control-functions" "\
Halve speed." t)
(autoload 'emms-player-simple-mpv-ab-loop "emms-player-simple-mpv-control-functions" "\
Cycle ab-loop." t)
(autoload 'emms-player-simple-mpv-loop-to "emms-player-simple-mpv-control-functions" "\
Set loop to N.
If N is less than 1, set loop to \"inf\".

(fn N)" t)
(autoload 'emms-player-simple-mpv-loop-file-to "emms-player-simple-mpv-control-functions" "\
Set loop-file to N.
If N is less than 0, set loop-file to \"inf\".

(fn N)" t)
(autoload 'emms-player-simple-mpv-ontop "emms-player-simple-mpv-control-functions" "\
Cycle ontop." t)
(autoload 'emms-player-simple-mpv-fullscreen "emms-player-simple-mpv-control-functions" "\
Cycle fullscreen." t)
(autoload 'emms-player-simple-mpv-metadata "emms-player-simple-mpv-control-functions" "\
Display metadata." t)
(autoload 'emms-player-simple-mpv-filtered-metadata "emms-player-simple-mpv-control-functions" "\
Display filtered-metadata." t)
(autoload 'emms-player-simple-mpv-property-list "emms-player-simple-mpv-control-functions" "\
Display the current value of a property via get_property_string." t)
(register-definition-prefixes "emms-player-simple-mpv-control-functions" '("emms-player-simple-mpv-"))


;;; Generated autoloads from emms-player-simple-mpv-e.g.hydra.el

(register-definition-prefixes "emms-player-simple-mpv-e.g.hydra" '("emms-player-simple-mpv-hydra-docstring"))


;;; Generated autoloads from emms-player-simple-mpv-e.g.playlist-fname.el

(register-definition-prefixes "emms-player-simple-mpv-e.g.playlist-fname" '("emms-player-simple-mpv-update-playlist-filename"))


;;; Generated autoloads from emms-player-simple-mpv-e.g.time-display.el

(register-definition-prefixes "emms-player-simple-mpv-e.g.time-display" '("emms-player-simple-mpv-"))


;;; Generated autoloads from emms-player-simple-mpv-playlist-mode.el

(autoload 'emms-player-simple-mpv-playlist-mode-reload "emms-player-simple-mpv-playlist-mode" "\
Reload mpv playlist buffer." t)
(autoload 'emms-player-simple-mpv-playlist-mode-refresh "emms-player-simple-mpv-playlist-mode" "\
Refreash mpv playlist buffer." t)
(autoload 'emms-player-simple-mpv-playlist-mode-goto-nth "emms-player-simple-mpv-playlist-mode" "\
Go to the N the entry.

(fn N)" t)
(autoload 'emms-player-simple-mpv-playlist-mode-goto-current "emms-player-simple-mpv-playlist-mode" "\
Go to the current entry." t)
(autoload 'emms-player-simple-mpv-plm-update-playlist-pos "emms-player-simple-mpv-playlist-mode" "\
Update playlist-pos(POS) for `emms-player-simple-mpv-plm--buffer'.

(fn POS)")
(autoload 'emms-player-simple-mpv-playlist-mode-play-at "emms-player-simple-mpv-playlist-mode" "\
Set playlist-pos to the entry at POINT.

(fn &optional POINT)" t)
(autoload 'emms-player-simple-mpv-playlist-mode-remove-at "emms-player-simple-mpv-playlist-mode" "\
Remove the entry at POINT.

(fn &optional POINT)" t)
(autoload 'emms-player-simple-mpv-playlist-mode-move-up "emms-player-simple-mpv-playlist-mode" "\
Move up the entry at the point N times.

(fn N)" t)
(autoload 'emms-player-simple-mpv-playlist-mode-move-down "emms-player-simple-mpv-playlist-mode" "\
Move down the entry at the point N times.

(fn N)" t)
(autoload 'emms-player-simple-mpv-playlist-mode-next "emms-player-simple-mpv-playlist-mode" "\
Run playlist-next and reload." t)
(autoload 'emms-player-simple-mpv-playlist-mode-prev "emms-player-simple-mpv-playlist-mode" "\
Run playlist-prev and reload." t)
(autoload 'emms-player-simple-mpv-playlist-mode-shuffle "emms-player-simple-mpv-playlist-mode" "\
Shuffle playlist." t)
(autoload 'emms-player-simple-mpv-playlist-mode-shuffle-restart "emms-player-simple-mpv-playlist-mode" "\
Shuffle playlist and Set playlist-pos to 0." t)
(autoload 'emms-player-simple-mpv-playlist-mode-setup-keybinds "emms-player-simple-mpv-playlist-mode" "\
Set some control functions to `emms-player-simple-mpv-playlist-mode-map'.")
(autoload 'emms-player-simple-mpv-playlist-popup "emms-player-simple-mpv-playlist-mode" "\
Popup mpv playlist buffer.
ACTION and FRAME will be used as arguments for `display-buffer'.
If ACTION is nil,
`emms-player-simple-mpv-playlist-mode-display-action' will be uesd.

(fn &optional ACTION FRAME)" t)
(autoload 'emms-player-simple-mpv-playlist-mode "emms-player-simple-mpv-playlist-mode" "\
Major mode for displaying mpv playlist.

\\{emms-player-simple-mpv-playlist-mode-map}

(fn)" t)
(register-definition-prefixes "emms-player-simple-mpv-playlist-mode" '("emms-player-simple-mpv-pl"))

;;; End of scraped data

(provide 'emms-player-simple-mpv-autoloads)

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; no-native-compile: t
;; coding: utf-8-emacs-unix
;; End:

;;; emms-player-simple-mpv-autoloads.el ends here
