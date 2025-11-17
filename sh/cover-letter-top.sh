#!/bin/bash
# Clear the screen
clear
echo "Welcome to the Professional Cover Letter Formatter!"
echo "Let's create a polished, professional cover letter."
echo ""
sleep 1
# -------------------- User Inputs --------------------
read -rp "Recipient Name: " recipient_name
read -rp "Recipient Address (Company, Street, City, State, ZIP): " recipient_address
read -rp "Your Name: " sender_name
read -rp "Your Address (Street, City, State, ZIP): " sender_address
read -rp "Position applying to: " position
echo "cover letter sections."
read -rp "1. Intro: " introduction
read -rp "2. Body Paragraph 1: " body1
read -rp "3. Body Paragraph 2: " body2
read -rp "4. Closing: " closing
# -------------------- File Paths --------------------
output_dir="$(pwd)"
output_name="cover_letter"
pdf_file="$output_dir/${output_name}.pdf"
temp_tex="$output_dir/${output_name}_temp.tex"
# -------------------- LaTeX Template --------------------
cat > "$temp_tex" <<EOF
\documentclass[12pt]{letter}
\usepackage[letterpaper,top=0.5in,left=1in,right=1in,bottom=1in]{geometry} % top margin small
\usepackage{helvet}
\renewcommand{\familydefault}{\sfdefault}
\pagestyle{empty} % no page numbers
% Remove extra vertical space before first line
\makeatletter
\let\@opening\@empty
\makeatother
\signature{$sender_name}
\address{$sender_address}
\begin{document}
\begin{letter}{$recipient_name\\$recipient_address}
\opening{Dear $recipient_name,}
$introduction
$body1
$body2
$closing
\closing{Sincerely,}
\end{letter}
\end{document}
EOF
pdflatex -interaction=nonstopmode -output-directory="$output_dir" "$temp_tex" > /dev/null 2>&1
rm -f "$temp_tex"
rm -f "$output_dir/${output_name}.aux" "$output_dir/${output_name}.log"
echo "$pdf_file"
echo "🎉"
exit 0
