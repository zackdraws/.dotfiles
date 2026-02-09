# Run at login (only once)
if [[ -z "$LOGIN_ALREADY_RUN" ]]; then
    export LOGIN_ALREADY_RUN=true
    /path/to/your-login-script.sh
fi
