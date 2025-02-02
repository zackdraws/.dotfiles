#!/usr/bin/env fish



# Get the current day and time

set current_day (date "+%A")  # Day of the week

set current_time (date "+%T")  # Current time (HH:MM:SS)



# Define the city coordinates for Irvine, California (latitude and longitude)

set latitude 33.6846

set longitude -117.8265



# Fetch the weather data using Open-Meteo (latitude and longitude of Irvine, CA)

set weather_data (curl -s "https://api.open-meteo.com/v1/forecast?latitude=$latitude&longitude=$longitude&current_weather=true")



# Extract the temperature in Celsius and weather description

set temperature_celsius (echo $weather_data | jq '.current_weather.temperature')



# Convert Celsius to Fahrenheit: (Celsius * 9/5) + 32

set temperature_fahrenheit (math $temperature_celsius \* 9 / 5 + 32)



# Get the weather description (Open-Meteo uses a weather code, so mapping it to a description is needed)

set weather_code (echo $weather_data | jq '.current_weather.weathercode')



# Optional: A simple map for weather codes to text (you can expand this)

switch $weather_code

    case 0

        set weather_desc "Clear sky"

    case 1

        set weather_desc "Mainly clear"

    case 2

        set weather_desc "Partly cloudy"

    case 3

        set weather_desc "Cloudy"

    case 45

        set weather_desc "Fog"

    case 48

        set weather_desc "Depositing rime fog"

    case 51

        set weather_desc "Light drizzle"

    case 53

        set weather_desc "Moderate drizzle"

    case 55

        set weather_desc "Heavy drizzle"

    case '*'

        set weather_desc "Unknown"

end



# Output the result

echo "Today is $current_day and the time is $current_time."

echo "Current weather in Irvine, California: $temperature_fahrenheit°F and $weather_desc."



# Print simple block sun ASCII art (updated version)

echo "
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡀⠀⠀

⠀⠀⠀⠀⡦⠤⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡰⠋⠀⠀⠀⠸⡄
⠀⠀⠀⠀⣧⠀⠀⠻⣦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⠎⠀⠀⠀⠀⠀⠀⡇
⠀⠀⠀⠀⢻⡄⠀⠀⠈⢿⣦⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡜⠁⠀⠀⠀⠀⠀⠀⠀⣽
⠀⠀⠀⠀⠘⡧⠀⠀⠀⠀⠙⣿⣧⣀⠀⠀⠀⠀⢀⢀⣀⣀⣀⣀⡴⠋⢀⠔⡀⠀⠀⠀⠀⠀⢰⡏
⠀⠀⠀⠀⠀⢹⣆⠀⠐⢆⠘⢌⣻⣿⣿⣿⣿⠟⠋⠙⠻⣿⣿⣿⣦⣴⣧⡊⢀⠤⠂⠀⠀⠀⡞⡇
⠀⠀⠀⠀⠀⠀⢻⠣⡄⠀⢷⣞⣿⣿⡿⠏⠋⠀⠀⠀⠀⠀⠀⢩⣿⣿⣷⣏⠳⣄⠀⠀⠀⡼⢰⠃
⠀⠀⠀⠀⠀⠀⠘⡆⠘⠦⠋⠘⣇⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠁⠁⢹⠿⢿⣆⠀⠀⡞⢀⠞⠀
⠀⠀⠀⠀⠀⠀⠀⢿⠂⢀⣀⣀⠀⠈⢳⠀⠀⠀⠀⠀⢀⡴⣶⣎⠙⣾⣉⣀⣀⡀⠀⠸⠀⢸⡄⠀
⠀⠀⠀⠀⠀⠀⠀⡼⠀⢸⡀⣾⡟⣶⡾⠀⠀⠀⠀⢀⢼⣆⠻⣿⣆⡿⠁⠀⠀⠑⡄⠀⠀⢸⠃⠀
⠀⠀⠀⠀⠀⠀⢠⡇⠀⠈⣉⠽⠋⠹⢁⣀⣀⠀⠀⠋⠀⠉⠉⠉⠀⠀⠀⠀⠀⠀⢷⡀⠀⠸⠀⠀
⠀⠀⠀⠀⠀⠀⠘⡗⠲⣼⡇⠀⠀⢰⠋⠀⢀⣹⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⢦⣆⠀⠀
⠀⠀⠀⠀⠀⠀⢀⣣⣀⣘⡇⠀⠀⠘⢷⡀⡿⠛⠁⠀⠀⢀⡀⠤⠤⢀⡀⠀⠀⡀⠀⠀⠀⢸⠀⠀
⠀⠀⠤⠒⠊⣉⠡⠼⣖⣺⣷⠄⠀⢀⣀⣹⣥⣀⠀⠀⠈⠉⠩⣹⡒⠤⣌⡤⠚⠁⠀⠀⠀⢸⡀⠀
⠀⣀⠤⠒⠉⡀⠔⠊⢻⠀⠈⠓⢤⡽⠦⣀⣀⡴⠏⠑⠢⠔⠚⠁⠙⠢⡀⠉⠒⢄⡀⠀⠀⠘⡇⠀
⠈⠀⢀⠴⠊⠀⣀⡠⠊⠀⠀⠀⠀⠳⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠂⠀⠀⠈⠂⠀⢀⣷⠀
⠀⠘⠁⠀⠀⢠⠇⠀⠀⠀⠀⠀⠀⠀⠈⠙⠦⠤⠤⠒⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⠀
⠀⠀⠀⠀⢠⠏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡿⠀
⠀⠀⠀⢠⠞⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⠃⠀
⠀⢀⠴⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡗⠀⠀
⠈⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⠃⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⠂⠀⠀
"
 emacs --batch -l ~/.emacs --eval "(progn (require 'org) (org-agenda nil \"a\") (write-file \"/tmp/agenda.txt\"))" --no-site-file --no-init-file

head -n 200 /tmp/agenda.txt | bat 
