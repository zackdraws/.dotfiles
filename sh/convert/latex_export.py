import subprocess
import os
def latex_to_pdf(latex_file, output_dir="."):
  if not os.path.exists(latex_file):
    print(f"Error: LaTeX file not found: {latex_file}")
    return
  if not os.path.exists(output_dir):
    os.makedirs(output_dir)
  command = ["pdflatex", "-output-directory", output_dir, latex_file]
  try:
    result = subprocess.run(command, capture_output=True, text=True,
check=True)
    print(result.stdout)
    pdf_file = os.path.join(output_dir,
os.path.splitext(os.path.basename(latex_file))[0] + ".pdf")
    print(f"PDF created: {pdf_file}")
  except subprocess.CalledProcessError as e:
    print(f"Error running pdflatex: {e}")
    print(f"Stdout: {e.stdout}")
    print(f"Stderr: {e.stderr}")
    return False  # Indicate failure
  except Exception as e:
    print(f"An unexpected error occurred: {e}")
    return False
  return True 
if __name__ == "__main__":
  latex_file = "my_document.tex" 
  with open(latex_file, "w") as f:
    f.write("\\documentclass{article}\n")
    f.write("\\begin{document}\n")
    f.write("Hello, world!\n")
    f.write("\\end{document}\n")
  pdf_file = latex_to_pdf(latex_file, output_dir="output_pdfs")
  if pdf_file:
    print(f"Conversion successful.  PDF located at: {pdf_file}")
  else:
    print("Conversion failed.")
